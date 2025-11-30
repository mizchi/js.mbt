///|
#external
pub type HTMLDivElement

///|
pub fn HTMLDivElement::as_any(self : HTMLDivElement) -> @nostd.Any = "%identity"

///|
pub fn HTMLDivElement::as_event_target(
  self : HTMLDivElement,
) -> @event.EventTarget = "%identity"

///|
pub fn HTMLDivElement::as_node(self : HTMLDivElement) -> Node = "%identity"

///|
pub fn HTMLDivElement::as_element(self : HTMLDivElement) -> Element = "%identity"

///|
pub fn HTMLDivElement::as_html_element(self : HTMLDivElement) -> HTMLElement = "%identity"

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
pub fn HTMLCanvasElement::as_any(self : HTMLCanvasElement) -> @nostd.Any = "%identity"

///|
pub fn HTMLCanvasElement::as_event_target(
  self : HTMLCanvasElement,
) -> @event.EventTarget = "%identity"

///|
pub fn HTMLCanvasElement::as_node(self : HTMLCanvasElement) -> Node = "%identity"

///|
pub fn HTMLCanvasElement::as_element(self : HTMLCanvasElement) -> Element = "%identity"

///|
pub fn HTMLCanvasElement::as_html_element(
  self : HTMLCanvasElement,
) -> HTMLElement = "%identity"

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
pub fn HTMLBodyElement::as_event_target(
  self : HTMLBodyElement,
) -> @event.EventTarget = "%identity"

///|
pub fn HTMLBodyElement::as_node(self : HTMLBodyElement) -> Node = "%identity"

///|
pub fn HTMLBodyElement::as_element(self : HTMLBodyElement) -> Element = "%identity"

///|
pub fn HTMLBodyElement::as_html_element(self : HTMLBodyElement) -> HTMLElement = "%identity"

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
pub fn HTMLHeadElement::as_event_target(
  self : HTMLHeadElement,
) -> @event.EventTarget = "%identity"

///|
pub fn HTMLHeadElement::as_node(self : HTMLHeadElement) -> Node = "%identity"

///|
pub fn HTMLHeadElement::as_element(self : HTMLHeadElement) -> Element = "%identity"

///|
pub fn HTMLHeadElement::as_html_element(self : HTMLHeadElement) -> HTMLElement = "%identity"

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
pub fn HTMLHtmlElement::as_event_target(
  self : HTMLHtmlElement,
) -> @event.EventTarget = "%identity"

///|
pub fn HTMLHtmlElement::as_node(self : HTMLHtmlElement) -> Node = "%identity"

///|
pub fn HTMLHtmlElement::as_element(self : HTMLHtmlElement) -> Element = "%identity"

///|
pub fn HTMLHtmlElement::as_html_element(self : HTMLHtmlElement) -> HTMLElement = "%identity"

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
pub fn HTMLSpanElement::as_event_target(
  self : HTMLSpanElement,
) -> @event.EventTarget = "%identity"

///|
pub fn HTMLSpanElement::as_node(self : HTMLSpanElement) -> Node = "%identity"

///|
pub fn HTMLSpanElement::as_element(self : HTMLSpanElement) -> Element = "%identity"

///|
pub fn HTMLSpanElement::as_html_element(self : HTMLSpanElement) -> HTMLElement = "%identity"

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
pub fn HTMLAnchorElement::as_any(self : HTMLAnchorElement) -> @nostd.Any = "%identity"

///|
pub fn HTMLAnchorElement::as_event_target(
  self : HTMLAnchorElement,
) -> @event.EventTarget = "%identity"

///|
pub fn HTMLAnchorElement::as_node(self : HTMLAnchorElement) -> Node = "%identity"

///|
pub fn HTMLAnchorElement::as_element(self : HTMLAnchorElement) -> Element = "%identity"

///|
pub fn HTMLAnchorElement::as_html_element(
  self : HTMLAnchorElement,
) -> HTMLElement = "%identity"

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
pub fn HTMLButtonElement::as_any(self : HTMLButtonElement) -> @nostd.Any = "%identity"

