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
      trace('SpecRunner.run', example);
      
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
      
        runNext();
      }, totalAsyncTime);
    }
  
    public function runExampleGroup(exampleGroup:ExampleGroup):void
    {
      // shove any pending examples / example groups somewhere
      // because we want to be able to return to them later
    
      // set this exampleGroup as the current example group
      spec.currentExampleGroup = exampleGroup;
    
      // notify the reporter that we are about to start an example group
      reporter.startExampleGroup(exampleGroup);
    
      // run the implementation closure to trigger describe()s and it()s
      // new describes and its will be added to the current example group (this exampleGroup);
      // note: not all example groups will have an implementation, especially in the case of the root spec
      if (exampleGroup.implementation is Function)
      {
        exampleGroup.implementation();
      }
    
      // we should now have some example in the current example group
      // we'll run them next as that seems like the least surprising thing to do.
      // makes it a bit tricky for the implementation but meh, yay!
      trace(exampleGroup.examples.length);
      
      
      
      // notify the reporter we have finished an example group
      // this should only be triggered once all its examples & children example groups have been set to completed
      reporter.endExampleGroup(exampleGroup);
    }
  
    public function runNext():void 
    {
      // find the next pending example in the current example group
    }
  }
}