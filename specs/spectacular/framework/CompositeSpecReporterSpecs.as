package spectacular.framework { 
   
   import org.hamcrest.*;
   
   import spectacular.dsl.*;
   
   public function CompositeSpecReporterSpecs():void {
     
     describe("CompositeSpecReporter", function():void {
       var composite:CompositeSpecReporter;
       
       before(function():void {
         composite = new CompositeSpecReporter();
       });
       
       describe("adding a SpecReporter", function():void {
         
       });
       
       describe("methods", function():void {
         var child1:SpecReporterMock;
         var child2:SpecReporterMock;
         
         before(function():void {
           child1 = new SpecReporterMock();
           child2 = new SpecReporterMock();
           composite.addReporter(child1);
           composite.addReporter(child2);
         });
         
         after(function():void {
           Mock.verify(child1.mock, child2.mock);
         });
         
        ("start end startExample endExample startExampleGroup endExampleGroup failure").split(" ").forEach(function(method:String, i:int, a:Array):void {
           describe(method + " when called should call each child", function():void {
             child1.mock.method(method).withAnyArgs();
             child2.mock.method(method).withAnyArgs();
             composite[method]();
           });
         });
       });
       
       describe("when start is called", function():void {
         it("should call start on each child SpecReporter", function():void {
           
         });
       });
       
       describe("when end is called", function():void {
         
       });
     });
   }
}
