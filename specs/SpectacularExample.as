package
{
  import flash.display.Sprite;
  import flash.utils.setTimeout;
  import spectacular.framework.Spec;
  import spectacular.framework.SpecRunner;
  import spectacular.framework.TraceSpecReporter;
  
  public class SpectacularExample extends Sprite {
    
    private var runner:SpecRunner;
    
    public function SpectacularExample() {
      
      super();
      
      runner = new SpecRunnerBase(new TraceSpecReporter());

      setTimeout(function():void {
        runner.run(Spec.spec.currentExampleGroup);
      }, 1000);
    }
  }
}

public class SpectacularSpecs extends SpecRunnerBase {
  
  public function SpectacularSpecs() {
    super();
    
    // Public API Specifications
    DslSpecs();
    
    // Implementation Specifications
    ExampleSpecs();
    ExampleGroupSpecs();
    SpecSpecs();
    TraceSpecReporterSpecs();
    SpecRunnerSpecs();
    
    run();
  }
}

/*
<SpecRunnerMxml
  xmlns="spectacular.mxml.*"
  xmlns:mx="http://www.adobe.com/2006/mxml">
  
  <!-- fail idea -->
  <ExampleGroup>
    <description>...</description>
    <mx:Script><![CDATA[
      function()
      
    ]]></mx:Script>
  </ExampleGroup>
  
</SpecRunnerMxml>
*/