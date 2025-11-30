///|
#external
pub type Node

///|
pub fn Node::as_any(self : Node) -> @nostd.Any = "%identity"

///|
pub fn Node::as_event_target(self : Node) -> @event.EventTarget = "%identity"

///|

///|
pub impl NodeImpl for Node with as_any(self) -> @nostd.Any {
  self.as_any()
}

///|
/// Node_ trait - base interface for DOM tree nodes
pub(open) trait NodeImpl {
  as_any(Self) -> @nostd.Any
  nodeType(Self) -> Int = _
  nodeName(Self) -> String = _
  parentNode(Self) -> Node? = _
  childNodes(Self) -> Array[Node] = _
  firstChild(Self) -> Node? = _
  lastChild(Self) -> Node? = _
  previousSibling(Self) -> Node? = _
  nextSibling(Self) -> Node? = _
  appendChild(Self, Node) -> Node = _
  removeChild(Self, Node) -> Node = _
  insertBefore(Self, Node, Node?) -> Node = _
  replaceChild(Self, Node, Node) -> Node = _
  cloneNode(Self, Bool) -> Node = _
  contains(Self, Node?) -> Bool = _
  hasChildNodes(Self) -> Bool = _
  textContent(Self) -> String = _
  setTextContent(Self, String) -> Unit = _
}

///|
impl NodeImpl with nodeType(self) -> Int {
  self.as_any()._get("nodeType").cast()
}

///|
impl NodeImpl with nodeName(self) -> String {
  self.as_any()._get("nodeName").cast()
}

///|
impl NodeImpl with parentNode(self) -> Node? {
  let v : @js.Any = self.as_any()._get("parentNode").cast()
  @js.identity_option(v)
}

///|
/// Returns a static array of child nodes.
/// Note: The returned array is a snapshot and should be treated as immutable.
impl NodeImpl with childNodes(self) -> Array[Node] {
  let arr : @js.Any = self.as_any()._get("childNodes").cast()
  @js.array_from(arr).map(v => @js.identity(v))
}

///|
impl NodeImpl with firstChild(self) -> Node? {
  let v : @js.Any = self.as_any()._get("firstChild").cast()
  @js.identity_option(v)
}

///|
impl NodeImpl with lastChild(self) -> Node? {
  let v : @js.Any = self.as_any()._get("lastChild").cast()
  @js.identity_option(v)
}

///|
impl NodeImpl with previousSibling(self) -> Node? {
  let v : @js.Any = self.as_any()._get("previousSibling").cast()
  @js.identity_option(v)
}

///|
impl NodeImpl with nextSibling(self) -> Node? {
  let v : @js.Any = self.as_any()._get("nextSibling").cast()
  @js.identity_option(v)
}

///|
impl NodeImpl with appendChild(self, child : Node) -> Node {
  self.as_any()._call("appendChild", [child.as_any()]).cast()
}

///|
impl NodeImpl with removeChild(self, child : Node) -> Node {
  self.as_any()._call("removeChild", [child.as_any()]).cast()
}

///|
impl NodeImpl with insertBefore(self, new_node : Node, ref_node : Node?) -> Node {
  match ref_node {
    Some(node) =>
      self
      .as_any()
      ._call("insertBefore", [new_node.as_any(), node.as_any()])
      .cast()
    None =>
      self
      .as_any()
      ._call("insertBefore", [new_node.as_any(), @nostd.null()])
      .cast()
  }
}

///|
impl NodeImpl with replaceChild(self, new_child : Node, old_child : Node) -> Node {
  self
  .as_any()
  ._call("replaceChild", [new_child.as_any(), old_child.as_any()])
  .cast()
}

///|
impl NodeImpl with cloneNode(self, deep) {
  self.as_any()._call("cloneNode", [@nostd.any(deep)]).cast()
}

///|
impl NodeImpl with contains(self, other : Node?) {
  match other {
    Some(node) => self.as_any()._call("contains", [node.as_any()]).cast()
    None => self.as_any()._call("contains", [@nostd.null()]).cast()
  }
}

///|
impl NodeImpl with hasChildNodes(self) -> Bool {
  self.as_any()._call("hasChildNodes", []).cast()
}

///|
impl NodeImpl with textContent(self) -> String {
  self.as_any()._get("textContent").cast()
}

///|
impl NodeImpl with setTextContent(self, content) -> Unit {
  self.as_any()._set("textContent", @nostd.any(content)) |> ignore
}
