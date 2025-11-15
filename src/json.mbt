///|
pub fn json_stringify(
  v : Val,
  replacer? : Val = undefined(),
  space? : Int = 2,
) -> String {
  ffi_json_stringify(v.to_js(), replacer, space |> js)
}

///|
pub fn json_parse(s : String, reviver? : Val? = None) -> Val raise JsError {
  throwable(() => ffi_json_parse(s, reviver?))
}

///|
test "json_stringify" {
  let arr : Array[Int] = [1] |> unsafe_cast
  arr |> inspect(content="[1]")
  json_stringify(arr |> from_builtin_array, space=2)
  |> inspect(
    content=(
      #|[
      #|  1
      #|]
    ),
  )
  let v = from_builtin_map({
    "key1": 123 |> js,
    "key2": 456 |> js,
    "key3": 789 |> js,
  })
  json_stringify(v, space=2)
  |> inspect(
    content=(
      #|{
      #|  "key1": 123,
      #|  "key2": 456,
      #|  "key3": 789
      #|}
    ),
  )
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
  if self.type_of() == "boolean" {
    let v : Bool = self.cast()
    return v.to_json()
  }
  if self.type_of() == "number" {
    let v : Double = self.cast()
    return v.to_json()
  }
  if self.type_of() == "string" {
    let v : String = self.cast()
    return v.to_json()
  }
  if self.is_array() {
    let len : Int = self.invoke("length", []).cast()
    let arr : Array[Json] = []
    for i = 0; i < len; i = i + 1 {
      let v = self.get(i.to_string())
      arr.push(v.to_json())
    }
    return arr.to_json()
  }
  if self.type_of() == "object" {
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

///|
test "from_builtin_json" {
  inspect(
    from_builtin_json({
      "value": null,
      "items": [1, 2, 3],
      "nested": { "key": "value" },
    }),
    content=(
      #|{"value":null,"items":[1,2,3],"nested":{"key":"value"}}
    ),
  )
  inspect(
    from_builtin_json({ "age": 30, "name": "Alice" }),
    content=(
      #|{"age":30,"name":"Alice"}
    ),
  )
}

///|
test "json::to_js" {
  let j : Json = { "items": [1, 2, 3], "nested": { "key": "value" } }
  let v : Val = Js::to_js(j)
  assert_eq(v.get("items").get("0").cast(), 1)
  assert_eq(v.get("nested").get("key").cast(), "value")
}
