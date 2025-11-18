///|
test "node:process" {
  assert_true(@js.typeof_(@process.cwd()) == "string")
  (@process.argv().length() > 2) |> assert_true
  assert_true(@process.env().has("PATH"))
  assert_true(@process.env().has("HOME") || @process.env().has("HOME_PATH"))
  assert_true(@js.typeof_(stdin()) == "object")
  assert_true(@js.typeof_(stdout()) == "object")
}
