package spectacular.internals {
  
  /**
   * Constructor. 
   */
  public class Async {
    
    /**
     * Constructor. 
     */
    public function Async() {
      super();
    }
    
    /**
     * 
     */
    public function get asyncFunction():Function {
      return _asyncFunction;
    }
    
    public function set asyncFunction(value:Function):void {
      _asyncFunction = value;
    }
    
    private var _asyncFunction:Function;
    
    /**
     * 
     */
    public function get failureTimeoutMs():int {
      return _failureTimeoutMs;
    }
    
    public function set failureTimeoutMs(value:int):void {
      _failureTimeoutMs = value;
    }
    
    private var _failureTimeoutMs:int;
    
    /**
     * 
     */
    public function get failureFunction():Function {
      return _failureFunction;
    }
    
    public function set failureFunction(value:Function):void {
      _failureFunction = value;
    }
    
    private var _failureFunction:Function;
    
    /**
     * 
     */
    public function get called():Boolean {
      return _called;
    }
    
    public function set called(value:Boolean):void {
      _called = value;
    }
    
    private var _called:Boolean;
    
    /**
     * 
     */
    public function get callback():Function {
      return _callback;
    }
    
    public function set callback(value:Function):void {
      _callback = value;
    }    
    
    private var _callback:Function;
    
    /**
     * 
     */
    public function get error():Error {
      return _error;
    }
    
    public function set error(value:Error):void {
      _error = value;
    }
    
    private var _error:Error;
  }
}