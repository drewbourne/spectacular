package spec.matcher
{
  public class StrictEqualityMatcher implements SpecExpectationMatcher
  {
    public function StrictEqualityMatcher( expected:* )
    {
      this.expected = expected;
    }

    public function matches( actual:* ):Boolean
    {
      return expected === actual;
    }

    public function failureMesssage():String
    {
      return ('Expected #{expected}, received #{actual}, expected to be ===')
        .replace('#{expected}', expected)
        .replace('#{actual}', actual);
    }

    public function negativeFailureMessage():String
    {
      return ('Expected #{expected}, received #{actual}, expected to be !==')
        .replace('#{expected}', expected)
        .replace('#{actual}', actual);
    }

    private var expected:*;
    private var actual:*;
  }
}