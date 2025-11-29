///|
/// null | undefined | T
#external
pub type Nullish

///|
pub fn Nullish::to_optional(self : Self) -> JsValue? {
  if is_nullish(self |> JsValue::from) {
    None
  } else {
    Some(self |> JsValue::from)
  }
}

///|
/// null or T
#external
pub type Nullable

///|
pub fn Nullable::to_optional(self : Self) -> JsValue? {
  if is_null(self |> JsValue::from) {
    None
  } else {
    Some(self |> JsValue::from)
  }
}
