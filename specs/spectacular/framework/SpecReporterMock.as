package spectacular.framework { 
  
  import com.anywebcam.mock.*;
  
  public class SpecReporterMock implements SpecReporter {
    public var mock:Mock;
    
    public function SpecReporterMock() {
      super();
      mock = new Mock(this);
    }
    
    public function start():void {
      mock.start();
    }
    
    public function end():void {
      mock.end();
    }
    
    public function startExample(example:Example):void {
      mock.startExample(example);
    }
    
    public function endExample(example:Example):void {
      mock.endExample(example);
    }
    
    public function startExampleGroup(exampleGroup:ExampleGroup):void {
      mock.startExampleGroup(exampleGroup);
    }
    
    public function endExampleGroup(exampleGroup:ExampleGroup):void {
      mock.endExampleGroup(exampleGroup);
    }
    
    public function failure(cause:Error):void {
      mock.failure(cause);
    }
  } 
}
