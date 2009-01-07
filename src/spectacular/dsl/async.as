package spectacular.dsl
{
  import spectacular.framework.Spec;
  
  public function async(fn:Function, failAfterMs:Number, failFn:Function = null):Function 
  {
    return Spec.addAsync(fn, failAfterMs, failFn);
  }
}