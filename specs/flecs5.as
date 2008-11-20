package
{
  import flash.display.*;
  import flash.events.*;
  
  public class flecs5 extends Sprite
  {
    public function flecs5()
    {
      super();
    }
  }
}

import flash.utils.*;
import spec.framework.*;

trace('\n---------\n');

// spec.framework
internal var runner:SpecRunner = new SpecRunner(Spec.spec, new TraceSpecReporter());

// setup the runner to run later
setTimeout(function():void {
  runner.run(Spec.spec.currentExampleGroup);
}, 1000);

// spec.dsl
import spec.dsl.*;
import org.hamcrest.*;

/*include 'SpecsAsyncSpecs.as'*/
include 'ArrayMethodsSpecs.as'
/*include 'FunctionMethodsSpecs.as'*/
/*include 'NumberMethodsSpecs.as'*/
/*include 'ObjectMethodsSpecs.as'*/
/*include 'StringMethodsSpecs.as'*/
