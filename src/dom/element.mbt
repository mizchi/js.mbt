///|
/// DOM trait hierarchy following TypeScript/Web IDL standards
/// EventTarget_ -> Node_ -> Element_ -> HTMLElement_

///|
/// EventTarget_ trait - base interface for objects that can receive events
pub(open) trait EventTargetImpl: Js {
  add_event_listener(Self, String, (Event) -> Unit) -> Unit = _
  remove_event_listener(Self, String, (Event) -> Unit) -> Unit = _
  dispatch_event(Self, Event) -> Bool = _
}

///|
impl EventTargetImpl with add_event_listener(self, event_type, handler) -> Unit {
  ignore(self.invoke("addEventListener", [event_type, @js.js(handler)]))
}

///|
impl EventTargetImpl with remove_event_listener(self, event_type, handler) -> Unit {
  ignore(self.invoke("removeEventListener", [event_type, @js.js(handler)]))
}

///|
impl EventTargetImpl with dispatch_event(self, event) -> Bool {
  self.invoke("dispatchEvent", [event]) |> unsafe_cast
}

///|
/// Node_ trait - base interface for DOM tree nodes
pub(open) trait NodeImpl: Js + EventTargetImpl {
  node_type(Self) -> Int = _
  node_name(Self) -> String = _
  parent_node(Self) -> Node? = _
  child_nodes(Self) -> Array[Node] = _
  first_child(Self) -> Node? = _
  last_child(Self) -> Node? = _
  previous_sibling(Self) -> Node? = _
  next_sibling(Self) -> Node? = _
  append_child(Self, Node) -> Node = _
  remove_child(Self, Node) -> Node = _
  insert_before(Self, Node, Node?) -> Node = _
  replace_child(Self, Node, Node) -> Node = _
  clone_node(Self, Bool) -> Node = _
  contains(Self, Node?) -> Bool = _
  has_child_nodes(Self) -> Bool = _
  text_content(Self) -> String = _
  set_text_content(Self, String) -> Unit = _
}

///|
impl NodeImpl with node_type(self) -> Int {
  unsafe_cast(self.to_js().get("nodeType"))
}

///|
impl NodeImpl with node_name(self) -> String {
  unsafe_cast(self.to_js().get("nodeName"))
}

///|
impl NodeImpl with parent_node(self) -> Node? {
  unsafe_cast(self.to_js().get("parentNode"))
}

///|
impl NodeImpl with child_nodes(self) -> Array[Node] {
  @js.array_from(self.to_js().get("childNodes")).map(fn(v) { unsafe_cast(v) })
}

///|
impl NodeImpl with first_child(self) -> Node? {
  unsafe_cast(self.to_js().get("firstChild"))
}

///|
impl NodeImpl with last_child(self) -> Node? {
  unsafe_cast(self.to_js().get("lastChild"))
}

///|
impl NodeImpl with previous_sibling(self) -> Node? {
  unsafe_cast(self.to_js().get("previousSibling"))
}

///|
impl NodeImpl with next_sibling(self) -> Node? {
  unsafe_cast(self.to_js().get("nextSibling"))
}

///|
impl NodeImpl with append_child(self, child) -> Node {
  self.invoke("appendChild", [child.to_js()]) |> unsafe_cast
}

///|
impl NodeImpl with remove_child(self, child) -> Node {
  self.invoke("removeChild", [child.to_js()]) |> unsafe_cast
}

///|
impl NodeImpl with insert_before(self, new_node, ref_node) -> Node {
  match ref_node {
    Some(node) =>
      unsafe_cast(self.invoke("insertBefore", [new_node.to_js(), node.to_js()]))
    None =>
      unsafe_cast(self.invoke("insertBefore", [new_node.to_js(), @js.null_()]))
  }
}

///|
impl NodeImpl with replace_child(self, new_child, old_child) -> Node {
  unsafe_cast(
    self.invoke("replaceChild", [new_child.to_js(), old_child.to_js()]),
  )
}

///|
impl NodeImpl with clone_node(self, deep) -> Node {
  self.invoke("cloneNode", [deep]) |> unsafe_cast
}

