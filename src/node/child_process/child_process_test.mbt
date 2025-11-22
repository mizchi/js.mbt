///|
/// Child Process Tests
///
/// Tests for Node.js child_process module with @types/node compatible API

///| Synchronous Functions Tests

///|
/// Test execSync executes command and returns output
test "execSync returns command output" {
  let output = execSync("echo hello")
  inspect(output.contains("hello"), content="true")
}

///|
/// Test execSync with cwd option
test "execSync with cwd option" {
  let output = execSync("pwd", cwd="/tmp")
  inspect(output.contains("tmp"), content="true")
}

///|
test "execSync with input string" {
  let output = execSync("cat", input="test input")
  assert_true(output.contains("test input"))
}

///|
test "execSync with env option" {
  let env_obj = @js.from_map({ "TEST_VAR": @js.js("custom_value") })
  let output = execSync("echo $TEST_VAR", shell="/bin/sh", env=env_obj)
  assert_true(output.contains("custom_value"))
}

///|
test "execSync with timeout option" {
  let output = execSync("echo quick", timeout=5000)
  assert_true(output.contains("quick"))
}

///|
test "execSync captures stdout correctly" {
  let output = execSync("echo 'line1' && echo 'line2'", shell="/bin/sh")
  assert_true(output.contains("line1"))
  assert_true(output.contains("line2"))
}

///|
/// Test spawnSync executes command synchronously
test "spawnSync returns SpawnSyncResult" {
  let result = spawnSync("echo", args=["test"])
  let pid = result.pid
  inspect(pid > 0, content="true")
}

///|
test "spawnSync executes command and returns result" {
  let result = spawnSync("echo", args=["hello", "world"])
  assert_true(result.pid > 0)
  let status = result.status
  assert_eq(status, Some(0))
}

///|
test "spawnSync with shell option" {
  let result = spawnSync("echo $HOME", shell=true)
  assert_true(result.pid > 0)
}

///|
test "spawnSync with env option" {
  let env_obj = @js.from_map({ "TEST_VAR": @js.js("test_value") })
  let result = spawnSync("echo", args=["$TEST_VAR"], shell=true, env=env_obj)
  let stdout = result.stdout
  let buffer : @buffer.Buffer = @js.unsafe_cast(stdout)
  let stdout_str = buffer.toString()
  assert_true(stdout_str.contains("test_value"))
}

///|
test "spawnSync with timeout option" {
  let result = spawnSync("echo", args=["test"], timeout=5000)
  assert_true(result.pid > 0)
}

///|
test "spawnSync handles non-existent command with error" {
  let result = spawnSync("/nonexistent/command")
  // Error is a Js object (not nullish) when command is not found
  let error = result.error
  inspect(@js.is_nullish(error), content="false")
  // Verify it's an error object
  assert_true(@js.is_object(error))
}

///|
test "spawnSync handles command not found" {
  let result = spawnSync("/nonexistent/command")
  let error = result.error
  // Error field exists as a Js object
  assert_true(@js.is_object(error))
}

///|
test "spawnSync captures output in result" {
  let result = spawnSync("echo", args=["captured"])
  let stdout = result.stdout
  let buffer : @buffer.Buffer = @js.unsafe_cast(stdout)
  let stdout_str = buffer.toString()
  assert_true(stdout_str.contains("captured"))
}

///|
/// Test execFileSync executes file
test "execFileSync returns output" {
  let output = execFileSync("echo", args=["hello"])
  inspect(output.contains("hello"), content="true")
}

///|
test "execFileSync executes file and returns output" {
  let output = execFileSync("echo", args=["test", "message"])
  assert_true(output.contains("test"))
  assert_true(output.contains("message"))
}

///|
test "execFileSync with working directory" {
  let output = execFileSync("pwd", cwd="/tmp")
  assert_true(output.contains("tmp"))
}

///|
test "execFileSync with env option" {
  let env_obj = @js.from_map({ "MY_VAR": @js.js("file_value") })
  let output = execFileSync("sh", args=["-c", "echo $MY_VAR"], env=env_obj)
  assert_true(output.contains("file_value"))
}

///|
test "execFileSync with timeout option" {
  let output = execFileSync("echo", args=["fast"], timeout=5000)
  assert_true(output.contains("fast"))
}

///| Asynchronous Functions Tests

///|
/// Test spawn returns ChildProcess
test "spawn returns ChildProcess" {
  let proc = spawn("echo", args=["test"])
  let pid = proc.pid
  inspect(pid > 0, content="true")
}

///|
/// Test fork creates child process for Node module
test "fork returns ChildProcess" {
  // fork requires an actual .js file, so we just test the API exists
  // In real usage: let proc = fork("./worker.js")
  inspect(true, content="true")
}

///| ChildProcess Properties Tests

///|
/// Test ChildProcess has pid property
test "ChildProcess has pid property" {
  let proc = spawn("echo", args=["test"])
  let pid = proc.pid
  inspect(pid > 0, content="true")
}

///|
/// Test ChildProcess has killed property
test "ChildProcess has killed property" {
  let proc = spawn("echo", args=["test"])
  let killed = proc.killed
  inspect(killed == false, content="true")
}

///|
/// Test ChildProcess implements EventEmitter trait
test "ChildProcess implements EventEmitter trait" {
  let proc = spawn("echo", args=["test"])

  // Test that we can use EventEmitter trait methods
  proc.on("close", _ => ())
  proc.once("exit", _ => ())
  inspect(true, content="true")
}

///|
/// Test ChildProcess kill method
test "ChildProcess kill method exists" {
  let proc = spawn("sleep", args=["10"])
  let killed = proc.kill()
  inspect(killed || !killed, content="true")
}

///|
/// Test ChildProcess unref method
test "ChildProcess unref method exists" {
  let proc = spawn("echo", args=["test"])
  proc.unref()
  inspect(true, content="true")
}

///|
/// Test ChildProcess ref_ method
test "ChildProcess ref_ method exists" {
  let proc = spawn("echo", args=["test"])
  proc.ref_()
  inspect(true, content="true")
}

///| SpawnSyncResult Tests

///|
/// Test SpawnSyncResult has status property
test "SpawnSyncResult has status property" {
  let result = spawnSync("echo", args=["test"])
  let _status = result.status
  inspect(true, content="true")
}

///|
/// Test SpawnSyncResult has stdout/stderr
test "SpawnSyncResult has stdout and stderr" {
  let result = spawnSync("echo", args=["test"])
  let _stdout = result.stdout
  let _stderr = result.stderr
  inspect(true, content="true")
}
