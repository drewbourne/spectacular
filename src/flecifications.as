package
{
  import flash.display.*;
  
  public class flecifications extends Sprite
  {
    public function flecifications()
    {
      super();
      
      // helper: StringMethods.repeat
      var repeat:Function = function(str:String = '', count:int = 1):String
      {
        var out:String = str;
        while(--count > 0){ out += str; }
        return out;
      };
      
      // returns a function that will trace() with an indentation level of depth
      var traceNested:Function = function(depth:int = 0):Function {
        return function(...rest):void {
          var args:Array = [repeat('  ', depth)].concat(rest);
          trace.apply(null, args);
        };
      };
      
      var traceExample:Function;
      var traceExamples:Function
      
      traceExample = function(depth:int = 0):Function
      {
        var trace:Function = traceNested(depth);
        return function(e:*, i:int, a:Array):void {
          ++depth;
          if(e is ExampleGroup)
          {
            var eg:ExampleGroup = e as ExampleGroup;
            trace(eg.type || '-', eg.desc || '-');
            traceExamples(eg.examples, depth);
          }
          else if(e is Example)
          {
            trace('-', e.desc);
          };
          --depth;
        };
      };
      
      traceExamples = function(examples:Array, depth:int = 0):void {
        examples.forEach(traceExample(depth));
      };
      
      Spec.specs.forEach(function(spec:Spec, i:int, a:Array):void {
        traceExamples(spec.exampleGroups, 0);
      });
    }
    
  }
}

// classes
internal class Spec
{
  public var exampleGroups:Array;
  public var currentExampleGroup:ExampleGroup;
  public var currentExample:Example;
  
  public function Spec()
  {
    exampleGroups = [];
    currentExampleGroup = new ExampleGroup(null, null, null);
    exampleGroups.push(currentExampleGroup);
  }
  
  /*
    describe( Class, String, Function )
    describe( Class, Function )
    describe( String, Function )
   */
  public function describe(...rest):void
  {
    // create an example group
    // add it to the example group
    var type:Class;
    var desc:String;
    var impl:Function;
    
    // match args
    if( rest.length == 3 )
    {
      if(rest[0] is Class && rest[1] is String && rest[2] is Function)
      {
        type = rest[0] as Class;
        desc = rest[1] as String;
        impl = rest[2] as Function;
      }
    }
    else if( rest.length == 2 )
    {
      if(rest[0] is Class && rest[1] is Function)
      {
        type = rest[0] as Class;
        impl = rest[1] as Function;
      }
      else if(rest[0] is String && rest[1] is Function)
      {
        type = currentExampleGroup.type;
        desc = rest[0] as String;
        impl = rest[1] as Function;
      }
      else
      {
        throw new ArgumentError('Bad Args');
      }
    }
    
    _describe(type, desc, impl);
  }
  
  private function _describe(type:Class, desc:String, impl:Function):void
  {
    var eg:ExampleGroup = new ExampleGroup(type, desc, impl);
    var previousExampleGroup:ExampleGroup = currentExampleGroup;
    currentExampleGroup.examples.push(eg);
    currentExampleGroup = eg;
    currentExample = null;
    currentExampleGroup.run();
    currentExampleGroup = previousExampleGroup;
  }

  public function it(desc:String, impl:Function):void
  {
    // add an example to the currentExampleGroup
    var e:Example = new Example(desc, impl);
    var previousExample:Example = currentExample;
    currentExampleGroup.examples.push(e);
    currentExample = e;
    currentExample.run();
    //currentExample = previousExample;
  }
  
  /*
    expect(instance:Object, methodName:String, ...args)
    expect(instanceMethod:Function, ..args)
    expect(value)
   */
  public function expect(...rest):*
  {
    if( !currentExample )
      throw Error('expect() is only allowed inside it()');

    var ex:SpecExpectation = new SpecExpectation(rest.shift(), rest);
    currentExample.expectations.push(ex);
    return ex;
  }
  
  /*
   */
  public function beforeEach(block:Function):void
  {
    currentExampleGroup.beforeEaches.push(block);
  }

  public function beforeAll(block:Function):void
  {
    currentExampleGroup.beforeAlls.push(block);
  }
  
  /*
   */
  public function afterEach(block:Function):void
  {
    currentExampleGroup.afterEaches.push(block);
  }

  public function afterAll(block:Function):void
  {
    currentExampleGroup.afterAlls.push(block);
  }
  
  // statics
  static public var specs:Array = [];
  static public function add(impl:Function = null):Spec
  {
    var spec:Spec = new Spec();
    specs.push(spec);
    if(impl is Function) impl(spec);
    return spec;
  }
  
  static public function get currentSpec():Spec
  {
    return specs.length == 0 ? add() : specs[specs.length - 1] as Spec;
  }
  
  static public function describe(...rest):Spec
  {
    currentSpec.describe.apply(null, rest);
    return currentSpec;
  }
  
  static public function it(...rest):Spec
  {
    currentSpec.it.apply(null, rest);
    return currentSpec;
  }
  
