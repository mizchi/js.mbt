///|
/// Tests for node:assert module
test "ok with truthy value" {
  ok(true)
  ok(true, message="should pass")
}

///|
test "equal checks equality" {
  let obj1 = @nostd.any(42)
  let obj2 = @nostd.any(42)
  equal(obj1, obj2)
}

///|
test "notEqual checks inequality" {
  let obj1 = @nostd.any(42)
  let obj2 = @nostd.any(43)
  notEqual(obj1, obj2)
}

///|
test "deepEqual checks deep equality" {
  let obj1 = @nostd.Object::new()
  obj1["a"] = @nostd.any(1)
  obj1["b"] = @nostd.any(2)
  let obj2 = @nostd.Object::new()
  obj2["a"] = @nostd.any(1)
  obj2["b"] = @nostd.any(2)
  deepEqual(obj1, obj2)
}

///|
test "notDeepEqual checks deep inequality" {
  let obj1 = @nostd.Object::new()
  obj1["a"] = @nostd.any(1)
  obj1["b"] = @nostd.any(2)
  let obj2 = @nostd.Object::new()
  obj2["a"] = @nostd.any(1)
  obj2["b"] = @nostd.any(3)
  notDeepEqual(obj1, obj2)
}

///|
test "strictEqual checks strict equality" {
  let obj1 = @nostd.any("hello")
  let obj2 = @nostd.any("hello")
  strictEqual(obj1, obj2)
}

///|
test "notStrictEqual checks strict inequality" {
  let obj1 = @nostd.any(42)
  let obj2 = @nostd.any("42")
  notStrictEqual(obj1, obj2)
}

///|
test "throws checks if function throws" {
  throws(fn() {
    @js.throw_("Expected error")
    ()
  })
}

///|
test "doesNotThrow checks if function does not throw" {
  doesNotThrow(fn() { () })
}

///|
test "match_ checks regex match" {
  match_("hello world", "hello", message="should match")
  match_("test123", "\\d+")
}

///|
test "doesNotMatch checks regex does not match" {
  doesNotMatch("hello", "\\d+")
}
