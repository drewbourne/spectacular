package spectacular.dsl
{
  import spectacular.framework.Spec;
  
  public function before(func:Function):void 
  {
    Spec.addBefore(func);
  }
}