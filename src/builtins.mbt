///|
/// Convert a MoonBit Array to a JavaScript array.
///
/// # Safety
///
/// This uses `unsafe_cast` to directly convert the array representation.
///
/// # Parameters
///
/// - `arr`: A MoonBit Array of any type
///
/// # Returns
///
/// A JavaScript array with the same elements
///
/// # Example
///
/// ```moonbit
/// let arr = [1, 2, 3, 4, 5]
/// let js_arr = from_array(arr)
/// // JavaScript: [1, 2, 3, 4, 5]
/// ```
// pub fn[T] from_array(arr : Array[T]) -> Val {
//   arr |> unsafe_cast
// }

///|
/// Create a new empty JavaScript array.
///
/// Equivalent to JavaScript's `[]` or `new Array()`.
///
/// # Returns
///
/// A new empty array as a Val
///
/// # Example
///
/// ```moonbit
/// let arr = new_empty_array()
/// arr.set(0, "first")
/// arr.set(1, "second")
/// ```
pub fn new_empty_array() -> Val {
  ffi_new_empty_array()
}

///|
/// Create a new JavaScript Symbol with a description.
///
/// # Parameters
///
/// - `name`: The description for the symbol
///
/// # Returns
///
/// A new Symbol
///
/// # Example
///
/// ```moonbit
/// let sym = symbol("mySymbol")
/// let obj = new_empty_object()
/// obj.set(sym, "value")
/// ```
pub fn symbol(name : String) -> Symbol {
  ffi_symbol(name)
}

///|
/// Get the well-known Symbol.iterator symbol.
///
/// Used to make objects iterable in JavaScript.
///
/// # Returns
///
/// The Symbol.iterator symbol
///
/// # Example
///
/// ```moonbit
/// let iter_sym = symbol_iterator()
/// // Use to implement custom iterators
/// ```
pub fn symbol_iterator() -> Symbol {
  ffi_symbol_iterator()
}

///|
/// Get the well-known Symbol.dispose symbol.
///
/// Used for explicit resource management (using statement).
///
/// # Returns
///
/// The Symbol.dispose symbol
pub fn symbol_dispose() -> Symbol {
  ffi_symbol_dispose()
}

///|
/// Get the well-known Symbol.asyncDispose symbol.
///
/// Used for asynchronous resource management.
///
/// # Returns
///
/// The Symbol.asyncDispose symbol
pub fn symbol_async_dispose() -> Symbol {
  ffi_symbol_async_dispose()
}

///|
pub fn from_builtin_json(j : Json) -> Val {
  Js::to_js(j)
}

///|
pub impl ToJson for Val with to_json(self) -> Json {
  if self.is_none() {
    return null
  }
  if type_of(self) == "boolean" {
    let v : Bool = unsafe_cast(self)
    return v.to_json()
  }
  if type_of(self) == "number" {
    let v : Double = unsafe_cast(self)
    return v.to_json()
  }
  if type_of(self) == "string" {
    let v : String = unsafe_cast(self)
    return v.to_json()
  }
  if is_array(self) {
    let len : Int = unsafe_cast(self.invoke("length", []))
    let arr : Array[Json] = []
    for i = 0; i < len; i = i + 1 {
      let v = self.get(i.to_string())
      arr.push(v.to_json())
    }
    return arr.to_json()
  }
  if type_of(self) == "object" {
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
pub impl Js for Json with to_js(self) -> Val {
  match self {
    Json::Null => null_()
    Json::String(s) => js(s)
    Json::Number(n, ..) => js(n)
    Json::True => js(true)
    Json::False => js(false)
    Json::Object(o) => {
      let obj = new_empty_object()
      for k, v in o {
        let v : Val = Js::to_js(v)
        obj.set(k, v)
      }
      obj
    }
    Json::Array(a) => {
      let arr = new_empty_array()
      for v in a {
        let v : Val = Js::to_js(v)
        arr.invoke("push", [v]) |> ignore
      }
      arr
    }
  }
}
