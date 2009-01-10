package spectacular.framework.reporters {
  
  import spectacular.framework.*;
  
  public class TraceSpecReporter extends TextSpecReporter {
    
    public function TraceSpecReporter() {
      super();
    }
    
    override protected function appendLine(...strings):void {
      trace.apply(null, strings);
    }
  }
}