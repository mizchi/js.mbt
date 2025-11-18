///|
#external
pub type Node

///|
pub impl JsImpl for Node

///|
pub impl EventTargetImpl for Node

///|
pub impl NodeImpl for Node

///|
/// Node_ trait - base interface for DOM tree nodes
pub(open) trait NodeImpl: JsImpl + EventTargetImpl {
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
  unsafe_cast(self.get("nodeType"))
}

///|
impl NodeImpl with nodeName(self) -> String {
  unsafe_cast(self.get("nodeName"))
}

///|
impl NodeImpl with parentNode(self) -> Node? {
  unsafe_option(self.get("parentNode"))
}

///|
impl NodeImpl with childNodes(self) -> Array[Node] {
  @js.array_from(self.get("childNodes")).map(v => unsafe_cast(v))
}

///|
impl NodeImpl with firstChild(self) -> Node? {
  unsafe_option(self.get("firstChild"))
}

///|
impl NodeImpl with lastChild(self) -> Node? {
  unsafe_option(self.get("lastChild"))
}

///|
impl NodeImpl with previousSibling(self) -> Node? {
  unsafe_option(self.get("previousSibling"))
}

///|
impl NodeImpl with nextSibling(self) -> Node? {
  unsafe_option(self.get("nextSibling"))
}

///|
impl NodeImpl with appendChild(self, child) -> Node {
  self.invoke("appendChild", [child.to_js()]) |> unsafe_cast
}

///|
impl NodeImpl with removeChild(self, child) -> Node {
  self.invoke("removeChild", [child.to_js()]) |> unsafe_cast
}

///|
impl NodeImpl with insertBefore(self, new_node, ref_node) -> Node {
  match ref_node {
    Some(node) =>
      unsafe_cast(self.invoke("insertBefore", [new_node.to_js(), node.to_js()]))
    None =>
      unsafe_cast(self.invoke("insertBefore", [new_node.to_js(), @js.null_()]))
  }
}

///|
impl NodeImpl with replaceChild(self, new_child, old_child) -> Node {
  unsafe_cast(
    self.invoke("replaceChild", [new_child.to_js(), old_child.to_js()]),
  )
}

///|
impl NodeImpl with cloneNode(self, deep) {
  self.invoke("cloneNode", [deep]) |> unsafe_cast
}

///|
impl NodeImpl with contains(self, other) {
  match other {
    Some(node) => self.invoke("contains", [node.to_js()]) |> unsafe_cast
    None => self.invoke("contains", [@js.null_()]) |> unsafe_cast
  }
}

///|
impl NodeImpl with hasChildNodes(self) -> Bool {
  self.invoke("hasChildNodes", []) |> unsafe_cast
}

///|
impl NodeImpl with textContent(self) -> String {
  unsafe_cast(self.get("textContent"))
}

///|
impl NodeImpl with setTextContent(self, content) -> Unit {
  self.set("textContent", content)
}
