///|
#external
pub type Node

///|
pub impl @js.JsImpl for Node

///|
pub impl @event.EventTargetImpl for Node

///|
pub impl NodeImpl for Node

///|
/// Node_ trait - base interface for DOM tree nodes
pub(open) trait NodeImpl: @js.JsImpl + @event.EventTargetImpl {
  nodeType(Self) -> Int = _
  nodeName(Self) -> String = _
  parentNode(Self) -> Node? = _
  childNodes(Self) -> Array[Node] = _
  firstChild(Self) -> Node? = _
  lastChild(Self) -> Node? = _
  previousSibling(Self) -> Node? = _
  nextSibling(Self) -> Node? = _
  appendChild(Self, &NodeImpl) -> Node = _
  removeChild(Self, &NodeImpl) -> Node = _
  insertBefore(Self, &NodeImpl, &NodeImpl?) -> Node = _
  replaceChild(Self, &NodeImpl, &NodeImpl) -> Node = _
  cloneNode(Self, Bool) -> Node = _
  contains(Self, &NodeImpl?) -> Bool = _
  hasChildNodes(Self) -> Bool = _
  textContent(Self) -> String = _
  setTextContent(Self, String) -> Unit = _
}

///|
impl NodeImpl with nodeType(self) -> Int {
  self.get("nodeType") |> @js.identity
}

///|
impl NodeImpl with nodeName(self) -> String {
  self.get("nodeName") |> @js.identity
}

///|
impl NodeImpl with parentNode(self) -> Node? {
  @js.identity_option(self.get("parentNode"))
}

///|
/// Returns a static array of child nodes.
/// Note: The returned array is a snapshot and should be treated as immutable.
impl NodeImpl with childNodes(self) -> Array[Node] {
  @js.array_from(self.get("childNodes")).map(v => @js.identity(v))
}

///|
impl NodeImpl with firstChild(self) -> Node? {
  @js.identity_option(self.get("firstChild"))
}

///|
impl NodeImpl with lastChild(self) -> Node? {
  @js.identity_option(self.get("lastChild"))
}

///|
impl NodeImpl with previousSibling(self) -> Node? {
  @js.identity_option(self.get("previousSibling"))
}

///|
impl NodeImpl with nextSibling(self) -> Node? {
  @js.identity_option(self.get("nextSibling"))
}

///|
impl NodeImpl with appendChild(self, child) -> Node {
  self.call("appendChild", [child.to_js()]) |> @js.identity
}

///|
impl NodeImpl with removeChild(self, child) -> Node {
  self.call("removeChild", [child.to_js()]) |> @js.identity
}

///|
impl NodeImpl with insertBefore(self, new_node, ref_node) -> Node {
  match ref_node {
    Some(node) =>
      @js.identity(
        self.call2("insertBefore", new_node.to_js(), node.to_js()),
      )
    None =>
      @js.identity(self.call2("insertBefore", new_node.to_js(), @js.null_()))
  }
}

///|
impl NodeImpl with replaceChild(self, new_child, old_child) -> Node {
  @js.identity(
    self.call2("replaceChild", new_child.to_js(), old_child.to_js()),
  )
}

///|
impl NodeImpl with cloneNode(self, deep) {
  self.call("cloneNode", [deep]) |> @js.identity
}

///|
impl NodeImpl with contains(self, other) {
  match other {
    Some(node) => self.call("contains", [node.to_js()]) |> @js.identity
    None => self.call("contains", [@js.null_()]) |> @js.identity
  }
}

///|
impl NodeImpl with hasChildNodes(self) -> Bool {
  self.call0("hasChildNodes") |> @js.identity
}

///|
impl NodeImpl with textContent(self) -> String {
  self.get("textContent") |> @js.identity
}

///|
impl NodeImpl with setTextContent(self, content) -> Unit {
  self.set("textContent", content)
}
