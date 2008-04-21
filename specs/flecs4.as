package
{
  import flash.display.*;
  import flash.events.*;
  
  public class flecs4 extends Sprite
  {
    public function flecs4()
    {
      super();
    }
  }
}

import flash.utils.*;

trace('');
trace('---------');
trace('');

// console
internal var console:Object = {
  groups: []
  ,
  log: function(...rest):String {
    // trace with a group name if any
    var group:String = this.groups[this.groups.length - 1] || '';
    var args:Array = [StringMethods.repeat(' ', this.groups.length * 2), group].concat(rest);
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

// spec.framework
internal var spec:Object = {
    type: 'example_group'
  , description: 'specs'
  , examples: []
  // internal state
  , asyncs: []
  , previousExampleGroups: []
  , pendingExamples: []
  , currentExampleGroup: null
};

// set the initial example group to the spec object itself
spec.currentExampleGroup = spec;

// the runner of amazingness
internal var runner:Object = {
  run: function(spec:Object):void {
    console.group('runner');
    console.log('spec.examples:', spec.examples.length);

    this.runExample(spec, [], spec);
    // this.runExample(spec.examples[0], spec.examples.slice(1), spec);
  }
  ,
  runExample: function(example:Object, remaining:Array, exampleGroup:Object):void
  {
    // console.log('runExample', example, remaining);
    
    if (example.type == 'example_group') 
    {
      console.group('describe:');
      console.log(example.description);
      
      spec.pendingExamples.push([remaining, exampleGroup]);
      spec.currentExampleGroup = example;
      
      // console.log('examples:', example.examples.length);
      // describe()s & it()s run in this implementation will be added
      // to the current example groups examples
      if (example.implementation)
      {
        example.implementation();
      }
      // we should now have some examples
      // console.log('examples:', example.examples.length);
      
      // if we dont have examples, complain a little bit as its useless 
      // describe()ing a group with no examples
      // if (ArrayMethods.empty(example.examples))
      if (example.examples.length == 0)
      {
        console.log('whoops! did you forget to include examples?');
      }
      
      // we can now run the first of the examples
      runner.runExample(example.examples[0], example.examples.slice(1), example);
    }
    else if (example.type == 'example')
    {
      console.group('it:');
      console.log(example.description);
      var asyncsBefore:Array = spec.asyncs.slice(0);
      
      // todo: document the fuck out of whats going on in this function
      example.implementation();
      
      var asyncsAfter:Array = spec.asyncs.slice(0);
      var newAsyncs:Array = asyncsAfter.filter(function(ao:Object, i:int, a:Array):Boolean {
        return asyncsBefore.indexOf(ao) == -1;
      });
      var totalFailAfterTime:Number = 0;
      newAsyncs.forEach(function(ao:Object, i:int, a:Array):void {
        totalFailAfterTime += ao.failAfter;
      });
      
      // console.log('asyncs:', newAsyncs.length, totalFailAfterTime);
      
      // simply wait for the total time failAfter time before running the next example
      setTimeout(function(e:Object, remaining:Array, exampleGroup:Object):void {
        console.groupEnd();
        
        if (remaining.length > 0)
        {
          runner.runExample(remaining[0], remaining.slice(1), exampleGroup);
        }
        else
        {
          console.groupEnd();
          // console.log('pendingExamples', spec.pendingExamples.length);
          
          var next:Array;
          while(spec.pendingExamples.length > 0)
          {
            next = spec.pendingExamples.pop();
            if (next && (next[0] as Array || []).length > 0)
            {
              remaining = next[0];
              exampleGroup = next[1];
              // console.log('remaining', remaining.length);
              
              if(remaining.length > 0)
              {
                runner.runExample(remaining[0], remaining.slice(1), exampleGroup);
                break;
              }
            }
          }
        }
      }, totalFailAfterTime, example, remaining, exampleGroup);
    }
  }
};

// setup the runner to run later
setTimeout(function():void {
  runner.run(spec);
}, 1000);

// spec.dsl
internal function describe( desc:*, impl:Function ):void 
{
  var exampleGroup:Object = {
      type: 'example_group'
    , state: 'pending'
    , description: desc
    , implementation: impl
    , examples: []
    };
  spec.currentExampleGroup.examples.push(exampleGroup);
}

internal function it( desc:String, impl:Function ):void 
{
  var example:Object = {
      type: 'example'
    , state: 'pending'
    , description: desc
    , implementation: impl
    };
  spec.currentExampleGroup.examples.push(example);
}

// pass / fail
internal function pass(message:String=null):void 
{
  //trace('passed', message || '');
}

internal function fail(message:String=null):void
{
  console.log('failed!', message || '');
}

// 

internal function async(func:Function, failAfter:Number):Function 
{
  var asyncDetails:Object;
  
  var failTimeout:int = setTimeout(function():void {
    // should get the description from the it() this was called within
    fail('async not called');
    //spec.asyncs.splice(spec.asyncs.indexOf(asyncDetails), 1);
  }, failAfter);
  
  asyncDetails = { failTimeout: failTimeout, func:func, failAfter: failAfter };
  spec.asyncs.push(asyncDetails);
  
  return function(...rest):void {
    clearInterval(failTimeout);
    //spec.asyncs.splice(spec.asyncs.indexOf(asyncDetails), 1);
    func.apply(null, rest);
  };
}

// expectation matchers
internal function eq(expected:*):Object
{
  return {
    match: function(actual:*):Boolean {
      return expected === actual;
    }
    ,
    failureMessage: function(actual:*):String {
      return 'Expected '+ actual +' to be === to '+ expected;
    }
    ,
    negativeFailureMessage: function(actual:*):String {
      return 'Expected '+ actual +' to be !== to '+ expected;;
    }
  };
}

/*
internal var expectationMatchers:Object = {
  '===': eq
};
*/

// parameters are the method and parameter result
internal function expect( ...rest ):Object 
{
  var evaluate:Function = function(args:Array):Function {
    return function():* {
      try 
      {
        console.group('evaluate');
        var result:*;
        var f:* = args.shift();
        if(f is Function)
        {
          result = (f as Function).apply(null, args);
        }
        else
        {
          result = f;
        }
      }
      catch(e:Error)
      {
        console.log('error:', e.toString());
        throw e;
      }
      finally
      {
        console.groupEnd();
        return result;
      }
    };
  };
  
  var actualArgs:Array = rest;
  var evaluateActual:Function = evaluate(actualArgs.slice(0));
  var shouldInternal:Function = function(negative:Boolean = false):Function {
    return function(...rest):Object {
      var expectedArgs:Array = rest;
      var evaluateExpected:Function = evaluate(expectedArgs.slice(0));
      var evaluateMatcher:Object = evaluateExpected();
      var actual:* = evaluateActual();
      var passed:Boolean = evaluateMatcher.match(actual);
      
      console.group('should');
      console.log('args:', actualArgs, 'result:', actual, 'expected:', expectedArgs);
      if(!passed)
      {
        console.group('failed');
        console.log(evaluateMatcher.failureMessage(actual));
        console.groupEnd();
      }
      else if(negative && passed)
      {
        console.group('failed');
        console.log(evaluateMatcher.negativeFailureMessage(actual));
        console.groupEnd();
      }
      console.groupEnd();
      return this;
    };
  }
  
  return {
    should: function(...rest):Object {
      return shouldInternal().apply(null, rest);
    }
    , 
    shouldNot: function(...rest):Object {
      return shouldInternal(true).apply(null, rest);
    }
  };
}

// async demo
import flash.events.*;

describe('Async Example', function():void {
  var ed:EventDispatcher = new EventDispatcher();
  
  it('should wait before running next example', function():void {
    var later:Function = async(function():void {
      console.log('async example, should wait until this is done');
    }, 100);
    
    setTimeout(function():void {
      later();
    }, 50);
  });
  
  it('should pass if async function is called', function():void {
    ed.addEventListener('example', async(function(e:Event):void {
      console.log('async example, should pass, this trace should be called');
    }, 1000));
    
    setTimeout(function():void {
      ed.dispatchEvent(new Event('example'));
    }, 50);
  });
  
  it('should fail if async function is not called', function():void {
    async(function():void {
      console.log('it should fail if this function is not called');
    }, 100);
  });
  
  it('should allow multiple async functions to be pending', function():void {
    ed.addEventListener('multi_async_1', async(function(e:Event):void {
      console.log('multi_async_1');
    }, 100));
    ed.addEventListener('multi_async_1', async(function(e:Event):void {
      console.log('multi_async_2');
    }, 200));
    ed.addEventListener('multi_async_1', async(function(e:Event):void {
      console.log('multi_async_3');
    }, 300));
    
    setTimeout(function():void {
      ed.dispatchEvent(new Event('multi_async_1'));
      setTimeout(function():void {
        ed.dispatchEvent(new Event('multi_async_2'));
        setTimeout(function():void {
          ed.dispatchEvent(new Event('multi_async_3'));
        }, 50);
      }, 50);
    }, 50);
  });
});

// StringMethods
internal class StringMethods
{
  static public function repeat(value:String, count:Number = 1):String
  {
    var out:String = '';
    while(count > 0){ out += value; --count; }
    return out;
  }
}

describe('StringMethods', function():void {
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
    if (!between(value, min, max))
      return value;
   
    var mindiff:Number = value - min;
    var maxdiff:Number = max - value;
    return mindiff <= maxdiff ? min : max;
  }
  
  static public function overflow(value:Number, min:Number, max:Number):Number
  {
    if (between(value, min, max))
      return value;

    var range:Number = max - min;
    var difference:Number;
    var modulus:Number;
    
    if (value < min)
    {
      difference = min - value;
      modulus = difference % range;
      return max - modulus;
    }
    
    if (value > max)
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

describe('NumberMethods', function():void {
  describe('between', function():void {
    it('should indicate if the value is between the min and max values', function():void {
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
    it('should leave the value as is if between the min and max values', function():void {
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
    
    it('should return the min value if value is less than the min value', function():void {
      expect(NumberMethods.bound, -1, 0, 1).should(eq, 0);
      expect(NumberMethods.bound, 0, 1, 10).should(eq, 1);
    });
    
    it('should return the max value if value is greater than the max value', function():void {
      expect(NumberMethods.bound, 2, 0, 1).should(eq, 1);
      expect(NumberMethods.bound, 11, 1, 10).should(eq, 10);
    });
  });
 
  describe('exclude', function():void {
    it('should return a value outside the min and max range', function():void {
      // todo: rethink houw to express isNaN 
      // can this work like this?
      expect(NumberMethods.exclude, 0, 0, 0).should(eq, NaN);
      
      expect(NumberMethods.exclude, 0, 1, 10).should(eq, 0);
      expect(NumberMethods.exclude, 0.1, -1, 1).should(eq, 1);
      expect(NumberMethods.exclude, -0.1, -1, 1).should(eq, -1);
      expect(NumberMethods.exclude, 6, 1, 10).should(eq, 10);
    });
  });
  
  describe('overflow', function():void {
    it('should return a value between the min and max range', function():void {
      expect(NumberMethods.overflow, 0, 0, 0).should(eq, 0);
      expect(NumberMethods.overflow, 0, 1, 10).should(eq, 9);
      expect(NumberMethods.overflow, 12, 1, 10).should(eq, 3);
    });
  });
  
  describe('snap', function():void {
    it('should round to the nearest multiple of the step value', function():void {
      expect(NumberMethods.snap, 0).should(eq, 0);
      expect(NumberMethods.snap, 1).should(eq, 1);
      expect(NumberMethods.snap, 1, 2).should(eq, 0);
      expect(NumberMethods.snap, 2, 3).should(eq, 3);
    });
    
    it('should offset from the origin value', function():void {
      expect(NumberMethods.snap, 1, 2, 1).should(eq, 1);
      expect(NumberMethods.snap, 4, 4, 1).should(eq, 5); 
    });
  });
  
});