///|
pub fn HTMLButtonElement::as_event_target(
  self : HTMLButtonElement,
) -> @event.EventTarget = "%identity"

///|
pub fn HTMLButtonElement::as_node(self : HTMLButtonElement) -> Node = "%identity"

///|
pub fn HTMLButtonElement::as_element(self : HTMLButtonElement) -> Element = "%identity"

///|
pub fn HTMLButtonElement::as_html_element(
  self : HTMLButtonElement,
) -> HTMLElement = "%identity"

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
pub fn HTMLInputElement::as_any(self : HTMLInputElement) -> @nostd.Any = "%identity"

///|
pub fn HTMLInputElement::as_event_target(
  self : HTMLInputElement,
) -> @event.EventTarget = "%identity"

///|
pub fn HTMLInputElement::as_node(self : HTMLInputElement) -> Node = "%identity"

///|
pub fn HTMLInputElement::as_element(self : HTMLInputElement) -> Element = "%identity"

///|
pub fn HTMLInputElement::as_html_element(
  self : HTMLInputElement,
) -> HTMLElement = "%identity"

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
pub fn HTMLTextAreaElement::as_any(self : HTMLTextAreaElement) -> @nostd.Any = "%identity"

///|
pub fn HTMLTextAreaElement::as_event_target(
  self : HTMLTextAreaElement,
) -> @event.EventTarget = "%identity"

///|
pub fn HTMLTextAreaElement::as_node(self : HTMLTextAreaElement) -> Node = "%identity"

///|
pub fn HTMLTextAreaElement::as_element(self : HTMLTextAreaElement) -> Element = "%identity"

///|
pub fn HTMLTextAreaElement::as_html_element(
  self : HTMLTextAreaElement,
) -> HTMLElement = "%identity"

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
pub fn HTMLIFrameElement::as_any(self : HTMLIFrameElement) -> @nostd.Any = "%identity"

///|
pub fn HTMLIFrameElement::as_event_target(
  self : HTMLIFrameElement,
) -> @event.EventTarget = "%identity"

///|
pub fn HTMLIFrameElement::as_node(self : HTMLIFrameElement) -> Node = "%identity"

///|
pub fn HTMLIFrameElement::as_element(self : HTMLIFrameElement) -> Element = "%identity"

///|
pub fn HTMLIFrameElement::as_html_element(
  self : HTMLIFrameElement,
) -> HTMLElement = "%identity"

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
pub fn HTMLFormElement::as_event_target(
  self : HTMLFormElement,
) -> @event.EventTarget = "%identity"

///|
pub fn HTMLFormElement::as_node(self : HTMLFormElement) -> Node = "%identity"

///|
pub fn HTMLFormElement::as_element(self : HTMLFormElement) -> Element = "%identity"

///|
pub fn HTMLFormElement::as_html_element(self : HTMLFormElement) -> HTMLElement = "%identity"

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
pub fn HTMLSelectElement::as_any(self : HTMLSelectElement) -> @nostd.Any = "%identity"

///|
pub fn HTMLSelectElement::as_event_target(
  self : HTMLSelectElement,
) -> @event.EventTarget = "%identity"

///|
pub fn HTMLSelectElement::as_node(self : HTMLSelectElement) -> Node = "%identity"

///|
pub fn HTMLSelectElement::as_element(self : HTMLSelectElement) -> Element = "%identity"

///|
pub fn HTMLSelectElement::as_html_element(
  self : HTMLSelectElement,
) -> HTMLElement = "%identity"

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
pub fn HTMLOptionElement::as_any(self : HTMLOptionElement) -> @nostd.Any = "%identity"

///|
pub fn HTMLOptionElement::as_event_target(
  self : HTMLOptionElement,
) -> @event.EventTarget = "%identity"

///|
pub fn HTMLOptionElement::as_node(self : HTMLOptionElement) -> Node = "%identity"

