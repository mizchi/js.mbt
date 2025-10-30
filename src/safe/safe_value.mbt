///|
#external
pub type SafeValue

///|
pub impl ToJs for SafeValue with to_js(self) -> @js.Value {
  self |> @js.to_js
}

///|
pub(open) trait ToSafeValue {
  to_safe_value(Self) -> SafeValue
}

///|
pub impl ToSafeValue for Value with to_safe_value(v) {
  v |> identity
}

///|
pub impl ToSafeValue for &ToJs with to_safe_value(v) -> SafeValue {
  v.to_js() |> identity
}

///|
pub fn as_string(self : SafeValue) -> String? {
  if self.to_js().is_string() {
    self |> identity
  } else {
    None
  }
}

///|
pub fn as_int(self : SafeValue) -> Int? {
  match self.as_double() {
    Some(d) => if d == d.ceil() { Some(d.to_int()) } else { None }
    None => None
  }
}

///|
pub fn as_double(self : SafeValue) -> Double? {
  if self.to_js().is_number() {
    self |> identity
  } else {
    None
  }
}

///|
pub fn as_object(self : SafeValue) -> SafeObject? {
  if self.to_js().is_object() {
    self |> identity
  } else {
    None
  }
}
