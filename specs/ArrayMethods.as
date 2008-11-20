package 
{
  public class ArrayMethods
  {
    static public function pluck(array:Array, field:String):Array
    {
      var result:Array = array.map(function(value:Object, i:int, a:Array):Object {
        return value.hasOwnProperty(field) ? value[field] : null;
      });
      return result;
    }

    static public function inject(memo:Object, array:Array, iterator:Function):Object
    {
      array.forEach(function(value:Object, i:int, a:Array):void {
        memo = iterator(memo, value);
      });
      return memo;
    }
    
    // state        initial state
    // predicate    tests the state to know when to stop
    // transformer  converts the state to an output value
    // incrementor  converts the state to the next state
    static public function unfold(initial:Object, predicate:Function, transformer:Function, incrementor:Function):Array {
      
      var result:Array = [];
      var state:Object = initial;
      
      do {
        result.push(transformer(state));
        state = incrementor(state);
      } while (predicate(state))
      
      return result;
    }

    static private function flattenInternal(memo:Array, value:Object):Array
    {
      return memo.concat(value is Array ? flatten(value as Array) : [value]);
    }

    static public function flatten(array:Array):Array
    {
      return inject([], array, flattenInternal) as Array;
    }
    
    static private function isArray(value:Object, i:int=0, a:Array=null):Boolean 
    { 
      return value is Array; 
    }

    static public function zip(...arrays):Array
    {
      var arrayCount:int = arrays.length
      
      if (arrayCount == 0) 
      {
        return [];
      } 
      
      if (!arrays.every(isArray))
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
      return array.filter(notNull);
    }

    static private function notNull(v:Object, i:int=0, a:Array=null):Boolean
    {
      return v !== null;
    }

    static public function contains(array:Array, value:Object):Boolean
    {
      return array.indexOf(value) !== -1;
    }

    static private function uniqueInternal(memo:Array, value:Object):Array 
    {
      if (!contains(memo, value)) 
      {
        memo.push(value);
      }
      return memo;
    }

    static public function unique(array:Array):Array
    {
      return inject([], array, uniqueInternal) as Array;
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
    
    static public function find(array:Array, iterator:Function):Object 
    {
      var result:Object = null;
      var item:Object = null;
      
      // TODO: is this safe? in that it does not experience the same issues as enumerable properties in javascript
      // for each (var o in array) { ... }
      
      // FIXME do we really want to iterate over every element in sparse arrays?
      for (var i:int = 0, n:int = array.length; i < n; i++) 
      {
        item = array[i];
        if (iterator(item, i, array)) {
          result = item;
          break;
        }
      }
      
      return result;
    }
  }
}
