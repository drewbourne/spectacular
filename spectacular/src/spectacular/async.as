package spectacular {

  import spectacular.internals.SpectacularContext;
   
  /**
   * Indicates to Spectacular that an Event listener or other Function should 
   * be called asynchronously. 
   * 
   * @param asyncFunction
   * @param timeoutMs
   * @param failFunction
   */
  public function async(asyncFunction:Function, timeoutMs:int=500, failFunction:Function=null):Function {
    return SpectacularContext.instance.async(asyncFunction, timeoutMs, failFunction);
  }
}
