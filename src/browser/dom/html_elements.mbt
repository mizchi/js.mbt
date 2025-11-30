///|
#external
pub type HTMLDivElement

///|
pub fn HTMLDivElement::as_any(self : HTMLDivElement) -> @nostd.Any = "%identity"

///|
pub impl @js.JsImpl for HTMLDivElement

///|
pub impl @event.EventTargetImpl for HTMLDivElement

///|
pub impl NodeImpl for HTMLDivElement

///|
pub impl ElementImpl for HTMLDivElement

///|
pub impl HTMLElementImpl for HTMLDivElement

///|
/// HTMLCanvasElement represents a <canvas> element
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLCanvasElement
pub(all) struct HTMLCanvasElement {
  mut width : Int
  mut height : Int
} derive(Show)

///|
pub impl @js.JsImpl for HTMLCanvasElement

///|
pub impl @event.EventTargetImpl for HTMLCanvasElement

///|
pub impl NodeImpl for HTMLCanvasElement

///|
pub impl ElementImpl for HTMLCanvasElement

///|
pub impl HTMLElementImpl for HTMLCanvasElement

///|
/// Canvas methods
pub fn HTMLCanvasElement::getContext(
  self : Self,
  context_type : String,
) -> @js.Any {
  self.call("getContext", [context_type])
}

///|
pub fn HTMLCanvasElement::toDataURL(
  self : Self,
  image_type? : String,
  quality? : Double,
) -> String {
  match (image_type, quality) {
    (Some(t), Some(q)) => self.call2("toDataURL", t, q).cast()
    (Some(t), None) => self.call("toDataURL", [t]).cast()
    (None, _) => self.call0("toDataURL").cast()
  }
}

///|
pub async fn HTMLCanvasElement::toBlob(
  self : Self,
  image_type? : String,
  quality? : Double,
) -> @blob.Blob {
  let promise : @js.Promise[@blob.Blob] = match (image_type, quality) {
    (Some(t), Some(q)) => self.call2("toBlob", t, q).cast()
    (Some(t), None) => self.call("toBlob", [t]).cast()
    (None, _) => self.call0("toBlob").cast()
  }
  promise.wait()
}

///|
#external
pub type HTMLBodyElement

///|
pub fn HTMLBodyElement::as_any(self : HTMLBodyElement) -> @nostd.Any = "%identity"

///|
pub impl @js.JsImpl for HTMLBodyElement

///|
pub impl @event.EventTargetImpl for HTMLBodyElement

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
pub fn HTMLHeadElement::as_any(self : HTMLHeadElement) -> @nostd.Any = "%identity"

///|
pub impl @js.JsImpl for HTMLHeadElement

///|
pub impl @event.EventTargetImpl for HTMLHeadElement

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
pub fn HTMLHtmlElement::as_any(self : HTMLHtmlElement) -> @nostd.Any = "%identity"

///|
pub impl @js.JsImpl for HTMLHtmlElement

///|
pub impl @event.EventTargetImpl for HTMLHtmlElement

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
pub fn HTMLSpanElement::as_any(self : HTMLSpanElement) -> @nostd.Any = "%identity"

///|
pub impl @js.JsImpl for HTMLSpanElement

///|
pub impl @event.EventTargetImpl for HTMLSpanElement

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
pub impl @js.JsImpl for HTMLAnchorElement

///|
pub impl @event.EventTargetImpl for HTMLAnchorElement

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
pub impl @js.JsImpl for HTMLButtonElement

///|
pub impl @event.EventTargetImpl for HTMLButtonElement

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
pub impl @js.JsImpl for HTMLInputElement

///|
pub impl @event.EventTargetImpl for HTMLInputElement

///|
pub impl NodeImpl for HTMLInputElement

///|
pub impl ElementImpl for HTMLInputElement

///|
pub impl HTMLElementImpl for HTMLInputElement

///|
/// Returns the type of the input
pub fn HTMLInputElement::type_(self : Self) -> String {
  self.get("type").cast()
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
pub impl @js.JsImpl for HTMLTextAreaElement

///|
pub impl @event.EventTargetImpl for HTMLTextAreaElement

///|
pub impl NodeImpl for HTMLTextAreaElement

///|
pub impl ElementImpl for HTMLTextAreaElement

///|
pub impl HTMLElementImpl for HTMLTextAreaElement

///|
/// HTMLIFrameElement represents an <iframe> element
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLIFrameElement
pub(all) struct HTMLIFrameElement {
  mut src : String
  mut sandbox : String
  mut width : String
  mut height : String
  mut name : String
} derive(Show)

///|
pub impl @js.JsImpl for HTMLIFrameElement

///|
pub impl @event.EventTargetImpl for HTMLIFrameElement

///|
pub impl NodeImpl for HTMLIFrameElement

///|
pub impl ElementImpl for HTMLIFrameElement

///|
pub impl HTMLElementImpl for HTMLIFrameElement

///|
/// Returns the content window
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLIFrameElement/contentWindow
pub fn HTMLIFrameElement::contentWindow(self : Self) -> Window? {
  self.get("contentWindow").cast() |> @js.identity_option
}

///|
/// Returns the content document
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLIFrameElement/contentDocument
pub fn HTMLIFrameElement::contentDocument(self : Self) -> Document? {
  self.get("contentDocument").cast() |> @js.identity_option
}

///|
#external
pub type HTMLFormElement

///|
pub fn HTMLFormElement::as_any(self : HTMLFormElement) -> @nostd.Any = "%identity"

///|
pub impl @js.JsImpl for HTMLFormElement

///|
pub impl @event.EventTargetImpl for HTMLFormElement

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
pub impl @js.JsImpl for HTMLSelectElement

///|
pub impl @event.EventTargetImpl for HTMLSelectElement

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
pub impl @js.JsImpl for HTMLOptionElement

///|
pub impl @event.EventTargetImpl for HTMLOptionElement

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
pub impl @js.JsImpl for HTMLLabelElement

///|
pub impl @event.EventTargetImpl for HTMLLabelElement

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
pub impl @js.JsImpl for HTMLImageElement

///|
pub impl @event.EventTargetImpl for HTMLImageElement

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
pub fn HTMLParagraphElement::as_any(self : HTMLParagraphElement) -> @nostd.Any = "%identity"

///|
pub impl @js.JsImpl for HTMLParagraphElement

///|
pub impl @event.EventTargetImpl for HTMLParagraphElement

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
pub fn HTMLHeadingElement::as_any(self : HTMLHeadingElement) -> @nostd.Any = "%identity"

///|
pub impl @js.JsImpl for HTMLHeadingElement

///|
pub impl @event.EventTargetImpl for HTMLHeadingElement

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
pub fn HTMLUListElement::as_any(self : HTMLUListElement) -> @nostd.Any = "%identity"

///|
pub impl @js.JsImpl for HTMLUListElement

///|
pub impl @event.EventTargetImpl for HTMLUListElement

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
pub fn HTMLOListElement::as_any(self : HTMLOListElement) -> @nostd.Any = "%identity"

///|
pub impl @js.JsImpl for HTMLOListElement

///|
pub impl @event.EventTargetImpl for HTMLOListElement

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
pub fn HTMLLIElement::as_any(self : HTMLLIElement) -> @nostd.Any = "%identity"

///|
pub impl @js.JsImpl for HTMLLIElement

///|
pub impl @event.EventTargetImpl for HTMLLIElement

///|
pub impl NodeImpl for HTMLLIElement

///|
pub impl ElementImpl for HTMLLIElement

///|
pub impl HTMLElementImpl for HTMLLIElement