///|
pub fn HTMLOptionElement::as_element(self : HTMLOptionElement) -> Element = "%identity"

///|
pub fn HTMLOptionElement::as_html_element(
  self : HTMLOptionElement,
) -> HTMLElement = "%identity"

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
pub fn HTMLLabelElement::as_any(self : HTMLLabelElement) -> @nostd.Any = "%identity"

///|
pub fn HTMLLabelElement::as_event_target(
  self : HTMLLabelElement,
) -> @event.EventTarget = "%identity"

///|
pub fn HTMLLabelElement::as_node(self : HTMLLabelElement) -> Node = "%identity"

///|
pub fn HTMLLabelElement::as_element(self : HTMLLabelElement) -> Element = "%identity"

///|
pub fn HTMLLabelElement::as_html_element(
  self : HTMLLabelElement,
) -> HTMLElement = "%identity"

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
pub fn HTMLImageElement::as_any(self : HTMLImageElement) -> @nostd.Any = "%identity"

///|
pub fn HTMLImageElement::as_event_target(
  self : HTMLImageElement,
) -> @event.EventTarget = "%identity"

///|
pub fn HTMLImageElement::as_node(self : HTMLImageElement) -> Node = "%identity"

///|
pub fn HTMLImageElement::as_element(self : HTMLImageElement) -> Element = "%identity"

///|
pub fn HTMLImageElement::as_html_element(
  self : HTMLImageElement,
) -> HTMLElement = "%identity"

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
pub fn HTMLParagraphElement::as_event_target(
  self : HTMLParagraphElement,
) -> @event.EventTarget = "%identity"

///|
pub fn HTMLParagraphElement::as_node(self : HTMLParagraphElement) -> Node = "%identity"

///|
pub fn HTMLParagraphElement::as_element(self : HTMLParagraphElement) -> Element = "%identity"

///|
pub fn HTMLParagraphElement::as_html_element(
  self : HTMLParagraphElement,
) -> HTMLElement = "%identity"

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
pub fn HTMLHeadingElement::as_event_target(
  self : HTMLHeadingElement,
) -> @event.EventTarget = "%identity"

///|
pub fn HTMLHeadingElement::as_node(self : HTMLHeadingElement) -> Node = "%identity"

///|
pub fn HTMLHeadingElement::as_element(self : HTMLHeadingElement) -> Element = "%identity"

///|
pub fn HTMLHeadingElement::as_html_element(
  self : HTMLHeadingElement,
) -> HTMLElement = "%identity"

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
pub fn HTMLUListElement::as_event_target(
  self : HTMLUListElement,
) -> @event.EventTarget = "%identity"

///|
pub fn HTMLUListElement::as_node(self : HTMLUListElement) -> Node = "%identity"

///|
pub fn HTMLUListElement::as_element(self : HTMLUListElement) -> Element = "%identity"

///|
pub fn HTMLUListElement::as_html_element(
  self : HTMLUListElement,
) -> HTMLElement = "%identity"

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
pub fn HTMLOListElement::as_event_target(
  self : HTMLOListElement,
) -> @event.EventTarget = "%identity"

///|
pub fn HTMLOListElement::as_node(self : HTMLOListElement) -> Node = "%identity"

///|
pub fn HTMLOListElement::as_element(self : HTMLOListElement) -> Element = "%identity"

///|
pub fn HTMLOListElement::as_html_element(
  self : HTMLOListElement,
) -> HTMLElement = "%identity"

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
pub fn HTMLLIElement::as_event_target(
  self : HTMLLIElement,
) -> @event.EventTarget = "%identity"

///|
pub fn HTMLLIElement::as_node(self : HTMLLIElement) -> Node = "%identity"

///|
pub fn HTMLLIElement::as_element(self : HTMLLIElement) -> Element = "%identity"

///|
pub fn HTMLLIElement::as_html_element(self : HTMLLIElement) -> HTMLElement = "%identity"

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
