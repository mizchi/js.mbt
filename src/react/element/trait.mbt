///|
pub(open) trait ReactNode {
  to_react_node(Self) -> @js.Value
}

///|
pub impl ReactNode for String with to_react_node(self) {
  self |> @js.to_js
}

///|
pub impl ReactNode for @react.Element with to_react_node(self) {
  self |> @js.identity
}

///|
pub impl ReactNode for Int with to_react_node(self) {
  self |> @js.to_js
}

///|
pub impl ReactNode for Double with to_react_node(self) {
  self |> @js.to_js
}

///|
pub impl ReactNode for Bool with to_react_node(self) {
  self |> @js.to_js
}

///|
pub impl[T : ReactNode] ReactNode for T? with to_react_node(self) {
  match self {
    Some(v) => v.to_react_node()
    None => @js.js_undefined()
  }
}

// pub(open) trait ToProps {
//   to_props(Self) -> @js.Value
// }

// pub impl ToProps for &ToJson with to_props(self) -> @js.Value {
//   self.to_json() |> @js.to_js
// }

// priv struct ExampleProps {
//   title : String
//   count : Int
// } derive(ToJson)

// fn get_props(t: &ToJson) -> @js.Value {
//   @js.log(t.to_json())
//   t.to_json() |> @js.to_js
// }

// test "to props interface test" {
//   let ex = ExampleProps::{
//     title : "Test",
//     count : 42
//   }
//   let props = get_props(ex)
//   assert_eq(props.get_as("title"), "Test")
//   // assert_eq(props.get("count"), 42)
// }