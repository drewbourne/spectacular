package spectacular.framework
{
  public interface SpecReporter
  {
    function start():void;
    
    function end():void;
    
    function startExample(example:Example):void;

    function endExample(example:Example):void;

    function startExampleGroup(exampleGroup:ExampleGroup):void;

    function endExampleGroup(exampleGroup:ExampleGroup):void;

    function failure(cause:Error):void;
  }
}