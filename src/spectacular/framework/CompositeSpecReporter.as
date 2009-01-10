package spectacular.framework { 
  
  import asx.array.invoke;
  
  public class CompositeSpecReporter implements SpecReporter {

    private var _reporters:Array;

    public function CompositeSpecReporter() {
      super();
      _reporters = [];
    }

    public function get reporters():Array {
      return _reporters;
    }
    
    public function start():void {
      invokeReporters('start');
    }
    
    public function end():void {
      invokeReporters('end');
    }
    
    public function startExample(example:Example):void {
      invokeReporters('startExample', example);
    }
    
    public function endExample(example:Example):void {
      invokeReporters('endExample', example);
    }
    
    public function startExampleGroup(exampleGroup:ExampleGroup):void {
      invokeReporters('startExampleGroup', exampleGroup);
    }
    
    public function endExampleGroup(exampleGroup:ExampleGroup):void {
      invokeReporters('endExampleGroup', exampleGroup);
    }
    
    public function failure(cause:Error):void {
      invokeReporters('failure', cause);
    }
    
    public function addReporter(reporter:SpecReporter):void {
      _reporters.push(reporter);
    }
    
    protected function invokeReporters(method:String, ...args):void {
      invoke.apply(null, [_reporters, method].concat(args));
    }
  }
}
