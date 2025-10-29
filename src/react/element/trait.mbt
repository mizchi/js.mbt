pub(open) trait ReactNode {
  to_react_node(Self) -> @js.Value
}

pub impl ReactNode for String with to_react_node(self) {
  self |> @js.to_js
}
pub impl ReactNode for @react.Element with to_react_node(self) {
  self |> @js.identity
}
pub impl ReactNode for Int with to_react_node(self) {
  self |> @js.to_js
}
pub impl ReactNode for Double with to_react_node(self) {
  self |> @js.to_js
}

pub impl ReactNode for Bool with to_react_node(self) {
  self |> @js.to_js
}

pub impl[T: ReactNode] ReactNode for T? with to_react_node(self) {
  match self {
    Some(v) => v.to_react_node()
    None => @js.js_undefined()
  }
}