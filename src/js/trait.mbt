///|
pub(open) trait ToJsValue {
  to_js(Self) -> Value
}

///|
pub impl ToJsValue for Value with to_js(self) -> Value {
  self
}

///|
pub impl ToJsValue for String with to_js(self) -> Value {
  Value::cast_from(self)
}

///|
pub impl ToJsValue for Double with to_js(self) -> Value {
  Value::cast_from(self)
}

///|
pub impl ToJsValue for Int with to_js(self) -> Value {
  Value::cast_from(self.to_double())
}

///|
pub impl ToJsValue for Bool with to_js(self) -> Value {
  Value::cast_from(self)
}

///|
pub impl ToJsValue for Map[String, &ToJsValue] with to_js(self) -> Value {
  let obj = Value::new_object()
  for k, v in self {
    obj.set(k, v.to_js())
  }
  obj
}

///|
pub impl ToJsValue for Array[&ToJsValue] with to_js(self) -> Value {
  let arr = Value::new_array()
  for v in self {
    arr.push(v.to_js())
  }
  arr
}

///|
pub impl ToJsValue for Json with to_js(self) -> Value {
  match self {
    Json::Null => Value::js_null()
    Json::String(s) => Value::cast_from(s)
    Json::Number(n, ..) => Value::cast_from(n)
    Json::True => Value::cast_from(true)
    Json::False => Value::cast_from(false)
    Json::Object(o) => {
      let obj = Value::new_object()
      for k, v in o {
        obj.set(k, v)
      }
      obj
    }
    Json::Array(a) => {
      let arr = Value::new_array()
      for v in a {
        arr.push_internal(ToJsValue::to_js(v))
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
    let keys = self.keys()
    for k in keys {
      let v = self.get(k)
      out[k] = v.to_json()
    }
    return out.to_json()
  }
  return {}
}
