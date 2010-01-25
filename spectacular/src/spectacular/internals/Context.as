package spectacular.internals {
  
  import asx.string.formatToString;

  /**
   * 
   */  
  public class Context {
    
    /**
     * Constructor.
     */
    public function Context() {
      super();
      
      _examples = [];
      _befores = [];
      _afters = [];
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
    public function get contextFunction():Function {
      return _contextFunction;
    }
    
    public function set contextFunction(value:Function):void {
      _contextFunction = value;
    }
    
    private var _contextFunction:Function;
    
    /**
     * 
     */
    public function get examples():Array {
      return _examples.slice(0);
    }
    
    private var _examples:Array;    
    
    /**
     * @param example Example or Context
     */
    public function addExample(example:Object):void {
      _examples[_examples.length] = example;
    }
    
    /**
     * 
     */
    public function get befores():Array {
      return _befores.slice(0);
    }
    
    private var _befores:Array;
    
    /**
     * 
     */
    public function addBefore(before:Example):void {
      _befores[_befores.length] = before;
    }
    
    /**
     * 
     */
    public function get afters():Array {
      return _afters.slice(0);
    }
    
    private var _afters:Array;
    
    /**
     * 
     */
    public function addAfter(after:Example):void {
      _afters[_afters.length] = after;
    }
    
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
        
    /**
     * 
     */    
    public function toString():String {
      return formatToString(this, "Context", ["description", "parent"]);
    }
  }
}
