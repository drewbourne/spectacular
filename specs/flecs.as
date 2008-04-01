package
{
  import flash.display.*;
  import flash.events.*;
  import spec.dsl.*;
  import spec.framework.*;
  
  public class flecs extends Sprite
  {
    private var runner:SpecRunner;
    private var reporter:SpecReporter
    
    public function flecs ()
    {
      super();
            
      reporter  = new TraceSpecReporter();
      runner    = new SpecRunner();
      runner.run(SpecStaticMethods.spec.exampleGroups, {reporter: reporter});
    }
  }
}

import spec.dsl.*;
import spec.framework.*;

describe('spec.framework.*', function():void {
  trace('spec.framework.* impl');

  describe(Spec, 'Static Methods', function():void {
    trace('Spec.Static Methods impl');
    
    describe('describe', function():void {
      trace('Spec.Static Methods / describe impl');
      
      it('should be nestable', function():void { 
        trace('Spec.Static Methods / describe "it should be nestable"');
      });
    })
  });
  
  describe(ExampleGroup, 'Constructor', function(eg:ExampleGroup):void {
    it('should eat Class, description and closure function', function():void {
      trace('ExampleGroup Constructor');
    });
  });
  
  describe(ExampleGroup, 'Methods', function():void {
    
    beforeAll(function():void {
      trace('ExampleGroup Methods beforeAll');
    });
    
    afterAll(function():void {
      trace('ExampleGroup Methods afterAll');
    });
    
    beforeEach(function():void {
      trace('ExampleGroup Methods beforeEach');
    });
    
    afterEach(function():void {
      trace('ExampleGroup Methods afterEach');
    });
    
    it('should have beforeAlls, afterAlls, beforeEaches, afterEaches, and examples', function(s:Object):void {
      trace('ExampleGroup Methods it()');
    });
    
    it('should support async execution', function():void {
      // var listener:Function = function(e:Event):void {};
      // something.addEventListener('someEvent', addAsync(listener, 100));
      // something.addEventListener('someOtherEvent', addAsync(listener, 100));
    })
    
  });
});

/*
describe('spec.dsl.*', function():void {
  it('should be awesome and close to the rspec version', function():void {
    
  });
});
*/