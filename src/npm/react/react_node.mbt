///|
/// Renderable React node types.
/// Int, Double, Bool, String, ReactElement, Array of ReactNode, Option of ReactNode
pub(open) trait ReactNode {
  to_react_node(Self) -> @js.Any
}

///|
pub impl ReactNode for String with to_react_node(self) {
  self |> @js.any
}

///|
pub impl ReactNode for Element with to_react_node(self) {
  self |> @js.any
}

///|
pub impl ReactNode for Int with to_react_node(self) {
  self |> @js.any
}

///|
pub impl ReactNode for Double with to_react_node(self) {
  self |> @js.any
}

///|
pub impl ReactNode for Bool with to_react_node(self) {
  self |> @js.any
}

///|
pub impl ReactNode for Array[&ReactNode] with to_react_node(self) {
  @js.from_array(self.map(x => x.to_react_node())).cast()
}

///|
pub impl[T : ReactNode] ReactNode for T? with to_react_node(self) {
  match self {
    Some(v) => v.to_react_node()
    None => @js.undefined()
  }
}
