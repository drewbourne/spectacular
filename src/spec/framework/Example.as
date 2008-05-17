package spec.framework
{
  public class Example
  {
    private var _parent         :ExampleGroup;
    private var _description    :String;
    private var _implementation :Function;
    private var _expectations   :Array;
    private var _asyncs         :Array;
    private var _state          :ExampleState = ExampleState.PENDING;
    
    public function Example(parent:ExampleGroup, description:String, implementation:Function)
    {
      _expectations = [];
      _asyncs = [];
      
      _parent = parent;
      _description = description;
      _implementation = implementation;
    }
    
    public function get parent():ExampleGroup
    {
      return _parent;
    }
    
    public function get description():String
    {
      return _description;
    }
    
    public function get implementation():Function
    {
      return _implementation;
    }
    
    public function get expectations():Array 
    {
      return _expectations;
    }
    
    public function get asyncs():Array
    {
      return _asyncs;
    }
    
    public function get state():ExampleState
    {
      return _state;
    }
    
    public function set state(state:ExampleState):void 
    {
      _state = state;
    }
    
    public function toString():String
    {
      return '[Example '+ description +']';
    }
  }
}