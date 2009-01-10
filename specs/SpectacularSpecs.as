package
{
  import flash.display.*;
  import flash.events.Event;
  import flash.utils.setTimeout;
  import flash.text.TextField;
  
  import spectacular.framework.CompositeSpecReporter;
  import spectacular.framework.Spec;
  import spectacular.framework.SpectacularSpecRunner;
  import spectacular.framework.reporters.TextSpecReporter;
  import spectacular.framework.reporters.TraceSpecReporter;

  import spectacular.framework.ExampleSpecs;  
  import spectacular.framework.BaseSpecRunnerSpecs;
  import spectacular.framework.CompositeSpecReporterSpecs;
  
  [SWF(backgroundColor="#F0F0F0")]
  public class SpectacularSpecs extends SpectacularSpecRunner {
    
    private var textReporter:TextSpecReporter;
    private var textField:TextField;
    
    public function SpectacularSpecs() {
      
      stage.align = StageAlign.TOP_LEFT;
      stage.scaleMode = StageScaleMode.NO_SCALE;
      
      var reporter:CompositeSpecReporter = new CompositeSpecReporter();
      reporter.addReporter(new TraceSpecReporter());
      reporter.addReporter(textReporter = new TextSpecReporter());

      textReporter.addEventListener("textChanged", function(event:Event):void {
        textField.text = textReporter.text;
      });
      
      textField = new TextField();
      addChild(textField);

      super(reporter);
      
      setTimeout(function():void {
        textField.width = stage.stageWidth;
        textField.height = stage.stageHeight;

        ExampleSpecs();
        BaseSpecRunnerSpecs();
        CompositeSpecReporterSpecs();

        run(Spec.root);        
      }, 100);
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