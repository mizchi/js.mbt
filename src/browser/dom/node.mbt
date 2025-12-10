///|
#external
pub type Node

///|
pub fn Node::as_any(self : Node) -> @core.Any = "%identity"

///|
pub fn Node::as_event_target(self : Node) -> @event.EventTarget = "%identity"

///|

///|
pub fn Node::nodeType(self : Node) -> Int {
  self.as_any()._get("nodeType").cast()
}

///|
pub fn Node::nodeName(self : Node) -> String {
  self.as_any()._get("nodeName").cast()
}

///|
pub fn Node::parentNode(self : Node) -> Node? {
  let v : @core.Any = self.as_any()._get("parentNode").cast()
  @core.identity_option(v)
}

///|
/// Returns a static array of child nodes.
/// Note: The returned array is a snapshot and should be treated as immutable.
pub fn Node::childNodes(self : Node) -> Array[Node] {
  let arr : @core.Any = self.as_any()._get("childNodes").cast()
  @core.array_from(arr).map(v => @core.identity(v))
}

///|
pub fn Node::firstChild(self : Node) -> Node? {
  let v : @core.Any = self.as_any()._get("firstChild").cast()
  @core.identity_option(v)
}

///|
pub fn Node::lastChild(self : Node) -> Node? {
  let v : @core.Any = self.as_any()._get("lastChild").cast()
  @core.identity_option(v)
}

///|
pub fn Node::previousSibling(self : Node) -> Node? {
  let v : @core.Any = self.as_any()._get("previousSibling").cast()
  @core.identity_option(v)
}

///|
pub fn Node::nextSibling(self : Node) -> Node? {
  let v : @core.Any = self.as_any()._get("nextSibling").cast()
  @core.identity_option(v)
}

///|
pub fn Node::appendChild(self : Node, child : Node) -> Node {
  self.as_any()._call("appendChild", [child.as_any()]).cast()
}

///|
pub fn Node::removeChild(self : Node, child : Node) -> Node {
  self.as_any()._call("removeChild", [child.as_any()]).cast()
}

///|
pub fn Node::insertBefore(
  self : Node,
  new_node : Node,
  ref_node : Node?,
) -> Node {
  match ref_node {
    Some(node) =>
      self
      .as_any()
      ._call("insertBefore", [new_node.as_any(), node.as_any()])
      .cast()
    None =>
      self
      .as_any()
      ._call("insertBefore", [new_node.as_any(), @core.null()])
      .cast()
  }
}

///|
pub fn Node::replaceChild(
  self : Node,
  new_child : Node,
  old_child : Node,
) -> Node {
  self
  .as_any()
  ._call("replaceChild", [new_child.as_any(), old_child.as_any()])
  .cast()
}

///|
pub fn Node::cloneNode(self : Node, deep : Bool) -> Node {
  self.as_any()._call("cloneNode", [@core.any(deep)]).cast()
}

///|
pub fn Node::contains(self : Node, other : Node?) -> Bool {
  match other {
    Some(node) => self.as_any()._call("contains", [node.as_any()]).cast()
    None => self.as_any()._call("contains", [@core.null()]).cast()
  }
}

///|
pub fn Node::hasChildNodes(self : Node) -> Bool {
  self.as_any()._call("hasChildNodes", []).cast()
}

///|
pub fn Node::textContent(self : Node) -> String {
  self.as_any()._get("textContent").cast()
}

///|
pub fn Node::setTextContent(self : Node, content : String) -> Unit {
  self.as_any()._set("textContent", @core.any(content)) |> ignore
}

///|
/// Moves `moved_node` to a new position before `ref_node` while preserving state.
/// Unlike insertBefore, this preserves animations, transitions, focus state, etc.
pub fn Node::moveBefore(
  self : Node,
  moved_node : Node,
  ref_node : Node?,
) -> Unit {
  match ref_node {
    Some(node) =>
      self.as_any()._call("moveBefore", [moved_node.as_any(), node.as_any()])
      |> ignore
    None =>
      self.as_any()._call("moveBefore", [moved_node.as_any(), @core.null()])
      |> ignore
  }
}

///|
/// Compares the position of the current node against another node in any document.
pub fn Node::compareDocumentPosition(self : Node, other : Node) -> Int {
  self.as_any()._call("compareDocumentPosition", [other.as_any()]).cast()
}

///|
/// Returns the root node of the node's tree.
pub fn Node::getRootNode(self : Node) -> Node {
  self.as_any()._call("getRootNode", []).cast()
}

///|
/// Returns whether two nodes are equal (same type and defining data).
pub fn Node::isEqualNode(self : Node, other : Node?) -> Bool {
  match other {
    Some(node) => self.as_any()._call("isEqualNode", [node.as_any()]).cast()
    None => self.as_any()._call("isEqualNode", [@core.null()]).cast()
  }
}

///|
/// Returns whether two nodes are the same (reference the same object).
pub fn Node::isSameNode(self : Node, other : Node?) -> Bool {
  match other {
    Some(node) => self.as_any()._call("isSameNode", [node.as_any()]).cast()
    None => self.as_any()._call("isSameNode", [@core.null()]).cast()
  }
}

///|
/// Normalizes the node by merging adjacent text nodes and removing empty ones.
pub fn Node::normalize(self : Node) -> Unit {
  self.as_any()._call("normalize", []) |> ignore
}

///|
/// Returns the node value (for text nodes, comments, etc.)
pub fn Node::nodeValue(self : Node) -> String? {
  let v : @core.Any = self.as_any()._get("nodeValue").cast()
  @core.identity_option(v)
}

///|
/// Sets the node value.
pub fn Node::setNodeValue(self : Node, value : String?) -> Unit {
  match value {
    Some(v) => self.as_any()._set("nodeValue", @core.any(v)) |> ignore
    None => self.as_any()._set("nodeValue", @core.null()) |> ignore
  }
}

///|
/// Returns the Document that the node belongs to.
pub fn Node::ownerDocument(self : Node) -> Document? {
  let v : @core.Any = self.as_any()._get("ownerDocument").cast()
  @core.identity_option(v)
}

///|
/// Returns whether the node is connected to the document.
pub fn Node::isConnected(self : Node) -> Bool {
  self.as_any()._get("isConnected").cast()
}
