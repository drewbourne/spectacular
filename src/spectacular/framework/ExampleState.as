package spectacular.framework
{
  public class ExampleState
  {
    public static const PENDING   :ExampleState = new ExampleState('PENDING');
    public static const RUNNING   :ExampleState = new ExampleState('RUNNING');
    public static const COMPLETED :ExampleState = new ExampleState('COMPLETED');
    // ? public static const FAILED    :ExampleState = new ExampleState('FAILED');
    
    private var _value:String;
    
    public function ExampleState(value:String)
    {
      _value = value;
    }
    
    public function equals(state:ExampleState):Boolean 
    { 
      return state.valueOf() === valueOf(); 
    }
    
    public function valueOf():String 
    { 
      return _value; 
    }
    
    public function toString():String 
    { 
      return valueOf(); 
    }
  }
}