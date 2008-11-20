package spec.dsl
{
  import spec.framework.*;
  
  public function before(func:Function):void 
  {
    Spec.addBefore(func);
  }
}