package spec.framework
{
  // used by the spec.dsl
  public class SpecStaticMethods
  {
    static private var _spec:Spec;

    static public function get spec():Spec
    {
      if(!_spec) 
      {
        _spec = new Spec();
      };
      return _spec;
    }

    static public function describe(...rest):ExampleGroup
    {
      return spec.describe.apply(null, rest);
    }
    
    static public function xdescribe(...rest):ExampleGroup
    {
      return spec.xdescribe.apply(null, rest);
    }    

    static public function it(...rest):Example
    {
      return spec.it.apply(null, rest);
    }

    static public function xit(...rest):Example
    {
      return spec.xit.apply(null, rest);
    }

    static public function expect(...rest):SpecExpectation
    {
      return spec.expect.apply(null, rest);
    }
  }
}