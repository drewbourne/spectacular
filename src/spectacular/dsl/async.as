package spectacular.dsl
{
  import spectacular.framework.Spec;
  
  public function async(fn:Function, failAfter:Number):Function 
  {
    return Spec.addAsync(fn, failAfter);
  }
}