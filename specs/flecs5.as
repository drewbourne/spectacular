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
    ed.addEventListener('multi_async_2', async(function(e:Event):void {
      console.log('multi_async_2');
    }, 200));
    ed.addEventListener('multi_async_3', async(function(e:Event):void {
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