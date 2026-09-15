///|
test "URLSearchParams::get - existing parameter" {
  let url = URL::new("https://example.com?foo=bar&baz=qux")
  let params = url.searchParams
  assert_eq(params.get("foo"), Some("bar"))
  assert_eq(params.get("baz"), Some("qux"))
}

///|
test "URLSearchParams::get - missing parameter" {
  let url = URL::new("https://example.com?foo=bar")
  let params = url.searchParams
  assert_eq(params.get("missing"), None)
}

///|
test "URLSearchParams::get - first value of duplicate" {
  let url = URL::new("https://example.com?foo=first&foo=second")
  let params = url.searchParams
  assert_eq(params.get("foo"), Some("first"))
}

///|
test "URLSearchParams::get_all - single value" {
  let url = URL::new("https://example.com?foo=bar")
  let params = url.searchParams
  let values = params.get_all("foo")
  assert_eq(values.length(), 1)
  assert_eq(values[0], "bar")
}

///|
test "URLSearchParams::get_all - multiple values" {
  let url = URL::new("https://example.com?foo=first&foo=second&foo=third")
  let params = url.searchParams
  let values = params.get_all("foo")
  assert_eq(values.length(), 3)
  assert_eq(values[0], "first")
  assert_eq(values[1], "second")
  assert_eq(values[2], "third")
}

///|
test "URLSearchParams::get_all - missing parameter" {
  let url = URL::new("https://example.com?foo=bar")
  let params = url.searchParams
  let values = params.get_all("missing")
  assert_eq(values.length(), 0)
}

///|
test "URLSearchParams::has - existing parameter" {
  let url = URL::new("https://example.com?foo=bar&baz=qux")
  let params = url.searchParams
  assert_true(params.has("foo"))
  assert_true(params.has("baz"))
}

///|
test "URLSearchParams::has - missing parameter" {
  let url = URL::new("https://example.com?foo=bar")
  let params = url.searchParams
  assert_false(params.has("missing"))
}

///|
test "URLSearchParams::set - new parameter" {
  let url = URL::new("https://example.com?foo=bar")
  let params = url.searchParams
  params.set("new", "value")
  assert_eq(params.get("new"), Some("value"))
}

///|
test "URLSearchParams::set - replace existing" {
  let url = URL::new("https://example.com?foo=bar")
  let params = url.searchParams
  params.set("foo", "updated")
  assert_eq(params.get("foo"), Some("updated"))
}

///|
test "URLSearchParams::set - replace duplicates" {
  let url = URL::new("https://example.com?foo=first&foo=second")
  let params = url.searchParams
  params.set("foo", "only")
  assert_eq(params.get("foo"), Some("only"))
  let values = params.get_all("foo")
  assert_eq(values.length(), 1)
  assert_eq(values[0], "only")
}

///|
test "URLSearchParams - empty query string" {
  let url = URL::new("https://example.com")
  let params = url.searchParams
  assert_eq(params.get("anything"), None)
  assert_false(params.has("anything"))
}

///|
test "URLSearchParams - encoded values" {
  let url = URL::new("https://example.com?name=hello%20world&special=%40%23%24")
  let params = url.searchParams
  assert_eq(params.get("name"), Some("hello world"))
  assert_eq(params.get("special"), Some("@#$"))
}

///|
test "URLSearchParams - empty value" {
  let url = URL::new("https://example.com?empty=")
  let params = url.searchParams
  assert_eq(params.get("empty"), Some(""))
  assert_true(params.has("empty"))
}

///|
test "URLSearchParams - parameter without value" {
  let url = URL::new("https://example.com?flag")
  let params = url.searchParams
  assert_true(params.has("flag"))
  assert_eq(params.get("flag"), Some(""))
}

