package spec.dsl
{
  import spec.dsl.*;
  
  describe('spec.dsl.*', function():void {
    it('should be awesome and close to the rspec version', function():void {
      
    });
  });
  
  describe('spec.framework.*', function():void {
    
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
      
    });
  });
}