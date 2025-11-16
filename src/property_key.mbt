///|
/// key for js object access
pub trait PropertyKey {
  to_key(Self) -> Val = _
}

///|
impl PropertyKey with to_key(self) -> Val {
  self |> unsafe_cast
}

///|
pub impl PropertyKey for String

///|
pub impl PropertyKey for Int

///|
pub impl PropertyKey for Symbol
