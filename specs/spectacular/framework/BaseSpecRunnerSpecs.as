package spectacular.framework 
{
  import org.hamcrest.*;
  
  import spectacular.dsl.*;
  
  public function BaseSpecRunnerSpecs():void 
  {
    describe("BaseSpecRunner", function():void {
      describe("running an Example", function():void {
        it("should run the Example implementation", function():void {
          
        });
        
        it("should notify the SpecReporter of starting an Example", function():void {
          
        });
        
        it("should notify the SpecReporter of ending an Example", function():void {
          
        });
      });
      
      describe("running a nested Example", function():void {
        it("should call befores outermost to innermost", function():void {
          
        });
        
        it("should call afters innermost to outermost", function():void {
          
        });
      });
      
      describe("running an Example that throws an error", function():void {
        it("should notify the SpecReporter of failure", function():void {
          
        });
      });
      
      describe("running an Example that fails", function():void {
        it("should notify the SpecReporter of failure", function():void {
          
        });
      });
      
      describe("running an Async Example", function():void {
        it("should ...", function():void {
          
        });
      });
      
      describe("running an Async Example that times-out", function():void {
        it("should", function():void {
          
        });
      });
    });
  }
}