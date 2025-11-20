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
#external
pub type HTMLAnchorElement

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
/// Returns the href attribute
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLAnchorElement/href
pub fn HTMLAnchorElement::href(self : Self) -> String {
  self.get("href") |> unsafe_cast
}

///|
/// Sets the href attribute
pub fn HTMLAnchorElement::setHref(self : Self, href : String) -> Unit {
  self.set("href", href)
}

///|
/// Returns the target attribute
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLAnchorElement/target
pub fn HTMLAnchorElement::target(self : Self) -> String {
  self.get("target") |> unsafe_cast
}

///|
/// Sets the target attribute
pub fn HTMLAnchorElement::setTarget(self : Self, target : String) -> Unit {
  self.set("target", target)
}

///|
#external
pub type HTMLButtonElement

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
/// Returns whether the button is disabled
pub fn HTMLButtonElement::disabled(self : Self) -> Bool {
  self.get("disabled") |> unsafe_cast
}

///|
/// Sets whether the button is disabled
pub fn HTMLButtonElement::setDisabled(self : Self, disabled : Bool) -> Unit {
  self.set("disabled", disabled)
}

///|
#external
pub type HTMLInputElement

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
/// Returns the value of the input
pub fn HTMLInputElement::value(self : Self) -> String {
  self.get("value") |> unsafe_cast
}

///|
/// Sets the value of the input
pub fn HTMLInputElement::setValue(self : Self, value : String) -> Unit {
  self.set("value", value)
}

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
/// Returns whether the input is disabled
pub fn HTMLInputElement::disabled(self : Self) -> Bool {
  self.get("disabled") |> unsafe_cast
}

///|
/// Sets whether the input is disabled
pub fn HTMLInputElement::setDisabled(self : Self, disabled : Bool) -> Unit {
  self.set("disabled", disabled)
}

///|
/// Returns whether the input is checked (for checkbox/radio)
pub fn HTMLInputElement::checked(self : Self) -> Bool {
  self.get("checked") |> unsafe_cast
}

///|
/// Sets whether the input is checked (for checkbox/radio)
pub fn HTMLInputElement::setChecked(self : Self, checked : Bool) -> Unit {
  self.set("checked", checked)
}

///|
/// Returns the placeholder text
pub fn HTMLInputElement::placeholder(self : Self) -> String {
  self.get("placeholder") |> unsafe_cast
}

///|
/// Sets the placeholder text
pub fn HTMLInputElement::setPlaceholder(
  self : Self,
  placeholder : String,
) -> Unit {
  self.set("placeholder", placeholder)
}

///|
#external
pub type HTMLTextAreaElement

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
/// Returns the value of the textarea
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLTextAreaElement/value
pub fn HTMLTextAreaElement::value(self : Self) -> String {
  self.get("value") |> unsafe_cast
}

///|
/// Sets the value of the textarea
pub fn HTMLTextAreaElement::setValue(self : Self, value : String) -> Unit {
  self.set("value", value)
}

///|
/// Returns the placeholder text
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLTextAreaElement/placeholder
pub fn HTMLTextAreaElement::placeholder(self : Self) -> String {
  self.get("placeholder") |> unsafe_cast
}

///|
/// Sets the placeholder text
pub fn HTMLTextAreaElement::setPlaceholder(
  self : Self,
  placeholder : String,
) -> Unit {
  self.set("placeholder", placeholder)
}

///|
/// Returns whether the textarea is disabled
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLTextAreaElement/disabled
pub fn HTMLTextAreaElement::disabled(self : Self) -> Bool {
  self.get("disabled") |> unsafe_cast
}

///|
/// Sets whether the textarea is disabled
pub fn HTMLTextAreaElement::setDisabled(self : Self, disabled : Bool) -> Unit {
  self.set("disabled", disabled)
}

///|
/// Returns the number of visible text lines
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLTextAreaElement/rows
pub fn HTMLTextAreaElement::rows(self : Self) -> Int {
  self.get("rows") |> unsafe_cast
}

///|
/// Sets the number of visible text lines
pub fn HTMLTextAreaElement::setRows(self : Self, rows : Int) -> Unit {
  self.set("rows", rows)
}

///|
/// Returns the visible width of the text control
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLTextAreaElement/cols
pub fn HTMLTextAreaElement::cols(self : Self) -> Int {
  self.get("cols") |> unsafe_cast
}

///|
/// Sets the visible width of the text control
pub fn HTMLTextAreaElement::setCols(self : Self, cols : Int) -> Unit {
  self.set("cols", cols)
}

///|
/// Returns whether the textarea is read-only
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLTextAreaElement/readOnly
pub fn HTMLTextAreaElement::readOnly(self : Self) -> Bool {
  self.get("readOnly") |> unsafe_cast
}

///|
/// Sets whether the textarea is read-only
pub fn HTMLTextAreaElement::setReadOnly(self : Self, read_only : Bool) -> Unit {
  self.set("readOnly", read_only)
}

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
#external
pub type HTMLSelectElement

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
/// Returns the value of the select element
pub fn HTMLSelectElement::value(self : Self) -> String {
  self.get("value") |> unsafe_cast
}

///|
/// Sets the value of the select element
pub fn HTMLSelectElement::setValue(self : Self, value : String) -> Unit {
  self.set("value", value)
}

///|
/// Returns whether the select is disabled
pub fn HTMLSelectElement::disabled(self : Self) -> Bool {
  self.get("disabled") |> unsafe_cast
}

///|
/// Sets whether the select is disabled
pub fn HTMLSelectElement::setDisabled(self : Self, disabled : Bool) -> Unit {
  self.set("disabled", disabled)
}

///|
#external
pub type HTMLOptionElement

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
/// Returns the value of the option
pub fn HTMLOptionElement::value(self : Self) -> String {
  self.get("value") |> unsafe_cast
}

///|
/// Sets the value of the option
pub fn HTMLOptionElement::setValue(self : Self, value : String) -> Unit {
  self.set("value", value)
}

///|
/// Returns whether the option is selected
pub fn HTMLOptionElement::selected(self : Self) -> Bool {
  self.get("selected") |> unsafe_cast
}

///|
/// Sets whether the option is selected
pub fn HTMLOptionElement::setSelected(self : Self, selected : Bool) -> Unit {
  self.set("selected", selected)
}

///|
#external
pub type HTMLLabelElement

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
/// Returns the htmlFor attribute (references an input id)
pub fn HTMLLabelElement::htmlFor(self : Self) -> String {
  self.get("htmlFor") |> unsafe_cast
}

///|
/// Sets the htmlFor attribute
pub fn HTMLLabelElement::setHtmlFor(self : Self, html_for : String) -> Unit {
  self.set("htmlFor", html_for)
}

///|
#external
pub type HTMLImageElement

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
/// Returns the src attribute
pub fn HTMLImageElement::src(self : Self) -> String {
  self.get("src") |> unsafe_cast
}

///|
/// Sets the src attribute
pub fn HTMLImageElement::setSrc(self : Self, src : String) -> Unit {
  self.set("src", src)
}

///|
/// Returns the alt attribute
pub fn HTMLImageElement::alt(self : Self) -> String {
  self.get("alt") |> unsafe_cast
}

///|
/// Sets the alt attribute
pub fn HTMLImageElement::setAlt(self : Self, alt : String) -> Unit {
  self.set("alt", alt)
}

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
