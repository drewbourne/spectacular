package spec.framework
{
  public class TraceSpecReporter implements SpecReporter
  {
    private var _nest:int = 0;
    
    public function TraceSpecReporter()
    {
      
    }
    
    public function startExample(example:Example):void 
    {
      _nest++;
      var out:String = StringMethods.repeat(' ', _nest) + example.description;
      trace(out);
    }
    
    public function endExample(example:Example):void
    {
      _nest--;
    }
    
    public function startExampleGroup(exampleGroup:ExampleGroup):void
    {
      _nest++;
      var out:String = StringMethods.repeat(' ', _nest) + exampleGroup.description;
      trace(out);
    }
    
    public function endExampleGroup(exampleGroup:ExampleGroup):void
    {
      _nest--;
    }
    
    public function error():void 
    {
      throw new Error('Not Implemented');
    }
    
    public function failure():void
    {
      throw new Error('Not Implemented');
    }
  }
}