///|
impl NodeImpl with contains(self, other) -> Bool {
  match other {
    Some(node) => self.invoke("contains", [node.to_js()]) |> unsafe_cast
    None => self.invoke("contains", [@js.null_()]) |> unsafe_cast
  }
}

///|
impl NodeImpl with has_child_nodes(self) -> Bool {
  self.invoke("hasChildNodes", []) |> unsafe_cast
}

///|
impl NodeImpl with text_content(self) -> String {
  unsafe_cast(self.to_js().get("textContent"))
}

///|
impl NodeImpl with set_text_content(self, content) -> Unit {
  self.to_js().set("textContent", content)
}

///|
/// Element trait - base interface for element nodes
pub(open) trait ElementImpl: Js + NodeImpl {
  tag_name(Self) -> String = _
  class_name(Self) -> String = _
  set_class_name(Self, String) -> Unit = _
  id(Self) -> String = _
  set_id(Self, String) -> Unit = _
  get_attribute(Self, String) -> String? = _
  set_attribute(Self, String, String) -> Unit = _
  remove_attribute(Self, String) -> Unit = _
  has_attribute(Self, String) -> Bool = _
  get_elements_by_tag_name(Self, String) -> Array[Element] = _
  get_elements_by_class_name(Self, String) -> Array[Element] = _
  query_selector(Self, String) -> Element? = _
  query_selector_all(Self, String) -> Array[Element] = _
}

///|
impl ElementImpl with tag_name(self) -> String {
  unsafe_cast(self.to_js().get("tagName"))
}

///|
impl ElementImpl with class_name(self) -> String {
  unsafe_cast(self.to_js().get("className"))
}

///|
impl ElementImpl with set_class_name(self, class_name) -> Unit {
  self.to_js().set("className", class_name)
}

///|
impl ElementImpl with id(self) -> String {
  unsafe_cast(self.to_js().get("id"))
}

///|
impl ElementImpl with set_id(self, id) -> Unit {
  self.to_js().set("id", id)
}

///|
impl ElementImpl with get_attribute(self, name) -> String? {
  self.invoke("getAttribute", [name]) |> unsafe_cast
}

///|
impl ElementImpl with set_attribute(self, name, value) -> Unit {
  ignore(self.invoke("setAttribute", [name, value]))
}

///|
impl ElementImpl with remove_attribute(self, name) -> Unit {
  ignore(self.invoke("removeAttribute", [name]))
}

///|
impl ElementImpl with has_attribute(self, name) -> Bool {
  self.invoke("hasAttribute", [name]) |> unsafe_cast
}

///|
impl ElementImpl with get_elements_by_tag_name(self, tag_name) -> Array[Element] {
  @js.array_from(self.invoke("getElementsByTagName", [tag_name])).map(fn(v) {
    unsafe_cast(v)
  })
}

///|
impl ElementImpl with get_elements_by_class_name(self, class_name) -> Array[
  Element,
] {
  @js.array_from(self.invoke("getElementsByClassName", [class_name])).map(fn(
    v,
  ) {
    unsafe_cast(v)
  })
}

///|
impl ElementImpl with query_selector(self, selector) -> Element? {
  self.invoke("querySelector", [selector]) |> unsafe_cast
}

///|
impl ElementImpl with query_selector_all(self, selector) -> Array[Element] {
  @js.array_from(self.invoke("querySelectorAll", [selector])).map(
    unsafe_cast(_),
  )
}

///|
/// HTMLElement trait - base interface for HTML elements
pub(open) trait HTMLElementImpl: Js + ElementImpl {
  inner_text(Self) -> String = _
  set_inner_text(Self, String) -> Unit = _
  inner_html(Self) -> String = _
  set_inner_html(Self, String) -> Unit = _
  outer_html(Self) -> String = _
  set_outer_html(Self, String) -> Unit = _
}

///|
impl HTMLElementImpl with inner_text(self) -> String {
  unsafe_cast(self.to_js().get("innerText"))
}

///|
impl HTMLElementImpl with set_inner_text(self, text) -> Unit {
  self.to_js().set("innerText", text)
}

///|
impl HTMLElementImpl with inner_html(self) -> String {
  unsafe_cast(self.to_js().get("innerHTML"))
}

///|
impl HTMLElementImpl with set_inner_html(self, html) -> Unit {
  self.to_js().set("innerHTML", html)
}

