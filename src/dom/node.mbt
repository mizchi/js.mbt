///|
/// Node interface represents a node in the DOM tree
/// https://developer.mozilla.org/en-US/docs/Web/API/Node
///
/// Note: In this implementation, we use Element type for Node operations
/// since most practical DOM operations work with Elements.

///|
/// Returns the parent node of this element
/// https://developer.mozilla.org/en-US/docs/Web/API/Node/parentNode
#alias(parentNode)
pub fn Element::parent_node(self : Self) -> Element? {
  self.to_js().get("parentNode").cast_option()
}

///|
/// Returns the next sibling node
/// https://developer.mozilla.org/en-US/docs/Web/API/Node/nextSibling
#alias(nextSibling)
pub fn Element::next_sibling(self : Self) -> Element? {
  self.to_js().get("nextSibling").cast_option()
}

///|
/// Returns the previous sibling node
/// https://developer.mozilla.org/en-US/docs/Web/API/Node/previousSibling
#alias(previousSibling)
pub fn Element::previous_sibling(self : Self) -> Element? {
  self.to_js().get("previousSibling").cast_option()
}

///|
/// Returns the first child node
/// https://developer.mozilla.org/en-US/docs/Web/API/Node/firstChild
#alias(firstChild)
pub fn Element::first_child(self : Self) -> Element? {
  self.to_js().get("firstChild").cast_option()
}

///|
/// Returns the last child node
/// https://developer.mozilla.org/en-US/docs/Web/API/Node/lastChild
#alias(lastChild)
pub fn Element::last_child(self : Self) -> Element? {
  self.to_js().get("lastChild").cast_option()
}

///|
/// Returns the parent element
/// https://developer.mozilla.org/en-US/docs/Web/API/Node/parentElement
#alias(parentElement)
pub fn Element::parent_element(self : Self) -> Element? {
  self.to_js().get("parentElement").cast_option()
}

///|
/// Returns the next element sibling (skips text nodes)
/// https://developer.mozilla.org/en-US/docs/Web/API/Element/nextElementSibling
#alias(nextElementSibling)
pub fn Element::next_element_sibling(self : Self) -> Element? {
  self.to_js().get("nextElementSibling").cast_option()
}

///|
/// Returns the previous element sibling (skips text nodes)
/// https://developer.mozilla.org/en-US/docs/Web/API/Element/previousElementSibling
#alias(previousElementSibling)
pub fn Element::previous_element_sibling(self : Self) -> Element? {
  self.to_js().get("previousElementSibling").cast_option()
}

///|
/// Returns the first child element (skips text nodes)
/// https://developer.mozilla.org/en-US/docs/Web/API/Element/firstElementChild
#alias(firstElementChild)
pub fn Element::first_element_child(self : Self) -> Element? {
  self.to_js().get("firstElementChild").cast_option()
}

///|
/// Returns the last child element (skips text nodes)
/// https://developer.mozilla.org/en-US/docs/Web/API/Element/lastElementChild
#alias(lastElementChild)
pub fn Element::last_element_child(self : Self) -> Element? {
  self.to_js().get("lastElementChild").cast_option()
}

///|
/// Returns the number of child elements
/// https://developer.mozilla.org/en-US/docs/Web/API/Element/childElementCount
#alias(childElementCount)
pub fn Element::child_element_count(self : Self) -> Int {
  self.to_js().get("childElementCount").cast()
}

///|
/// Returns the node type
/// https://developer.mozilla.org/en-US/docs/Web/API/Node/nodeType
#alias(nodeType)
pub fn Element::node_type(self : Self) -> Int {
  self.to_js().get("nodeType").cast()
}

///|
/// Returns the node name
/// https://developer.mozilla.org/en-US/docs/Web/API/Node/nodeName
#alias(nodeName)
pub fn Element::node_name(self : Self) -> String {
  self.to_js().get("nodeName").cast()
}

///|
/// Returns the node value
/// https://developer.mozilla.org/en-US/docs/Web/API/Node/nodeValue
#alias(nodeValue)
pub fn Element::node_value(self : Self) -> String? {
  self.to_js().get("nodeValue").cast_option()
}

///|
/// Sets the node value
pub fn Element::set_node_value(self : Self, value : String) -> Unit {
  self.to_js().set("nodeValue", value |> js) |> ignore
}

///|
/// Returns the text content of the node and its descendants
/// https://developer.mozilla.org/en-US/docs/Web/API/Node/textContent
#alias(textContent)
pub fn Element::text_content(self : Self) -> String {
  self.to_js().get("textContent").cast()
}

///|
/// Sets the text content of the node
pub fn Element::set_text_content(self : Self, text : String) -> Unit {
  self.to_js().set("textContent", text |> js) |> ignore
}

///|
/// Returns a collection of child nodes
/// https://developer.mozilla.org/en-US/docs/Web/API/Node/childNodes
#alias(childNodes)
pub fn Element::child_nodes(self : Self) -> Val {
  self.to_js().get("childNodes")
}

