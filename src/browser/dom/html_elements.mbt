///|
#external
pub type HTMLDivElement

///|
pub fn HTMLDivElement::as_any(self : HTMLDivElement) -> @core.Any = "%identity"

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

///|

///|

///|

///|

///|
/// HTMLCanvasElement represents a <canvas> element
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLCanvasElement
pub(all) struct HTMLCanvasElement {
  mut width : Int
  mut height : Int
} derive(Show)

///|
pub fn HTMLCanvasElement::as_any(self : HTMLCanvasElement) -> @core.Any = "%identity"

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

///|

///|

///|

///|

///|
/// Canvas methods
pub fn HTMLCanvasElement::getContext(
  self : Self,
  context_type : String,
) -> @core.Any {
  self.as_any()._call("getContext", [@core.any(context_type)]).cast()
}

///|
pub fn HTMLCanvasElement::toDataURL(
  self : Self,
  image_type? : String,
  quality? : Double,
) -> String {
  match (image_type, quality) {
    (Some(t), Some(q)) =>
      self.as_any()._call("toDataURL", [@core.any(t), @core.any(q)]).cast()
    (Some(t), None) => self.as_any()._call("toDataURL", [@core.any(t)]).cast()
    (None, _) => self.as_any()._call("toDataURL", []).cast()
  }
}

///|
pub async fn HTMLCanvasElement::toBlob(
  self : Self,
  image_type? : String,
  quality? : Double,
) -> @blob.Blob {
  let promise : @js.Promise[@blob.Blob] = match (image_type, quality) {
    (Some(t), Some(q)) =>
      self.as_any()._call("toBlob", [@core.any(t), @core.any(q)]).cast()
    (Some(t), None) => self.as_any()._call("toBlob", [@core.any(t)]).cast()
    (None, _) => self.as_any()._call("toBlob", []).cast()
  }
  promise.wait()
}

///|
#external
pub type HTMLBodyElement

///|
pub fn HTMLBodyElement::as_any(self : HTMLBodyElement) -> @core.Any = "%identity"

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

///|

///|

///|

///|

///|
#external
pub type HTMLHeadElement

///|
pub fn HTMLHeadElement::as_any(self : HTMLHeadElement) -> @core.Any = "%identity"

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

///|

///|

///|

///|

///|
#external
pub type HTMLHtmlElement

///|
pub fn HTMLHtmlElement::as_any(self : HTMLHtmlElement) -> @core.Any = "%identity"

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

///|

///|

///|

///|

///|
#external
pub type HTMLSpanElement

///|
pub fn HTMLSpanElement::as_any(self : HTMLSpanElement) -> @core.Any = "%identity"

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

///|

///|

///|

///|

///|
/// HTMLAnchorElement represents an <a> element
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLAnchorElement
pub(all) struct HTMLAnchorElement {
  mut href : String
  mut target : String
}

///|
pub fn HTMLAnchorElement::as_any(self : HTMLAnchorElement) -> @core.Any = "%identity"

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

///|

///|

///|

///|

///|
/// HTMLButtonElement represents a <button> element
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLButtonElement
pub(all) struct HTMLButtonElement {
  mut disabled : Bool
}

///|
pub fn HTMLButtonElement::as_any(self : HTMLButtonElement) -> @core.Any = "%identity"

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

///|

///|

///|

///|

///|
// #external
pub(all) struct HTMLInputElement {
  mut disabled : Bool
  mut value : String
  mut placeholder : String
  mut checked : Bool
}

///|
pub fn HTMLInputElement::as_any(self : HTMLInputElement) -> @core.Any = "%identity"

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

///|

///|

///|

///|

///|
/// Returns the type of the input
pub fn HTMLInputElement::type_(self : Self) -> String {
  self.as_any()._get("type").cast()
}

///|
/// Sets the type of the input
pub fn HTMLInputElement::setType(self : Self, input_type : String) -> Unit {
  self.as_any()._set("type", @core.any(input_type)) |> ignore
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
pub fn HTMLTextAreaElement::as_any(self : HTMLTextAreaElement) -> @core.Any = "%identity"

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

///|

///|

///|

///|

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
pub fn HTMLIFrameElement::as_any(self : HTMLIFrameElement) -> @core.Any = "%identity"

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

///|

///|

///|

///|

///|
/// Returns the content window
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLIFrameElement/contentWindow
pub fn HTMLIFrameElement::contentWindow(self : Self) -> Window? {
  let v : @core.Any = self.as_any()._get("contentWindow").cast()
  v |> @core.identity_option
}

///|
/// Returns the content document
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLIFrameElement/contentDocument
pub fn HTMLIFrameElement::contentDocument(self : Self) -> Document? {
  let v : @core.Any = self.as_any()._get("contentDocument").cast()
  v |> @core.identity_option
}

///|
#external
pub type HTMLFormElement

///|
pub fn HTMLFormElement::as_any(self : HTMLFormElement) -> @core.Any = "%identity"

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

///|

///|

///|

///|

///|
/// HTMLSelectElement represents a <select> element
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLSelectElement
pub(all) struct HTMLSelectElement {
  mut value : String
  mut disabled : Bool
}

///|
pub fn HTMLSelectElement::as_any(self : HTMLSelectElement) -> @core.Any = "%identity"

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

///|

///|

///|

///|

///|
/// HTMLOptionElement represents an <option> element
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLOptionElement
pub(all) struct HTMLOptionElement {
  mut value : String
  mut selected : Bool
}

///|
pub fn HTMLOptionElement::as_any(self : HTMLOptionElement) -> @core.Any = "%identity"

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

///|

///|

///|

///|

///|
/// HTMLLabelElement represents a <label> element
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLLabelElement
pub(all) struct HTMLLabelElement {
  mut htmlFor : String
}

///|
pub fn HTMLLabelElement::as_any(self : HTMLLabelElement) -> @core.Any = "%identity"

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

///|

///|

///|

///|

///|
/// HTMLImageElement represents an <img> element
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLImageElement
pub(all) struct HTMLImageElement {
  mut src : String
  mut alt : String
}

///|
pub fn HTMLImageElement::as_any(self : HTMLImageElement) -> @core.Any = "%identity"

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

///|

///|

///|

///|

///|
#external
pub type HTMLParagraphElement

///|
pub fn HTMLParagraphElement::as_any(self : HTMLParagraphElement) -> @core.Any = "%identity"

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

///|

///|

///|

///|

///|
#external
pub type HTMLHeadingElement

///|
pub fn HTMLHeadingElement::as_any(self : HTMLHeadingElement) -> @core.Any = "%identity"

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

///|

///|

///|

///|

///|
#external
pub type HTMLUListElement

///|
pub fn HTMLUListElement::as_any(self : HTMLUListElement) -> @core.Any = "%identity"

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

///|

///|

///|

///|

///|
#external
pub type HTMLOListElement

///|
pub fn HTMLOListElement::as_any(self : HTMLOListElement) -> @core.Any = "%identity"

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

///|

///|

///|

///|

///|
#external
pub type HTMLLIElement

///|
pub fn HTMLLIElement::as_any(self : HTMLLIElement) -> @core.Any = "%identity"

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
