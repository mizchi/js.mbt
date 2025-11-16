///|
test "json::to_js" {
  let j : Json = { "items": [1, 2, 3], "nested": { "key": "value" } }
  let v : Val = Js::to_js(j)
  assert_eq(unsafe_cast(v.get("items").get("0")), 1)
  assert_eq(unsafe_cast(v.get("nested").get("key")), "value")
}

///|
fn[T] is_builtin_trait(v : T) -> Bool {
  let v : Val = v |> unsafe_cast
  v.has_own_property("self") && v.has_own_property("method_0")
}

///|
test "is_builtin_trait" {
  let show : &Show = "hello"
  assert_true(is_builtin_trait(show))
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
