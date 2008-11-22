package spectacular.dsl
{
  import spectacular.framework.Spec;
  
  public function after(func:Function):void 
  {
    Spec.addAfter(func);
  }
}