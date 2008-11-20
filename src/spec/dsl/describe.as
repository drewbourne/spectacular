package spec.dsl
{
  import spec.framework.*;
  
  public function describe(description:*, func:Function):void 
  {
    Spec.addExampleGroup(null, description, func);
  }
}