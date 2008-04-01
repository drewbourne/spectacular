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
            e.run();
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
    //currentExample.run();
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
    impl(this);
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
    impl(this);
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
  
  public function failureMessage():String
  {
    return ('Expected #{expected}, received #{actual}, expected to be ===')
      .replace('#{expected}', expected)
      .replace('#{actual}', actual);
  }
  
  public function negativeFailureMessage():String
  {
    return ('Expected #{expected}, received #{actual}, expected to be !==')
      .replace('#{expected}', expected)
      .replace('#{actual}', actual);
  }
  
  private var expected:*;
  private var actual:*;
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

internal function eq(expected:*):StrictEqualityMatcher {
  return new StrictEqualityMatcher(expected);
}

var hello:Function = function():void { trace('hello from hello()'); }

// this is really fucking shit
/*
Spec.add(function(s:Spec):void { with(s) {
  describe(Spec, 'Methods', function(eg:ExampleGroup):void { with(eg) {
    describe('describe', function(eg:ExampleGroup):void { with(eg) {
      it('should provide a flexible api', function(e:Example):void { with(e) {
        expect(0).should(eq(0));
        trace('hello', hello, hello is Function);
      }});      
    }});
  }});
}});
*/


// helper:functions
/*
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
*/
