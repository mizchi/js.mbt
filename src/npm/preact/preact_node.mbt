///|
/// PreactNode trait - types that can be children in Preact
pub trait PreactNode {
  to_preact_node(Self) -> @js.Any
}

///|
pub impl PreactNode for VNode with to_preact_node(self) {
  @js.identity(self)
}

///|
pub impl PreactNode for String with to_preact_node(self) {
  @js.identity(self)
}

///|
pub impl PreactNode for Int with to_preact_node(self) {
  @js.identity(self)
}

///|
pub impl PreactNode for Double with to_preact_node(self) {
  @js.identity(self)
}

///|
pub impl PreactNode for Bool with to_preact_node(self) {
  @js.identity(self)
}

///|
pub impl[T : PreactNode] PreactNode for Array[T] with to_preact_node(self) {
  @js.from_array(self.map(_.to_preact_node()))
}

///|
pub impl[T : PreactNode] PreactNode for T? with to_preact_node(self) {
  match self {
    Some(v) => v.to_preact_node()
    None => @js.null_()
  }
}
