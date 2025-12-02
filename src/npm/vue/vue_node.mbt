///|
/// VueNode trait - types that can be children in Vue
pub trait VueNode {
  to_vue_node(Self) -> @nostd.Any
}

///|
pub impl VueNode for VNode with to_vue_node(self) {
  @nostd.identity(self)
}

///|
pub impl VueNode for String with to_vue_node(self) {
  @nostd.identity(self)
}

///|
pub impl VueNode for Int with to_vue_node(self) {
  @nostd.identity(self)
}

///|
pub impl VueNode for Double with to_vue_node(self) {
  @nostd.identity(self)
}

///|
pub impl VueNode for Bool with to_vue_node(self) {
  @nostd.identity(self)
}

///|
pub impl[T : VueNode] VueNode for Array[T] with to_vue_node(self) {
  @js.from_array(self.map(_.to_vue_node()))
}

///|
pub impl[T : VueNode] VueNode for T? with to_vue_node(self) {
  match self {
    Some(v) => v.to_vue_node()
    None => @nostd.null()
  }
}
