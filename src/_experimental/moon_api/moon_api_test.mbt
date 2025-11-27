///|
/// Tests for moon_api package
/// NOTE: These tests call moon commands which interfere with moon test output

///|
#skip("calls moon command which interferes with moon test output")
test "is_available returns true for installed moon" {
  let available = @moon_api.is_available()
  assert_true(available)
}

///|
#skip("calls moon command which interferes with moon test output")
test "get_version returns non-empty string" {
  let ver = @moon_api.get_version()
  assert_true(ver.length() > 0)
  // Version should contain "moon" or a digit
  assert_true(ver.contains("moon") || ver.contains("0") || ver.contains("1"))
}

///|
#skip("calls moon command which interferes with moon test output")
test "version command succeeds" {
  let result = @moon_api.version()
  assert_true(result.success)
  inspect(result.exit_code, content="0")
  assert_true(result.stdout.length() > 0)
}

///|
#skip("calls moon command which interferes with moon test output")
test "version --all shows detailed info" {
  let result = @moon_api.version(all=true)
  assert_true(result.success)
  // Should contain moonc/moonrun info
  assert_true(result.stdout.contains("moon"))
}

///|
#skip("calls moon command which interferes with moon test output")
test "check runs in current project" {
  // Use runtime to find project root
  let cwd = @process.cwd()
  let result = @moon_api.check(cwd~)
  // Check should succeed on a valid MoonBit project
  assert_true(result.success)
}

///|
#skip("calls moon command which interferes with moon test output")
test "check with target js" {
  let cwd = @process.cwd()
  let result = @moon_api.check(target=JS, cwd~)
  assert_true(result.success)
}

///|
#skip("calls moon command which interferes with moon test output")
test "fmt --check doesn't modify files" {
  let cwd = @process.cwd()
  // Just verify the command runs without error
  let result = @moon_api.fmt(check=true, cwd~)
  // May succeed or fail depending on formatting, but should not crash
  assert_true(result.exit_code >= 0)
}

///|
#skip("calls moon command which interferes with moon test output")
test "build with target js" {
  let cwd = @process.cwd()
  let result = @moon_api.build(target=JS, cwd~)
  assert_true(result.success)
}

///|
test "Target enum shows correctly" {
  inspect(@moon_api.JS, content="js")
  inspect(@moon_api.Wasm, content="wasm")
  inspect(@moon_api.WasmGC, content="wasm-gc")
  inspect(@moon_api.Native, content="native")
  inspect(@moon_api.All, content="all")
}

///|
test "BuildMode enum shows correctly" {
  inspect(@moon_api.Debug, content="debug")
  inspect(@moon_api.Release, content="release")
}

///|
#skip("calls moon command which interferes with moon test output")
test "CommandResult has correct fields" {
  let result = @moon_api.version()
  // Verify structure
  assert_true(result.exit_code == 0)
  assert_true(result.success)
  assert_true(result.stdout.length() > 0)
}
