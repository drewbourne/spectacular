package spec.dsl
{
  import spec.framework.*;
  
  public function beforeAll(func:Function):void 
  {
    Spec.addBeforeAll(func);
  }
}