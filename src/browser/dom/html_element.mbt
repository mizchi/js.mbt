///|
/// HTMLElement trait - base interface for HTML elements
pub(open) trait HTMLElementImpl: @js.JsImpl + ElementImpl {
  innerText(Self) -> String = _
  setInnerText(Self, String) -> Unit = _
  innerHTML(Self) -> String = _
  setInnerHTML(Self, String) -> Unit = _
  outerHTML(Self) -> String = _
  setOuterHTML(Self, String) -> Unit = _
  focus(Self) -> Unit = _
  click(Self) -> Unit = _
}

///|
#external
pub type HTMLElement

///|
pub impl @js.JsImpl for HTMLElement

///|
pub impl @event.EventTargetImpl for HTMLElement

///|
pub impl ElementImpl for HTMLElement

///|
pub impl NodeImpl for HTMLElement

///|
pub impl HTMLElementImpl for HTMLElement

///|
pub impl @js.JsImpl for HTMLElement

///|
pub impl HTMLElementImpl for HTMLElement

///|
impl HTMLElementImpl with innerText(self) -> String {
  self.get("innerText").cast()
}

///|
impl HTMLElementImpl with setInnerText(self, text) -> Unit {
  self.set("innerText", text)
}

///|
impl HTMLElementImpl with innerHTML(self) -> String {
  self.get("innerHTML").cast()
}

///|
impl HTMLElementImpl with setInnerHTML(self, html) -> Unit {
  self.set("innerHTML", html)
}

///|
impl HTMLElementImpl with outerHTML(self) -> String {
  self.get("outerHTML").cast()
}

///|
impl HTMLElementImpl with setOuterHTML(self, html) -> Unit {
  self.set("outerHTML", html)
}

///|
impl HTMLElementImpl with focus(self) -> Unit {
  ignore(self.call0("focus"))
}

///|
impl HTMLElementImpl with click(self) -> Unit {
  ignore(self.call0("click"))
}
