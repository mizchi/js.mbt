///|
#external
pub type HTMLDivElement

///|
pub impl JsImpl for HTMLDivElement

///|
pub impl EventTargetImpl for HTMLDivElement

///|
pub impl NodeImpl for HTMLDivElement

///|
pub impl ElementImpl for HTMLDivElement

///|
pub impl HTMLElementImpl for HTMLDivElement

///|
#external
pub type HTMLCanvasElement

///|
pub impl JsImpl for HTMLCanvasElement

///|
pub impl EventTargetImpl for HTMLCanvasElement

///|
pub impl NodeImpl for HTMLCanvasElement

///|
pub impl ElementImpl for HTMLCanvasElement

///|
pub impl HTMLElementImpl for HTMLCanvasElement

///|
/// Canvas properties
pub fn HTMLCanvasElement::width(self : Self) -> Int {
  self.get("width") |> unsafe_cast
}

///|
pub fn HTMLCanvasElement::setWidth(self : Self, value : Int) -> Unit {
  self.set("width", value)
}

///|
pub fn HTMLCanvasElement::height(self : Self) -> Int {
  self.get("height") |> unsafe_cast
}

///|
pub fn HTMLCanvasElement::setHeight(self : Self, value : Int) -> Unit {
  self.set("height", value)
}

///|
/// Canvas methods
pub fn HTMLCanvasElement::getContext(self : Self, context_type : String) -> Js {
  self.call("getContext", [context_type])
}

///|
pub fn HTMLCanvasElement::toDataURL(
  self : Self,
  image_type? : String,
  quality? : Double,
) -> String {
  match (image_type, quality) {
    (Some(t), Some(q)) => self.call2("toDataURL", t, q) |> unsafe_cast
    (Some(t), None) => self.call("toDataURL", [t]) |> unsafe_cast
    (None, _) => self.call0("toDataURL") |> unsafe_cast
  }
}

///|
pub fn HTMLCanvasElement::toBlob(
  self : Self,
  image_type? : String,
  quality? : Double,
) -> Promise[Blob] {
  match (image_type, quality) {
    (Some(t), Some(q)) => self.call2("toBlob", t, q) |> unsafe_cast
    (Some(t), None) => self.call("toBlob", [t]) |> unsafe_cast
    (None, _) => self.call0("toBlob") |> unsafe_cast
  }
}

///|
#external
pub type HTMLBodyElement

///|
pub impl JsImpl for HTMLBodyElement

///|
pub impl EventTargetImpl for HTMLBodyElement

///|
pub impl NodeImpl for HTMLBodyElement

///|
pub impl ElementImpl for HTMLBodyElement

///|
pub impl HTMLElementImpl for HTMLBodyElement

///|
#external
pub type HTMLHeadElement

///|
pub impl JsImpl for HTMLHeadElement

///|
pub impl EventTargetImpl for HTMLHeadElement

///|
pub impl NodeImpl for HTMLHeadElement

///|
pub impl ElementImpl for HTMLHeadElement

///|
pub impl HTMLElementImpl for HTMLHeadElement

///|
#external
pub type HTMLHtmlElement

///|
pub impl JsImpl for HTMLHtmlElement

///|
pub impl EventTargetImpl for HTMLHtmlElement

///|
pub impl NodeImpl for HTMLHtmlElement

///|
pub impl ElementImpl for HTMLHtmlElement

///|
pub impl HTMLElementImpl for HTMLHtmlElement

///|
#external
pub type HTMLSpanElement

///|
pub impl JsImpl for HTMLSpanElement

///|
pub impl EventTargetImpl for HTMLSpanElement

///|
pub impl NodeImpl for HTMLSpanElement

///|
pub impl ElementImpl for HTMLSpanElement

///|
pub impl HTMLElementImpl for HTMLSpanElement

///|
/// HTMLAnchorElement represents an <a> element
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLAnchorElement
pub(all) struct HTMLAnchorElement {
  mut href : String
  mut target : String
}

///|
pub impl JsImpl for HTMLAnchorElement

///|
pub impl EventTargetImpl for HTMLAnchorElement

///|
pub impl NodeImpl for HTMLAnchorElement

///|
pub impl ElementImpl for HTMLAnchorElement

