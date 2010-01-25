package spectacular.runners {
  
  import asx.array.empty;
  import asx.array.flatten;
  import asx.array.injectSequentially;
  import asx.array.mapParallelized;
  import asx.array.mapSequentially;
  import asx.array.unfold;
  import asx.string.formatToString;
  
  import flash.utils.clearTimeout;
  import flash.utils.getQualifiedClassName;
  import flash.utils.setTimeout;
  
  import org.flexunit.internals.runners.model.EachTestNotifier;
  import org.flexunit.runner.Description;
  import org.flexunit.runner.IDescription;
  import org.flexunit.runner.IRunner;
  import org.flexunit.runner.notification.IRunNotifier;
  import org.flexunit.runners.model.IRunnerBuilder;
  import org.flexunit.token.AsyncTestToken;
  import org.flexunit.token.ChildResult;
  import org.flexunit.token.IAsyncTestToken;
  import org.flexunit.utils.ClassNameUtil;
  
  import spectacular.internals.Async;
  import spectacular.internals.Context;
  import spectacular.internals.Example;
  import spectacular.internals.SpectacularContext;

  /**
   * Runs Spectacular tests for FlexUnit4.   
   * 
   * @example
   * <listing version="3.0">
   * package {
   *   [RunWith("spectacular.runners.SpectacularRunner")]
   *   public class SumNumber {
   *     describe("asx.number.sum()", function():void {
   *       var numbers:Array; 
   *       before(function():void { 
   *         numbers = [1, 2, 3] 
   *       });
   *       it("should return the total of all the numbers in the given array", function():void {
   *         assertThat(sum(numbers), equalTo(6));
   *       });
   *     });
   *   }
   * }
   * </listing>
   */
  public class SpectacularRunner implements IRunner {
    
    private var _classReference:Class;
    private var _classInstance:Object;
    private var _previousContext:Context;
    private var _previousExample:Example;
    
    private var _description:IDescription;
    private var _notifier:IRunNotifier;
    private var _parentToken:IAsyncTestToken;
    private var _runnerToken:IAsyncTestToken;
    private var _currentContextToken:IAsyncTestToken;
    private var _currentExampleToken:IAsyncTestToken;
             
    /**
     * Constructor.
     * 
     * @param classReference Class to run
     */
    public function SpectacularRunner(classReference:Class /*, builder:IRunnerBuilder*/) {
      super();
      _classReference = classReference;
    }
 
    /**
     * Returns an <code>IDescription</code> of the test class that the runner is running. 
     */
    public function get description():IDescription {
      if (!_description) {
        _description = new Description(getQualifiedClassName(_classReference), null);
      }
      return _description;
    }
    
    protected function get notifier():IRunNotifier {
      return _notifier;
    }
    
    public function toString():String {
      return formatToString(this, 'SpectacularRunner');
    }
    
    /**
		 * Runs the test class and updates the <code>notifier</code> on the status of running the tests.
		 * 
		 * @param notifier The notifier that is notified about issues encountered during the execution of the test class.
		 * @param parentToken The token that is to be notified when the runner has finished execution of the test class.
     */
    public function run(notifier:IRunNotifier, parentToken:IAsyncTestToken):void {
      _notifier = notifier;
      _parentToken = parentToken;
      
      // set the SpectacularCore.instance to a new SpectacularCore
      // in order to capture only those contexts and examples that are 
      // defined within the scope of the current Class given to this IRunner.
      SpectacularContext.instance = new SpectacularContext();      
      
      // integrate with FlexUnit async system.
      _runnerToken = createToken(SpectacularContext.instance.currentContext, null);
      _runnerToken['previousToken'] = parentToken;
//      _runnerToken.addNotificationMethod(runnerComplete);
      
      _currentContextToken = _runnerToken; 
               
      // 
      runClass(
        function():void {
          //trace(this, 'runClass() callback');
          // 
          runContext(
            SpectacularContext.instance.currentContext, 
            function():void {
              //trace(this, 'run() parentToken', parentToken);
              
              _runnerToken.sendResult();            
              parentToken.sendResult();              
            });
        },
        function(error:Error):void {
          //trace(this, 'runClass() errback');
          //trace(this, 'run() error parentToken', parentToken);
          
          _runnerToken["eachNotifier"].addFailure(error);
          _runnerToken.sendResult();
          parentToken.sendResult(error) 
        });
    }
    
//    //  
//    protected function runnerComplete(result:ChildResult):void {
//      //trace(this, 'runnerComplete', result);
//      
//      var error:Error = result.error;
//			var token:AsyncTestToken = result.token;
//			var eachNotifier:EachTestNotifier = result.token["eachNotifier"];
//			
//      if ( error ) {
//				eachNotifier.addFailure( error );
//			}
//			
//			// Notify the token that was passed to the run method that the runner has finished
//			token.previousToken.sendResult();
//    }
    
    /**
     * Instantiates the <code>Class</code> in order to being running the 
     * contained <code>describe()</code> and <code>it()</code> functions.
     * 
     * @param callback Function to call when instantiated successfully. 
     * @param errback Function to call when an Error is thrown while instantiating the Class.
     */
    protected function runClass(callback:Function, errback:Function):void {
      try {
        // keep a reference just in case the GC gets hungry, on nom nom.
        _classInstance = new _classReference();
        callback();
      }
      catch (error:Error) {
        //trace(this, 'runClass errback', error.getStackTrace());
        
        _currentContextToken["eachNotifier"].addFailure(error);
        errback(error);
      }
    }
    
    /**
     * Runs a Context created by <code>describe</code>. When complete calls the 
     * <code>complete</code> Function. 
     * 
     * @param context Context to run.
     * @param complete Function to call when complete, <code>function(context:Context):void</code>
     */
    protected function runContext(context:Context, complete:Function):void {
      //trace(this, 'runContext', context.description);

      // integrate with FlexUnit async system.
//      _currentContextToken = createToken(context, _currentContextToken);
//      _currentContextToken.addNotificationMethod(notifyContextComplete);
            
      // define a sequence of steps we want run the current context through.
      var sequence:Array = [
        setCurrentContext,
        notifyContextStarted,
        runContextWithPotentialError,
//        runBeforeAlls,
        runContextExamples,
//        runAfterAlls,
        notifyContextFinished,
        setParentContext
      ];
      
      // injects the context into each step in the sequence.
      runSequence(sequence, context, function(context:Context):void {
        //trace(this, 'runContext complete', context.description);
        complete(context);  
      });    
    }
    
    /**
     * Sets the given Context as the current Context into which new Contexts and 
     * Examples will be added. 
     * 
     * @param context Context to set as current.
     * @param complete Function to call when complete, <code>function(context:Context):void</code>
     */
    protected function setCurrentContext(context:Context, complete:Function):void {
      // set the SpectacularCore.currentContext to this context
      // in order to capture contexts and examples.
      _previousContext = SpectacularContext.instance.currentContext;  
      SpectacularContext.instance.currentContext = context;
      
      complete(context);
    }   
    
    /**
     * Sets the parent of the given Context as the current Context into which
     * new Contexts and exaples will be added. Called after running a Context. 
     * 
     * @param context Context from which to get parent Context. 
     * @param complete Function to call when complete, <code>function(context:Context):void</code>
     */
    protected function setParentContext(context:Context, complete:Function):void {      
      SpectacularContext.instance.currentContext = context.parent;
      
      // FAILED attempt at running/notifying contexts as test  
//      if (_currentContextToken)
//        _currentContextToken = _currentContextToken.parentToken;
      
      complete(context);
    }
    
    /**
     * Runs a Context that may throw an Error.
     * 
     * @param context Context to run 
     * @param complete Function to call when complete, <code>function(context:Context):void</code>
     */
    protected function runContextWithPotentialError(context:Context, complete:Function):void {
      //trace(this, 'runContextWithPotentialError', context.description);
      try {
        // run the context to capture befores, afters, and examples
        if (context.contextFunction != null)
          context.contextFunction();        
      }
      catch (error:Error) {
        _currentContextToken["eachNotifier"].addFailure(error);
      }
      finally {
        complete(context);
      }
    }
    
    // FIXME this does nothing, remove it for runExamples
    /**
     * Runs the Examples contained in a Context.
     * 
     * @param context Context to run 
     * @param complete Function to call when complete, <code>function(context:Context):void</code>
     */    
    protected function runContextExamples(context:Context, complete:Function):void {
      //trace(this, 'runContextExamples', context.description);
      // run the examples in this context
      runExamples(context, function(context:Object):void {
        //trace(this, 'runContextExamples complete', context.description);
        complete(context);
      });
    }
    
    //
        
    /**
     * Runs the Examples contained in a Context.
     * 
     * @param context Context to run 
     * @param complete Function to call when complete, <code>function(context:Context):void</code>
     */    
    protected function runExamples(context:Context, complete:Function):void {
      //trace(this, 'runExamples', context.description);

      // carry on if this context has no examples
      if (empty(context.examples)) {
        complete(context);
        return;
      }
    
      // use the awesomeness of mapSequentially to process each example
      // and then carry on when they are all complete.
      mapSequentially(
        context.examples,
        function(example:Object, next:Function):void {
          //trace(this, 'runExamples', example is Context, example.description);
          (example is Context ? runContext : runExample)(example, next);
        },
        function():void {
          //trace(this, 'runExamples complete', context.description);
          complete(context);    
        });
    }

    /**
     * Runs an Example
     * 
     * @param example Example to run
     * @param complete Funtion to call when complete, <code>function(example:Example):void</code>
     */
    protected function runExample(example:Example, complete:Function):void {
      //trace(this, 'runExample', example.description);

      // integrate with FlexUnit async system.
      _currentExampleToken = createToken(example, _currentContextToken);
      _currentExampleToken.addNotificationMethod(notifyExampleComplete);
      
      // define a sequence of steps we want run the current example through.
      var sequence:Array = [
        setCurrentExample,
        notifyExampleStarted,
        runBefores,
        runExampleWithPotentialError,
        runExampleWithPotentialAsync,
        runAfters,
        notifyExampleFinished
      ];
      
      runSequence(sequence, example, complete);
    }
    
    /**
     * Sets the given Example as the current Example into which new Asyncs will be added.
     * 
     * @param example Example to run
     * @param complete Funtion to call when complete, <code>function(example:Example):void</code>
     */
    protected function setCurrentExample(example:Example, complete:Function):void {
      // while each example runs 
      // it must set itself as the current example
      // in order to accumulate async() for itself.
      _previousExample = SpectacularContext.instance.currentExample;
      SpectacularContext.instance.currentExample = example;
      
      complete(example);      
    }    
    
    /**
     * Sets the previous Eample as the current Example. Required for correct 
     * processing of before and after Functions.
     * 
     * @param example Ignored. 
     * @param complete Funtion to call when complete, <code>function(example:Example):void</code>
     */
    protected function setPreviousExample(example:Example, complete:Function):void {
      // while each example runs 
      // it must set itself as the current example
      // in order to accumulate async() for itself.
//      var previousExample:Example = SpectacularCore.instance.currentExample;
      SpectacularContext.instance.currentExample = _previousExample;
      
      complete(example);      
    }
        
    /**
     * Runs an Example that may throw an Error.
     * 
     * @param example Example to run 
     * @param complete Function to call when complete, <code>function(example:Example):void</code>
     */
    protected function runExampleWithPotentialError(example:Example, complete:Function):void {
      //trace(this, 'runExampleWithPotentialError', example.description);
      try {
        // run the context to capture befores, afters, and examples
        if (example.exampleFunction != null) {
          example.exampleFunction();
        }
      }
      catch (error:Error) {
        _currentExampleToken["eachNotifier"].addFailure(error);
      }
      finally {
        complete(example);
      }
    }

    /**
     * Runs an Example with potential calls to <code>async()</code>.
     * 
     * @param example Example to run 
     * @param complete Function to call when complete, <code>function(example:Example):void</code>
     */
    protected function runExampleWithPotentialAsync(example:Example, complete:Function):void {
      //trace(this, 'runExampleWithPotentialAsync', example.description);      
      // TODO reset the asyncs before running the example 
      // when running befores and afters the asyncs need to be reset
      // in order to not run/expect asyncs from previous examples. 

      // carry on if the example has no asyncs
      if (empty(example.asyncs)) {
        complete(example);
        return;
      }
      
      // when there are asyncs
      // then we must wait until those calls are complete
      // to do so use the awesomeness of mapParallelized
      // to prepare each async so that this runner is notified
      mapParallelized(
        example.asyncs, 
        function(asyncDetails:Async, next:Function):void {
          // when the asyncDetails indicates it has already been called
          // then we can carry on early
          if (asyncDetails.called)
            next(asyncDetails);
           
          // otherwise we need to prepare to fail
          var asyncTimeout:int = setTimeout(asyncDetails.failureFunction || function():void {
            // TODO throwing an error in this async context is a bad idea, should be forwarded to the notifier
            // TODO throw a SpectacularAsyncError
            
            // throw new Error("async function not called");
            var error:Error = new Error("async function not called");
            _currentExampleToken["eachNotifier"].addFailure(error);
            
          }, asyncDetails.failureTimeoutMs);
          
          // prepare to win
          asyncDetails.callback = function(args:Array):void {
            // prevent failure by timeout
            clearTimeout(asyncTimeout);
            
            // call the function given to async()
            try {
              asyncDetails.asyncFunction.apply(null, args);
            } 
            catch (error:Error) {
              throw error;
            }
            finally {
              next(asyncDetails);
            }
          };
        },
        function(results:Array):void {
//          // once complete then the before must reset 
//          // the current example as its parent example
//          SpectacularCore.instance.currentExample = previousExample; 
          
          // carry on
          complete(example);              
        });
    }

    /**
     * Not Implemented Yet.
     */
    protected function runBeforeAlls(context:Context, complete:Function):void {
      complete(context);
    }

    /**
     * Not Implemented Yet.
     */
    protected function runAfterAlls(context:Context, complete:Function):void {
      complete(context);
    }

    /**
     * Runs all the befores of an Example.
     * 
     * @param example Example for which to run befores. 
     * @param complete Function to call when complete, <code>function(example:Example):void</code>
     */
    protected function runBefores(example:Example, complete:Function):void {
      var befores:Array = collectBefores(example);
      //trace(this, 'runBefores', example.description, befores.length);
      
      if (empty(befores)) {
        complete(example);
        return;
      }        

      // run the befores from outermost to innermost.
      // as befores are Examples and potentially async
      // we run them the same way.
      mapSequentially(
        befores, 
        runBefore,
        function(befores:Array):void {
          complete(example);
        });
    }
    
    /**
     * Runs an individual Example as a before.
     * 
     * @param example Example to run. 
     * @param complete Function to call when complete, <code>function(example:Example):void</code>
     */
    protected function runBefore(example:Example, complete:Function):void {
      //trace(this, 'runBefore');
      var sequence:Array = [
        setCurrentExample,
        runExampleWithPotentialError,
        runExampleWithPotentialAsync,
        setPreviousExample
      ];
      
      runSequence(sequence, example, complete);
    }    
        
    /**
     * Collects all the before Examples up the Context hierarchy.  
     * 
     * @param example Example from which to collect befores.  
     * @return Array of before Examples. 
     */
    protected function collectBefores(example:Example):Array {
      // befores are interesting in that every before defined in the current 
      // context and its parents will be run before executing each example in 
      // the current context.
      // 
      // befores are run from the outermost context to the innermost. 
      
      // to collect all the befores we are going to use 'unfold'
      // unfold is a reverse 'inject'/'reduce' in that it takes a single initial 
      // value and then transforms that value into an Array of values.
      // 
      var befores:Array = unfold(
        // start with the parent of the current example
        // as befores are defined on the context not the example
        example.parent,
        // predicate: stop unfolding when the parent is null as we have reached the root context
        function(context:Context):Boolean { return context.parent != null },
        // transformer: grab the befores
        function(context:Context):Array { return context.befores.reverse() },
        // incrementor: continue with the next parent
        function(context:Context):Context { return context.parent });
       
      // as each step returns an array of befores we also need to flatten 
      // the result to a single dimension array. 
      // eg: [[before1, before2], [before3]] => [before1, before2, before3]
      befores = flatten(befores);
      
      // reverse the entire list of befores
      // as they were accumulated from innermost to outermost
      // and we want them the other way. 
      befores = befores.reverse();
      
      return befores;
    }

    /**
     * Runs all the afters of an Example.
     * 
     * @param example Example for which to run afters. 
     * @param complete Function to call when complete, <code>function(example:Example):void</code>
     */
    protected function runAfters(example:Example, complete:Function):void {
      var afters:Array = collectAfters(example);
      //trace(this, 'runAfters', example.description, afters.length);
      
      if (empty(afters)) {
        complete(example);
        return;
      }
      
      // run the fters from innermost to outermost.
      // as fters are Examples and potentially async
      // we run them the same way.
      mapSequentially(
        afters, 
        runAfter,
        function(afters:Array):void {
          complete(example);
        });
    }
    
    /**
     * Runs an individual Example as an after.
     * 
     * @param example Example to run. 
     * @param complete Function to call when complete, <code>function(example:Example):void</code>
     */
    protected function runAfter(example:Example, complete:Function):void {
      //trace(this, 'runAfter');
      var sequence:Array = [
        setCurrentExample,
        runExampleWithPotentialError,
        runExampleWithPotentialAsync,
        setPreviousExample
      ];
      
      runSequence(sequence, example, complete);
    }   
    
    /**
     * Collects all the after Examples up the Context hierarchy.  
     * 
     * @param example Example from which to collect afters.  
     * @return Array of after Examples 
     */
    protected function collectAfters(example:Example):Array {
      // afters are interesting in that every fter defined in the current 
      // context and its parents will be run fter executing each example in 
      // the current context.
      // 
      // afters are run from the innermost context to the outermost. 
      
      // to collect all the afters we are going to use 'unfold'
      // unfold is a reverse 'inject' in that it takes a single initial value           
      // and then transforms that value into an Array of values.
      // 
      var afters:Array = unfold(
        // start with the parent of the current example
        // as afters are defined on the context not the example
        example.parent,
        // predicate: stop unfolding when the parent is null as we have reached the root context
        function(context:Context):Boolean { return context.parent != null },
        // transformer: grab the befores
        function(context:Context):Array { return context.afters },
        // incrementor: continue with the next parent
        function(context:Context):Context { return context.parent });
       
      // as each step returns an array of afters we also need to flatten 
      // the result to a single dimension array. 
      // eg: [[after1, after2], [after3]] => [after1, after2, after3]
      afters = flatten(afters);
      
      return afters;
    }
    
    /**
     * @param sequence Array of Function to inject <code>target</code> into. 
     * @param target Object to inject to each Function in <code>sequence</code>
     * @param complete Function to call once the sequence is completed.
     */
    protected function runSequence(sequence:Array, target:Object, complete:Function):void {
      //trace(this, 'runSequence', target);
      
      // use the awesomeness of injectSequentially to inject the example into 
      // each step of the sequence.
      injectSequentially(
        target, 
        sequence, 
        function(target:Object, sequenceFunction:Function, next:Function):void {
          sequenceFunction(target, next);
        },
        function(target:Object):void {
          //trace(this, 'runSequence complete', target);
//          complete(target);
        // break long stacks, and prevent player script timeouts
          setTimeout(complete, 10, target);
        });
    } 
    
    //
    //  notifiers
    //
    
    /**
     * Notify that a Context has started running.
     */
    protected function notifyContextStarted(context:Context, complete:Function):void {
      //trace(this, 'notifyContextStarted', context);

      var contextDescription:IDescription = createDescription(context);
      _currentContextToken["eachNotifier"] = createEachNotifier(contextDescription);

      complete(context);
    }

    /**
     * Notify that a Context has finished running.  
     */    
    protected function notifyContextFinished(context:Context, complete:Function):void {
      //trace(this, 'notifyContextFinished', context);
      complete(context);
    } 
    
    
//    /**
//     *  
//     */    
//    protected function notifyContextComplete(result:ChildResult):void {
//      //trace(this, 'notifyContextComplete', result);
//      var error:Error = result.error;
//      if (error) {
//        _currentContextToken["eachNotifier"].addFailure(error);
//      }
//      
//      _currentContextToken["eachNotifier"].fireTestFinished();
//      _currentContextToken.parentToken.sendResult();
//    }
    
    //
    
    /**
     * Notify that an Example has started running.
     */    
    protected function notifyExampleStarted(example:Example, complete:Function):void {
      //trace(this, 'notifyExampleStarted', example);
      _currentExampleToken["eachNotifier"].fireTestStarted();
      complete(example);
    }
    
    /**
     * Notify that an Example has finished running.
     */    
    protected function notifyExampleFinished(example:Example, complete:Function):void {
      //trace(this, 'notifyExampleFinished', example);
      _currentExampleToken.sendResult();
      complete(example);
    }
    
    /**
     * Notify that an Example has completed. Notification method used by the AsyncTestToken.
     */    
    protected function notifyExampleComplete(result:ChildResult):void {
      //trace(this, 'notifyExampleComplete', result);
      var error:Error = result.error;
      if (error) {
        _currentExampleToken["eachNotifier"].addFailure(error);
      }

      _currentExampleToken["eachNotifier"].fireTestFinished();      
      _currentExampleToken.parentToken.sendResult();
    }
    
    //
    //  factories
    //
    
    /**
     * Create an IDescription for the given Example or Context or Class. 
     * 
     * @param example Example or Context or Class.
     * @return IDescription instance for the given example.   
     */
    protected function createDescription(example:Object = null):IDescription {
      var descriptions:Array = [];
      var description:String;
      
      if (example is Class) {
        description = ClassNameUtil.getLoggerFriendlyClassName( _classReference );
      } 
      else if (example) {
        descriptions = unfold(
          example, 
          function(context:Object):Boolean { return context.parent != null },
          function(context:Object):String  { return context.description },
          function(context:Object):Object  { return context.parent });
        
        // skip the first, its the name of this class
        description = descriptions.reverse().join(", ");
      }
      
//      //trace(this, 'createDescription', description);
//      //trace(this, new Error().getStackTrace().split('\n').slice(0, 5).join('\n'));
      
      return Description.createTestDescription(_classReference, description);
    }
    
    /**
     * Create an EachTestNotifier for the given Description. 
     */
    protected function createEachNotifier(description:IDescription):EachTestNotifier {
      var eachNotifier:EachTestNotifier = new EachTestNotifier(notifier, description);
      return eachNotifier; 
    }
    
    /**
     * Create an IAsyncTestToken for the given example and parentToken.
     */
    protected function createToken(example:Object, parentToken:IAsyncTestToken):IAsyncTestToken {
       // deal with the FlexUnit AsyncTestToken stuff
      // this isn't very nice.
      var exampleDescription:IDescription = createDescription(example);
      var exampleNotifier:EachTestNotifier = createEachNotifier(exampleDescription);
      var token:AsyncTestToken = new AsyncTestToken(ClassNameUtil.getLoggerFriendlyClassName(this));
      token.parentToken = parentToken;
      token["eachNotifier"] = exampleNotifier;    
      return token; 
    }
  }
}