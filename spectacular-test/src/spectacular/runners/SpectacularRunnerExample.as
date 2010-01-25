package spectacular.runners
{
  import asx.fn.noop;
  
  import flash.events.EventDispatcher;
  import flash.utils.setTimeout;
  
  import org.flexunit.assertThat;
  import org.flexunit.asserts.fail;
  import org.hamcrest.object.notNullValue;
  
  import spectacular.*;
  
  [RunWith("spectacular.runners.SpectacularRunner")]
  public class SpectacularRunnerExample
  {
    public function SpectacularRunnerExample() {
      
      // FIXME notification is proper broken for this case.  
//      throw new Error("oh no!");
      
      it("should report it() as a Test");
      
      describe("should run nested contexts", function():void {
        describe("nested context", function():void {
          it("should run multiple its");
          it("should run another it just to be sure");
        });
      });
      
      describe("failing examples", function():void {
        it("example should be reported as a failure", function():void {
          throw new Error("example boom!");
        });
        
        // FIXME notification is proper broken for this case.
        describe("context should be reported as a failure", function():void {
          throw new Error("contextual boom!");
        });
      });
      
      describe("async examples", function():void {
        describe("async before", function():void {
          var dispatcher:EventDispatcher;
          
          before(function():void {
            // pretend for some reason we can't create the dispatcher immediately 
            setTimeout(async(function():void {
              dispatcher = new EventDispatcher();
            }, 500), 100);   
          });
          
          it("dispatcher should be created", function():void {
            assertThat(dispatcher, notNullValue());
          });
        });
        
        describe("async after", function():void {
          var dispatcher:EventDispatcher;
          
          before(function():void {  
            dispatcher = new EventDispatcher() 
          });
          
          after(function():void {
            // pretend we can't destroy the dispatcher immediately
            setTimeout(async(function():void { 
              dispatcher = null 
            }, 500), 100); 
          });
          
          it("do dee doo");
        });
      });
    
//        describe("syntax errors", function():void {
//
//          describe("async() in describe() should explode", function():void {
//            try {
//              async(noop);
//              fail("async() in describe() should throw a SyntaxError");
//            }
//            catch (error:SyntaxError) {
//              // expected, carry on
//            }
//          });
//
//          it("describe() in it() should explode", function():void {
//            try {
//              describe("should cause syntax error");
//              fail("describe() in it() should throw a SyntaxError");
//            }
//            catch (error:SyntaxError) {
//              // expected, carry on  
//            }
//          });
//          
//        });      
    }
  }
}