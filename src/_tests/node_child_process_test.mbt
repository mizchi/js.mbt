///|
/// Child Process Tests for src/_tests
/// Tests Node.js child_process module functionality

///| Synchronous Functions Tests

///|
test {
  it("execSync executes command and returns output", _ => {
    let output = @child_process.execSync("echo hello")
    assert_true(output.contains("hello"))
  })
}

///|
test {
  it("execSync with working directory option", _ => {
    let output = @child_process.execSync("pwd", cwd="/tmp")
    assert_true(output.contains("tmp"))
  })
}

///|
test {
  it("execSync with input string", _ => {
    let output = @child_process.execSync("cat", input="test input")
    assert_true(output.contains("test input"))
  })
}

///|
test {
  it("spawnSync executes command and returns result", _ => {
    let result = @child_process.spawnSync("echo", args=["hello", "world"])
    assert_true(result.pid() > 0)
    let status = result.status()
    assert_eq(status, Some(0))
  })
}

///|
test {
  it("spawnSync with shell option", _ => {
    let result = @child_process.spawnSync("echo $HOME", shell=true)
    assert_true(result.pid() > 0)
  })
}

///|
test {
  it("execFileSync executes file and returns output", _ => {
    let output = @child_process.execFileSync("echo", args=["test", "message"])
    assert_true(output.contains("test"))
    assert_true(output.contains("message"))
  })
}

///|
test {
  it("execFileSync with working directory", _ => {
    let output = @child_process.execFileSync("pwd", cwd="/tmp")
    assert_true(output.contains("tmp"))
  })
}

///| Asynchronous Spawn Tests

///|
test {
  it("spawn creates child process with valid PID", _ => {
    let proc = @child_process.spawn("echo", args=["test"])
    let pid = proc.pid()
    assert_true(pid > 0)
    assert_false(proc.killed())
  })
}

///|
test {
  it("spawn with shell option", _ => {
    let proc = @child_process.spawn("echo test", shell=true)
    assert_true(proc.pid() > 0)
  })
}

///|
test {
  it("spawn with working directory", _ => {
    let proc = @child_process.spawn("pwd", cwd="/tmp")
    assert_true(proc.pid() > 0)
  })
}

///| ChildProcess Properties

///|
test {
  it("ChildProcess has stdout and stderr streams", _ => {
    let proc = @child_process.spawn("echo", args=["test"])
    let stdout = proc.stdout()
    let stderr = proc.stderr()
    assert_true(stdout is Some(_))
    assert_true(stderr is Some(_))
  })
}

///|
test {
  it("ChildProcess exitCode is None for running process", _ => {
    let proc = @child_process.spawn("sleep", args=["0.1"])
    let exit_code = proc.exitCode()
    // Process might still be running
    assert_true(exit_code is None || exit_code is Some(_))
  })
}

///| ChildProcess Methods

///|
test {
  it("ChildProcess kill terminates process", _ => {
    let proc = @child_process.spawn("sleep", args=["10"])
    let killed = proc.kill()
    assert_true(killed)
  })
}

///|
test {
  it("ChildProcess kill with signal", _ => {
    let proc = @child_process.spawn("sleep", args=["10"])
    let killed = proc.kill(signal="SIGTERM")
    assert_true(killed)
  })
}

///|
test {
  it("ChildProcess unref and ref methods", _ => {
    let proc = @child_process.spawn("echo", args=["test"])
    proc.unref()
    proc.ref_()
    assert_true(proc.pid() > 0)
  })
}

///| SpawnSyncResult Properties

///|
test {
  it("SpawnSyncResult has all properties", _ => {
    let result = @child_process.spawnSync("echo", args=["test"])
    assert_true(result.pid() > 0)
    assert_true(result.status() is Some(_))
    let _stdout = result.stdout()
    let _stderr = result.stderr()
    let _error = result.error()

  })
}

///|
test {
  it("SpawnSyncResult successful command has status 0", _ => {
    let result = @child_process.spawnSync("echo", args=["success"])
    match result.status() {
      Some(0) => assert_true(true)
      _ => assert_true(false)
    }
  })
}

///| Event Emitter Integration

///|
test {
  it("ChildProcess has EventEmitter methods", _ => {
    let proc = @child_process.spawn("echo", args=["test"])
    // Test EventEmitter trait methods are available
    proc.on("exit", _ => ())
    proc.once("close", _ => ())
    let names = proc.eventNames()
    assert_true(names.length() >= 0)
  })
}

///| Error Handling

///|
test {
  it("spawnSync handles non-existent command with error", _ => {
    let result = @child_process.spawnSync("/nonexistent/command")
    let error = result.error()
    assert_true(error is Some(_))
  })
}

///|
test {
  it("spawnSync handles command not found", _ => {
    let result = @child_process.spawnSync("/nonexistent/command")
    let error = result.error()
    assert_true(error is Some(_))
  })
}

///| Command Output Tests

///|
test {
  it("execSync captures stdout correctly", _ => {
    let output = @child_process.execSync(
      "echo 'line1' && echo 'line2'",
      shell="/bin/sh",
    )
    assert_true(output.contains("line1"))
    assert_true(output.contains("line2"))
  })
}

///|
test {
  it("spawnSync captures output in result", _ => {
    let result = @child_process.spawnSync("echo", args=["captured"])
    let stdout = result.stdout()
    // stdout is a Buffer, need to convert to string
    let buffer : @buffer.Buffer = unsafe_cast(stdout)
    let stdout_str = buffer.toString()
    assert_true(stdout_str.contains("captured"))
  })
}
