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
  }
}
