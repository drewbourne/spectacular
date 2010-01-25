package spectacular.listeners {
  
  import asx.string.formatToString;
  
  import org.flexunit.runner.IDescription;
  import org.flexunit.runner.Result;
  import org.flexunit.runner.notification.Failure;
  import org.flexunit.runner.notification.IRunListener;

  public class SpectacularRunListener implements IRunListener {
    
    public function SpectacularRunListener() {
      super();
    }

    public function testRunStarted(description:IDescription):void {
      trace(this, 'testRunStarted', description.displayName);
    }
    
    public function testRunFinished(result:Result):void {
      trace(this, 'testRunFinished', result.successful, result.failures);
    }
    
    public function testStarted(description:IDescription):void {
      trace(this, 'testStarted', description.displayName);
    }
    
    public function testFinished(description:IDescription):void {
      trace(this, 'testFinished', description.displayName);
    }
    
    public function testFailure(failure:Failure):void {
      trace(this, 'testFailure', failure.toString());
    }
    
    public function testAssumptionFailure(failure:Failure):void {
      trace(this, 'testAssumptionFailure', failure.toString());
    }
    
    public function testIgnored(description:IDescription):void {
      trace(this, 'testIgnored', description.displayName);
    }
  
    public function toString():String {
      return formatToString(this, 'SpectacularRunListener');
    }
  }
}