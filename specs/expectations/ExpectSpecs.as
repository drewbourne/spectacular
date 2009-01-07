package expectations {
  
  import spectacular.dsl.*;
  
  public function ExpectSpecs():void {
    
    describe('expect()', function():void {
      describe('matches a literal', function():void {
        expect(2, 2);
        expect("string", "string");
        expect(true, true);
        expect([1, 2, 3], [1, 2, 3]);
      });
      
      describe('matches a return value', function():void {
        expect(2, function():Number { return 2; });
        expect("string", function():String { return "string"; });
      });
      
      describe('matches an error', function():void {
        expect(ArgumentError, function():void {
          
        });
      });
      
      describe('matches an event', function():void {
        expect(new Event("waffles"), eventDispatcher, function():void {
          
        });
        
        expect(eventDispatcher, new Event("somePropertyChanged"), function():void {
          
        });
        
        assertEvent("somePropertyChanged", eventDispatcher, )
      });
    });
  }
}