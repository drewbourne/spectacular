package spectacular.framework.reporters { 
  
  import flash.events.Event;
  import flash.events.EventDispatcher;
  import flash.utils.getTimer;
  
  import spectacular.framework.*;
  
  public class StatisticsSpecReporter extends EventDispatcher implements SpecReporter {
    
    private var _exampleGroupCount:int;
    private var _exampleCount:int;
    private var _failureCount:int;
    private var _runningTime:Number;
    private var _startTime:Number;
    
    public function StatisticsSpecReporter() {
      super();
      runningTime = 0;
    }
    
    // properties
    
    [Bindable]
    public function get exampleGroupCount():int {
      return _exampleGroupCount;
    }
    
    public function set exampleGroupCount(value:int):void {
      _exampleGroupCount = value;
    }
    
    [Bindable]
    public function get exampleCount():int {
      return _exampleCount;
    }
    
    public function set exampleCount(value:int):void {
      _exampleCount = value;
    }
    
    [Bindable]
    public function get failureCount():int {
      return _failureCount;
    }
    
    public function set failureCount(value:int):void {
      _failureCount = value;
    }
    
    [Bindable]
    public function get runningTime():Number {
      return _runningTime;
    }
    
    public function set runningTime(value:Number):void {
      _runningTime = value;
    }
    
    // methods
    
    public function start():void {
      _startTime = getTimer();
    }
    
    public function end():void {
      update();
    }
    
    public function startExample(example:Example):void {
      exampleCount++;
    }
    
    public function endExample(example:Example):void {
      update();
    }
    
    public function startExampleGroup(exampleGroup:ExampleGroup):void {
      exampleGroupCount++;
    }
    
    public function endExampleGroup(exampleGroup:ExampleGroup):void {
      update();
    }
    
    public function failure(cause:Error):void {
      failureCount++;
    }
    
    protected function update():void {
      var endTime:Number = getTimer();
      runningTime = endTime - _startTime;
    }
  } 
}