///|
impl HTMLElementImpl with outer_html(self) -> String {
  unsafe_cast(self.to_js().get("outerHTML"))
}

///|
impl HTMLElementImpl with set_outer_html(self, html) -> Unit {
  self.to_js().set("outerHTML", html)
}

///|
#external
pub type Node

///|
pub impl Js for Node

///|
pub impl EventTargetImpl for Node

///|
pub impl NodeImpl for Node

///|
#external
pub type Element

///|
pub impl Js for Element

///|
pub impl EventTargetImpl for Element

///|
#external
pub type HTMLElement

///|
pub impl Js for HTMLElement

///|
pub impl EventTargetImpl for HTMLElement

///|
pub impl ElementImpl for HTMLElement

///|
pub impl NodeImpl for HTMLElement

///|
pub impl HTMLElementImpl for HTMLElement

///|
pub impl Js for HTMLElement

///|
pub impl HTMLElementImpl for HTMLElement

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
  unsafe_cast(self.to_js().get("width"))
}

///|
pub fn HTMLCanvasElement::set_width(self : Self, value : Int) -> Unit {
  self.to_js().set("width", value)
}

///|
pub fn HTMLCanvasElement::height(self : Self) -> Int {
  unsafe_cast(self.to_js().get("height"))
}

///|
pub fn HTMLCanvasElement::set_height(self : Self, value : Int) -> Unit {
  self.to_js().set("height", value)
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
  unsafe_cast(self.to_js().get("href"))
}

///|
/// Sets the href attribute
pub fn HTMLAnchorElement::set_href(self : Self, href : String) -> Unit {
  self.to_js().set("href", href)
}

///|
/// Returns the target attribute
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLAnchorElement/target
pub fn HTMLAnchorElement::target(self : Self) -> String {
  unsafe_cast(self.to_js().get("target"))
}

///|
/// Sets the target attribute
pub fn HTMLAnchorElement::set_target(self : Self, target : String) -> Unit {
  self.to_js().set("target", target)
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
  unsafe_cast(self.to_js().get("disabled"))
}

///|
/// Sets whether the button is disabled
pub fn HTMLButtonElement::set_disabled(self : Self, disabled : Bool) -> Unit {
  self.to_js().set("disabled", disabled)
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
  unsafe_cast(self.to_js().get("value"))
}

///|
/// Sets the value of the input
pub fn HTMLInputElement::set_value(self : Self, value : String) -> Unit {
  self.to_js().set("value", value)
}

///|
/// Returns the type of the input
pub fn HTMLInputElement::input_type(self : Self) -> String {
  unsafe_cast(self.to_js().get("type"))
}

///|
/// Sets the type of the input
pub fn HTMLInputElement::set_input_type(
  self : Self,
  input_type : String,
) -> Unit {
  self.to_js().set("type", input_type)
}

///|
/// Returns whether the input is disabled
pub fn HTMLInputElement::disabled(self : Self) -> Bool {
  unsafe_cast(self.to_js().get("disabled"))
}

///|
/// Sets whether the input is disabled
pub fn HTMLInputElement::set_disabled(self : Self, disabled : Bool) -> Unit {
  self.to_js().set("disabled", disabled)
}

///|
/// Returns whether the input is checked (for checkbox/radio)
pub fn HTMLInputElement::checked(self : Self) -> Bool {
  unsafe_cast(self.to_js().get("checked"))
}

///|
/// Sets whether the input is checked (for checkbox/radio)
pub fn HTMLInputElement::set_checked(self : Self, checked : Bool) -> Unit {
  self.to_js().set("checked", checked)
}

///|
/// Returns the placeholder text
pub fn HTMLInputElement::placeholder(self : Self) -> String {
  unsafe_cast(self.to_js().get("placeholder"))
}

///|
/// Sets the placeholder text
pub fn HTMLInputElement::set_placeholder(
  self : Self,
  placeholder : String,
) -> Unit {
  self.to_js().set("placeholder", placeholder)
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
  unsafe_cast(self.to_js().get("value"))
}

///|
/// Sets the value of the textarea
pub fn HTMLTextAreaElement::set_value(self : Self, value : String) -> Unit {
  self.to_js().set("value", value)
}

