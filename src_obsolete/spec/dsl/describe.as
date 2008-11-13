package spec.dsl
{
  import spec.framework.*;
  
  public function describe(...rest):ExampleGroup
  {
    return SpecStaticMethods.describe.apply(null, rest);
  }
}