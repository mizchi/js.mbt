///|
test "json::to_js" {
  let j : Json = { "items": [1, 2, 3], "nested": { "key": "value" } }
  let v : Val = Js::to_js(j)
  assert_eq(unsafe_cast(v.get("items").get("0")), 1)
  assert_eq(unsafe_cast(v.get("nested").get("key")), "value")
}

///|
test "is_builtin_trait" {
  let show : &Show = "hello"
  let v : Val = unsafe_cast(show)
  assert_true(is_builtin_trait(v))
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
