///|
test "Level enum to_string" {
  assert_eq(Level::Trace.to_string(), "trace")
  assert_eq(Level::Debug.to_string(), "debug")
  assert_eq(Level::Info.to_string(), "info")
  assert_eq(Level::Warn.to_string(), "warn")
  assert_eq(Level::Error.to_string(), "error")
  assert_eq(Level::Fatal.to_string(), "fatal")
  assert_eq(Level::Silent.to_string(), "silent")
}

///|
test "Level enum to_number" {
  assert_eq(Level::Trace.to_number(), 10)
  assert_eq(Level::Debug.to_number(), 20)
  assert_eq(Level::Info.to_number(), 30)
  assert_eq(Level::Warn.to_number(), 40)
  assert_eq(Level::Error.to_number(), 50)
  assert_eq(Level::Fatal.to_number(), 60)
  assert_eq(Level::Silent.to_number(), 100)
}

///|
test "create logger with silent level" {
  // Use silent level to avoid stdout output during tests
  let logger = pino(level=Silent)
  assert_eq(@core.typeof_(logger.as_any()["info"]), "function")
  assert_eq(@core.typeof_(logger.as_any()["error"]), "function")
}

///|
test "create logger with name option" {
  let logger = pino(level=Silent, name="test-logger")
  // Logger should be created successfully
  assert_eq(@core.typeof_(logger.as_any()["info"]), "function")
}

///|
test "logger level methods exist" {
  let logger = pino(level=Silent)
  assert_eq(@core.typeof_(logger.as_any()["trace"]), "function")
  assert_eq(@core.typeof_(logger.as_any()["debug"]), "function")
  assert_eq(@core.typeof_(logger.as_any()["info"]), "function")
  assert_eq(@core.typeof_(logger.as_any()["warn"]), "function")
  assert_eq(@core.typeof_(logger.as_any()["error"]), "function")
  assert_eq(@core.typeof_(logger.as_any()["fatal"]), "function")
}

///|
test "logger info with silent level" {
  // Using silent level prevents output but tests method call
  let logger = pino(level=Silent)
  // Should not throw even when called (though it won't output)
  logger.info("test message")
}

///|
test "logger with object silent level" {
  let logger = pino(level=Silent)
  let obj = @core.new_object()
  obj["userId"] = @core.any(123)
  // Should not throw
  logger.info_obj(obj, "user logged in")
}

///|
test "child logger" {
  let logger = pino(level=Silent)
  let bindings = @core.new_object()
  bindings["requestId"] = @core.any("abc123")
  let child = logger.child(bindings)
  assert_eq(@core.typeof_(child.as_any()["info"]), "function")
}

///|
test "get and set level" {
  let logger = pino(level=Silent)
  assert_eq(logger.level(), "silent")
  logger.set_level(Fatal)
  assert_eq(logger.level(), "fatal")
}

///|
test "is level enabled with silent" {
  let logger = pino(level=Silent)
  // Nothing should be enabled at silent level
  assert_false(logger.is_level_enabled(Info))
  assert_false(logger.is_level_enabled(Warn))
  assert_false(logger.is_level_enabled(Error))
  assert_false(logger.is_level_enabled(Fatal))
}

///|
test "logger flush" {
  let logger = pino(level=Silent)
  // Should not throw
  logger.flush()
}

///|
test "logger without timestamp" {
  let logger = pino(level=Silent, timestamp=false)
  // Should create logger without error
  assert_eq(@core.typeof_(logger.as_any()["info"]), "function")
}
