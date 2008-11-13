package 
{
  public class ArrayMethods
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
}
