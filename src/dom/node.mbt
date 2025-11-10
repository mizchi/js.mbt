/// TODO: Node/Element/HTMLElement/EventTarget

///|
#alias(parentNode)
pub fn Element::parent_node(self : Self) -> Element? {
  self.to_js().get("parentNode").cast_option()
}

///|
#alias(nextSibling)
pub fn Element::next_sibling(self : Self) -> Element? {
  self.to_js().get("nextSibling").cast_option()
}

///|
#alias(previousSibling)
pub fn Element::previous_sibling(self : Self) -> Element? {
  self.to_js().get("previousSibling").cast_option()
}

///|
#alias(firstChild)
pub fn Element::first_child(self : Self) -> Element? {
  self.to_js().get("firstChild").cast_option()
}

///|
#alias(lastChild)
pub fn Element::last_child(self : Self) -> Element? {
  self.to_js().get("lastChild").cast_option()
}

///|
#alias(parentElement)
pub fn Element::parent_element(self : Self) -> Element? {
  self.to_js().get("parentElement").cast_option()
}

///|
/// TODO: Node API
#alias(nodeValue)
pub fn Element::node_value(self : Self) -> Int {
  self.to_js().get("nodeValue").cast()
}

///|
#alias(textContent)
pub fn Element::text_content(self : Self) -> String {
  self.to_js().get("textContent").cast()
}
