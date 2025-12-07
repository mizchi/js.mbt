///| Element creation DSL

///|

///|
/// Create element VNode - accepts Props type
pub fn el(tag : String, props : Props, children : Array[VNode]) -> VNode {
  VNode::Element(ElementNode::{ tag, props, children, key: None })
}

///|

///|
/// Create element with key
pub fn el_key(
  tag : String,
  props : Props,
  children : Array[VNode],
  key : String,
) -> VNode {
  VNode::Element(ElementNode::{ tag, props, children, key: Some(key) })
}

///| Common HTML elements

///|
pub fn div(props : Props, children : Array[VNode]) -> VNode {
  el("div", props, children)
}

///|
pub fn span(props : Props, children : Array[VNode]) -> VNode {
  el("span", props, children)
}

///|
pub fn p(props : Props, children : Array[VNode]) -> VNode {
  el("p", props, children)
}

///|
pub fn button(props : Props, children : Array[VNode]) -> VNode {
  el("button", props, children)
}

///|
pub fn a(props : Props, children : Array[VNode]) -> VNode {
  el("a", props, children)
}

///|
pub fn input(props : Props) -> VNode {
  el("input", props, [])
}

///|
pub fn textarea(props : Props, children : Array[VNode]) -> VNode {
  el("textarea", props, children)
}

///|
pub fn form(props : Props, children : Array[VNode]) -> VNode {
  el("form", props, children)
}

///|
pub fn label(props : Props, children : Array[VNode]) -> VNode {
  el("label", props, children)
}

///|
pub fn h1(props : Props, children : Array[VNode]) -> VNode {
  el("h1", props, children)
}

///|
pub fn h2(props : Props, children : Array[VNode]) -> VNode {
  el("h2", props, children)
}

///|
pub fn h3(props : Props, children : Array[VNode]) -> VNode {
  el("h3", props, children)
}

///|
pub fn h4(props : Props, children : Array[VNode]) -> VNode {
  el("h4", props, children)
}

///|
pub fn h5(props : Props, children : Array[VNode]) -> VNode {
  el("h5", props, children)
}

///|
pub fn h6(props : Props, children : Array[VNode]) -> VNode {
  el("h6", props, children)
}

///|
pub fn ul(props : Props, children : Array[VNode]) -> VNode {
  el("ul", props, children)
}

///|
pub fn ol(props : Props, children : Array[VNode]) -> VNode {
  el("ol", props, children)
}

///|
pub fn li(props : Props, children : Array[VNode]) -> VNode {
  el("li", props, children)
}

///|
pub fn img(props : Props) -> VNode {
  el("img", props, [])
}

///|
/// br with no props
pub fn br() -> VNode {
  el("br", [], [])
}

///|
/// hr with no props
pub fn hr() -> VNode {
  el("hr", [], [])
}

///| Text and Fragment

///|

///|
/// Create text node
pub fn text(content : String) -> VNode {
  VNode::Text(content)
}

///|

///|
/// Create fragment
pub fn fragment(children : Array[VNode]) -> VNode {
  VNode::Fragment(children)
}

///|

///|
/// Empty node (renders nothing)
pub fn empty() -> VNode {
  VNode::Empty
}
