package spectacular.framework
{
  public class ExampleGroup extends Example
  {
    private var _examples     :Array;
    private var _beforeAlls   :Array;
    private var _befores      :Array;
    private var _afters       :Array;
    private var _afterAlls    :Array;
    private var _type:Class;
    
    public function ExampleGroup(parent:ExampleGroup, type:Class, description:String, implementation:Function)
    {
      super(parent, description, implementation);
      
      _examples      = [];
      _beforeAlls    = [];
      _befores       = [];
      _afters        = [];
      _afterAlls     = [];
      
      _type = type;
    }
    
    override public function toString():String
    {
      return '[ExampleGroup '+ type +':'+ description +' '+ state +']';
    }
    
    public function get type():Class
    {
      return _type;
    }
    
    public function get examples():Array
    {
      return _examples;
    }
    
    public function get pendingExamples():Array {
      
      return _examples.filter(isPendingExample);
    }
    
    protected function isPendingExample(example:Example, i:int = 0, a:Array = null):Boolean {
      
      return example.isPending;
    }
    
    public function get beforeAlls():Array 
    {
      return _beforeAlls;
    }
    
    public function get befores():Array 
    {
      return _befores;
    }
    
    public function get afters():Array
    {
      return _afters;
    }
    
    public function get afterAlls():Array 
    {
      return _afterAlls;
    }
    
    public function addBeforeAll(fn:Function):void 
    {
      beforeAlls.push(fn);
    }
    
    public function addBefore(fn:Function):void 
    {
      befores.push(fn);
    }
    
    public function addAfter(fn:Function):void 
    {
      afters.push(fn);
    }
    
    public function addAfterAll(fn:Function):void 
    {
      afterAlls.push(fn);
    }
  }
}
