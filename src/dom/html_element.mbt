///|
#external
pub type HTMLElement

///|
pub impl Js for HTMLElement

///|
pub impl EventTarget for HTMLElement

///|
pub impl ElementImpl for HTMLElement

///|
pub impl NodeImpl for HTMLElement

///|
pub impl HTMLElementImpl for HTMLElement

///|
pub impl Js for HTMLElement

///|
pub impl HTMLElementImpl for HTMLElement

///|
/// HTMLElement trait - base interface for HTML elements
pub(open) trait HTMLElementImpl: Js + ElementImpl {
  inner_text(Self) -> String = _
  set_inner_text(Self, String) -> Unit = _
  inner_html(Self) -> String = _
  set_inner_html(Self, String) -> Unit = _
  outer_html(Self) -> String = _
  set_outer_html(Self, String) -> Unit = _
  focus(Self) -> Unit = _
  click(Self) -> Unit = _
}

///|
impl HTMLElementImpl with inner_text(self) -> String {
  unsafe_cast(self.get("innerText"))
}

///|
impl HTMLElementImpl with set_inner_text(self, text) -> Unit {
  self.set("innerText", text)
}

///|
impl HTMLElementImpl with inner_html(self) -> String {
  unsafe_cast(self.get("innerHTML"))
}

///|
impl HTMLElementImpl with set_inner_html(self, html) -> Unit {
  self.set("innerHTML", html)
}

///|
impl HTMLElementImpl with outer_html(self) -> String {
  unsafe_cast(self.get("outerHTML"))
}

///|
impl HTMLElementImpl with set_outer_html(self, html) -> Unit {
  self.set("outerHTML", html)
}

///|
impl HTMLElementImpl with focus(self) -> Unit {
  ignore(self.invoke("focus", []))
}

///|
impl HTMLElementImpl with click(self) -> Unit {
  ignore(self.invoke("click", []))
}
