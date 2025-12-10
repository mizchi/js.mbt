///|
test "MagicString - basic creation and to_string" {
  let s = @magic_string.MagicString::new("hello world")
  inspect(s.to_string(), content="hello world")
}

///|
test "MagicString - append" {
  let s = @magic_string.MagicString::new("hello")
  let _ = s.append(" world")
  inspect(s.to_string(), content="hello world")
}

///|
test "MagicString - prepend" {
  let s = @magic_string.MagicString::new("world")
  let _ = s.prepend("hello ")
  inspect(s.to_string(), content="hello world")
}

///|
test "MagicString - update" {
  let s = @magic_string.MagicString::new("hello world")
  let _ = s.update(0, 5, "hi")
  inspect(s.to_string(), content="hi world")
}

///|
test "MagicString - remove" {
  let s = @magic_string.MagicString::new("hello world")
  let _ = s.remove(5, 11)
  inspect(s.to_string(), content="hello")
}

///|
test "MagicString - replace" {
  let s = @magic_string.MagicString::new("hello world")
  let _ = s.replace("world", "universe")
  inspect(s.to_string(), content="hello universe")
}

///|
test "MagicString - replace_all" {
  let s = @magic_string.MagicString::new("foo bar foo")
  let _ = s.replace_all("foo", "baz")
  inspect(s.to_string(), content="baz bar baz")
}

///|
test "MagicString - append_left and append_right" {
  let s = @magic_string.MagicString::new("abc")
  let _ = s.append_left(1, "[")
  let _ = s.append_right(1, "]")
  // append_left inserts before index, append_right after index
  inspect(s.to_string(), content="a[]bc")
}

///|
test "MagicString - trim" {
  let s = @magic_string.MagicString::new("  hello  ")
  let _ = s.trim()
  inspect(s.to_string(), content="hello")
}

///|
test "MagicString - has_changed" {
  let s = @magic_string.MagicString::new("hello")
  inspect(s.has_changed(), content="false")
  let _ = s.append("!")
  inspect(s.has_changed(), content="true")
}

///|
test "MagicString - clone" {
  let s = @magic_string.MagicString::new("hello")
  let c = s.clone()
  let _ = s.append(" world")
  inspect(s.to_string(), content="hello world")
  inspect(c.to_string(), content="hello")
}

///|
test "MagicString - slice" {
  let s = @magic_string.MagicString::new("hello world")
  inspect(s.slice(0, 5), content="hello")
  inspect(s.slice(6, 11), content="world")
}

///|
test "MagicString - snip" {
  let s = @magic_string.MagicString::new("hello world")
  let snipped = s.snip(6, 11)
  inspect(snipped.to_string(), content="world")
}

///|
test "MagicString - original" {
  let s = @magic_string.MagicString::new("hello")
  let _ = s.append(" world")
  inspect(s.original(), content="hello")
  inspect(s.to_string(), content="hello world")
}

///|
test "MagicString - generate_map" {
  let s = @magic_string.MagicString::new("hello world")
  let _ = s.update(0, 5, "hi")
  let map = s.generate_map(source="input.js", include_content=true)
  assert_true(map.mappings().length() > 0)
  assert_true(map.to_string().contains("mappings"))
}

///|
test "MagicString - indent" {
  let s = @magic_string.MagicString::new("line1\nline2")
  let _ = s.indent(prefix="  ")
  inspect(s.to_string(), content="  line1\n  line2")
}

///|
test "Bundle - basic usage" {
  let bundle = @magic_string.Bundle::new()
  let s1 = @magic_string.MagicString::new("const a = 1;")
  let s2 = @magic_string.MagicString::new("const b = 2;")
  let _ = bundle.add_source(s1)
  let _ = bundle.add_source(s2)
  let result = bundle.to_string()
  assert_true(result.contains("const a = 1;"))
  assert_true(result.contains("const b = 2;"))
}

///|
test "Bundle - prepend and append" {
  let bundle = @magic_string.Bundle::new()
  let s = @magic_string.MagicString::new("content")
  let _ = bundle.add_source(s)
  let _ = bundle.prepend("// header\n")
  let _ = bundle.append("\n// footer")
  let result = bundle.to_string()
  assert_true(result.has_prefix("// header"))
  assert_true(result.has_suffix("// footer"))
}

///|
test "MagicString - relocate" {
  let s = @magic_string.MagicString::new("abcdefghij")
  // Move "def" (3-6) to position 0
  let _ = s.relocate(3, 6, 0)
  inspect(s.to_string(), content="defabcghij")
}

///|
test "MagicString - is_empty" {
  let s = @magic_string.MagicString::new("hello")
  inspect(s.is_empty(), content="false")
  let _ = s.remove(0, 5)
  inspect(s.is_empty(), content="true")
}
