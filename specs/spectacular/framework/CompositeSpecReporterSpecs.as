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
        it("should add the SpecReporter to the composite.specReporters collection", function():void {
          var specReporter:SpecReporterMock = new SpecReporterMock;
          composite.addReporter(specReporter);
          assertThat(composite.reporters, equalTo([specReporter]));
        });
      });
       
      describe("methods", function():void {
        var child1:SpecReporterMock;
        var child2:SpecReporterMock;
        var eg:ExampleGroup;
        var e:Example;
         
        before(function():void {
          child1 = new SpecReporterMock();
          child2 = new SpecReporterMock();
          composite.addReporter(child1);
          composite.addReporter(child2);
          eg = new ExampleGroup(null, null, null, null);
          e = new Example(null, null, null);
        });
         
        after(function():void {
          child1.mock.verify();
          child2.mock.verify();
        });
        
        ("start end").split(" ").forEach(function(method:String, i:int, a:Array):void {
          describe('#' + method, function():void {
            it("should call each reporter#"+ method, function():void {
              child1.mock.method(method).withNoArgs;
              child2.mock.method(method).withNoArgs;
              composite[method]();
            });
          });
        });
         
        ("startExample endExample").split(" ").forEach(function(method:String, i:int, a:Array):void {
          describe('#' + method, function():void {
            it("should call each reporter#" + method, function():void {
              child1.mock.method(method).withArgs(e);
              child2.mock.method(method).withArgs(e);
              composite[method](e);
            });
          });
        });
        
        ("startExampleGroup endExampleGroup").split(" ").forEach(function(method:String, i:int, a:Array):void {
          describe('#' + method, function():void {
            it("should call each reporter#" + method, function():void {
              child1.mock.method(method).withArgs(eg);
              child2.mock.method(method).withArgs(eg);
              composite[method](eg);
            });
          });
        });       
     });
    });
  }
}