///|
pub impl HTMLElementImpl for HTMLAnchorElement

///|
/// HTMLButtonElement represents a <button> element
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLButtonElement
pub(all) struct HTMLButtonElement {
  mut disabled : Bool
}

///|
pub impl JsImpl for HTMLButtonElement

///|
pub impl EventTargetImpl for HTMLButtonElement

///|
pub impl NodeImpl for HTMLButtonElement

///|
pub impl ElementImpl for HTMLButtonElement

///|
pub impl HTMLElementImpl for HTMLButtonElement

///|
// #external
pub(all) struct HTMLInputElement {
  mut disabled : Bool
  mut value : String
  mut placeholder : String
  mut checked : Bool
}

///|
pub impl JsImpl for HTMLInputElement

///|
pub impl EventTargetImpl for HTMLInputElement

///|
pub impl NodeImpl for HTMLInputElement

///|
pub impl ElementImpl for HTMLInputElement

///|
pub impl HTMLElementImpl for HTMLInputElement

///|
/// Returns the type of the input
pub fn HTMLInputElement::type_(self : Self) -> String {
  self.get("type") |> unsafe_cast
}

///|
/// Sets the type of the input
pub fn HTMLInputElement::setType(self : Self, input_type : String) -> Unit {
  self.set("type", input_type)
}

///|
/// HTMLTextAreaElement represents a <textarea> element
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLTextAreaElement
pub(all) struct HTMLTextAreaElement {
  mut value : String
  mut placeholder : String
  mut disabled : Bool
  mut rows : Int
  mut cols : Int
  mut readOnly : Bool
}

///|
pub impl JsImpl for HTMLTextAreaElement

///|
pub impl EventTargetImpl for HTMLTextAreaElement

///|
pub impl NodeImpl for HTMLTextAreaElement

///|
pub impl ElementImpl for HTMLTextAreaElement

///|
pub impl HTMLElementImpl for HTMLTextAreaElement

///|
#external
pub type HTMLIFrameElement

///|
pub impl JsImpl for HTMLIFrameElement

///|
pub impl EventTargetImpl for HTMLIFrameElement

///|
pub impl NodeImpl for HTMLIFrameElement

///|
pub impl ElementImpl for HTMLIFrameElement

///|
pub impl HTMLElementImpl for HTMLIFrameElement

///|
/// Returns the src attribute
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLIFrameElement/src
pub fn HTMLIFrameElement::src(self : Self) -> String {
  self.get("src") |> unsafe_cast
}

///|
/// Sets the src attribute
pub fn HTMLIFrameElement::setSrc(self : Self, src : String) -> Unit {
  self.set("src", src)
}

///|
/// Returns the content window
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLIFrameElement/contentWindow
pub fn HTMLIFrameElement::contentWindow(self : Self) -> Window? {
  self.get("contentWindow") |> @js.unsafe_cast_option()
}

///|
/// Returns the content document
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLIFrameElement/contentDocument
pub fn HTMLIFrameElement::contentDocument(self : Self) -> Document? {
  self.get("contentDocument") |> @js.unsafe_cast_option()
}

///|
/// Returns the width attribute
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLIFrameElement/width
pub fn HTMLIFrameElement::width(self : Self) -> String {
  self.get("width") |> unsafe_cast
}

///|
/// Sets the width attribute
pub fn HTMLIFrameElement::setWidth(self : Self, width : String) -> Unit {
  self.set("width", width)
}

///|
/// Returns the height attribute
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLIFrameElement/height
pub fn HTMLIFrameElement::height(self : Self) -> String {
  self.get("height") |> unsafe_cast
}

///|
/// Sets the height attribute
pub fn HTMLIFrameElement::setHeight(self : Self, height : String) -> Unit {
  self.set("height", height)
}

///|
/// Returns the name attribute
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLIFrameElement/name
pub fn HTMLIFrameElement::name(self : Self) -> String {
  self.get("name") |> unsafe_cast
}

///|
/// Sets the name attribute
pub fn HTMLIFrameElement::setName(self : Self, name : String) -> Unit {
  self.set("name", name)
}

///|
/// Returns the sandbox attribute
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLIFrameElement/sandbox
pub fn HTMLIFrameElement::sandbox(self : Self) -> String {
  self.get("sandbox") |> unsafe_cast
}

