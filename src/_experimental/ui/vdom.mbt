///| Pure MoonBit Virtual DOM Implementation

///|

///|
/// Virtual Node - Pure MoonBit representation of UI tree
pub enum VNode {
  Element(ElementNode)
  Text(String)
  Component(ComponentNode)
  Fragment(Array[VNode])
  Empty
}

///|

///|
/// DOM Element node
/// Props is Array[(String, AttrValue)] for type safety and comparability
pub struct ElementNode {
  tag : String
  props : Props
  children : Array[VNode]
  key : String?
}

///|

///|
/// Component function node
pub struct ComponentNode {
  render : () -> VNode
  key : String?
  // hooks_state : HooksState  // TODO: Will be added in Phase 5
}

///|

///|
/// Event handler type
pub type EventHandler = (@core.Any) -> Unit

///|

///|
/// Attribute value - typed representation of prop values
pub enum AttrValue {
  Str(String) // String attribute (className, id, href, etc.)
  Num(Int) // Numeric attribute (tabIndex, maxLength, etc.)
  Bool(Bool) // Boolean attribute (disabled, checked, etc.)
  Handler(EventHandler) // Event handler (onClick, onChange, etc.)
  StyleObj(Array[(String, String)]) // Style object {color: "red", fontSize: "16px"}
}

///|

///|
/// Props - array of key-value pairs
pub type Props = Array[(String, AttrValue)]

///|

///|
/// Compare two AttrValue instances for equality
/// Note: Handlers are always considered different
pub fn compare_attr_value(a : AttrValue, b : AttrValue) -> Bool {
  match (a, b) {
    (Str(s1), Str(s2)) => s1 == s2
    (Num(n1), Num(n2)) => n1 == n2
    (Bool(b1), Bool(b2)) => b1 == b2
    (Handler(_), Handler(_)) => false // Functions cannot be compared
    (StyleObj(s1), StyleObj(s2)) => compare_style_arrays(s1, s2)
    _ => false // Different types
  }
}

///|

///|
/// Compare two style arrays for equality
fn compare_style_arrays(
  s1 : Array[(String, String)],
  s2 : Array[(String, String)],
) -> Bool {
  if s1.length() != s2.length() {
    return false
  }
  for i = 0; i < s1.length(); i = i + 1 {
    let (k1, v1) = s1[i]
    let (k2, v2) = s2[i]
    if k1 != k2 || v1 != v2 {
      return false
    }
  }
  true
}

///|

///|
/// Compare two Props for equality
pub fn compare_props(p1 : Props, p2 : Props) -> Bool {
  if p1.length() != p2.length() {
    return false
  }
  for i = 0; i < p1.length(); i = i + 1 {
    let (k1, v1) = p1[i]
    let (k2, v2) = p2[i]
    if k1 != k2 || not(compare_attr_value(v1, v2)) {
      return false
    }
  }
  true
}

///|

///|
/// Helper to check if VNode is empty
pub fn VNode::is_empty(self : VNode) -> Bool {
  match self {
    Empty => true
    _ => false
  }
}

///|

///|
/// Get key from VNode if it has one
pub fn VNode::get_key(self : VNode) -> String? {
  match self {
    Element({ key, .. }) => key
    Component({ key, .. }) => key
    _ => None
  }
}

///|

///|
/// Debug representation of VNode
pub fn VNode::debug_string(self : VNode) -> String {
  match self {
    Empty => "Empty"
    Text(content) => "Text(\"\{content}\")"
    Element({ tag, children, .. }) =>
      "Element(\{tag}, \{children.length()} children)"
    Component(_) => "Component(...)"
    Fragment(children) => "Fragment(\{children.length()} children)"
  }
}
