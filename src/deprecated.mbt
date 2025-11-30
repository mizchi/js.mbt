///| Deprecated functions - Use @mbtconv package instead

///|
/// Convert a MoonBit Map to a JavaScript object.
#deprecated("Use @mbtconv.from_map instead for better performance with @nostd.Any")
pub fn from_map(map : Map[String, Any]) -> Any {
  let obj = Object::new()
  for k, v in map {
    let v : Any = JsImpl::as_any(v)
    obj.set(k, v)
  }
  obj.as_any()
}

///|
/// Convert a MoonBit Map with optional values to a JavaScript object.
#deprecated("Use @mbtconv.from_option_map instead for better performance with @nostd.Any")
pub fn from_option_map(map : Map[String, Any?]) -> Any {
  let obj = Object::new()
  for k, v in map {
    if v is Some(val) && not(ffi_is_nullish(val)) {
      obj.set(k, val)
    }
  }
  obj.as_any()
}

///|
/// Convert a MoonBit Map with optional values to a JavaScript object,
/// returning undefined if all properties are None or nullish.
#deprecated("Use @mbtconv.from_option_map_or_undefined instead for better performance with @nostd.Any")
pub fn from_option_map_or_undefined(map : Map[String, Any?]) -> Any {
  let obj = Object::new()
  let mut has_value = false
  for k, v in map {
    if v is Some(val) && not(ffi_is_nullish(val)) {
      obj.set(k, val)
      has_value = true
    }
  }
  if has_value {
    obj.as_any()
  } else {
    undefined()
  }
}

///|
/// Convert MoonBit's builtin `Json` type to JavaScript `Js` value.
#deprecated("Use @mbtconv.from_json instead for better performance with @nostd.Any")
pub fn from_json(j : Json) -> Any {
  JsImpl::as_any(j)
}

///|
/// Use @mbtconv.to_json instead for better performance with @nostd.Any
pub impl ToJson for Any with to_json(self) -> Json {
  if is_nullish(self) {
    return null
  }
  match typeof_(self) {
    "boolean" => {
      let v : Bool = identity(self)
      return v.to_json()
    }
    "number" => {
      let v : Double = identity(self)
      return v.to_json()
    }
    "string" => {
      let v : String = identity(self)
      return v.to_json()
    }
    _ => ()
  }
  if is_array(self) {
    let len : Int = self.get("length").cast()
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
/// Use @mbtconv.from_json instead for better performance with @nostd.Any
pub impl JsImpl for Json with as_any(self) -> Any {
  match self {
    Null => null_()
    String(s) => any(s)
    Number(n, ..) => any(n)
    True => any(true)
    False => any(false)
    Object(o) => {
      let obj = Object::new()
      for k, v in o {
        let v : Any = JsImpl::as_any(v)
        obj.set(k, v)
      }
      obj
    }
    Array(a) => {
      let arr : Array[Any] = []
      for v in a {
        arr.push(JsImpl::as_any(v))
      }
      from_array(arr)
    }
  }
}
