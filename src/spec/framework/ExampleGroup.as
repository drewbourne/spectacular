package spec
{
  public class ExampleGroup extends Example
  {
    public var examples     : Array;
    public var beforeAlls   : Array;
    public var beforeEaches : Array;
    public var afterEaches  : Array;
    public var afterAlls    : Array;

    public function ExampleGroup(type:Class, desc:String, impl:Function)
    {
      super(desc, impl);

      examples      = [];
      beforeAlls    = [];
      beforeEaches  = [];
      afterEaches   = [];
      afterAlls     = [];
      
      _type = type;
    }
    
    private var _type:Class;
    
    public function get type():Class
    {
      return _type;
    }
  }
}
