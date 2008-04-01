package spec.framework
{
  public class Example
  {
    public function Example(parent:ExampleGroup, desc:String, impl:Function)
    {
      _expectations = [];
      _parent = parent;
      _desc = desc;
      _impl = impl;
    }
    
    private var _parent:ExampleGroup;
    
    public function get parent():ExampleGroup
    {
      return _parent;
    }

    private var _desc:String;
    
    public function get desc():String
    {
      return _desc;
    }
    
    private var _impl:Function;
    
    public function get impl():Function
    {
      return _impl;
    }
    
    private var _expectations:Array;
    
    public function get expectations():Array 
    {
      return _expectations;
    }
    
    public function toString():String
    {
      return '[Example '+ desc +']';
    }
  }
  
}