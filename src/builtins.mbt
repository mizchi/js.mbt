///|
pub fn from_builtin_json(j : Json) -> Val {
  JsImpl::to_js(j)
}

///|
pub impl ToJson for Val with to_json(self) -> Json {
  if self.is_none() {
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
    let len : Int = unsafe_cast(self.invoke("length", []))
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
pub impl JsImpl for Json with to_js(self) -> Val {
  match self {
    Null => null_()
    String(s) => js(s)
    Number(n, ..) => js(n)
    True => js(true)
    False => js(false)
    Object(o) => {
      let obj = Object::new()
      for k, v in o {
        let v : Val = JsImpl::to_js(v)
        obj.set(k, v)
      }
      obj.to_js()
    }
    Array(a) => {
      let arr = JsArray::new()
      for v in a {
        let v : Val = JsImpl::to_js(v)
        arr.invoke("push", [v]) |> ignore
      }
      arr.to_js()
    }
  }
}
