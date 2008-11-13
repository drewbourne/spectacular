package spec.framework
{
  import flash.utils.*;
  
  public class SpecRunner
  {
    private var _spec:Spec;
    private var _reporter:SpecReporter;

    public function SpecRunner(spec:Spec, reporter:SpecReporter)
    {
      _spec = spec;
      _reporter = reporter;
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
      // check if it is a Spec
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
  
    public function runExample(example:Example):void
    {
      // get the async()s before this example runs
      var asyncsBefore:Array = example.asyncs.slice(0);
      
      // notify the report that we are about to start an example
      reporter.startExample(example);
    
      // run the beforeEaches for this example, and up the parent heirarchy
      /*var befores:Array = ArrayMethods.flatten(ObjectMethods.unfold(example, function(exampleGroup:ExampleGroup):Array {
        return example.parent.beforeEaches;
      }, function(example:Example):Boolean {
        return example.parent != null;
      }));*/
    
      // run the implementation closure to trigger expect()s & async()s
      spec.currentExample = example;
      example.state = ExampleState.RUNNING;
      example.implementation();
    
      // run the afterEaches for this example, and up the parent heirarchy
      // see beforeEaches as above
    
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
      
      setTimeout(function():void {
        example.state = ExampleState.COMPLETED;
      
        // notify the report that we have finished an example
        reporter.endExample(example);
      
        runNext(example);
      }, totalAsyncTime);
    }
  
    public function runExampleGroup(exampleGroup:ExampleGroup):void
    {
      // shove any pending examples / example groups somewhere
      // because we want to be able to return to them later
    
      // set this exampleGroup as the current example group
      spec.previousExampleGroups.push(spec.currentExampleGroup);
      spec.currentExampleGroup = exampleGroup;
    
      // notify the reporter that we are about to start an example group
      reporter.startExampleGroup(exampleGroup);
    
      // run the implementation closure to trigger describe()s and it()s
      // new describes and its will be added to the current example group (this exampleGroup);
      // note: not all example groups will have an implementation, especially in the case of the root spec
      if (exampleGroup.implementation is Function)
      {
        exampleGroup.state = ExampleState.RUNNING;
        exampleGroup.implementation();
      }
    
      // we should now have some example in the current example group
      // we'll run them next as that seems like the least surprising thing to do.
      // makes it a bit tricky for the implementation but meh, yay!
      trace(exampleGroup.examples.length);
      
      // shove the new examples to the top of the pending examples array
      // spec.pendingExamples.unshift.apply(spec.pendingExamples, exampleGroup.examples);
      // trace(spec.pendingExamples.length);
      
      // run the next example
      runNext(exampleGroup);
      
      
      // notify the reporter we have finished an example group
      // this should only be triggered once all its examples & children example groups have been set to completed
      // reporter.endExampleGroup(exampleGroup);
    }
    
    public function runNext(current:Example):void 
    {
      trace('runNext current\n\t' + current);
      
      // find the first pending example
      if (current is ExampleGroup)
      {
        var pending:Array = (current as ExampleGroup).examples.filter(function(example:Example, i:int, a:Array):Boolean {
          return example.state.equals(ExampleState.PENDING);
        });
        
        trace('runNext pending\n\t' + pending.join('\n\t'));
        
        if (pending.length > 0)
        {
          run(pending.shift());
          return;
        }
      }
      
      // else if its an example, check its parents
      if (current.parent)
      {
        if (current is ExampleGroup) {
          // we've run out of pending examples so we notify the reporter we have finished with this example group
          reporter.endExampleGroup(current as ExampleGroup);
        }

        runNext(current.parent);
        return;
      }
      
      // else we are at the top of the spec heirarchy and can safely stop
      trace('done.');
    }
  
    public function shitrunNext(current:Example):void 
    {
      // find the next pending example in the current example group
      var pending:Array = spec.currentExampleGroup.examples.filter(function(example:Example, i:int, a:Array):Boolean {
        return example.state.equals(ExampleState.PENDING);
      });
      
      trace ('pending', pending);
      
      if (pending.length == 0)
      {
        spec.currentExampleGroup.state = ExampleState.COMPLETED;
      }
      
      var next:Example = pending.shift();

      // if we've got a pending example run it
      if (next)
      {
        run(next);
        return;
      }
      
      // else find the previous example group, if it has pending examples, run the first pending example
      var pendingGroups:Array = spec.previousExampleGroups.filter(function(example:Example, i:int, a:Array):Boolean {
        return example.state.equals(ExampleState.PENDING);
      });
      
      trace('pendingGroups', pendingGroups);
      
      var nextGroup:ExampleGroup = pendingGroups.shift();
      
      /*spec.currentExampleGroup = spec.previousExampleGroups.filter(function(example:Example, i:int, a:Array):Boolean {
        return example.state.equals(ExampleState.PENDING);
      }).shift();
      
      runNext();*/
    }
  }
}