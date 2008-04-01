package spec
{
  public class Example
  {
    public var expectations:Array;
    
    public function Example(desc:String, impl:Function)
    {
      expectations = [];
      
      _desc = desc;
      _impl = impl;
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
  }
  
}