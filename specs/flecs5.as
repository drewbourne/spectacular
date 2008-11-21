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

describe('StringTable', function():void {
  it('should be awesome', function():void {
    
    var fields:Array = ['Total Example Groups', 'Total Examples', 'Failures'];
    var fieldLengths:Array = ArrayMethods.pluck(fields, 'length');
    var max:Number = Math.max.apply(null, fieldLengths);
    
    var table:Array = (fields.map(function(field:String, i:int, a:Array):String {
      return StringMethods.padLeft(field, max);
    }));
    
    trace(table.join('\n'));
    
  });
});