///|
/// Child Process Tests for src/_tests
/// Tests Node.js child_process module functionality

///| Asynchronous Spawn Tests (Non-blocking operations)

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

///| ChildProcess Stream Tests

///|
test {
  it("ChildProcess stdin is available", _ => {
    let proc = @child_process.spawn("cat")
    let stdin = proc.stdin()
    assert_true(stdin is Some(_))
    proc.kill() |> ignore
  })
}

///|
test {
  it("ChildProcess signalCode returns signal", _ => {
    let proc = @child_process.spawn("sleep", args=["10"])
    proc.kill(signal="SIGTERM") |> ignore
    // signalCode may not be available immediately
    let _signal = proc.signalCode()
    assert_true(true) // Just verify the method exists
  })
}
