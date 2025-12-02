///|
test "ok - truthy value" {
  ok(true)
  ok(true, message="should be true")
}

///|
test "equal - strict equality" {
  equal(@core.any(1), @core.any(1))
  equal(@core.any("hello"), @core.any("hello"))
  equal(@core.any(true), @core.any(true))
}

///|
test "notEqual - strict inequality" {
  notEqual(@core.any(1), @core.any(2))
  notEqual(@core.any("hello"), @core.any("world"))
  notEqual(@core.any(1), @core.any("1")) // strict mode: 1 !== "1"
}

///|
test "deepEqual - deep strict equality" {
  let obj1 = @core.Object::new()
  obj1["a"] = @core.any(1)
  obj1["b"] = @core.any(2)
  let obj2 = @core.Object::new()
  obj2["a"] = @core.any(1)
  obj2["b"] = @core.any(2)
  deepEqual(obj1, obj2)
}

///|
test "strictEqual - same as equal in strict mode" {
  strictEqual(@core.any(42), @core.any(42))
  strictEqual(@core.any("test"), @core.any("test"))
}

///|
test "deepStrictEqual - recursive strict equality" {
  let arr1 = @js.JsArray::from([1, 2, 3])
  let arr2 = @js.JsArray::from([1, 2, 3])
  deepStrictEqual(@core.any(arr1), @core.any(arr2))
}

///|
test "throws - function throws error" {
  throws(fn() { abort("error") })
}

///|
test "doesNotThrow - function does not throw" {
  doesNotThrow(fn() {
    let _ = 1 + 1

  })
}

///|
test "match - regex match" {
  match_("hello world", "world")
  match_("test123", "\\d+")
}

///|
test "doesNotMatch - regex does not match" {
  doesNotMatch("hello", "\\d+")
  doesNotMatch("abc", "xyz")
}

///|
test "ifError - null and undefined pass" {
  ifError(@core.null())
  ifError(@core.undefined())
}
