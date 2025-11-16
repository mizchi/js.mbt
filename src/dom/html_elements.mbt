///|
#external
pub type HTMLDivElement

///|
pub impl Js for HTMLDivElement

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
pub impl Js for HTMLCanvasElement

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
  unsafe_cast(self.get("width"))
}

///|
pub fn HTMLCanvasElement::set_width(self : Self, value : Int) -> Unit {
  self.set("width", value)
}

///|
pub fn HTMLCanvasElement::height(self : Self) -> Int {
  unsafe_cast(self.get("height"))
}

///|
pub fn HTMLCanvasElement::set_height(self : Self, value : Int) -> Unit {
  self.set("height", value)
}

///|
/// Canvas methods
pub fn HTMLCanvasElement::get_context(
  self : Self,
  context_type : String,
) -> Val {
  self.invoke("getContext", [context_type])
}

///|
pub fn HTMLCanvasElement::to_data_url(
  self : Self,
  image_type? : String,
  quality? : Double,
) -> String {
  match (image_type, quality) {
    (Some(t), Some(q)) => self.invoke("toDataURL", [t, q]) |> unsafe_cast
    (Some(t), None) => self.invoke("toDataURL", [t]) |> unsafe_cast
    (None, _) => self.invoke("toDataURL", []) |> unsafe_cast
  }
}

///|
pub fn HTMLCanvasElement::to_blob(
  self : Self,
  image_type? : String,
  quality? : Double,
) -> Promise[Blob] {
  match (image_type, quality) {
    (Some(t), Some(q)) => self.invoke("toBlob", [t, q]) |> unsafe_cast
    (Some(t), None) => self.invoke("toBlob", [t]) |> unsafe_cast
    (None, _) => self.invoke("toBlob", []) |> unsafe_cast
  }
}

///|
#external
pub type HTMLBodyElement

///|
pub impl Js for HTMLBodyElement

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
pub impl Js for HTMLHeadElement

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
pub impl Js for HTMLHtmlElement

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
pub impl Js for HTMLSpanElement

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
pub impl Js for HTMLAnchorElement

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
  unsafe_cast(self.get("href"))
}

///|
/// Sets the href attribute
pub fn HTMLAnchorElement::set_href(self : Self, href : String) -> Unit {
  self.set("href", href)
}

///|
/// Returns the target attribute
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLAnchorElement/target
pub fn HTMLAnchorElement::target(self : Self) -> String {
  unsafe_cast(self.get("target"))
}

///|
/// Sets the target attribute
pub fn HTMLAnchorElement::set_target(self : Self, target : String) -> Unit {
  self.set("target", target)
}

///|
#external
pub type HTMLButtonElement

///|
pub impl Js for HTMLButtonElement

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
  unsafe_cast(self.get("disabled"))
}

///|
/// Sets whether the button is disabled
pub fn HTMLButtonElement::set_disabled(self : Self, disabled : Bool) -> Unit {
  self.set("disabled", disabled)
}

///|
#external
pub type HTMLInputElement

///|
pub impl Js for HTMLInputElement

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
  unsafe_cast(self.get("value"))
}

///|
/// Sets the value of the input
pub fn HTMLInputElement::set_value(self : Self, value : String) -> Unit {
  self.set("value", value)
}

///|
/// Returns the type of the input
pub fn HTMLInputElement::input_type(self : Self) -> String {
  unsafe_cast(self.get("type"))
}

///|
/// Sets the type of the input
pub fn HTMLInputElement::set_input_type(
  self : Self,
  input_type : String,
) -> Unit {
  self.set("type", input_type)
}

///|
/// Returns whether the input is disabled
pub fn HTMLInputElement::disabled(self : Self) -> Bool {
  unsafe_cast(self.get("disabled"))
}

///|
/// Sets whether the input is disabled
pub fn HTMLInputElement::set_disabled(self : Self, disabled : Bool) -> Unit {
  self.set("disabled", disabled)
}

///|
/// Returns whether the input is checked (for checkbox/radio)
pub fn HTMLInputElement::checked(self : Self) -> Bool {
  unsafe_cast(self.get("checked"))
}

///|
/// Sets whether the input is checked (for checkbox/radio)
pub fn HTMLInputElement::set_checked(self : Self, checked : Bool) -> Unit {
  self.set("checked", checked)
}

///|
/// Returns the placeholder text
pub fn HTMLInputElement::placeholder(self : Self) -> String {
  unsafe_cast(self.get("placeholder"))
}

