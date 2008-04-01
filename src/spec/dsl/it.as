package spec.dsl
{
  import spec.framework.*;
  
  public function it(...rest):Example
  {
    trace('SpecStaticMethods.it', rest);
    return SpecStaticMethods.it.apply(null, rest);
  }
}