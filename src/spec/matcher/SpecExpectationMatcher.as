package spec.matcher
{
  public interface SpecExpectationMatcher
  {
    function matches(actual:*):Boolean;
    function failureMessage():String;
    function negativeFailureMessage():String;
  }
}