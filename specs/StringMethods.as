package
{
  public class StringMethods
  {
    static public function repeat(value:String, count:Number = 1):String
    {
      var out:String = '';
      while(count > 0){ out += value; --count; }
      return out;
    }

    static public function padLeft(value:String, length:Number = 1, pad:String = ' '):String
    {
      if (length < value.length) 
        return value.substring(0, length);

      var padLength:Number = length - value.length;
      var padRepeat:Number = Math.ceil(padLength / pad.length);
      var padding:String = StringMethods.repeat(pad, padRepeat).slice(-padLength);

      return padding + value;
    }

    static public function padRight(value:String, length:Number = 1, pad:String = ' '):String
    {
      if (length < value.length)
        return value.substring(0, length);

      var out:String = value;
      var padLength:Number = length - value.length;
      var padRepeat:Number = Math.ceil(padLength / pad.length);
      var padding:String = StringMethods.repeat(pad, padRepeat).slice(0, padLength);

      return value + padding;
    }
  }
}