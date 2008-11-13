package spec.framework
{
  public class Spec extends ExampleGroup
  {
    public function Spec()
    {
      super(null, null, 'specs', null);
    }
    
    // public var asyncs:Array = [];
    public var currentExampleGroup  :ExampleGroup;
    public var currentExample       :Example;
    public var pendingExamples      :Array = [];
    public var previousExampleGroups:Array = [];
    public var results:Object = {
      exampleGroupCount: 0
    , exampleCount: 0
    , passedCount: 0
    , failedCount: 0
    };
    
    public function addExampleGroup(klass:Class, description:String, implementation:Function):ExampleGroup {
      var exampleGroup:ExampleGroup = new ExampleGroup(currentExampleGroup, null, description, implementation);
      currentExampleGroup.examples.push(exampleGroup);
      return exampleGroup;
    }
    
    public function addExample(description:String, implementation:Function):Example {
      var example:Example = new Example(currentExampleGroup, description, implementation);
      currentExampleGroup.examples.push(example);
      return example;
    }
  }
}
