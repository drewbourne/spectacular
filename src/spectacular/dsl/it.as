package spectacular.dsl
{
  import spectacular.framework.Spec;
  
  public function it(description:String, func:Function):void 
  {
    Spec.addExample(description, func);
  }
}