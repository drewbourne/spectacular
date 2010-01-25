package spectacular.internals {
  
  import asx.string.formatToString;

  /**
   * 
   */  
  public class Example {
    
    /**
     * Constructor.
     */
    public function Example() {
      super();
      _asyncs = [];
    }
    
    // 
    //  properties
    //

    /**
     * 
     */
    public function get parent():Context {
      return _parent;
    }
    
    public function set parent(value:Context):void {
      _parent = value;
    }
    
    private var _parent:Context;    
    
    /**
     * 
     */
    public function get description():String {
      return _description;
    }
    
    public function set description(value:String):void {
      _description = value;
    }
    
    private var _description:String;
    
    /**
     * 
     */
    public function get exampleFunction():Function {
      return _exampleFunction;
    }
    
    public function set exampleFunction(value:Function):void {
      _exampleFunction = value;
    }
    
    private var _exampleFunction:Function;
    
    /**
     * 
     */
    public function get asyncs():Array {
      return _asyncs.slice(0);
    }
    
    private var _asyncs:Array;
    
    /**
     * 
     */
    public function addAsync(async:Async):void {
      _asyncs[_asyncs.length] = async;
    }
    
    //
    //  methods
    //
    
    /**
     * 
     */    
    public function toString():String {
      return formatToString(this, "Example", ["description", "parent"]);
    }
  }
}
