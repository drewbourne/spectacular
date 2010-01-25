package spectacular {
  
  import spectacular.internals.SpectacularContext;
   
  /**
   * Describe a context.
   */
  public function describe(description:String, contextFunction:Function=null):void {
    SpectacularContext.instance.describe(description, contextFunction);
  }
}
