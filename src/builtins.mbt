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
      let obj = Object::new()
      for k, v in o {
        let v : Val = Js::to_js(v)
        obj.set(k, v)
      }
      obj.to_js()
    }
    Json::Array(a) => {
      let arr = JsArray::new()
      for v in a {
        let v : Val = Js::to_js(v)
        arr.invoke("push", [v]) |> ignore
      }
      arr.to_js()
    }
  }
}
