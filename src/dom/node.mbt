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
