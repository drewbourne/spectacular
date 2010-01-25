package spectacular {
  
  import spectacular.internals.SpectacularContext;
   
  /**
   * Describe an example.
   */
  public function it(description:String, exampleFunction:Function=null):void {
    SpectacularContext.instance.it(description, exampleFunction);
  }
}
