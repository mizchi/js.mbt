// This module provides conversion utilities between MoonBit and JavaScript types.
//
// Main functions:
// - from_array() - Convert MoonBit Array to JS Array
// - from_map() - Convert MoonBit Map to JS Object
// - from_entries() - Convert tuple array to JS Object
// - from_entries_option() - Convert optional tuple array to JS Object
// - from_fn0/1/2/3() - Convert MoonBit functions to JS functions
// - from_builtin_json() - Convert MoonBit Json to JS Object
// - to_json() / to_js() - Bidirectional conversion between Json and Js

///|
/// Cast a MoonBit Array to a JavaScript array.
pub fn[T : JsImpl] from_array(v : Array[T]) -> Js {
  unsafe_cast(v.map(_.to_js()))
}

///|
/// Convert a MoonBit Map to a JavaScript object.
///
/// # Example
///
/// ```moonbit
/// let _obj = from_map({ "name": js("Alice"), "age": js(30) })
/// // JavaScript: { name: "Alice", age: 30 }
/// ```
pub fn from_map(map : Map[String, Js]) -> Js {
  let obj = Object::new()
  for k, v in map {
    let v : Js = JsImpl::to_js(v)
    obj.set(k, v)
  }
  obj.to_js()
}

///|
/// Convert an array of tuples to a JavaScript object.
///
/// # Example
///
/// ```moonbit
/// let _obj = from_entries([("name", "Alice"), ("age", 30)])
/// // JavaScript: { name: "Alice", age: 30 }
/// ```
pub fn from_entries(entries : Array[(String, &JsImpl)]) -> Js {
  let obj = Object::new()
  for entry in entries {
    let (k, v) = entry
    obj.set(k, v.to_js())
  }
  obj.to_js()
}

///|
/// Convert an array of tuples with optional values to a JavaScript object.
/// Only sets properties where the value is Some.
///
/// **Use this when values have mixed types (String, Int, Bool, etc).**
/// For single-type values, use `from_entries_option_cast` which has better type inference.
///
/// # Example
///
/// ```moonbit
/// let _obj = from_entries_option([
///   ("name", Some("Alice")),  // String
///   ("age", Some(30)),        // Int
///   ("active", Some(true)),   // Bool - mixed types!
///   ("email", None)
/// ])
/// // JavaScript: { name: "Alice", age: 30, active: true }
/// ```
pub fn from_entries_option(entries : Array[(String, &JsImpl?)]) -> Js {
  let obj = Object::new()
  for entry in entries {
    let (k, v) = entry
    match v {
      Some(val) => obj.set(k, val.to_js())
      None => ()
    }
  }
  obj.to_js()
}

///|
/// Convert an array of tuples with optional values to a JavaScript object.
/// Accepts Option[T] where T: JsImpl directly without requiring .map().
/// Only sets properties where the value is Some.
///
/// # Example
///
/// ```moonbit
/// // All values are Bool - use this function!
/// let _obj = from_entries_option_cast([
///   ("open", Some(true)),
///   ("readOnly", Some(false)),
///   ("timeout", None)
/// ])
/// // JavaScript: { open: true, readOnly: false }
/// ```
pub fn[T : JsImpl] from_entries_option_cast(
  entries : Array[(String, T?)],
) -> Js {
  let obj = Object::new()
  for entry in entries {
    let (k, v) = entry
    match v {
      Some(val) => obj.set(k, val.to_js())
      None => ()
    }
  }
  obj.to_js()
}

///|
/// Cast a MoonBit function with 0 arguments to a JavaScript function Val.
pub fn[R] from_fn0(f : () -> R) -> Js {
  unsafe_cast(f)
}

///|
/// Cast a MoonBit function with 1 argument to a JavaScript function Val.
pub fn[A, R] from_fn1(f : (A) -> R) -> Js {
  unsafe_cast(f)
}

///|
/// Cast a MoonBit function with 2 arguments to a JavaScript function Val.
pub fn[A, B, R] from_fn2(f : (A, B) -> R) -> Js {
  unsafe_cast(f)
}

///|
/// Cast a MoonBit function with 3 arguments to a JavaScript function Val.
pub fn[A, B, C, R] from_fn3(f : (A, B, C) -> R) -> Js {
  unsafe_cast(f)
}

///|
pub fn from_builtin_json(j : Json) -> Js {
  JsImpl::to_js(j)
}

///|
pub impl ToJson for Js with to_json(self) -> Json {
  if is_nullish(self) {
    return null
  }
  match typeof_(self) {
    "boolean" => {
      // let v : Bool = unsafe_cast(self)
      let v : Bool = unsafe_cast(self)
      return v.to_json()
    }
    "number" => {
      let v : Double = unsafe_cast(self)
      return v.to_json()
    }
    "string" => {
      let v : String = unsafe_cast(self)
      return v.to_json()
    }
    _ => ()
  }
  if is_array(self) {
    let len : Int = self.call0("length") |> unsafe_cast
    let arr : Array[Json] = []
    for i = 0; i < len; i = i + 1 {
      let v = self.get(i.to_string())
      arr.push(v.to_json())
    }
    return arr.to_json()
  }
  if typeof_(self) == "object" {
    let out : Map[String, Json] = {}
    let keys = self |> ffi_object_keys()
    for k in keys {
      let v = self.get(k)
      out[k] = v.to_json()
    }
    return out.to_json()
  }
  return {}
}

///|
pub impl JsImpl for Json with to_js(self) -> Js {
  match self {
    Null => null_()
    String(s) => js(s)
    Number(n, ..) => js(n)
    True => js(true)
    False => js(false)
    Object(o) => {
      let obj = Object::new()
      for k, v in o {
        let v : Js = JsImpl::to_js(v)
        obj.set(k, v)
      }
      obj.to_js()
    }
    Array(a) => {
      let arr = JsArray::new()
      for v in a {
        let v : Js = JsImpl::to_js(v)
        arr.call("push", [v]) |> ignore
      }
      arr.to_js()
    }
  }
}
