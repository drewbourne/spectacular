package spectacular.framework 
{
  import flash.errors.IllegalOperationError;
  
  import org.hamcrest.*;
  
  import spectacular.dsl.*;
  
  public function ExampleSpecs():void
  {
    describe('ExampleGroup', function():void {
      var eg:ExampleGroup;

      describe('a root ExampleGroup', function():void {
        it('should not have a parent', function():void {
          
        });
      });
      
      describe('a nested ExampleGroup', function():void {
        it('should have a parent', function():void {
          
        });
        
        describe('runBefores', function():void {
          it('should collect before functions up the heirarchy', function():void {

          });
          it('should run before functions outermost to innermost', function():void {
            
          });
        });
        
        describe('runAfters', function():void {
          it('should collect after functions up the heirarchy', function():void {

          });
          it('should run after functions innermost to outermost', function():void {
            
          });
        });
      });
      
      describe('a Typed ExampleGroup', function():void {
        it('should have a type / Class', function():void {
          eg = new ExampleGroup(null, Example);
          assertThat(eg.type, equalTo(Example));
        });
      });
      
      describe('running an ExampleGroup', function():void {
        
      });
      
      describe('adding an Example', function():void {
        before(function():void {
          eg = new ExampleGroup();
        });
        
        it('should be added to ExampleGroup.examples', function():void {
          
        });
        it('added Example should be pending', function():void {
          
        });
      });
    });
  }
}