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
    //var args:Array = [StringMethods.repeat(' ', (this.groups.length - 1) * 2), group].concat(rest);
    var out:String = StringMethods.repeat(' ', (this.groups.length - 1) * 2) + [group].concat(rest).join(' ');
    trace(out);
    //trace.apply(null, args);
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
internal var spec:Spec = new Spec(); 

// set the initial example group to the spec object itself
spec.currentExampleGroup = spec;

internal var runner:SpecRunner = new SpecRunner(spec, new SpecReporter());

// setup the runner to run later
setTimeout(function():void {
  runner.run(spec);
}, 1000);

// spec.dsl
internal function describe(description:*, implementation:Function):void 
{
  var exampleGroup:ExampleGroup = new ExampleGroup(spec.currentExampleGroup, null, description, implementation);
  spec.currentExampleGroup.examples.push(exampleGroup);
}

internal function it(description:String, implementation:Function):void 
{
  var example:Example = new Example(spec.currentExampleGroup, description, implementation);
  spec.currentExampleGroup.examples.push(example);
}

// pass / fail
internal function pass(message:String = null):void 
{
  //trace('passed', message || '');
}

internal function fail(message:String = null):void
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
  spec.currentExample.asyncs.push(asyncDetails);
  
  return function(...rest):void {
    clearInterval(failTimeout);
    //spec.asyncs.splice(spec.asyncs.indexOf(asyncDetails), 1);
    func.apply(null, rest);
  };
}

