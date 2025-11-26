///|
test "parse simple string" {
  let result = parse("KEY=value")
  guard result.get_("KEY") is Some(v)
  assert_eq(v, "value")
}

///|
test "parse multiple lines" {
  let result = parse("FOO=bar\nBAZ=qux")
  guard result.get_("FOO") is Some(foo)
  assert_eq(foo, "bar")
  guard result.get_("BAZ") is Some(baz)
  assert_eq(baz, "qux")
}

///|
test "parse with quotes" {
  let result = parse("QUOTED=\"hello world\"")
  guard result.get_("QUOTED") is Some(v)
  assert_eq(v, "hello world")
}

///|
test "parse with single quotes" {
  let result = parse("SINGLE='hello world'")
  guard result.get_("SINGLE") is Some(v)
  assert_eq(v, "hello world")
}

///|
test "parse with comments" {
  let result = parse("# comment\nKEY=value")
  guard result.get_("KEY") is Some(v)
  assert_eq(v, "value")
  // Comment line should not create a key
  guard result.get_("# comment") is None
}

///|
test "parse empty value" {
  let result = parse("EMPTY=")
  guard result.get_("EMPTY") is Some(v)
  assert_eq(v, "")
}

///|
test "parse keys" {
  let result = parse("A=1\nB=2\nC=3")
  let keys = result.keys()
  assert_eq(keys.length(), 3)
}

///|
test "getEnv and setEnv" {
  // Set a test env var
  setEnv("TEST_VAR_123", "test_value")
  guard getEnv("TEST_VAR_123") is Some(v)
  assert_eq(v, "test_value")
  // Clean up
  deleteEnv("TEST_VAR_123")
  guard getEnv("TEST_VAR_123") is None
}

///|
test "processEnv returns object" {
  let env = processEnv()
  @js.typeof_(env) |> assert_eq("object")
}

///|
test "config without .env file" {
  // This will likely fail if no .env exists, but should not throw
  // quiet=true to suppress console output
  let result = config(path="/nonexistent/.env", quiet=true)
  // Error should be set since file doesn't exist
  guard result.error is Some(_)
}

///|
test "parse with export prefix" {
  let result = parse("export KEY=value")
  guard result.get_("KEY") is Some(v)
  assert_eq(v, "value")
}

///|
test "parse multiline" {
  let result = parse("MULTI=\"line1\nline2\"")
  guard result.get_("MULTI") is Some(v)
  assert_eq(v.contains("line1"), true)
}

///|
test "populate target object" {
  let target = @js.Object::new()
  let source = @js.Object::new()
  source.set("MY_KEY", "my_value")
  populate(target.to_any(), source.to_any())
  let v : String = target.get("MY_KEY").cast()
  assert_eq(v, "my_value")
}
