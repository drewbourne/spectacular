package 
{
  public class FunctionMethods
  {
    public static function toIterator(iterator:Function):Function
    {
      return function(value:Object, i:int, a:Array):Object {
        return iterator.apply(null, [value, i, a].slice(0, iterator.length));
      };
    }
  }
  
}