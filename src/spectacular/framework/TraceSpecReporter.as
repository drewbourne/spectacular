package spectacular.framework
{
  public class TraceSpecReporter implements SpecReporter
  {
    private var _nest:int = -1;
    private var _exampleGroupCount:int = 0;
    private var _exampleCount:int = 0;
    private var _failures:Array;
    
    public function TraceSpecReporter()
    {
      _failures = [];
    }
    
    public function start():void
    {
      trace('start');
    }
    
    public function end():void 
    {
      trace('\nDone');
      trace('\tTotal Example Groups:', _exampleGroupCount);
      trace('\tTotal Examples:', _exampleCount);
      trace('\tFailures:', _failures.length);
    }
    
    public function startExample(example:Example):void 
    {
      _nest++;
      _exampleCount++;
      var out:String = repeat('  ', _nest) + example.description;
      trace(out);
    }
    
    public function endExample(example:Example):void
    {
      _nest--;
    }
    
    public function startExampleGroup(exampleGroup:ExampleGroup):void
    {
      _nest++;
      _exampleGroupCount++;
      var out:String = repeat('  ', _nest) + exampleGroup.description;
      trace(out);
    }
    
    public function endExampleGroup(exampleGroup:ExampleGroup):void
    {
      _nest--;
    }
    
    public function failure(cause:Error):void
    {
      _failures.push(cause);
      trace(cause.getStackTrace());
    }
  }
}

internal function repeat(value:String, count:Number = 1):String {
  
  var out:String = '';
  while(count > 0){ out += value; --count; }
  return out;
}