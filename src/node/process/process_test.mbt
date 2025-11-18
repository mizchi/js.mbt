///|
test "node:process basic" {
  assert_true(@js.typeof_(@process.cwd()) == "string")
  (@process.argv().length() > 2) |> assert_true
  assert_true(@process.env().has("PATH"))
  assert_true(@process.env().has("HOME") || @process.env().has("HOME_PATH"))
  assert_true(@js.typeof_(stdin()) == "object")
  assert_true(@js.typeof_(stdout()) == "object")
}

///|
test "node:process cwd returns absolute path" {
  let current_dir = @process.cwd()
  assert_eq(current_dir.length() > 0, true)
  // cwd should be an absolute path (starts with / on Unix or drive letter on Windows)
  assert_eq(current_dir.starts_with("/") || current_dir.contains(":"), true)
}

///|
test "node:process argv contains node and script" {
  let args = @process.argv()
  // argv should have at least 2 elements: [node, script]
  assert_eq(args.length() >= 2, true)
  // First arg should contain 'node' or be an executable path
  assert_eq(args[0].length() > 0, true)
}

///|
test "node:process env has PATH" {
  let env = @process.env()
  assert_eq(env.has("PATH"), true)
  // PATH should be non-empty
  match env.get("PATH") {
    Some(path) => assert_eq(path.length() > 0, true)
    None => fail("PATH should exist")
  }
}

///|
test "node:process env get and has" {
  let env = @process.env()
  // Test has
  assert_eq(env.has("PATH"), true)
  assert_eq(env.has("NONEXISTENT_VAR_XYZ_123"), false)

  // Test get
  match env.get("PATH") {
    Some(path) => assert_eq(path.length() > 0, true)
    None => fail("PATH should exist")
  }
  match env.get("NONEXISTENT_VAR_XYZ_123") {
    Some(_) => fail("Non-existent var should not exist")
    None => ()
  }
}

///|
test "node:process version" {
  let ver = @process.version()
  // Should start with 'v' and contain numbers
  assert_eq(ver.starts_with("v"), true)
  assert_eq(ver.length() > 1, true)
}

///|
test "node:process stdin stdout stderr" {
  let stdin_stream = @process.stdin()
  let stdout_stream = @process.stdout()
  let stderr_stream = @process.stderr()

  // All streams should be objects
  assert_eq(@js.typeof_(stdin_stream) == "object", true)
  assert_eq(@js.typeof_(stdout_stream) == "object", true)
  assert_eq(@js.typeof_(stderr_stream) == "object", true)
}

///|
test "node:process exitCode" {
  let code = @process.exitCode()
  // exitCode property exists and is a number (may be undefined initially)
  // We just verify we can read it without error
  let _ = code

}
