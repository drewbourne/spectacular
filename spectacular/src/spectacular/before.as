package spectacular {

  import spectacular.internals.SpectacularContext;

  // TODO support named before() 
  /**
   * Calls the given function before each <code>it()</code>.
   * 
   * @param beforeFunction Function to run before each <code>it()</code>. 
   */
  public function before(beforeFunction:Function):void {
    SpectacularContext.instance.before(beforeFunction);
  }
}
