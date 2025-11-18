///|
#external
pub type Node

///|
pub impl Js for Node

///|
pub impl EventTarget for Node

///|
pub impl NodeImpl for Node

///|
/// Node_ trait - base interface for DOM tree nodes
pub(open) trait NodeImpl: Js + EventTarget {
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
  unsafe_cast(self.get("nodeType"))
}

///|
impl NodeImpl with node_name(self) -> String {
  unsafe_cast(self.get("nodeName"))
}

///|
impl NodeImpl with parent_node(self) -> Node? {
  unsafe_cast(self.get("parentNode"))
}

///|
impl NodeImpl with child_nodes(self) -> Array[Node] {
  @js.array_from(self.get("childNodes")).map(v => unsafe_cast(v))
}

///|
impl NodeImpl with first_child(self) -> Node? {
  unsafe_cast(self.get("firstChild"))
}

///|
impl NodeImpl with last_child(self) -> Node? {
  unsafe_cast(self.get("lastChild"))
}

///|
impl NodeImpl with previous_sibling(self) -> Node? {
  unsafe_cast(self.get("previousSibling"))
}

///|
impl NodeImpl with next_sibling(self) -> Node? {
  unsafe_cast(self.get("nextSibling"))
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
  unsafe_cast(self.get("textContent"))
}

///|
impl NodeImpl with set_text_content(self, content) -> Unit {
  self.set("textContent", content)
}
