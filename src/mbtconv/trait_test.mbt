///|
test "is_builtin_trait detects MoonBit builtin traits" {
  let show : &Show = "hello"
  let v : @core.Any = @core.identity(show)
  assert_true(is_builtin_trait(v))
}
