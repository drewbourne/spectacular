describe('NumberMethods', function():void {
  describe('between', function():void {
    it('should indicate if the value is between the minimum and maximum values', function():void {
      // bit repetitive with the ===
      expect(NumberMethods.between, 0, 0, 1).should(eq, true);
      expect(NumberMethods.between, 0, 1, 10).should(eq, false);
      expect(NumberMethods.between, 1, 1, 10).should(eq, true);
      expect(NumberMethods.between, 5, 1, 10).should(eq, true);
      
      // fail deliberately
      expect(NumberMethods.between, 5, 1, 10).should(eq, false);
      expect(NumberMethods.between, 5, 1, 10).shouldNot(eq, true);
    });
  });
  
  describe('bound', function():void {
    it('should leave the value as is if between the minimum and maximum values', function():void {
      // provide the matcher class
      // expect(NumberMethods.bound, 0, 0, 0).should(StrictlyEqualMatcher, 0);
      // use a proxy method
      // expect(NumberMethods.bound, 0, 0, 0).shouldBeStrictlyEqual(0);
      // provide a matcher instance
      // expect(NumberMethods.bound, 0, 0, 0).should(new StrictlyEqualMatcher(0));
      
      // provide a string to be converted to a lambda/function
      // or used as a hash-map key to find the actual matcher class to instantiate
      expect(NumberMethods.bound, 0, 0, 0).should(eq, 0);
      expect(NumberMethods.bound, 0, 0, 1).should(eq, 0);
      expect(NumberMethods.bound, 1, 0, 1).should(eq, 1);
      expect(NumberMethods.bound, 0.5, 0, 1).should(eq, 0.5); // aha floating point
    });
    
    it('should return the minimum value if value is less than the minimum value', function():void {
      expect(NumberMethods.bound, -1, 0, 1).should(eq, 0);
      expect(NumberMethods.bound, 0, 1, 10).should(eq, 1);
    });
    
    it('should return the maximum value if value is greater than the maximum value', function():void {
      expect(NumberMethods.bound, 2, 0, 1).should(eq, 1);
      expect(NumberMethods.bound, 11, 1, 10).should(eq, 10);
    });
  });
 
  describe('exclude', function():void {
    it('should return a value outside the minimum and maximum range', function():void {
      // todo: rethink houw to express isNaN 
      // can this work like this? --- no it cant
      expect(NumberMethods.exclude, 0, 0, 0).should(eq, NaN);
      
      expect(NumberMethods.exclude, 0, 1, 10).should(eq, 0);
      expect(NumberMethods.exclude, 0.1, -1, 1).should(eq, 1);
      expect(NumberMethods.exclude, -0.1, -1, 1).should(eq, -1);
      expect(NumberMethods.exclude, 6, 1, 10).should(eq, 10);
    });
  });
  
  describe('overflow', function():void {
    it('should return a value between the minimum and maximum range', function():void {
      expect(NumberMethods.overflow, 0, 0, 0).should(eq, 0);
      expect(NumberMethods.overflow, 0, 1, 10).should(eq, 9);
      expect(NumberMethods.overflow, 12, 1, 10).should(eq, 3);
    });
  });
  
  describe('snap', function():void {
    it('should round to the nearest multiple of the step value', function():void {
      expect(NumberMethods.snap, 0).should(eq, 0);
      expect(NumberMethods.snap, 1).should(eq, 1);
      expect(NumberMethods.snap, 0.9, 2).should(eq, 0);
      expect(NumberMethods.snap, 1, 2).should(eq, 2);
      expect(NumberMethods.snap, 1.1, 2).should(eq, 2);
      expect(NumberMethods.snap, 2, 3).should(eq, 3);
    });
    
    it('should offset from the origin value', function():void {
      expect(NumberMethods.snap, 1, 2, 1).should(eq, 1);
      expect(NumberMethods.snap, 4, 4, 1).should(eq, 5); 
    });
  });
  
  describe('normalize', function():void {
    it('should take a value and a range and scale the value to between 0 and 1', function():void {
      expect(NumberMethods.normalize, 0, 0, 10).should(eq, 0);
      expect(NumberMethods.normalize, 5, 0, 10).should(eq, 0.5);
      expect(NumberMethods.normalize, 1, 0, 4).should(eq, 0.25);
    });
  });
  
  describe('interpolate', function():void {
    it('should take a normalized value and a range and return the actual value for the interpolated value in that range', function():void {
      
    });
  });
});
