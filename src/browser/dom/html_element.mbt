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
pub extern "js" fn HTMLElement::innerText(self : HTMLElement) -> String =
  #| (self) => self.innerText

///|
pub fn HTMLElement::setInnerText(self : HTMLElement, text : String) -> Unit {
  self.as_any()._set("innerText", @core.any(text)) |> ignore
}

///|
pub extern "js" fn HTMLElement::innerHTML(self : HTMLElement) -> String =
  #| (self) => self.innerHTML

///|
pub fn HTMLElement::setInnerHTML(self : HTMLElement, html : String) -> Unit {
  self.as_any()._set("innerHTML", @core.any(html)) |> ignore
}

///|
pub extern "js" fn HTMLElement::outerHTML(self : HTMLElement) -> String =
  #| (self) => self.outerHTML

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
