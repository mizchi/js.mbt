///|
/// key for js object access
pub trait Key {
  to_key(Self) -> Val
}

///|
pub impl Key for String with to_key(self) -> Val {
  self |> js
}

///|
pub impl Key for Int with to_key(self) -> Val {
  self |> js
}

///|
pub impl Key for Symbol with to_key(self) -> Val {
  self |> js
}