///|
/// Returns the placeholder text
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLTextAreaElement/placeholder
pub fn HTMLTextAreaElement::placeholder(self : Self) -> String {
  unsafe_cast(self.to_js().get("placeholder"))
}

///|
/// Sets the placeholder text
pub fn HTMLTextAreaElement::set_placeholder(
  self : Self,
  placeholder : String,
) -> Unit {
  self.to_js().set("placeholder", placeholder)
}

///|
/// Returns whether the textarea is disabled
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLTextAreaElement/disabled
pub fn HTMLTextAreaElement::disabled(self : Self) -> Bool {
  unsafe_cast(self.to_js().get("disabled"))
}

///|
/// Sets whether the textarea is disabled
pub fn HTMLTextAreaElement::set_disabled(self : Self, disabled : Bool) -> Unit {
  self.to_js().set("disabled", disabled)
}

///|
/// Returns the number of visible text lines
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLTextAreaElement/rows
pub fn HTMLTextAreaElement::rows(self : Self) -> Int {
  unsafe_cast(self.to_js().get("rows"))
}

///|
/// Sets the number of visible text lines
pub fn HTMLTextAreaElement::set_rows(self : Self, rows : Int) -> Unit {
  self.to_js().set("rows", rows)
}

///|
/// Returns the visible width of the text control
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLTextAreaElement/cols
pub fn HTMLTextAreaElement::cols(self : Self) -> Int {
  unsafe_cast(self.to_js().get("cols"))
}

///|
/// Sets the visible width of the text control
pub fn HTMLTextAreaElement::set_cols(self : Self, cols : Int) -> Unit {
  self.to_js().set("cols", cols)
}

///|
/// Returns whether the textarea is read-only
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLTextAreaElement/readOnly
pub fn HTMLTextAreaElement::read_only(self : Self) -> Bool {
  unsafe_cast(self.to_js().get("readOnly"))
}

///|
/// Sets whether the textarea is read-only
pub fn HTMLTextAreaElement::set_read_only(
  self : Self,
  read_only : Bool,
) -> Unit {
  self.to_js().set("readOnly", read_only)
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
  unsafe_cast(self.to_js().get("src"))
}

///|
/// Sets the src attribute
pub fn HTMLIFrameElement::set_src(self : Self, src : String) -> Unit {
  self.to_js().set("src", src)
}

///|
/// Returns the content window
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLIFrameElement/contentWindow
pub fn HTMLIFrameElement::content_window(self : Self) -> Window? {
  self.to_js().get("contentWindow") |> to_option()
}

///|
/// Returns the content document
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLIFrameElement/contentDocument
pub fn HTMLIFrameElement::content_document(self : Self) -> Document? {
  self.to_js().get("contentDocument") |> to_option()
}

///|
/// Returns the width attribute
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLIFrameElement/width
pub fn HTMLIFrameElement::width(self : Self) -> String {
  unsafe_cast(self.to_js().get("width"))
}

///|
/// Sets the width attribute
pub fn HTMLIFrameElement::set_width(self : Self, width : String) -> Unit {
  self.to_js().set("width", width)
}

///|
/// Returns the height attribute
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLIFrameElement/height
pub fn HTMLIFrameElement::height(self : Self) -> String {
  unsafe_cast(self.to_js().get("height"))
}

///|
/// Sets the height attribute
pub fn HTMLIFrameElement::set_height(self : Self, height : String) -> Unit {
  self.to_js().set("height", height)
}

///|
/// Returns the name attribute
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLIFrameElement/name
pub fn HTMLIFrameElement::name(self : Self) -> String {
  unsafe_cast(self.to_js().get("name"))
}

///|
/// Sets the name attribute
pub fn HTMLIFrameElement::set_name(self : Self, name : String) -> Unit {
  self.to_js().set("name", name)
}

///|
/// Returns the sandbox attribute
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLIFrameElement/sandbox
pub fn HTMLIFrameElement::sandbox(self : Self) -> String {
  unsafe_cast(self.to_js().get("sandbox"))
}

///|
/// Sets the sandbox attribute
pub fn HTMLIFrameElement::set_sandbox(self : Self, sandbox : String) -> Unit {
  self.to_js().set("sandbox", sandbox)
}
