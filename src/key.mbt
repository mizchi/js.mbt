///|
#external
pub type Symbol

///|
/// key for js object access
pub trait PropertyKey {
  to_key(Self) -> Val
}

///|
pub impl PropertyKey for String with to_key(self) -> Val {
  Js::to_js(self)
}

///|
pub impl PropertyKey for Int with to_key(self) -> Val {
  Js::to_js(self)
}

///|
pub impl PropertyKey for Symbol with to_key(self) -> Val {
  self |> js
}
