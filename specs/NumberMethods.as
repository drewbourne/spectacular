package 
{
  public class NumberMethods
  {
    static public function between(value:Number, minimum:Number, maximum:Number):Boolean
    {
      return (minimum <= value && value <= maximum);
    }

    static public function bound(value:Number, minimum:Number, maximum:Number):Number
    {
      return Math.min(Math.max(minimum, value), maximum);
    }

    // minimum: is the start of the exclusion range
    // maximum: is the end of the exclusion range
    static public function exclude(value:Number, minimum:Number, maximum:Number):Number
    {
      if (!between(value, minimum, maximum))
        return value;

      if (value == minimum && value == maximum)
        return NaN;

      var mindiff:Number = value - minimum;
      var maxdiff:Number = maximum - value;
      return mindiff <= maxdiff ? minimum : maximum;
    }

    static public function overflow(value:Number, minimum:Number, maximum:Number):Number
    {
      if (between(value, minimum, maximum))
        return value;

      var range:Number = maximum - minimum;
      var difference:Number;
      var modulus:Number;

      if (value < minimum)
      {
        difference = minimum - value;
        modulus = difference % range;
        return maximum - modulus;
      }

      if (value > maximum)
      {
        difference = value - maximum;
        modulus = difference % range;
        return minimum + modulus;
      }

      // shouldnt happen
      return value;
    }

    // round to the closest step
    static public function snap(value:Number, step:Number = 1, origin:Number = 0):Number
    {
      return origin + (Math.round(value / step) * step);
    }

    static public function normalize(value:Number, minimum:Number, maximum:Number):Number 
    {
      return (value - minimum) / (maximum - minimum);
    }

    static public function interpolate(normalizedValue:Number, minimum:Number, maximum:Number):Number 
    {
      return minimum + (maximum - minimum) * normalizedValue;
    }
  }
}