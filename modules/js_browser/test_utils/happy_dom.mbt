///|
/// Create a new HappyDOM Window instance for testing
/// Returns a @dom.Window that can be used like a browser window
pub fn create_happy_window() -> @dom.Window {
  @core.identity(create_happy_window_internal())
}

///|
extern "js" fn create_happy_window_internal() -> @core.Any =
  #|() => new (require("happy-dom").Window)()
