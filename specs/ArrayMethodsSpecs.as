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
  
  describe('unfold', function():void {
    it('should work for simple values', function():void {
      var p:Function = function(n:Number):Boolean { return n > 0; };
      var t:Function = function(n:Number):Number { return n - 2; };
      var i:Function = t;

      expect(ArrayMethods.unfold, 10, p, t, i).to(eq, [8, 6, 4, 2, 0]);
    });
    
    it('should work for complex values', function():void {
      var parent:Object = { values: [1, 2, 3] };
      var child1:Object = { parent: parent, values: [4, 5, 6] };
      var child2:Object = { parent: child1, values: [7, 8, 9] };

      var predicate  :Function = function(o:Object):Boolean { return o && o.values != null };
      var transformer:Function = function(o:Object):Object { return o.values; };
      var incrementor:Function = function(o:Object):Object { return o.parent; }

      expect(ArrayMethods.unfold, child2, predicate, transformer, incrementor).to(eq, [[7, 8, 9], [4, 5, 6], [1, 2, 3]]);
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
