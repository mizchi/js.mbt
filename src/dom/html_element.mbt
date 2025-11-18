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
  setInnerText(Self, String) -> Unit = _
  innerHTML(Self) -> String = _
  setInnerHTML(Self, String) -> Unit = _
  outerHTML(Self) -> String = _
  setOuterHTML(Self, String) -> Unit = _
  focus(Self) -> Unit = _
  click(Self) -> Unit = _
}

///|
impl HTMLElementImpl with inner_text(self) -> String {
  unsafe_cast(self.get("innerText"))
}

///|
impl HTMLElementImpl with setInnerText(self, text) -> Unit {
  self.set("innerText", text)
}

///|
impl HTMLElementImpl with innerHTML(self) -> String {
  unsafe_cast(self.get("innerHTML"))
}

///|
impl HTMLElementImpl with setInnerHTML(self, html) -> Unit {
  self.set("innerHTML", html)
}

///|
impl HTMLElementImpl with outerHTML(self) -> String {
  unsafe_cast(self.get("outerHTML"))
}

///|
impl HTMLElementImpl with setOuterHTML(self, html) -> Unit {
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
