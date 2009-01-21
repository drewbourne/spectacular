package spectacular.framework
{
  import asx.ArrayMethods;
  
  import flash.utils.*;
  
  public class BaseSpecRunner implements SpecRunner
  {
    private var _spec:Spec;
    private var _reporter:SpecReporter;
    private var _running:Boolean;

    public function BaseSpecRunner(spec:Spec, reporter:SpecReporter)
    {
      _spec = spec;
      _reporter = reporter;
      _running = false;
    }
    
    public function get spec():Spec
    {
      return _spec;
    }
    
    public function get reporter():SpecReporter
    {
      return _reporter;
    }
  
    public function run(example:Example):void
    {
      if (!_running) {
        _running = true;
        reporter.start();
      }
      
      // check if it is an ExampleGroup
      // check if it is an Example
      if (example is ExampleGroup)
      {
        runExampleGroup(example as ExampleGroup);
      }
      else
      {
        runExample(example);
      }
    }
  
    protected function runExample(example:Example):void
    {
      // get the async()s before this example runs
      var asyncsBefore:Array = example.asyncs.slice(0);
      
      // notify the report that we are about to start an example
      reporter.startExample(example);
    
      // run the befores for this example, and up the parent heirarchy
      runBefores(example.parent);

      // run the implementation closure to trigger asyncs && assertions/expects/shoulds/matchers/what-have-you
      spec.currentExample = example;
      
      // not all example will have an implementation
      // for example: it('is just descriptive');
      // we should perhaps indicate to the reporter that the example group has no implementation
      if (example.implementation is Function) {
        try {
          example.run();
        } 
        catch (error:Error) {
          reporter.failure(error);
        }
      }
    
      // get the async()s after this example runs
      var asyncsAfter:Array = example.asyncs.slice(0);
      var asyncsAdded:Array = asyncsAfter.filter(function(value:Object, i:int, a:Array):Boolean { 
        return asyncsBefore.indexOf(value) == -1; 
      });
    
      // if there are asyncs we total the time they are expected to run
      // once the asyncs are run or expired we are safe to run the next example
      var totalAsyncTime:Number = 0;
      asyncsAdded.forEach(function(async:Object, i:int, a:Array):void {
        totalAsyncTime += async.failAfter;
      });
      
      // wait till any asyncs have been run, then continue
      setTimeout(function():void {
        
        // TODO complain if any of the asyncs failed to be called
        // TODO flag example as state == FAILED if it failed for any reason
        example.completed();
        
        // run the afters for this example, and up the parent hierarchy
        runAfters(example.parent);
        
        // notify the report that we have finished an example
        reporter.endExample(example);
      
        runNext(example);
      }, totalAsyncTime);
    }
  
    protected function runExampleGroup(exampleGroup:ExampleGroup):void
    {
      // shove any pending examples / example groups somewhere
      // because we want to be able to return to them later
      spec.previousExampleGroups.push(spec.currentExampleGroup);
          
      // set this exampleGroup as the current example group
      spec.currentExampleGroup = exampleGroup;
    
      // notify the reporter that we are about to start an example group
      reporter.startExampleGroup(exampleGroup);
      
      runBeforeAlls(exampleGroup);
    
      // run the implementation closure to trigger describe()s and it()s
      // new describes and its will be added to the current example group (this exampleGroup);
      // note: not all example groups will have an implementation, especially in the case of the root spec
      if (exampleGroup.implementation is Function)
      {
        // exampleGroup.state = ExampleState.RUNNING;
        // exampleGroup.implementation();
        try 
        {
          exampleGroup.run();
        } 
        catch (error:Error) 
        {
          // TODO put a better error description / helper text here
          trace('NOTE: the following error could well be because you are making assertions inside a describe() function instead of inside an it(). In the future some better handling will be added for this case.');
          throw error;
        }
      }
    
      // we should now have some example in the current example group
      // we'll run them next as that seems like the least surprising thing to do.
      // trace(exampleGroup.examples.length);
      
      // shove the new examples to the top of the pending examples array
      // spec.pendingExamples.unshift.apply(spec.pendingExamples, exampleGroup.examples);
      // trace(spec.pendingExamples.length);
      
      // run the next example
      runNext(exampleGroup);
    }
    
    protected function runNext(current:Example):void 
    {
      // find the first pending example
      if (current is ExampleGroup)
      {
        var pending:Array = (current as ExampleGroup).pendingExamples;
        
        if (pending.length > 0)
        {
          // setTimeout is used here to break recursive call chains avoiding deep recursion errors
          setTimeout(function():void {
            run(pending.shift());
          }, 10);
          
          return;
        }
      }
      
      // else if its an example, check its parents
      if (current.parent)
      {
        // example group is complete now so perform clean up operations
        if (current is ExampleGroup) 
        {
          var exampleGroup:ExampleGroup = current as ExampleGroup;
          
          // we've run out of pending examples so we notify the reporter we have finished with this example group
          reporter.endExampleGroup(exampleGroup);
          
          runAfterAlls(exampleGroup);
        }

        runNext(current.parent);
        return;
      }
      
      // else we are at the top of the spec hierarchy and can safely stop
      reporter.end();
    }
    
    /**
     * @private 
     */
    protected function invokeFunctionWithArgsIfArityMatches(...rest):Function {
      
      return function(fn:Function, i:int, a:Array):void {
        try 
        {
          fn.apply(null, rest && fn.length == rest.length ? rest : []);
        } 
        catch (error:Error) 
        {
          reporter.failure(error);
        }
      };
    }
    
    protected function pluckFromExampleGroupHierarchy(exampleGroup:ExampleGroup, field:String):Array {
      return ArrayMethods.unfold(
        exampleGroup, 
        exampleGroupAndParentIsNotNull,
        function(exampleGroup:ExampleGroup):Array {
          return (exampleGroup[field] as Array).slice(0).reverse();
        },
        exampleGroupParent
      );
    }
    
    protected function exampleGroupAndParentIsNotNull(exampleGroup:ExampleGroup):Boolean {
      return exampleGroup && exampleGroup.parent != null;
    }
    
    protected function exampleGroupParent(exampleGroup:ExampleGroup):ExampleGroup {
      return exampleGroup.parent;
    }
    
    protected function runBeforeAlls(exampleGroup:ExampleGroup):void {
      
      ArrayMethods.flatten(pluckFromExampleGroupHierarchy(exampleGroup, 'beforeAlls'))
        .reverse()
        .forEach(invokeFunctionWithArgsIfArityMatches(exampleGroup));      
    }
    
    protected function runBefores(exampleGroup:ExampleGroup):void {
      
      // unfold up the hierachy collecting before functions
      // reverse the order as we run first defined to last for each nested ExampleGroup
      // run the befores
      ArrayMethods.flatten(pluckFromExampleGroupHierarchy(exampleGroup, 'befores'))
        .reverse()
        .forEach(invokeFunctionWithArgsIfArityMatches(exampleGroup));
    }
    
    protected function runAfters(exampleGroup:ExampleGroup):void {
      
      // unfold up the heirarchy collecting after functions
      // keep the order as we run last defined to first for each nested ExampleGroup
      // run the afters
      ArrayMethods.flatten(pluckFromExampleGroupHierarchy(exampleGroup, 'afters'))
        .forEach(invokeFunctionWithArgsIfArityMatches(exampleGroup));
    }
 
    protected function runAfterAlls(exampleGroup:ExampleGroup):void {
      
      ArrayMethods.flatten(pluckFromExampleGroupHierarchy(exampleGroup, 'afterAlls'))
        .forEach(invokeFunctionWithArgsIfArityMatches(exampleGroup));
    }
  }
}