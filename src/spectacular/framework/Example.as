package spectacular.framework
{
  public class Example
  {
    private var _parent         :ExampleGroup;
    private var _description    :String;
    private var _implementation :Function;
    private var _asyncs         :Array;
    private var _state          :ExampleState;
    
    public function Example(parent:ExampleGroup, description:String, implementation:Function)
    {
      _asyncs = [];
      _state = ExampleState.PENDING;
      
      _parent = parent;
      _description = description;
      _implementation = implementation;
    }
    
    public function toString():String
    {
      return '[Example '+ description +' '+ state +']';
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
 
    public function addAsync(asyncDetails:Object):void
    {
      asyncs.push(asyncDetails);
    }
    
    public function run():void {
      
      _state = ExampleState.RUNNING;
      implementation();
    }
    
    public function completed():void {
      
      _state = ExampleState.COMPLETED;
    }
    
    public function get isPending():Boolean {
      
      return ExampleState.PENDING.equals(state);
    }
    
    public function get isRunning():Boolean {
      
      return ExampleState.RUNNING.equals(state);
    }
    
    public function get isCompleted():Boolean {
      
      return ExampleState.COMPLETED.equals(state);
    }
  }
}