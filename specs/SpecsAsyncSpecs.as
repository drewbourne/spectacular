package spectacular.dsl {

  import flash.events.EventDispatcher;
  import flash.events.Event;

  public function SpecsAsyncSpecs():void {
    
    describe('Async Example', function():void {
      var ed:EventDispatcher;
      
      before(function():void {
        ed = new EventDispatcher();
      });

      it('should wait before running next example', function():void {
        var later:Function = async(function():void {
          // console.log('async example, should wait until this is done');
        }, 100);

        setTimeout(function():void {
          later();
        }, 50);
      });

      it('should pass if async function is called', function():void {
        ed.addEventListener('example', async(function(e:Event):void {
          // console.log('async example, should pass, this trace should be called');
        }, 1000));

        setTimeout(function():void {
          ed.dispatchEvent(new Event('example'));
        }, 50);
      });

      it('should fail if async function is not called', function():void {
        async(function():void {
          // console.log('it should fail if this function is not called');
        }, 100);
      });

      it('should allow multiple async functions to be pending', function():void {
        ed.addEventListener('multi_async_1', async(function(e:Event):void {
          // console.log('multi_async_1');
        }, 100));
        ed.addEventListener('multi_async_2', async(function(e:Event):void {
          // console.log('multi_async_2');
        }, 200));
        ed.addEventListener('multi_async_3', async(function(e:Event):void {
          // console.log('multi_async_3');
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
  }
}

