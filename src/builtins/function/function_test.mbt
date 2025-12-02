///|
test "Function::to_string" {
  let parse_int = @global.global_this()._get("parseInt")
  let func : Function = @nostd.identity(parse_int)
  let func_str = func.to_string()
  assert_true(func_str.length() > 0)
}

///|
test "Function::name" {
  let parse_int = @global.global_this()._get("parseInt")
  let func : Function = @nostd.identity(parse_int)
  let name = func.name()
  assert_eq(name, "parseInt")
}
