package spec.framework
{
  public class SpecReporter
  {
    public function SpecReporter()
    {
      
    }
    
    public function startExample(example:Example):void 
    {
      trace('startExample', example);
    }
    
    public function endExample(example:Example):void
    {
      trace('endExample', example);
    }
    
    public function startExampleGroup(exampleGroup:ExampleGroup):void
    {
      trace('startExampleGroup', exampleGroup);
    }
    
    public function endExampleGroup(exampleGroup:ExampleGroup):void
    {
      trace('endExampleGroup', exampleGroup);
    }
    
    public function error():void 
    {
      
    }
    
    public function failure():void
    {
      
    }
  }
}