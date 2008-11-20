package spec.dsl
{
  import spec.framework.*;
  
  public function it(description:String, func:Function):void 
  {
    Spec.addExample(description, func);
  }
}