package spec.framework
{
  import flash.utils.setTimeout;
  import flash.utils.clearTimeout;
  
  public class Spec
  {
    private static var _spec:Spec;
    
    public static function get spec():Spec
    {
      if (!_spec) 
      {
        spec = new Spec();
      }
      return _spec;
    }
    
    public static function set spec(spec:Spec):void 
    {
      _spec = spec;
    }
    
    public static function addExampleGroup(klass:Class, description:String, implementation:Function):void 
    {
      spec.addExampleGroup(klass, description, implementation);
    }
    
    public static function addExample(description:String, implementation:Function):void 
    {
      spec.addExample(description, implementation);
    }

    public static function addBeforeAll(fn:Function):void
    {
      spec.addBeforeAll(fn);
    }
    
    public static function addBefore(fn:Function):void
    {
      spec.addBefore(fn);
    }
    
    public static function addAfter(fn:Function):void
    {
      spec.addAfter(fn);
    }
    
    public static function addAfterAll(fn:Function):void
    {
      spec.addAfterAll(fn);
    }
    
    public static function addAsync(fn:Function, failAfter:Number):Function
    {
      return spec.addAsync(fn, failAfter);
    }
    
    // TODO separate the statics and the Spec impl into different classes
    
    private var _currentExampleGroup:ExampleGroup;
    private var _currentExample:Example;
    private var _pendingExamples:Array;
    private var _previousExampleGroups:Array;
    
    public var results:Object = {
      exampleGroupCount: 0
    , exampleCount: 0
    , passedCount: 0
    , failedCount: 0
    };
    
    public function Spec()
    {
      _pendingExamples = [];
      _previousExampleGroups = [];
      _currentExampleGroup = new ExampleGroup(null, null, 'root', null);
    }
    
    public function get currentExampleGroup():ExampleGroup 
    {
      return _currentExampleGroup;
    }
    
    public function set currentExampleGroup(exampleGroup:ExampleGroup):void 
    {
      _currentExampleGroup = exampleGroup;
    }
    
    public function get currentExample():Example
    {
      return _currentExample;
    }
    
    public function set currentExample(example:Example):void 
    {
      _currentExample = example;
    }
    
    public function get previousExampleGroups():Array 
    {
      return _previousExampleGroups;
    }
    
    public function get pendingExamples():Array
    {
      return _pendingExamples;
    }
    
    public function addExampleGroup(klass:Class, description:String, implementation:Function):ExampleGroup 
    {
      var exampleGroup:ExampleGroup = new ExampleGroup(currentExampleGroup, null, description, implementation);
      currentExampleGroup.examples.push(exampleGroup);
      return exampleGroup;
    }
    
    public function addExample(description:String, implementation:Function):Example 
    {
      var example:Example = new Example(currentExampleGroup, description, implementation);
      currentExampleGroup.examples.push(example);
      return example;
    }
    
    public function addBeforeAll(fn:Function):void 
    {
      currentExampleGroup.addBeforeAll(fn);
    }
    
    public function addBefore(fn:Function):void 
    {
      currentExampleGroup.addBefore(fn);
    }
    
    public function addAfter(fn:Function):void 
    {
      currentExampleGroup.addAfter(fn);
    }
    
    public function addAfterAll(fn:Function):void 
    {
      currentExampleGroup.addAfterAll(fn);
    }
    
    public function addAsync(fn:Function, failAfter:Number):Function
    {
      var asyncDetails:Object;

      var failTimeout:int = setTimeout(function():void {
        //spec.asyncs.splice(spec.asyncs.indexOf(asyncDetails), 1);
        
        throw new Error("async not called: "+ currentExample.description);
      }, failAfter);

      asyncDetails = { failTimeout: failTimeout, func:fn, failAfter: failAfter };
      currentExample.addAsync(asyncDetails);

      return function(...rest):void {
        clearTimeout(failTimeout);
        //spec.asyncs.splice(spec.asyncs.indexOf(asyncDetails), 1);
        fn.apply(null, rest);
      };
    }
  }
}
