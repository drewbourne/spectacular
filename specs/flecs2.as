package
{
  import flash.display.*;
  import flash.events.*;
  
  public class flecs2 extends Sprite
  {
    public function flecs2()
    {
      super();
    }
  }
}

// console
internal var console : Object = {
  groups: []
  ,
  log: function(...rest):String {
    // trace with a group name if any
    var group:String = this.groups[this.groups.length - 1] || '';
    var args:Array = [StringMethods.repeat(' ', this.groups.length), group].concat(rest);
    trace.apply(null, args);
    //trace.apply(null, this.groups);
  }
  ,
  group: function(name:String):void {
    //trace(this.groups.length, name, this.groups[this.groups.length - 1]);
    //if(this.groups[this.groups.length - 1] != name);
    this.groups.push(name);
  }
  ,
  groupEnd: function():void {
    this.groups.pop();
  }
};

// spec.dsl
internal function describe( desc:*, impl:Function ):void 
{
  console.group('describe');
  console.log(desc);
  impl();
  console.groupEnd();
}

internal function it( desc:String, impl:Function ):void 
{
  console.group('it');
  console.log(desc);
  impl();
  console.groupEnd();
}

internal function expect( ...rest ):Object 
{
  var expected:* = rest.shift().apply(null, rest);
  return {should: function(...rest):void {
    console.group('expect');
    console.log(expected, 'should', rest);
    console.groupEnd();
  }};
}

// StringMethods
// String Methods
internal class StringMethods
{
  static public function repeat(value:String, count:Number = 1):String
  {
    var out:String = '';
    while(count > 0){ out += value; --count; }
    return out;    
  }
}

describe(StringMethods, function():void {
  describe('repeat', function():void {
    it('should repeat the given string the given number of times', function():void {
      
    });
  });
});

// NumberMethods
internal class NumberMethods
{
  static public function between(value:Number, min:Number, max:Number):Boolean
  {
    return (min <= value && value <= max);
  }
  
  static public function bound(value:Number, min:Number, max:Number):Number
  {
    return Math.min(Math.max(min, value), max);
  }
  
  // min: is the start of the exclusion range
  // max: is the end of the exclusion range
  static public function exclude(value:Number, min:Number, max:Number):Number
  {
    if(!between(value, min, max))
      return value;
   
    var mindiff:Number = value - min;
    var maxdiff:Number = max - value;
    return mindiff <= maxdiff ? min : max;
  }
  
  static public function overflow(value:Number, min:Number, max:Number):Number
  {
    if(between(value, min, max))
      return value;

    var range:Number = max - min;
    var difference:Number;
    var modulus:Number;
    
    if(value < min)
    {
      difference = min - value;
      modulus = difference % range;
      return max - modulus;
    }
    
    if(value > max)
    {
      difference = value - max;
      modulus = difference % range;
      return min + modulus;
    }
    
    // shouldnt happen
    return value;
  }
  
  // round to the closest step
  static public function snap(value:Number, step:Number = 1, origin:Number = 0):Number
  {
    return origin + (Math.round(value / step) * step);
  }
}

// NumberMethods Specs

describe(NumberMethods, function():void {
  describe('between', function():void {
    it('should indicate if the value is between the min and max values', function():void {
      // bit repetitive with the ===
      expect(NumberMethods.between, 0, 0, 1).should('===', true);
      expect(NumberMethods.between, 0, 1, 10).should('===', false);
      expect(NumberMethods.between, 1, 1, 10).should('===', true);
      expect(NumberMethods.between, 5, 1, 10).should('===', true);

      // alternatives
      /*
      expect(NumberMethods.between, 0, 0, 1).should(eq(true));
      
      expect(NumberMethods.between, 0, 0, 1).should(beTrue);
      expect(NumberMethods.between, 0, 0, 1).should(beTrue);
      expect(NumberMethods.between, 0, 1, 10).should(beFalse);
      expect(NumberMethods.between, 1, 1, 10).should(beTrue);
      expect(NumberMethods.between, 5, 1, 10).should(beTrue);
      */
    });
  });
  
  describe('bound', function():void {
    it('should leave the value as is if between the min and max values', function():void {
      // provide the matcher class
      // expect(NumberMethods.bound, 0, 0, 0).should(StrictlyEqualMatcher, 0);
      // use a proxy method
      // expect(NumberMethods.bound, 0, 0, 0).shouldBeStrictlyEqual(0);
      // provide a matcher instance
      // expect(NumberMethods.bound, 0, 0, 0).should(new StrictlyEqualMatcher(0));
      
      // provide a string to be converted to a lambda/function
      // or used as a hash-map key to find the actual matcher class to instantiate
      expect(NumberMethods.bound, 0, 0, 0).should('===', 0);
      expect(NumberMethods.bound, 0, 0, 1).should('===', 0);
      expect(NumberMethods.bound, 1, 0, 1).should('===', 1);
      expect(NumberMethods.bound, 0.5, 0, 1).should('===', 0.5); // aha floating point
    });
    
    it('should return the min value if value is less than the min value', function():void {
      expect(NumberMethods.bound, -1, 0, 1).should('===', 0);
      expect(NumberMethods.bound, 0, 1, 10).should('===', 0);
    });
    
    it('should return the max value if value is greater than the max value', function():void {
      expect(NumberMethods.bound, 2, 0, 1).should('===', 1);
      expect(NumberMethods.bound, 0, 1, 10).should('===', 10);        
    });
  });
 
  describe('exclude', function():void {
    it('should return a value outside the min and max range', function():void {
      // todo: rethink houw to express isNaN 
      // can this work like this?
      expect(NumberMethods.exclude, 0, 0, 0).should('===', NaN);
      
      expect(NumberMethods.exclude, 0, 1, 10).should('===', 0);
      expect(NumberMethods.exclude, 0.1, -1, 1).should('===', 1);
      expect(NumberMethods.exclude, -0.1, -1, 1).should('===', -1);
      expect(NumberMethods.exclude, 6, 1, 10).should('===', 10);
    });
  });
  
  describe('overflow', function():void {
    it('should return a value between the min and max range', function():void {
      expect(NumberMethods.overflow, 0, 0, 0).should('===', 0);
      expect(NumberMethods.overflow, 0, 1, 10).should('===', 9);
      expect(NumberMethods.overflow, 12, 1, 10).should('===', 2);
    });
  });
  
  describe('snap', function():void {
    it('should round to the nearest multiple of the step value', function():void {
      expect(NumberMethods.snap, 0).should('===', 0);
      expect(NumberMethods.snap, 1).should('===', 1);
      expect(NumberMethods.snap, 1, 2).should('===', 0);
      expect(NumberMethods.snap, 2, 3).should('===', 3);
    });
    
    it('should offset from the origin value', function():void {
      expect(NumberMethods.snap, 1, 2, 1).should('===', 1);
      expect(NumberMethods.snap, 4, 4, 1).should('===', 5); 
    });
  });
  
});