///|
/// Returns a collection of child elements
/// https://developer.mozilla.org/en-US/docs/Web/API/Element/children
pub fn Element::children(self : Self) -> Val {
  self.to_js().get("children")
}

///|
/// Checks if the node has child nodes
/// https://developer.mozilla.org/en-US/docs/Web/API/Node/hasChildNodes
pub fn Element::has_child_nodes(self : Self) -> Bool {
  self.to_js().call_method("hasChildNodes", []).cast()
}

///|
/// Checks if the node contains another node
/// https://developer.mozilla.org/en-US/docs/Web/API/Node/contains
pub fn Element::contains(self : Self, other : Element) -> Bool {
  self.to_js().call_method("contains", [other |> js]).cast()
}

///|
/// Clones the node
/// https://developer.mozilla.org/en-US/docs/Web/API/Node/cloneNode
pub fn Element::clone_node(self : Self, deep : Bool) -> Element {
  self.to_js().call_method("cloneNode", [deep |> js]).cast()
}

///|
/// Normalizes the node and its subtree
/// https://developer.mozilla.org/en-US/docs/Web/API/Node/normalize
pub fn Element::normalize(self : Self) -> Unit {
  self.to_js().call_method("normalize", []) |> ignore
}

///|
/// Compares the position of two nodes
/// https://developer.mozilla.org/en-US/docs/Web/API/Node/compareDocumentPosition
pub fn Element::compare_document_position(self : Self, other : Element) -> Int {
  self.to_js().call_method("compareDocumentPosition", [other |> js]).cast()
}

///|
/// Checks if two nodes are equal
/// https://developer.mozilla.org/en-US/docs/Web/API/Node/isEqualNode
pub fn Element::is_equal_node(self : Self, other : Element) -> Bool {
  self.to_js().call_method("isEqualNode", [other |> js]).cast()
}

///|
/// Checks if two nodes are the same
/// https://developer.mozilla.org/en-US/docs/Web/API/Node/isSameNode
pub fn Element::is_same_node(self : Self, other : Element) -> Bool {
  self.to_js().call_method("isSameNode", [other |> js]).cast()
}

///|
/// Returns the base URI of the node
/// https://developer.mozilla.org/en-US/docs/Web/API/Node/baseURI
pub fn Element::base_uri(self : Self) -> String {
  self.to_js().get("baseURI").cast()
}

///|
/// Returns the owner document
/// https://developer.mozilla.org/en-US/docs/Web/API/Node/ownerDocument
pub fn Element::owner_document(self : Self) -> Document {
  self.to_js().get("ownerDocument").cast()
}

///|
/// Node_ trait implementation for Element
pub impl Node_ for Element with node_type_(self) {
  self.node_type()
}

///|
pub impl Node_ for Element with node_name_(self) {
  self.node_name()
}

///|
pub impl Node_ for Element with parent_node_(self) {
  match self.parent_node() {
    Some(node) => node.to_js()
    None => @js.null_()
  }
}

///|
pub impl Node_ for Element with child_nodes_(self) {
  self.child_nodes()
}

///|
pub impl Node_ for Element with first_child_(self) {
  match self.first_child() {
    Some(node) => node.to_js()
    None => @js.null_()
  }
}

///|
pub impl Node_ for Element with last_child_(self) {
  match self.last_child() {
    Some(node) => node.to_js()
    None => @js.null_()
  }
}

///|
pub impl Node_ for Element with previous_sibling_(self) {
  match self.previous_sibling() {
    Some(node) => node.to_js()
    None => @js.null_()
  }
}

///|
pub impl Node_ for Element with next_sibling_(self) {
  match self.next_sibling() {
    Some(node) => node.to_js()
    None => @js.null_()
  }
}

///|
pub impl Node_ for Element with append_child_(self, child) {
  let result = self.to_js().call_method("appendChild", [child])
  result
}

///|
pub impl Node_ for Element with remove_child_(self, child) {
  self.to_js().call_method("removeChild", [child])
}

///|
pub impl Node_ for Element with insert_before_(self, new_node, ref_node) {
  self.to_js().call_method("insertBefore", [new_node, ref_node])
}

///|
pub impl Node_ for Element with replace_child_(self, new_child, old_child) {
  self.to_js().call_method("replaceChild", [new_child, old_child])
}

///|
pub impl Node_ for Element with clone_node_(self, deep) {
  self.clone_node(deep).to_js()
}

///|
pub impl Node_ for Element with contains_(self, other) {
  // containsはElement型を要求するが、Valを受け取るのでcastが必要
  let elem : Element = other.cast()
  self.contains(elem)
}

///|
pub impl Node_ for Element with has_child_nodes_(self) {
  self.has_child_nodes()
}

///|
pub impl Node_ for Element with text_content_(self) {
  self.text_content()
}

///|
pub impl Node_ for Element with set_text_content_(self, text) {
  self.set_text_content(text)
}
