package spectacular.dsl
{
  import spectacular.framework.Spec;
  
  public function async(fn:Function, failAfterMs:Number):Function 
  {
    return Spec.addAsync(fn, failAfterMs);
  }
}