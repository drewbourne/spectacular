package spec.framework
{
  public class Spec
  {
    public var exampleGroups:Array;
    public var currentExampleGroup:ExampleGroup;
    public var currentExample:Example;

    public function Spec()
    {
      exampleGroups = [];
      currentExampleGroup = new ExampleGroup(null, null, null);
    }

    // describe( Class, String, Function )
    // describe( Class, Function )
    // describe( String, Function )
    public function describe(...rest):ExampleGroup
    {
      // create an example group
      // add it to the example group
      var type:Class;
      var desc:String;
      var impl:Function;
      
      // allowed argument matches
      // [Class, String, Function], function(...rest):void { return _describe(rest[0], rest[1], rest[2]); }
      // [Class, Function], function(...rest):void { return _describe(rest[0], null, rest[1]); }
      // [String, Function], function(...rest):void { return _describe(currentExampleGroup.type, rest[0], rest[1]); }
      // FunctionMethods.match(patterns, rest).apply(null, rest);

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
          // use the type of the current example group
          type = currentExampleGroup ? currentExampleGroup.type : null;
          desc = rest[0] as String;
          impl = rest[1] as Function;
        }
        else
        {
          throw new ArgumentError('Bad Args');
        }
      }

      return _describe(type, desc, impl);
    }
    
    // add but dont run
    public function xdescribe(...rest):ExampleGroup
    {
      // full of fail!
      //return _describe(type, desc, impl, {disabled: true});
      
      return null;
    }
    
    private function _describe(type:Class, desc:String, impl:Function, options:Object = null):ExampleGroup
    {
      trace('_describe', type, desc, impl);
      
      var eg:ExampleGroup = new ExampleGroup(currentExampleGroup, type, desc, impl);
      currentExampleGroup.examples.push(eg);
      
      
      /*
      var previousExampleGroup:ExampleGroup = currentExampleGroup;
      previousExampleGroup.examples.push(eg);
      currentExampleGroup = eg;
      currentExample = null;
      // fairly iffy about this here, should be called by the runner
      // currentExampleGroup.impl();
      
      currentExampleGroup = previousExampleGroup;
      */
      
      return eg;
    }

    public function it(desc:String, impl:Function):Example
    {
      trace('it', desc, impl);
      return _it(desc, impl);
    }
    
    // add but dont run
    public function xit(desc:String, impl:Function):Example
    {
      return _it(desc, impl, {disabled: true});
    }
    
    private function _it(desc:String, impl:Function, options:Object = null):Example
    {
      trace('_it', desc, impl);
      
      // add an example to the currentExampleGroup
      var e:Example = new Example(desc, impl);
      var previousExample:Example = currentExample;
      currentExampleGroup.examples.push(e);
      currentExample = e;
      // currentExample.run();
      // currentExample = previousExample;
      return e;
    }

    // expect(instance:Object, methodName:String, ...args)
    // expect(instanceMethod:Function, ..args)
    // expect(value)
    public function expect(...rest):*
    {
      if( !currentExample )
      {
        throw Error('expect() is only allowed inside it()');
      }

      var ex:SpecExpectation = new SpecExpectation(rest.shift(), rest);
      currentExample.expectations.push(ex);
      return ex;
    }

    public function beforeEach(block:Function):void
    {
      currentExampleGroup.beforeEaches.push(block);
    }

    public function beforeAll(block:Function):void
    {
      currentExampleGroup.beforeAlls.push(block);
    }

    public function afterEach(block:Function):void
    {
      currentExampleGroup.afterEaches.push(block);
    }

    public function afterAll(block:Function):void
    {
      currentExampleGroup.afterAlls.push(block);
    }  
  }
}
