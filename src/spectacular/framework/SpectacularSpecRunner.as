package spectacular.framework {
  
  import flash.display.*;
  
  public class SpectacularSpecRunner extends Sprite implements SpecRunner {
    
    private var _runner:SpecRunner;
    
    public function SpectacularSpecRunner(reporter:SpecReporter = null, runner:SpecRunner = null) {
      
      super();
      
      _runner = runner || new BaseSpecRunner(Spec.spec, reporter || new TraceSpecReporter());
    }
    
    public function get specRunner():SpecRunner {
      
      return _runner;
    }
    
    public function run(example:Example):void {
      
      _runner.run(example);
    }
  }
}