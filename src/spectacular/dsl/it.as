package spectacular.dsl {
  
  import spectacular.framework.Spec;
  
  /**
   * @example
   * <listing version="3.0">
   *  it("is just a description");
   *  it("should be awesome", function():void {
   *    assertThat(new Awesome(), instanceOf(Awesome));
   *  });
   * </listing>
   */
  public function it(description:String, func:Function = null):void {
    Spec.addExample(description, func);
  }
}