  static public function expect(...rest):SpecExpectation
  {
    return currentSpec.expect.apply(null, rest);
  }
}

internal class ExampleGroup
{
  public function ExampleGroup(type:Class, desc:String, impl:Function)
  {
    examples = [];
    beforeAlls = [];
    beforeEaches = [];
    afterEaches = [];
    afterAlls = [];
    
    this.type = type;
    this.desc = desc;
    this.impl = impl;
  }
  
  public function run():void
  {
    impl();
  }

  public var examples:Array;
  public var beforeAlls:Array;
  public var beforeEaches:Array;
  public var afterEaches:Array;
  public var afterAlls:Array;
  
  public var type:Class;
  public var desc:String;
  public var impl:Function;
}

internal class Example
{
  public function Example(desc:String, impl:Function)
  {
    expectations = [];
    this.desc = desc;
    this.impl = impl;
  }
  
  public function run():void
  {
    impl();
  }
  
  public var expectations:Array;
  public var desc:String;
  public var impl:Function;
}

internal class SpecExpectation
{
  public var target:*;
  public var args:Array;
  public var matchers:Array;

  public function SpecExpectation(target:*, args:Array = null)
  {
    matchers = [];
    this.target = target;
    this.args = args;
  }
  
  public function should(...rest):SpecExpectation
  {
    // find and create matcher
    // push to matchers
    
    return this;
  }
  
  public function shouldNot(...rest):SpecExpectation
  {
    // find and create matcher
    // push to matchers
    
    return this;    
  }
  
  
  /*
  public function run():void
  {
    // check matchers
    // return matchers.every(function(matcher:ExampleMatcher, i:int, a:Array):Boolean {
    //   return matcher.matches();
    // });
  }
  
  public var target:*;
  public var matchers:Array;
  
  // matchers
  
  // remove matchers from here
  public function shouldBeA(type:Class):SpecExpectation
  {
    // add matcher to this.matchers
    return this;
  }
  */
}

internal interface SpecMatcher
{
  function matches(actual:*):Boolean;
  function failureMessage():String;
  function negativeFailureMessage():String;
}

internal class SimpleSpecMatcher implements SpecMatcher
{
  public function SimpleSpecMatcher(description:*, impl:Function)
  {
    this.description = description;
    this.impl = impl;
  }
  
  public function matches(actual:*):Boolean
  {
    this.actual = actual;
    return impl(actual);
  }
  
  public function failureMessage():String 
  {
    return '';
  }
  
  public function negativeFailureMessage():String 
  {
    return '';
  }
  
  private var description:*;
  private var impl:Function;
  private var actual:*;
}

internal class StrictEqualityMatcher implements SpecMatcher
{
  public function StrictEqualityMatcher( expected:* )
  {
    this.expected = expected;
  }
  
  public function matches( actual:* ):Boolean
  {
    return expected === actual;
  }
  
  public function failureMesssage():String
  {
    return 'Expected #{expected}, received #{actual}';
  }
  
  public function negativeFailureMessage():String
  {
    return '';
  }
  
  private var expected:*;
}

// runner
internal class SpecRunner 
{
  public function SpecRunner() 
  {
    
  }
  
  public function run(spec:Spec, reporter:SpecReporter):void
  {
    // run in defined order
    // run in shuffled order, but output in defined order
  }
}

// reporter
internal class SpecReporter
{
  public function SpecReporter() 
  {
    
  }
}



// helper:functions

internal function describe(...rest):Spec
{
  return Spec.describe.apply(null, rest);
}

internal function it(...rest):Spec
{
  return Spec.it.apply(null, rest);  
}

internal function expect(...rest):SpecExpectation
{
  return Spec.expect(null, rest);
}

// helper:matcher:functions

internal function eq( expected:* ):SpecMatcher
{
  return new StrictEqualityMatcher(expected);
}


// specs
Spec.add(function():void {
  describe(Spec, 'Methods', function():void {
    describe('describe', function():void {
      it('should provide a flexible api', function():void {
        //expect('full.qualified.classpath.SpecClass').shouldBeA('failure');
        //expect(Spec.describe, Spec, 'describe', function(){});
        //expect(Spec.describe, 'describe', function(){});
        //expect(Spec.describe, Spec, function(){});
      });
      it('should be nestable', function():void {
        describe('nested example group', function():void {
          it('should nest correctly', function():void {
            //expect
          });
        });
      });
      it('should have siblings', function():void {
        
      });
    });
    
    describe('it', function():void {
      it('should accept a description and examples implementation', function():void {
        
      });
    });
    
    describe('expect', function():void {
      it('should accept a value', function():void {
        
      });
      
      it('should accept a closure', function():void {
        
      });
      
      it('should return a SpecExpectation', function():void {
        
      });
    });
  }); 
});

// 

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

Spec.add(function():void {
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
});

// String Methods
/*
internal class StringMethods
{
  static public function repeat(value:String, count:Number = 1):String
  {
    var out:String = value;
    while(--count > 0){ out += value; }
    return out;    
  }
  
  static public function gsub(value:String, replacements:Object):String
  {
    
  }
}
*/