// expectation matchers
internal function eq(expected:*):Object
{
  var compareValues:Function = function(a:Object, b:Object):Boolean {
    if (a is Array && b is Array) 
    {
      return compareArrays(a, b);
    }
    
    return a === b;
  };

  var compareArrays:Function = function(a:Array, b:Array):Boolean {
    return a.every(function(value:Object, i:int, a:Array):Boolean {
      return compareValues(value, b[i]);
    });
  };
  
  return {
    match: (expected is Array) 
      ? function(actual:*):Boolean {
          if (! actual is Array) 
            return false;
          return compareValues(expected, actual);
      } 
      : function(actual:*):Boolean {
          // special case for NaN
          if (isNaN(expected) && isNaN(actual)) 
            return true;
          return expected === actual;
      }
    ,
    successMessage: function(actual:*):String {
      return actual + ' was === to '+ expected;
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
      
      // console.group('should');
      // if (actual is String) actual = "\""+ actual +"\"";
      // if (expected is String) expected = "\""+ expected +"\"";
      
      if(!passed)
      {
        console.group('failed');
        console.log('args:', actualArgs, ', result:', actual, ', expected:', expectedArgs);
        console.log(evaluateMatcher.failureMessage(actual));
        console.groupEnd();
        
        spec.results.failedCount++;
      }
      else if(negative && passed)
      {
        console.group('failed');
        console.log('args:', actualArgs, ', result:', actual, ', expected:', expectedArgs);
        console.log(evaluateMatcher.negativeFailureMessage(actual));
        console.groupEnd();
        
        spec.results.failedCount++;
      }
      else if(passed)
      {
        // console.group('passed');
        // console.log(evaluateMatcher.successMessage(actual));
        // console.groupEnd();
        
        spec.results.passedCount++;
      }
      // console.groupEnd();
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
    ,
    to: function(...rest):Object {
      return shouldInternal().apply(null, rest);
    }
    , 
    toNot: function(...rest):Object {
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
  
  static public function padLeft(value:String, length:Number = 1, pad:String = ' '):String
  {
    if (length < value.length) 
      return value.substring(0, length);
    
    var padLength:Number = length - value.length;
    var padRepeat:Number = Math.ceil(padLength / pad.length);
    var padding:String = StringMethods.repeat(pad, padRepeat).slice(-padLength);
    
    return padding + value;
  }
  
  static public function padRight(value:String, length:Number = 1, pad:String = ' '):String
  {
    if (length < value.length)
      return value.substring(0, length);
    
    var out:String = value;
    var padLength:Number = length - value.length;
    var padRepeat:Number = Math.ceil(padLength / pad.length);
    var padding:String = StringMethods.repeat(pad, padRepeat).slice(0, padLength);
    
    return value + padding;
  }
}

describe('StringMethods', function():void {
  describe('repeat', function():void {
    it('should repeat the given string the given number of times', function():void {
      expect(StringMethods.repeat, '', 0).should(eq, '');
      expect(StringMethods.repeat, '', 1).should(eq, '');
      expect(StringMethods.repeat, ' ', 0).should(eq, '');
      expect(StringMethods.repeat, ' ', 1).should(eq, ' ');
      expect(StringMethods.repeat, ' ', 2).should(eq, '  ');
      expect(StringMethods.repeat, '-+', 2).should(eq, '-+-+');
    });
  });
  
  describe('padLeft', function():void {
    it('should add the specified amount of padding from the pad string to the left side of the given value string', function():void {
      expect(StringMethods.padLeft, 'hello', 10).should(eq, '     hello');
      expect(StringMethods.padLeft, 'hello', 10, '-+(').should(eq, '+(-+(hello');
    });
  });
  
  describe('padRight', function():void {
    it('should add the specified amount of padding from the pad string to the right side of the given value string', function():void {
      expect(StringMethods.padRight, 'hello', 10).should(eq, 'hello     ');
      expect(StringMethods.padRight, 'hello', 10, ')+-').should(eq, 'hello)+-)+');
    });
  });
});

// NumberMethods
internal class NumberMethods
{
  static public function between(value:Number, minimum:Number, maximum:Number):Boolean
  {
    return (minimum <= value && value <= maximum);
  }
  
  static public function bound(value:Number, minimum:Number, maximum:Number):Number
  {
    return Math.min(Math.max(minimum, value), maximum);
  }
  
  // minimum: is the start of the exclusion range
  // maximum: is the end of the exclusion range
  static public function exclude(value:Number, minimum:Number, maximum:Number):Number
  {
    if (!between(value, minimum, maximum))
      return value;
      
    if (value == minimum && value == maximum)
      return NaN;
   
    var mindiff:Number = value - minimum;
    var maxdiff:Number = maximum - value;
    return mindiff <= maxdiff ? minimum : maximum;
  }
  
  static public function overflow(value:Number, minimum:Number, maximum:Number):Number
  {
    if (between(value, minimum, maximum))
      return value;

    var range:Number = maximum - minimum;
    var difference:Number;
    var modulus:Number;
    
    if (value < minimum)
    {
      difference = minimum - value;
      modulus = difference % range;
      return maximum - modulus;
    }
    
    if (value > maximum)
    {
      difference = value - maximum;
      modulus = difference % range;
      return minimum + modulus;
    }
    
    // shouldnt happen
    return value;
  }
  
  // round to the closest step
  static public function snap(value:Number, step:Number = 1, origin:Number = 0):Number
  {
    return origin + (Math.round(value / step) * step);
  }
  
  static public function normalize(value:Number, minimum:Number, maximum:Number):Number 
  {
    return (value - minimum) / (maximum - minimum);
  }
  
  static public function interpolate(normalizedValue:Number, minimum:Number, maximum:Number):Number 
  {
    return minimum + (maximum - minimum) * normalizedValue;
  }
}

// NumberMethods Specs

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

/*describe('Describe without examples', function():void {});*/

internal class ArrayMethods
{
  static public function pluck(array:Array, field:String):Array
  {
    return array.map(function(value:Object, i:int, a:Array):Object {
      return value.hasOwnProperty(field) ? value[field] : null;
    });
  }
  
  static public function inject(memo:Object, array:Array, iterator:Function):Object
  {
    array.forEach(function(value:Object, i:int, a:Array):void {
      memo = iterator(memo, value);
    });
    return memo;
  }
  
  static private function flattenInternal(memo:Array, value:Object):Array
  {
    return memo.concat(value is Array ? flatten(value as Array) : [value]);
  }
  
  static public function flatten(array:Array):Array
  {
    return inject([], array, flattenInternal) as Array;
  }
  
  static public function zip(...arrays):Array
  {
    var arrayCount:int = arrays.length
    if (arrayCount == 0) return [];
    if (!arrays.every(function(value:Object, i:int, a:Array):Boolean { return value is Array; }))
    {
      throw new ArgumentError('ArrayMethods.zip expects all arguments to be Array');
    }
    
    // find the maximum length of the arrays
    var maxLength:Number = Math.max.apply(null, pluck(arrays, 'length'));
    
    var zipped:Array = [];
    for (var i:int = 0, n:int = maxLength; i < n; i++)
    {
      var zipper:Array = zipped[i] = [];
      for (var j:int = 0, m:int = arrayCount; j < m; j++)
      {
        zipper.push(arrays[j][i]);
      }
    }
    return zipped;
  }
  
  static public function compact(array:Array):Array
  {
    return array.filter(notNullIterator);
  }
  
  static private function notNullIterator(v:Object, i:int, a:Array):Boolean
  {
    return v !== null;
  }
  
  static public function contains(array:Array, value:Object):Boolean
  {
    return array.indexOf(value) !== -1;
  }
  
  static public function unique(array:Array):Array
  {
    return inject([], array, function(memo:Array, value:Object):Array {
      if (!contains(memo, value)) memo.push(value);
      return memo;
    }) as Array;
  }
  
  static public function buckets(array:Array, iterator:Function):Array
  {
    var buckets:Array = [];
    array.forEach(function(value:Object, i:int, a:Array):void {
      var index:int = iterator(value);
      var bucket:Array = buckets[index];
      if (!bucket) bucket = buckets[index] = [];
      bucket.push(value);
    });
    return buckets;
  }
  
  static public function partition(array:Array, iterator:Function):Array
  {
    var trues:Array = []
      , falses:Array = [];
    array.forEach(function(value:Object, i:int, a:Array):void {
      (iterator(value) ? trues : falses).push(value);
    });
    return [trues, falses];
  }
}

describe('ArrayMethods', function():void {
  describe('pluck', function():void {
    it('should return an array of the value of the given field for each item', function():void {
      expect(ArrayMethods.pluck, ('a bee seady ee effigy').split(' '), 'length').should(eq, [1, 3, 5, 2, 6]);
    });
  });
  
  describe('inject', function():void {
    it('should pass the memo and each item individually to the iterator function and return the memo', function():void {
      expect(ArrayMethods.inject, 0, [1, 2, 3, 4], function(acc:Number, value:Number):Number {
        return acc + value;
      }).should(eq, 10);
    });
  });
  
  describe('flatten', function():void {
    it('should take a nested array and return a one dimensional array', function():void {
      expect(ArrayMethods.flatten, [1, 2, [3, 4, 5, [6], [7, 8]], 9]).to(eq, [1, 2, 3, 4, 5, 6, 7, 8, 9]);
    });
  })
  
  describe('zip', function():void {
    it('should take arrays arguments and return an array where each entry is an array of the values at that index in the argument arrays', function():void {
      expect(ArrayMethods.zip, [1, 2, 3], ['a', 'b', 'c']).should(eq, [[1, 'a'], [2, 'b'], [3, 'c']]);
        
      expect(ArrayMethods.zip
        , [1, 2, 3]
        , ['a', 'b', 'c']
        , [true, true, false, true])
        .should(eq
        , [[1, 'a', true]
        , [2, 'b', true]
        , [3, 'c', false]
        , [null, null, true]
        ]);
    });
  });
  
  describe('compact', function():void {
    it('should return an array without null values', function():void {
      expect(ArrayMethods.compact, [null]).should(eq, []);
      expect(ArrayMethods.compact, [null, null, 3, null]).should(eq, [3]);
      expect(ArrayMethods.compact, ['toast', 'waffles', null, 'crumpets']).should(eq, ['toast', 'waffles', 'crumpets']);
    });
  });
  
  describe('unique', function():void {
    it('should return an array without duplicate values', function():void {
      expect(ArrayMethods.unique, [1, 1, 2, 3, 5]).should(eq, [1, 2, 3, 5]);
      expect(ArrayMethods.unique, ['one', 'two', 'two', 'two']).should(eq, ['one', 'two']);
    });
  });
  
  describe('partition', function():void {
    it('should separate values on the boolean return value of the iterator function', function():void {
      expect(ArrayMethods.partition, [1, 2, 3, 4, 5], function(value:Number):Boolean { return value > 3; }).should(eq, [[4, 5], [1, 2, 3]]);
    });
  });
  
  // bucket / distribute / ?
  describe('buckets', function():void {
    it('should separate values on the return value of the iterator function', function():void {
      expect(ArrayMethods.buckets, [1, 2, 3, 4, 5, 6, 7, 8, 9], function(value:Number):int { return value % 3; }).should(eq, [[3, 6, 9], [1, 4, 7], [2, 5, 8]]);
    });    
  });
  
  describe('contains', function():void {
    it('should be true if the array contains the value', function():void {
      expect(ArrayMethods.contains, [], 0).should(eq, false);
      expect(ArrayMethods.contains, [1, 2, 3], 0).should(eq, false);
      expect(ArrayMethods.contains, [1, 2, 3], 3).should(eq, true);
    });
  });
  
  describe('naturalSort', function():void {
    it('should not be implemented yet', function():void {});
  });
  
  describe('naturalSortBy', function():void {
    it('should not be implemented yet', function():void {});
  });
});

// while/to, map/transform

function unfold(seed:*, incrementor:Function, stopCondition:Function = null):Array {
  var result:Array = [seed];
  var x:* = incrementor(seed);
  
  // use boolean cast rules if no stop condition function given
  if (! (stopCondition)) 
  {
    stopCondition = function(value:*):Boolean { return value; }; 
  }
  
  while (stopCondition(x))
  {
    result.push(x);
    x = incrementor(x);
  }
  return result;
};

describe('ObjectMethods', function():void {
  describe('unfold', function():void {
    it('should...', function():void {
      expect(unfold, 10, function(value:Number):Number { 
        return value - 2; 
      }).should(eq, [10, 8, 6, 4, 2]);
      
      expect(unfold, 10, function(value:Number):Number { 
        return value - 2; 
      }, function(value:Number):Boolean {
        return value > 0;
      }).should(eq, [10, 8, 6, 4, 2]);
    });
  });
});

internal class FunctionMethods
{
  static public function toIterator(iterator:Function):Function
  {
    return function(value:Object, i:int, a:Array):Object {
      return iterator.apply(null, [value, i, a].slice(0, iterator.length));
    };
  }
}

describe('FunctionMethods', function():void {
  describe('iterator', function():void {
    it('should create a function that can be used with the Array methods', function():void {
      expect(FunctionMethods.toIterator, function():void {}).should(eq, null);
      expect(FunctionMethods.toIterator, function(value:Object):void {}).should(eq, null);
      expect(FunctionMethods.toIterator, function(value:Object, i:int):void {}).should(eq, null);
      expect(FunctionMethods.toIterator, function(value:Object, i:int, a:Array):void {}).should(eq, null);
      expect(FunctionMethods.toIterator, function(value:Object, ...rest):void {}).should(eq, null);
      
      // the typing saving is negligible, *sigh*
      expect([0, 10, 20, 30].filter, FunctionMethods.toIterator(function(value:Number):Boolean { 
        return value > 10;
      })).should(eq, [20, 30]);
      
    });
  });
});

internal class JSON
{
  static public function toString(value:Object):String
  {
    if (value == null) return 'null';
    var type:String = (typeof value).toLowerCase();
    switch(type)
    {
      case 'undefined': 
      case 'function':
      case 'string': 
        return string(value as String);
      case 'array': 
        return array(value as Array);
      case 'object': 
      default: 
        return object(value);
    }
  }
  
  static private function array(value:Array):String
  {
    return '[' + value.map(FunctionMethods.toIterator(JSON.toString)).join(',') + ']';
  }
  
  static private function object(value:Object):String
  {
    var out:String = '{';
    var fields:Array = [];
    for (var key:String in object)
    {
      fields.push(JSON.toString(key) + ':' + JSON.toString(object[key]));
    }
    out += fields.join(', ');
    out += '}'
    return out;
  }
  
  static private function string(value:String):String
  {
    return '"'+ value +'"';
  }
}