///|
/// Unsafely cast a value from one type to another.
pub fn[A, B] unsafe_cast(a : A) -> B = "%identity"

///|
/// Cast any MoonBit Js-implementing type to a JavaScript Val safely.
pub fn js(a : &JsImpl) -> Js {
  unsafe_cast(a.to_js())
}

///|
/// Convert any MoonBit value to a JavaScript Val.
pub fn[T] unsafe_js(v : T) -> Js {
  unsafe_cast(v)
}

///|
/// Safely convert a JavaScript Val to an Option type.
/// Without check, Moonbit FFI will touch (null).toString() and crash.
pub fn[A] unsafe_option(v : Js) -> A? {
  if v.is_some() {
    Some(unsafe_cast(v))
  } else {
    None
  }
}
