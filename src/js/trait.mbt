///|
pub(open) trait ToJs {
  to_js(Self) -> Value
}

///|
pub impl ToJs for Value with to_js(self) -> Value {
  self
}

///|
pub impl ToJs for String with to_js(self) -> Value {
  to_js(self)
}

///|
pub impl ToJs for Double with to_js(self) -> Value {
  to_js(self)
}

///|
pub impl ToJs for Int with to_js(self) -> Value {
  to_js(self.to_double())
}

///|
pub impl ToJs for Bool with to_js(self) -> Value {
  to_js(self)
}

///|
pub impl ToJs for Map[String, &ToJs] with to_js(self) -> Value {
  let obj = new_object()
  for k, v in self {
    obj.set(k, v.to_js())
  }
  obj
}

///|
pub impl ToJs for Array[&ToJs] with to_js(self) -> Value {
  let arr = new_array()
  for v in self {
    arr.push(v.to_js())
  }
  arr
}

///|
pub impl ToJs for Json with to_js(self) -> Value {
  match self {
    Json::Null => js_null()
    Json::String(s) => to_js(s)
    Json::Number(n, ..) => to_js(n)
    Json::True => to_js(true)
    Json::False => to_js(false)
    Json::Object(o) => {
      let obj = new_object()
      for k, v in o {
        obj.set(k, v)
      }
      obj
    }
    Json::Array(a) => {
      let arr = new_array()
      for v in a {
        arr.push_internal(ToJs::to_js(v))
      }
      arr
    }
  }
}

///|
pub impl ToJson for Value with to_json(self) -> Json {
  if self.is_null() || self.is_undefined() {
    return null
  }
  if self.is_boolean() {
    let v : Bool = self.cast()
    return if v { false } else { true }
  }
  if self.is_number() {
    let v : Double = self.cast()
    return v.to_json()
  }
  if self.is_string() {
    let v : String = self.cast()
    return v.to_json()
  }
  if self.is_array() {
    let len : Int = self.length()
    let arr : Array[Json] = []
    for i = 0; i < len; i = i + 1 {
      let v = self.get(i.to_string())
      arr.push(v.to_json())
    }
    return arr.to_json()
  }
  if self.is_object() {
    let out : Map[String, Json] = {}
    let keys = self |> Object::keys()
    for k in keys {
      let v = self.get(k)
      out[k] = v.to_json()
    }
    return out.to_json()
  }
  return {}
}
