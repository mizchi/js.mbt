///|
/// Query Result Types - opaque wrapper around HTMLElement
#external
pub type ScreenResult

///|
pub fn ScreenResult::as_element(self : ScreenResult) -> @dom.HTMLElement {
  @nostd.identity(self)
}
