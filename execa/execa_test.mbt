///|
async test "execa - basic command execution" {
  let result = @execa.execa("echo", args=["hello"])
  inspect(result.stdout(), content="hello")
  inspect(result.exitCode(), content="0")
  inspect(result.failed(), content="false")
}

///|
async test "execa - command with multiple args" {
  let result = @execa.execa("echo", args=["hello", "world"])
  inspect(result.stdout(), content="hello world")
}

///|
async test "execaCommand - execute command string" {
  let result = @execa.execaCommand("echo hello")
  inspect(result.stdout(), content="hello")
  inspect(result.exitCode(), content="0")
}

///|
test "execaSync - synchronous execution" {
  let result = @execa.execaSync("echo", args=["sync"])
  inspect(result.stdout(), content="sync")
  inspect(result.exitCode(), content="0")
}

///|
test "execaCommandSync - synchronous command string" {
  let result = @execa.execaCommandSync("echo sync-command")
  inspect(result.stdout(), content="sync-command")
}

///|
async test "shell - execute shell command" {
  let result = @execa.shell("echo shell-test")
  inspect(result.stdout(), content="shell-test")
}

///|
async test "execa - options with cwd" {
  // New API: use cwd directly as labeled argument
  let result = @execa.execa("pwd", cwd="/tmp")
  // On macOS /tmp is a symlink to /private/tmp
  assert_true(result.stdout().contains("tmp"))
}

///|
async test "execa - result properties" {
  let result = @execa.execa("echo", args=["test"])
  // command property
  assert_true(result.command().contains("echo"))
  // escaped command property
  assert_true(result.escapedCommand().contains("echo"))
  // not timed out
  inspect(result.timedOut(), content="false")
  // not killed
  inspect(result.killed(), content="false")
}
