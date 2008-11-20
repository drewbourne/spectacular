package spec.dsl
{
  import spec.framework.*;
  
  public function after(func:Function):void 
  {
    Spec.addAfter(func);
  }
}