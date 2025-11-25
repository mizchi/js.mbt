///|
test "ok - truthy value" {
  ok(true)
  ok(true, message="should be true")
}

///|
test "equal - strict equality" {
  equal(1, 1)
  equal("hello", "hello")
  equal(true, true)
}

///|
test "notEqual - strict inequality" {
  notEqual(1, 2)
  notEqual("hello", "world")
  notEqual(1, "1") // strict mode: 1 !== "1"
}

///|
test "deepEqual - deep strict equality" {
  let obj1 = @js.Object::new()
  obj1.set("a", 1)
  obj1.set("b", 2)
  let obj2 = @js.Object::new()
  obj2.set("a", 1)
  obj2.set("b", 2)
  deepEqual(obj1, obj2)
}

///|
test "strictEqual - same as equal in strict mode" {
  strictEqual(42, 42)
  strictEqual("test", "test")
}

///|
test "deepStrictEqual - recursive strict equality" {
  let arr1 = @js.JsArray::from([1, 2, 3])
  let arr2 = @js.JsArray::from([1, 2, 3])
  deepStrictEqual(arr1, arr2)
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
  ifError(@js.null_())
  ifError(@js.undefined())
}
