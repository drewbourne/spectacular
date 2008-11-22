package spectacular.dsl
{
  import spectacular.framework.Spec;
  
  public function beforeAll(func:Function):void
  {
    Spec.addBeforeAll(func);
  }
}