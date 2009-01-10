package spectacular.framework.reporters {
  
  import flash.events.Event;
  import flash.events.EventDispatcher;
  
  import spectacular.framework.*;
  
  public class TextSpecReporter extends EventDispatcher implements SpecReporter {
    
    private var _nest:int = -1;
    private var _exampleGroupCount:int = 0;
    private var _exampleCount:int = 0;
    private var _failures:Array;
    private var _text:String;
    
    public function TextSpecReporter() {
      super();
      _failures = [];
      _text = "";
    }
    
    [Bindable("textChanged")]
    public function get text():String {
      return _text;
    }
    
    public function start():void {
      ;
    }
    
    public function end():void {
      appendLine('\nDone');
      appendLine('\tTotal Example Groups:', _exampleGroupCount);
      appendLine('\tTotal Examples:', _exampleCount);
      appendLine('\tFailures:', _failures.length);
    }
    
    public function startExample(example:Example):void {
      _nest++;
      _exampleCount++;
      var out:String = repeat('  ', _nest) + example.description;
      appendLine(out);
    }
    
    public function endExample(example:Example):void {
      _nest--;
    }
    
    public function startExampleGroup(exampleGroup:ExampleGroup):void {
      _nest++;
      _exampleGroupCount++;
      var out:String = repeat('  ', _nest) + exampleGroup.description;
      appendLine(out);
    }
    
    public function endExampleGroup(exampleGroup:ExampleGroup):void {
      _nest--;
    }
    
    public function failure(cause:Error):void {
      _failures.push(cause);
      appendLine(makeNiceStackTrace(cause.getStackTrace()));
    }
    
    // text methods
    protected function appendLine(...strings):void {
      _text += strings.join(' ') + "\n";
      dispatchEvent(new Event("textChanged"));
    }
  }
}

internal function repeat(value:String, count:Number = 1):String {
  
  var out:String = '';
  while(count > 0){ out += value; --count; }
  return out;
}

internal function makeNiceStackTrace(lines:String):String {
  
  return lines.split('\n')
    .filter(includeLineInStackTrace)
    .map(cleanLineOfUnnecesssaryPaths)
    .join('\n');
}

internal function includeLineInStackTrace(line:String, i:int, a:Array):Boolean {
  
  return true;
}

internal var packageAndClassPattern       :RegExp = /([\w]+)(.[\w]+)::([\w]+)/i;
internal var namespaceAndFunctionPattern  :RegExp = /([\w]+)\/([\w\:.]+)::([\w]+)/i;
internal var anonymousFunctionPattern     :RegExp = /<anonymous>/;
internal var filePathAndLineNumberPattern :RegExp = /\[([\w\/\.-]+:(\d+))\]/i;

internal function cleanLineOfUnnecesssaryPaths(line:String, i:int, a:Array):String {

  return line;
}