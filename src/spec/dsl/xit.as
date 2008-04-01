package spec.dsl
{
  import spec.framework.*;
  
  public function xit(...rest):Example
  {
    return SpecStaticMethods.xit.apply(null, rest);
  }
}