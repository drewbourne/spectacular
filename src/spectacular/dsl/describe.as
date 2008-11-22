package spectacular.dsl
{
  import spectacular.framework.Spec;
  
  public function describe(description:*, func:Function):void 
  {
    Spec.addExampleGroup(null, description, func);
  }
}