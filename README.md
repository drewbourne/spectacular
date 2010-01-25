# Spectacular

Spectacular is an experiment in DSLs/pidgins for ActionScript 3 for use testing Flash and Flex projects.

Spectacular provides a FlexUnit 4 Runner. Use it like so:

    package spectacular.examples {
            
        import org.flexunit.assertThat;
        import org.hamcrest.object.equalTo;
            
        import spectacular.*;
        
        [RunWith("spectacular.runners.SpectacularRunner")]
        public class SpectacularRunnerExample {
            public function SpectacularRunnerExample) {
                
                describe("a context", function():void {
                    it("should show an example of usage", function():void {
                        assertThat()("something", not(equalTo("nothing"));
                    });
                });
            }
        }
    }

# Contexts

Contexts are defined by `describe()`, and take a description String and a Function within which `before()`, `after()` and `it()` are called to define Examples.

    describe("a description of the scenario", function():void {
       // make calls to before(); after(); and it(); here.
    });

# Examples

Examples are defined by `it()` called within a `describe()` and take a description String and a Function within which tests are performed. 

    it("a description of the test", function():void {
       // make calls to assertThat(); assertTrue(); etc here.
    });

# Befores

Befores are defined by `before()` called within a `describe()` and take a Function to run before each Example in the current Context and its child Contexts. Befores are used to setup or initialise any objects or instances required by the `it()` Functions.

    describe("a before example", function():void {
        var dispatcher:EventDispatcher;
        
        before(function():void {
           dispatcher = new EventDispatcher();
        }); 
        
        it("before should have run", function():void {
            assertThat(dispatcher, notNullValue());
        });
    });

# Afters

Afters are defined by `after()` called within a `describe()` and take a Function to run after each Example in the current Context and its child Contexts. Afters are used to setup or initialise any objects or instances required by the `it()` Functions.

    describe("an after example", function():void {
        
        after(function():void {
            trace('done!');
        });
    });

# Asyncs

Asyncs can be used within `before()`, `after()` and `it()` Functions. Defining an async sets an expectation that the given function will be called asynchronously within the given timeframe. Failure to call the function wrapped by async will cause an Error to be thrown.

    it("waits till the event is fired", function():void {
       dispatcher.addEventListener(Event.COMPLETE, async(function():void {}, 500)); 
       
       // pretend we do something with a delay
       setTimeout(function():void {
           dispatcher.dispatchEvent(new Event(Event.COMPLETE));
       }, 200);
    });

