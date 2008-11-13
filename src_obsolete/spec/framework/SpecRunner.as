package spec.framework
{
  public class SpecRunner
  {
    public function SpecRunner()
    {
    }
    
    public function run(exampleGroups:Array, options:Object = null):void
    {
      // ignore async for now
      trace(this, 'run', exampleGroups.length);
      
      exampleGroups.forEach(iterator( runExample ));
    }
    
    private function runExample(e:Example, options:Object = null):void
    {
      trace( this, 'runExample', e );
      
      e.impl();
      
      if(e is ExampleGroup)
      {
        runExampleGroup(e as ExampleGroup);
      }
    }
    
    private function runExampleGroup(eg:ExampleGroup, options:Object = null):void
    {
      trace( this, 'runExampleGroup', eg, eg.examples.length );
      eg.examples.forEach(iterator( runExample ));
    }
  }
}

internal function iterator( f:Function ):Function {
  return function(v:*, i:int, a:Array):* { return f(v); }
}