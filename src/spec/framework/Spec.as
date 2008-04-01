package spec
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

    // add but dont run
    public function xdescribe(...rest):void
    {

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

    // add but dont run
    public function xit(desc:String, impl:Function):void
    {

    }

    /*
      expect(instance:Object, methodName:String, ...args)
      expect(instanceMethod:Function, ..args)
      expect(value)
     */
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

  /*
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
  */  
}
