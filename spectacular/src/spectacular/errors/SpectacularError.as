package spectacular.errors
{
  public class SpectacularError extends Error
  {
    public function SpectacularError(message:String="", cause:Error=null)
    {
      super(message);
      
      _cause = cause;
    }
    
    public function get cause():Error {
      return _cause;
    }
    
    private var _cause:Error;
  }
}