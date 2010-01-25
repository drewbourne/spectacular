package spectacular.internals {
  
  /**
   * 
   */
  public class SpectacularContext {
    
    //
    // Static evilness
    //
    
    public static function get instance():SpectacularContext {
      if (!_instance) 
        _instance = new SpectacularContext();
        
      return _instance;
    }
    
    public static function set instance(value:SpectacularContext):void {
      if (value) 
        _instance = value;
    } 
    
    private static var _instance:SpectacularContext;
    
    //
    //  instance goodness
    //
    
    /**
     * Constructor. 
     */
    public function SpectacularContext() {
      super();
      
      _currentContext = createContext("root");
    }
    
    //
    //  properties
    //
    
    /**
     * 
     */
    public function get currentContext():Context {
      return _currentContext;
    }
    
    // TODO namespace
    /** @private */
    public function set currentContext(value:Context):void {
      _currentContext = value; 
    }
    
    private var _currentContext:Context;
    
    /**
     * 
     */
    public function get currentExample():Example {
      return _currentExample;
    }

    // TODO namespace
    /** @private */    
    public function set currentExample(value:Example):void {
      _currentExample = value;
    }
    
    private var _currentExample:Example;
    
    //
    //  methods
    //

    public function describe(description:String, contextFunction:Function = null):void {
      currentContext.addExample(createContext(description, contextFunction));
    }
    
    public function it(description:String, exampleFunction:Function = null):void {
      currentContext.addExample(createExample(description, exampleFunction));
    }
    
    public function before(beforeFunction:Function):void {
      currentContext.addBefore(createExample("", beforeFunction));
    }
    
    public function after(afterFunction:Function):void {
      currentContext.addAfter(createExample("", afterFunction));
    }
    
    public function async(asyncFunction:Function, timeoutMs:int, failureFunction:Function = null):Function {
      var async:Async = createAsync(asyncFunction, timeoutMs, failureFunction);
      currentExample.addAsync(async);
      
      return function(...rest):* {
        async.called = true;
        
        return async.callback(rest); 
      };
    }
    
    /**
     * 
     */
    protected function createContext(description:String, contextFunction:Function = null):Context {
      var context:Context = new Context();
      context.description = description;
      context.contextFunction = contextFunction;
      context.parent = currentContext;
      return context;
    }
    
    /**
     * 
     */
    protected function createExample(description:String, exampleFunction:Function = null):Example {
      var example:Example = new Example();
      example.description = description;
      example.exampleFunction = exampleFunction;
      example.parent = currentContext;
      return example;  
    }
    
    /**
     * 
     */
    protected function createAsync(asyncFunction:Function, failureTimeoutMs:int, failureFunction:Function = null):Async {
      var async:Async = new Async();
      async.asyncFunction = asyncFunction;
      async.failureTimeoutMs = failureTimeoutMs;
      async.failureFunction = failureFunction;
      async.called = false;
      async.callback = function(...args):void {
        try {
          async.called = true;
          async.asyncFunction.apply(null, args);
        } 
        catch (error:Error) {
          async.error = error;
          throw error;
        }
      };
      return async;  
    }    
  }
}