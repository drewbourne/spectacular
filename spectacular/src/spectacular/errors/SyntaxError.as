package spectacular.errors
{
  public class SyntaxError extends SpectacularError
  {
    public function SyntaxError(message:String="", cause:Error=null)
    {
      super(message, cause);
    }
  }
}