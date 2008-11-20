package spec.dsl
{
  import spec.framework.*;
  
  public function async(fn:Function, failAfter:Number):Function 
  {
    return Spec.addAsync(fn, failAfter);
  }
}