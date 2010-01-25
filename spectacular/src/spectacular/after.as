package spectacular {
  
  import spectacular.internals.SpectacularContext;
  
  // TODO support named after()   
  /**
   * Calls the given function after each <code>it()</code>.
   * 
   * @param afterFunction Function to run after each <code>it()</code>. 
   */
  public function after(afterFunction:Function):void {
    SpectacularContext.instance.after(afterFunction);
  }
}