///|
/// Sets the sandbox attribute
pub fn HTMLIFrameElement::setSandbox(self : Self, sandbox : String) -> Unit {
  self.set("sandbox", sandbox)
}

///|
#external
pub type HTMLFormElement

///|
pub impl JsImpl for HTMLFormElement

///|
pub impl EventTargetImpl for HTMLFormElement

///|
pub impl NodeImpl for HTMLFormElement

///|
pub impl ElementImpl for HTMLFormElement

///|
pub impl HTMLElementImpl for HTMLFormElement

///|
/// HTMLSelectElement represents a <select> element
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLSelectElement
pub(all) struct HTMLSelectElement {
  mut value : String
  mut disabled : Bool
}

///|
pub impl JsImpl for HTMLSelectElement

///|
pub impl EventTargetImpl for HTMLSelectElement

///|
pub impl NodeImpl for HTMLSelectElement

///|
pub impl ElementImpl for HTMLSelectElement

///|
pub impl HTMLElementImpl for HTMLSelectElement

///|
/// HTMLOptionElement represents an <option> element
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLOptionElement
pub(all) struct HTMLOptionElement {
  mut value : String
  mut selected : Bool
}

///|
pub impl JsImpl for HTMLOptionElement

///|
pub impl EventTargetImpl for HTMLOptionElement

///|
pub impl NodeImpl for HTMLOptionElement

///|
pub impl ElementImpl for HTMLOptionElement

///|
pub impl HTMLElementImpl for HTMLOptionElement

///|
/// HTMLLabelElement represents a <label> element
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLLabelElement
pub(all) struct HTMLLabelElement {
  mut htmlFor : String
}

///|
pub impl JsImpl for HTMLLabelElement

///|
pub impl EventTargetImpl for HTMLLabelElement

///|
pub impl NodeImpl for HTMLLabelElement

///|
pub impl ElementImpl for HTMLLabelElement

///|
pub impl HTMLElementImpl for HTMLLabelElement

///|
/// HTMLImageElement represents an <img> element
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLImageElement
pub(all) struct HTMLImageElement {
  mut src : String
  mut alt : String
}

///|
pub impl JsImpl for HTMLImageElement

///|
pub impl EventTargetImpl for HTMLImageElement

///|
pub impl NodeImpl for HTMLImageElement

///|
pub impl ElementImpl for HTMLImageElement

///|
pub impl HTMLElementImpl for HTMLImageElement

///|
#external
pub type HTMLParagraphElement

///|
pub impl JsImpl for HTMLParagraphElement

///|
pub impl EventTargetImpl for HTMLParagraphElement

///|
pub impl NodeImpl for HTMLParagraphElement

///|
pub impl ElementImpl for HTMLParagraphElement

///|
pub impl HTMLElementImpl for HTMLParagraphElement

///|
#external
pub type HTMLHeadingElement

///|
pub impl JsImpl for HTMLHeadingElement

///|
pub impl EventTargetImpl for HTMLHeadingElement

///|
pub impl NodeImpl for HTMLHeadingElement

///|
pub impl ElementImpl for HTMLHeadingElement

///|
pub impl HTMLElementImpl for HTMLHeadingElement

///|
#external
pub type HTMLUListElement

///|
pub impl JsImpl for HTMLUListElement

///|
pub impl EventTargetImpl for HTMLUListElement

///|
pub impl NodeImpl for HTMLUListElement

///|
pub impl ElementImpl for HTMLUListElement

///|
pub impl HTMLElementImpl for HTMLUListElement

///|
#external
pub type HTMLOListElement

///|
pub impl JsImpl for HTMLOListElement

///|
pub impl EventTargetImpl for HTMLOListElement

///|
pub impl NodeImpl for HTMLOListElement

///|
pub impl ElementImpl for HTMLOListElement

///|
pub impl HTMLElementImpl for HTMLOListElement

///|
#external
pub type HTMLLIElement

///|
pub impl JsImpl for HTMLLIElement

///|
pub impl EventTargetImpl for HTMLLIElement

///|
pub impl NodeImpl for HTMLLIElement

///|
pub impl ElementImpl for HTMLLIElement

///|
pub impl HTMLElementImpl for HTMLLIElement
