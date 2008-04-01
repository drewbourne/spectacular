package spec.framework
{
  public class SpecExpectation
  {
    public function SpecExpectation(target:*, args:Array = null)
    {
      _matchers = [];
      _target = target;
      _args = args;
    }
    
    // properties
    
    private var _target:*;
    
    public function get target():*
    {
      return _target;
    }
    
    private var _args:Array;
    
    public function get args():Array
    {
      return _args;
    }
    
    private var _matchers:Array;
    
    public function get matchers():Array
    {
      return _matchers;
    }
    
    // methods

    public function should(...rest):SpecExpectation
    {
      // find and create matcher
      // push to matchers

      return this;
    }

    public function shouldNot(...rest):SpecExpectation
    {
      // find and create matcher
      // push to matchers

      return this;    
    }
  }
}