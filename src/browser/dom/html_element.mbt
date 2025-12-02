///|
/// HTMLElement trait - base interface for HTML elements
pub(open) trait HTMLElementImpl {
  as_any(Self) -> @core.Any
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
pub fn HTMLElement::as_any(self : HTMLElement) -> @core.Any = "%identity"

///|
pub fn HTMLElement::as_event_target(self : HTMLElement) -> @event.EventTarget = "%identity"

///|
pub fn HTMLElement::as_node(self : HTMLElement) -> Node = "%identity"

///|
pub fn HTMLElement::as_element(self : HTMLElement) -> Element = "%identity"

///|

///|
pub impl ElementImpl for HTMLElement with as_any(self) -> @core.Any {
  self.as_any()
}

///|
pub impl HTMLElementImpl for HTMLElement with as_any(self) -> @core.Any {
  self.as_any()
}

///|
impl HTMLElementImpl with innerText(self) -> String {
  self.as_any()._get("innerText").cast()
}

///|
impl HTMLElementImpl with setInnerText(self, text) -> Unit {
  self.as_any()._set("innerText", @core.any(text)) |> ignore
}

///|
impl HTMLElementImpl with innerHTML(self) -> String {
  self.as_any()._get("innerHTML").cast()
}

///|
impl HTMLElementImpl with setInnerHTML(self, html) -> Unit {
  self.as_any()._set("innerHTML", @core.any(html)) |> ignore
}

///|
impl HTMLElementImpl with outerHTML(self) -> String {
  self.as_any()._get("outerHTML").cast()
}

///|
impl HTMLElementImpl with setOuterHTML(self, html) -> Unit {
  self.as_any()._set("outerHTML", @core.any(html)) |> ignore
}

///|
impl HTMLElementImpl with focus(self) -> Unit {
  self.as_any()._call("focus", []) |> ignore
}

///|
impl HTMLElementImpl with click(self) -> Unit {
  self.as_any()._call("click", []) |> ignore
}
