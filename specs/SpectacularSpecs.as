package
{
  import flash.display.Sprite;
  import flash.utils.setTimeout;
  
  import spectacular.framework.ExampleSpecs;  
  import spectacular.framework.Spec;
  import spectacular.framework.SpectacularSpecRunner;
  
  [SWF(backgroundColor="#F0F0F0")]
  public class SpectacularSpecs extends SpectacularSpecRunner {
    
    public function SpectacularSpecs() {
      
      super();
      
      ExampleSpecs();
      
      run(Spec.root);
    }
  }
}

/*

// clean, direct, win
public class ProjectSpecs extends SpectacularSpecRunner {
  
  public function ProjectSpecs() {
    
    super();
    run(
      DslSpecs, 
      ExampleSpecs, 
      ExampleGroupSpecs, 
      SpecSpecs, 
      TraceSpecReportSpecs, 
      SpectacularSpecRunnerSpecs);
  }
}

// nice for mxml addicts
<specs:SpectacularSpecRunner
  xmlns:specs="spectacular.framework.mxml"
  xmlns:dsl="spectacular.dsl">

  <specs:specs>
    <dsl:DslSpecs />
    <specs:ExampleSpecs />
    <specs:ExampleGroupsSpecs />
    <specs:SpecSpecs />
    <specs:TraceSpecReporterSpecs />
    <specs:SpectacularSpecRunnerSpecs />
  </specs:specs>
  
</specs:SpectacularSpecRunner>

// too much indirection
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
*/
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