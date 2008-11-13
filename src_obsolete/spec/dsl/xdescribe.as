package spec.dsl
{
  import spec.framework.*;
  
  public function xdescribe(...rest):ExampleGroup
  {
    return SpecStaticMethods.xdescribe.apply(null, rest);
  }
}