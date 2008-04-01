package
{
  import flash.display.*;
  import flash.event.*;
  
  import spec.*;
  import spec.framework.*;
  
  public class SpecSpecs extends Sprite
  {
    public function SpecSpecs()
    {
      super();
      
      runner = new SpecRunner();
      runner.run(Spec.specs);
    }
  }
}

import spec.*;
import spec.dsl.*;

Spec.add(function():void {
  
});