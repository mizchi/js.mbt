///|
test "ok - truthy value" {
  ok(true)
  ok(true, message="should be true")
}

///|
test "equal - strict equality" {
  equal(@nostd.any(1), @nostd.any(1))
  equal(@nostd.any("hello"), @nostd.any("hello"))
  equal(@nostd.any(true), @nostd.any(true))
}

///|
test "notEqual - strict inequality" {
  notEqual(@nostd.any(1), @nostd.any(2))
  notEqual(@nostd.any("hello"), @nostd.any("world"))
  notEqual(@nostd.any(1), @nostd.any("1")) // strict mode: 1 !== "1"
}

///|
test "deepEqual - deep strict equality" {
  let obj1 = @nostd.Object::new()
  obj1["a"] = @nostd.any(1)
  obj1["b"] = @nostd.any(2)
  let obj2 = @nostd.Object::new()
  obj2["a"] = @nostd.any(1)
  obj2["b"] = @nostd.any(2)
  deepEqual(obj1, obj2)
}

///|
test "strictEqual - same as equal in strict mode" {
  strictEqual(@nostd.any(42), @nostd.any(42))
  strictEqual(@nostd.any("test"), @nostd.any("test"))
}

///|
test "deepStrictEqual - recursive strict equality" {
  let arr1 = @js.JsArray::from([1, 2, 3])
  let arr2 = @js.JsArray::from([1, 2, 3])
  deepStrictEqual(@nostd.any(arr1), @nostd.any(arr2))
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
  ifError(@nostd.null())
  ifError(@nostd.undefined())
}
