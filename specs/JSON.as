package 
{
  public class JSON
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
}