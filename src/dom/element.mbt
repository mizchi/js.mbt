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
  ignore(
    self.to_js().call_method("addEventListener", [event_type, @js.js(handler)]),
  )
}

///|
impl EventTargetImpl with remove_event_listener(self, event_type, handler) -> Unit {
  ignore(
    self
    .to_js()
    .call_method("removeEventListener", [event_type, @js.js(handler)]),
  )
}

///|
impl EventTargetImpl with dispatch_event(self, event) -> Bool {
  self.to_js().call_method("dispatchEvent", [event]).cast()
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
  self.to_js().get("nodeType").cast()
}

///|
impl NodeImpl with node_name(self) -> String {
  self.to_js().get("nodeName").cast()
}

///|
impl NodeImpl with parent_node(self) -> Node? {
  self.to_js().get("parentNode").cast()
}

///|
impl NodeImpl with child_nodes(self) -> Array[Node] {
  @js.array_from(self.to_js().get("childNodes")).map(fn(v) { v.cast() })
}

///|
impl NodeImpl with first_child(self) -> Node? {
  self.to_js().get("firstChild").cast()
}

///|
impl NodeImpl with last_child(self) -> Node? {
  self.to_js().get("lastChild").cast()
}

///|
impl NodeImpl with previous_sibling(self) -> Node? {
  self.to_js().get("previousSibling").cast()
}

///|
impl NodeImpl with next_sibling(self) -> Node? {
  self.to_js().get("nextSibling").cast()
}

///|
impl NodeImpl with append_child(self, child) -> Node {
  self.to_js().call_method("appendChild", [child.to_js()]).cast()
}

///|
impl NodeImpl with remove_child(self, child) -> Node {
  self.to_js().call_method("removeChild", [child.to_js()]).cast()
}

///|
impl NodeImpl with insert_before(self, new_node, ref_node) -> Node {
  match ref_node {
    Some(node) =>
      self
      .to_js()
      .call_method("insertBefore", [new_node.to_js(), node.to_js()])
      .cast()
    None =>
      self
      .to_js()
      .call_method("insertBefore", [new_node.to_js(), @js.null_()])
      .cast()
  }
}

///|
impl NodeImpl with replace_child(self, new_child, old_child) -> Node {
  self
  .to_js()
  .call_method("replaceChild", [new_child.to_js(), old_child.to_js()])
  .cast()
}

///|
impl NodeImpl with clone_node(self, deep) -> Node {
  self.to_js().call_method("cloneNode", [deep]).cast()
}

///|
impl NodeImpl with contains(self, other) -> Bool {
  match other {
    Some(node) => self.to_js().call_method("contains", [node.to_js()]).cast()
    None => self.to_js().call_method("contains", [@js.null_()]).cast()
  }
}

///|
impl NodeImpl with has_child_nodes(self) -> Bool {
  self.to_js().call_method("hasChildNodes", []).cast()
}

///|
impl NodeImpl with text_content(self) -> String {
  self.to_js().get("textContent").cast()
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
  self.to_js().get("tagName").cast()
}

///|
impl ElementImpl with class_name(self) -> String {
  self.to_js().get("className").cast()
}

///|
impl ElementImpl with set_class_name(self, class_name) -> Unit {
  self.to_js().set("className", class_name)
}

///|
impl ElementImpl with id(self) -> String {
  self.to_js().get("id").cast()
}

///|
impl ElementImpl with set_id(self, id) -> Unit {
  self.to_js().set("id", id)
}

///|
impl ElementImpl with get_attribute(self, name) -> String? {
  self.to_js().call_method("getAttribute", [name]).cast()
}

///|
impl ElementImpl with set_attribute(self, name, value) -> Unit {
  ignore(self.to_js().call_method("setAttribute", [name, value]))
}

///|
impl ElementImpl with remove_attribute(self, name) -> Unit {
  ignore(self.to_js().call_method("removeAttribute", [name]))
}

///|
impl ElementImpl with has_attribute(self, name) -> Bool {
  self.to_js().call_method("hasAttribute", [name]).cast()
}

///|
impl ElementImpl with get_elements_by_tag_name(self, tag_name) -> Array[Element] {
  @js.array_from(self.to_js().call_method("getElementsByTagName", [tag_name])).map(fn(
      v,
    ) {
      v.cast()
    },
  )
}

///|
impl ElementImpl with get_elements_by_class_name(self, class_name) -> Array[
  Element,
] {
  @js.array_from(
    self.to_js().call_method("getElementsByClassName", [class_name]),
  ).map(fn(v) { v.cast() })
}

///|
impl ElementImpl with query_selector(self, selector) -> Element? {
  self.to_js().call_method("querySelector", [selector]).cast()
}

///|
impl ElementImpl with query_selector_all(self, selector) -> Array[Element] {
  @js.array_from(self.to_js().call_method("querySelectorAll", [selector])).map(fn(
    v,
  ) {
    v.cast()
  })
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
  self.to_js().get("innerText").cast()
}

///|
impl HTMLElementImpl with set_inner_text(self, text) -> Unit {
  self.to_js().set("innerText", text)
}

///|
impl HTMLElementImpl with inner_html(self) -> String {
  self.to_js().get("innerHTML").cast()
}

///|
impl HTMLElementImpl with set_inner_html(self, html) -> Unit {
  self.to_js().set("innerHTML", html)
}

///|
impl HTMLElementImpl with outer_html(self) -> String {
  self.to_js().get("outerHTML").cast()
}

///|
impl HTMLElementImpl with set_outer_html(self, html) -> Unit {
  self.to_js().set("outerHTML", html)
}

///|
#external
pub type Node

///|
pub impl Js for Node with to_js(self) {
  self |> js
}

///|
pub impl EventTargetImpl for Node

///|
pub impl NodeImpl for Node

///|
#external
pub type Element

///|
pub impl Js for Element with to_js(self) {
  self |> js
}

///|
pub impl EventTargetImpl for Element

///|
#external
pub type HTMLElement

///|
pub impl Js for HTMLElement with to_js(self) {
  self |> js
}

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
pub impl Js for HTMLDivElement with to_js(self) {
  self |> js
}

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
pub impl Js for HTMLCanvasElement with to_js(self) -> Val {
  self |> js
}

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
  self.to_js().get("width").cast()
}

///|
pub fn HTMLCanvasElement::set_width(self : Self, value : Int) -> Unit {
  self.to_js().set("width", value)
}

///|
pub fn HTMLCanvasElement::height(self : Self) -> Int {
  self.to_js().get("height").cast()
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
  self.to_js().call_method("getContext", [context_type])
}

///|
pub fn HTMLCanvasElement::to_data_url(
  self : Self,
  image_type? : String,
  quality? : Double,
) -> String {
  match (image_type, quality) {
    (Some(t), Some(q)) => self.to_js().call_method("toDataURL", [t, q]).cast()
    (Some(t), None) => self.to_js().call_method("toDataURL", [t]).cast()
    (None, _) => self.to_js().call_method("toDataURL", []).cast()
  }
}

///|
pub fn HTMLCanvasElement::to_blob(
  self : Self,
  image_type? : String,
  quality? : Double,
) -> Promise[Blob] {
  match (image_type, quality) {
    (Some(t), Some(q)) => self.to_js().call_method("toBlob", [t, q]).cast()
    (Some(t), None) => self.to_js().call_method("toBlob", [t]).cast()
    (None, _) => self.to_js().call_method("toBlob", []).cast()
  }
}