///|
/// Sets the placeholder text
pub fn HTMLInputElement::set_placeholder(
  self : Self,
  placeholder : String,
) -> Unit {
  self.set("placeholder", placeholder)
}

///|
#external
pub type HTMLTextAreaElement

///|
pub impl Js for HTMLTextAreaElement

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
  unsafe_cast(self.get("value"))
}

///|
/// Sets the value of the textarea
pub fn HTMLTextAreaElement::set_value(self : Self, value : String) -> Unit {
  self.set("value", value)
}

///|
/// Returns the placeholder text
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLTextAreaElement/placeholder
pub fn HTMLTextAreaElement::placeholder(self : Self) -> String {
  unsafe_cast(self.get("placeholder"))
}

///|
/// Sets the placeholder text
pub fn HTMLTextAreaElement::set_placeholder(
  self : Self,
  placeholder : String,
) -> Unit {
  self.set("placeholder", placeholder)
}

///|
/// Returns whether the textarea is disabled
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLTextAreaElement/disabled
pub fn HTMLTextAreaElement::disabled(self : Self) -> Bool {
  unsafe_cast(self.get("disabled"))
}

///|
/// Sets whether the textarea is disabled
pub fn HTMLTextAreaElement::set_disabled(self : Self, disabled : Bool) -> Unit {
  self.set("disabled", disabled)
}

///|
/// Returns the number of visible text lines
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLTextAreaElement/rows
pub fn HTMLTextAreaElement::rows(self : Self) -> Int {
  unsafe_cast(self.get("rows"))
}

///|
/// Sets the number of visible text lines
pub fn HTMLTextAreaElement::set_rows(self : Self, rows : Int) -> Unit {
  self.set("rows", rows)
}

///|
/// Returns the visible width of the text control
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLTextAreaElement/cols
pub fn HTMLTextAreaElement::cols(self : Self) -> Int {
  unsafe_cast(self.get("cols"))
}

///|
/// Sets the visible width of the text control
pub fn HTMLTextAreaElement::set_cols(self : Self, cols : Int) -> Unit {
  self.set("cols", cols)
}

///|
/// Returns whether the textarea is read-only
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLTextAreaElement/readOnly
pub fn HTMLTextAreaElement::read_only(self : Self) -> Bool {
  unsafe_cast(self.get("readOnly"))
}

///|
/// Sets whether the textarea is read-only
pub fn HTMLTextAreaElement::set_read_only(
  self : Self,
  read_only : Bool,
) -> Unit {
  self.set("readOnly", read_only)
}

///|
#external
pub type HTMLIFrameElement

///|
pub impl Js for HTMLIFrameElement

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
  unsafe_cast(self.get("src"))
}

///|
/// Sets the src attribute
pub fn HTMLIFrameElement::set_src(self : Self, src : String) -> Unit {
  self.set("src", src)
}

///|
/// Returns the content window
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLIFrameElement/contentWindow
pub fn HTMLIFrameElement::content_window(self : Self) -> Window? {
  self.get("contentWindow") |> to_option()
}

///|
/// Returns the content document
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLIFrameElement/contentDocument
pub fn HTMLIFrameElement::content_document(self : Self) -> Document? {
  self.get("contentDocument") |> to_option()
}

///|
/// Returns the width attribute
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLIFrameElement/width
pub fn HTMLIFrameElement::width(self : Self) -> String {
  unsafe_cast(self.get("width"))
}

///|
/// Sets the width attribute
pub fn HTMLIFrameElement::set_width(self : Self, width : String) -> Unit {
  self.set("width", width)
}

///|
/// Returns the height attribute
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLIFrameElement/height
pub fn HTMLIFrameElement::height(self : Self) -> String {
  unsafe_cast(self.get("height"))
}

///|
/// Sets the height attribute
pub fn HTMLIFrameElement::set_height(self : Self, height : String) -> Unit {
  self.set("height", height)
}

///|
/// Returns the name attribute
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLIFrameElement/name
pub fn HTMLIFrameElement::name(self : Self) -> String {
  unsafe_cast(self.get("name"))
}

///|
/// Sets the name attribute
pub fn HTMLIFrameElement::set_name(self : Self, name : String) -> Unit {
  self.set("name", name)
}

///|
/// Returns the sandbox attribute
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLIFrameElement/sandbox
pub fn HTMLIFrameElement::sandbox(self : Self) -> String {
  unsafe_cast(self.get("sandbox"))
}

///|
/// Sets the sandbox attribute
pub fn HTMLIFrameElement::set_sandbox(self : Self, sandbox : String) -> Unit {
  self.set("sandbox", sandbox)
}
