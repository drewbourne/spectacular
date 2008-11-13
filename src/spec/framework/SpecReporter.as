package spec.framework
{
  public interface SpecReporter
  {
    function startExample(example:Example):void;

    function endExample(example:Example):void;

    function startExampleGroup(exampleGroup:ExampleGroup):void;

    function endExampleGroup(exampleGroup:ExampleGroup):void;

    function error():void;

    function failure():void;
  }
}