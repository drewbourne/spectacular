package spectacular.framework 
{
  import flash.errors.IllegalOperationError;
  
  import org.hamcrest.*;
  
  import spectacular.dsl.*;
  
  public function ExampleSpecs():void 
  {
    /**
     * Factory for Example instances
     */
    function createExample(overrides:Object = null):Example 
    {
      overrides = overrides || {};
      var e:Example = new Example(
        overrides.parent || null, 
        overrides.description || "test example", 
        overrides.implementation || overrides.impl || overrides.fn);
      return e;
    };
    
    /**
     * Do nothing
     */
    function noop():void {
      ;
    }
    
    describe("Example", function():void {
      var e:Example;
      
      before(function():void {
        e = createExample();
      });
      
      describe("properties", function():void {
        
      });
      
      describe("a new Example", function():void {
        it("should be pending", function():void {
          assertThat(e.isPending, equalTo(true));
          assertThat(e.state, equalTo(ExampleState.PENDING));
        });
        
        it("should not be running", function():void {
          assertThat(e.isRunning, equalTo(false));
          assertThat(e.state, not(equalTo(ExampleState.RUNNING)));
        });
        
        it("should not be completed", function():void {
          assertThat(e.isCompleted, equalTo(false));
          assertThat(e.state, not(equalTo(ExampleState.COMPLETED)));
        });
        
        it("should ignore reset", function():void {
          e.reset();
          assertThat(e.isPending, equalTo(true));
          assertThat(e.state, equalTo(ExampleState.PENDING));
        });
      });
      
      describe("a running Example", function():void {
        before(function():void {
          // create an example that will still be running while our assertions are made.
          e = createExample({
              description: "running example", 
              implementation: function():void { 
                // we dont care if the async doesnt fire, so we'll supply a custom fail function
                async(noop, 200, noop);
              }
            });
          e.run();
        });
        
        it("should not be pending", function():void {
          assertThat(e.isPending, equalTo(false));
          assertThat(e.state, not(equalTo(ExampleState.PENDING)));
        });
        
        it("should be running", function():void {
          assertThat(e.isRunning, equalTo(true));
          assertThat(e.state, equalTo(ExampleState.RUNNING));
        });
        
        it("should not be completed", function():void {
          assertThat(e.isCompleted, equalTo(false));
          assertThat(e.state, not(equalTo(ExampleState.COMPLETED)));
        });
        
        it("should complain if reset", function():void {
          assertThat(e.reset, throws(IllegalOperationError));
        });
      });
      
      describe("a completed Example", function():void {
        before(function():void {
          e.completed();
        });
        
        it("should not be pending", function():void {
          assertThat(e.isPending, equalTo(false));
          assertThat(e.state, not(equalTo(ExampleState.PENDING)));
        });
        
        it("should not be running", function():void {
          assertThat(e.isRunning, equalTo(false));
          assertThat(e.state, not(equalTo(ExampleState.RUNNING)));
        });
        
        it("should be completed", function():void {
          assertThat(e.isCompleted, equalTo(true));
          assertThat(e.state, equalTo(ExampleState.COMPLETED));
        });
        
        it("should be pending after reset", function():void {
          e.reset();
          assertThat(e.isPending, equalTo(true));
          assertThat(e.state, equalTo(ExampleState.PENDING));
        });
      });      
    });
  }
}