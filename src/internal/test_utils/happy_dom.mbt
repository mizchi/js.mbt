///|
/// HappyDOM Window instance for testing
#external
pub type HappyWindow

///|
/// Create a new HappyDOM Window instance
pub extern "js" fn create_happy_window() -> HappyWindow =
  #|() => new (require("happy-dom").Window)()

///|
/// Get the document from a HappyDOM Window
pub extern "js" fn HappyWindow::document(self : HappyWindow) -> @dom.Document =
  #|(w) => w.document

///|
/// Close the HappyDOM Window and clean up resources
pub extern "js" fn HappyWindow::close(self : HappyWindow) -> Unit =
  #|(w) => w.close()

///|
/// Get the window as Any for accessing additional properties
pub fn HappyWindow::as_any(self : HappyWindow) -> @core.Any = "%identity"

///|
/// Get the customElements registry from a HappyDOM Window
pub extern "js" fn HappyWindow::customElements(
  self : HappyWindow,
) -> @dom.CustomElementRegistry =
  #|(w) => w.customElements

///|
/// Get HTMLElement class from HappyDOM Window (for extending in custom elements)
pub extern "js" fn HappyWindow::html_element_class(
  self : HappyWindow,
) -> @core.Any =
  #|(w) => w.HTMLElement
