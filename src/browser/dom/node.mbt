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
pub fn Node::insertBefore(self : Node, new_node : Node, ref_node : Node?) -> Node {
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
  old_child : Node
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
