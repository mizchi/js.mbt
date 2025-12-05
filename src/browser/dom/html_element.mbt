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
pub fn HTMLElement::innerText(self : HTMLElement) -> String {
  self.as_any()._get("innerText").cast()
}

///|
pub fn HTMLElement::setInnerText(self : HTMLElement, text : String) -> Unit {
  self.as_any()._set("innerText", @core.any(text)) |> ignore
}

///|
pub fn HTMLElement::innerHTML(self : HTMLElement) -> String {
  self.as_any()._get("innerHTML").cast()
}

///|
pub fn HTMLElement::setInnerHTML(self : HTMLElement, html : String) -> Unit {
  self.as_any()._set("innerHTML", @core.any(html)) |> ignore
}

///|
pub fn HTMLElement::outerHTML(self : HTMLElement) -> String {
  self.as_any()._get("outerHTML").cast()
}

///|
pub fn HTMLElement::setOuterHTML(self : HTMLElement, html : String) -> Unit {
  self.as_any()._set("outerHTML", @core.any(html)) |> ignore
}

///|
pub fn HTMLElement::focus(self : HTMLElement) -> Unit {
  self.as_any()._call("focus", []) |> ignore
}

///|
pub fn HTMLElement::click(self : HTMLElement) -> Unit {
  self.as_any()._call("click", []) |> ignore
}