///|
test "URLSearchParams - complex query" {
  let url = URL::new("https://example.com?a=1&b=2&c=3&a=4")
  let params = url.searchParams
  assert_eq(params.get("a"), Some("1"))
  assert_eq(params.get("b"), Some("2"))
  assert_eq(params.get("c"), Some("3"))
  let a_values = params.get_all("a")
  assert_eq(a_values.length(), 2)
  assert_eq(a_values[0], "1")
  assert_eq(a_values[1], "4")
}

///|
test "URLSearchParams - special characters in keys" {
  let url = URL::new("https://example.com?foo%5Bbar%5D=value")
  let params = url.searchParams
  assert_eq(params.get("foo[bar]"), Some("value"))
}

///|
test "URLSearchParams::append - add new parameter" {
  let url = URL::new("https://example.com?foo=bar")
  let params = url.searchParams
  params.append("baz", "qux")
  assert_eq(params.get("baz"), Some("qux"))
}

///|
test "URLSearchParams::append - add duplicate parameter" {
  let url = URL::new("https://example.com?foo=first")
  let params = url.searchParams
  params.append("foo", "second")
  let values = params.get_all("foo")
  assert_eq(values.length(), 2)
  assert_eq(values[0], "first")
  assert_eq(values[1], "second")
}

///|
test "URLSearchParams::delete - remove existing parameter" {
  let url = URL::new("https://example.com?foo=bar&baz=qux")
  let params = url.searchParams
  params.delete("foo")
  assert_false(params.has("foo"))
  assert_true(params.has("baz"))
}

///|
test "URLSearchParams::delete - remove all duplicates" {
  let url = URL::new("https://example.com?foo=first&foo=second&bar=value")
  let params = url.searchParams
  params.delete("foo")
  assert_false(params.has("foo"))
  assert_true(params.has("bar"))
}

///|
test "URLSearchParams::delete - non-existent parameter" {
  let url = URL::new("https://example.com?foo=bar")
  let params = url.searchParams
  params.delete("missing")
  assert_true(params.has("foo"))
}

///|
test "URLSearchParams::sort - alphabetical order" {
  let url = URL::new("https://example.com?z=1&a=2&m=3")
  let params = url.searchParams
  params.sort()
  let str = params.to_string()
  assert_eq(str, "a=2&m=3&z=1")
}

///|
test "URLSearchParams::size - count parameters" {
  let url = URL::new("https://example.com?foo=bar&baz=qux")
  let params = url.searchParams
  assert_eq(params.size, 2)
}

///|
test "URLSearchParams::size - with duplicates" {
  let url = URL::new("https://example.com?foo=first&foo=second&bar=value")
  let params = url.searchParams
  assert_eq(params.size, 3)
}

///|
test "URLSearchParams::size - empty" {
  let url = URL::new("https://example.com")
  let params = url.searchParams
  assert_eq(params.size, 0)
}

///|
test "URLSearchParams::to_string - format query string" {
  let url = URL::new("https://example.com?foo=bar&baz=qux")
  let params = url.searchParams
  let str = params.to_string()
  assert_eq(str, "foo=bar&baz=qux")
}

///|
test "URLSearchParams::to_string - empty" {
  let url = URL::new("https://example.com")
  let params = url.searchParams
  let str = params.to_string()
  assert_eq(str, "")
}

///|
test "URLSearchParams::to_string - with special characters" {
  let url = URL::new("https://example.com?name=hello%20world")
  let params = url.searchParams
  let str = params.to_string()
  assert_eq(str, "name=hello+world")
}

///|
test "URLSearchParams - mutation workflow" {
  let url = URL::new("https://example.com?a=1&b=2")
  let params = url.searchParams
  assert_eq(params.size, 2)
  params.append("c", "3")
  assert_eq(params.size, 3)
  params.set("a", "updated")
  assert_eq(params.get("a"), Some("updated"))
  params.delete("b")
  assert_eq(params.size, 2)
  assert_false(params.has("b"))
  params.sort()
  let str = params.to_string()
  assert_eq(str, "a=updated&c=3")
}
