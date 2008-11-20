package spec.dsl
{
  import spec.framework.*;
  
  public function afterAll(func:Function):void 
  {
    Spec.addAfterAll(func);
  }
}