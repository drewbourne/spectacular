package spec.framework
{
  public class ExampleGroup extends Example
  {
    public var examples     :Array;
    public var beforeAlls   :Array;
    public var befores      :Array;
    public var afters       :Array;
    public var afterAlls    :Array;
    
    private var _type:Class;
    
    public function ExampleGroup(parent:ExampleGroup, type:Class, description:String, implementation:Function)
    {
      super(parent, description, implementation);
      
      examples      = [];
      beforeAlls    = [];
      befores       = [];
      afters        = [];
      afterAlls     = [];
      
      _type = type;
    }
    
    public function get type():Class
    {
      return _type;
    }
    
    override public function toString():String
    {
      return '[ExampleGroup '+ type +':'+ description +' '+ state +']';
    }
  }
}
