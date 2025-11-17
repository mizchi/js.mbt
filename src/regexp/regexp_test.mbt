///|
test "RegExp.test" {
  let re = RegExp::new("^[a-z]+$", flags="igu")
  assert_true(re.test_("MoonBit"))
}

///|
test "RegExp.exec" {
  let re = RegExp::new("^[a-z]+$", flags="igu")
  let matched = re.exec("MoonBit")
  guard matched is Some(matched)
  assert_eq(matched.full, "MoonBit")
  assert_eq(matched.index, 0)
  assert_eq(matched.input, "MoonBit")
}

///|
test "RegExp.exec with named capture groups" {
  let re = RegExp::new("(?<name>[a-z]+)", flags="igu")
  let matched = re.exec("MoonBit")
  guard matched is Some(matched)
  assert_eq(matched.full, "MoonBit")
  assert_eq(matched.index, 0)
  assert_eq(matched.input, "MoonBit")
  assert_eq(matched.groups, Some({ "name": "MoonBit" }))
}

///|
test "RegExp properties" {
  let re = RegExp::new("hello", flags="gim")
  assert_eq(re.source(), "hello")
  assert_eq(re.flags(), "gim")
  assert_true(re.global())
  assert_true(re.ignore_case())
  assert_true(re.multiline())
  assert_false(re.sticky())
  assert_false(re.unicode())
}

///|
test "RegExp.lastIndex" {
  let re = RegExp::new("test", flags="g")
  assert_eq(re.lastIndex(), 0)
  re.set_last_index(5)
  assert_eq(re.lastIndex(), 5)
}

///|
test "RegExp.to_string" {
  let re = RegExp::new("hello", flags="gi")
  assert_eq(re.to_string(), "/hello/gi")
}

///|
test "RegExp.match_" {
  let re = RegExp::new("world")
  let result = re.match_("hello world")
  guard result is Some(r)
  assert_eq(r.matches[0], "world")
  assert_eq(r.index, Some(6))
  assert_eq(r.input, Some("hello world"))
}

///|
test "RegExp.match_all" {
  let re = RegExp::new("test\\d", flags="g")
  let results = re.matchAll("test1 test2 test3")
  assert_eq(results.length(), 3)
  assert_eq(results[0].matches[0], "test1")
  assert_eq(results[1].matches[0], "test2")
  assert_eq(results[2].matches[0], "test3")
}

///|
test "RegExp.replace" {
  let re = RegExp::new("world")
  let result = re.replace("hello world", "MoonBit")
  assert_eq(result, "hello MoonBit")
}

///|
test "RegExp.replace_all" {
  let re = RegExp::new("test", flags="g")
  let result = re.replace_all("test test test", "demo")
  assert_eq(result, "demo demo demo")
}

///|
test "RegExp.search" {
  let re = RegExp::new("world")
  let index = re.search("hello world")
  assert_eq(index, 6)
}

///|
test "RegExp.split" {
  let re = RegExp::new("\\d")
  let parts = re.split("a1b2c3d")
  assert_eq(parts.length(), 4)
  assert_eq(parts[0], "a")
  assert_eq(parts[1], "b")
  assert_eq(parts[2], "c")
  assert_eq(parts[3], "d")
}

///|
test "RegExp.split with limit" {
  let re = RegExp::new("\\d")
  let parts = re.split("a1b2c3d", limit=2)
  assert_eq(parts.length(), 2)
  assert_eq(parts[0], "a")
  assert_eq(parts[1], "b")
}

///|
test "RegExp.replace_fn" {
  let re = RegExp::new("(\\w+)", flags="g")
  let result = re.replace_fn("hello world", fn(
    matched,
    _groups,
    _offset,
    _input,
  ) {
    "[" + matched + "]"
  })
  assert_eq(result, "[hello] [world]")
}

///|
test "RegExp.replace_all_fn" {
  let re = RegExp::new("(\\d+)", flags="g")
  let result = re.replace_all_fn("test1 test2 test3", fn(
    matched,
    _groups,
    _offset,
    _input,
  ) {
    "X"
  })
  assert_eq(result, "testX testX testX")
}
