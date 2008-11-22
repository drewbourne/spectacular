package spectacular.dsl
{
  import spectacular.framework.Spec;
  
  public function afterAll(func:Function):void 
  {
    Spec.addAfterAll(func);
  }
}