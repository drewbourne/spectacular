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
  }
  ,
  group: function(name:String):void {
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

internal var runner:SpecRunner = new SpecRunner(spec, new TraceSpecReporter());

// setup the runner to run later
setTimeout(function():void {
  runner.run(spec);
}, 1000);

// spec.dsl
internal function describe(description:*, implementation:Function):void 
{
  spec.addExampleGroup(null, description, implementation);
}

internal function it(description:String, implementation:Function):void 
{
  spec.addExample(description, implementation);
}

// pass / fail
internal function pass(message:String = null):void 
{
  //trace('passed', message || '');
}

internal function fail(message:String = null):void
{
  console.log('failed!', message || '');
  
  var error:Error = new Error();
  var stack:Array = error.getStackTrace().split('\n');
  trace(stack.join('\n'));
}

internal function async(func:Function, failAfter:Number):Function 
{
  var asyncDetails:Object;
  
  var failTimeout:int = setTimeout(function():void {
    // should get the description from the it() this was called within
    fail('async not called: ' + spec.currentExample.description);
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

// TODO replace with flexunit Assert, Hamcrest matchers, or whatever
// TODO separate the assertion framework from the test unit wrappers
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
      
      if(!passed)
      {
        console.group('failed');
        console.log('args:', actualArgs.slice(1), ', result:', actual, ', expected:', expectedArgs.slice(1));
        console.log(evaluateMatcher.failureMessage(actual));
        console.groupEnd();
        
        spec.results.failedCount++;
      }
      else if(negative && passed)
      {
        console.group('failed');
        console.log('args:', actualArgs.slice(1), ', result:', actual, ', expected:', expectedArgs.slice(1));
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

/*include 'SpecsAsyncSpecs.as'*/
include 'ArrayMethodsSpecs.as'
/*include 'FunctionMethodsSpecs.as'*/
/*include 'NumberMethodsSpecs.as'*/
/*include 'ObjectMethodsSpecs.as'*/
/*include 'StringMethodsSpecs.as'*/
