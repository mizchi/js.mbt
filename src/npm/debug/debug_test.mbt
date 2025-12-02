///|
/// debug bindings tests

///|
test "debug create instance" {
  let log = @debug.debug("test:app")
  inspect(log.get_namespace(), content="test:app")
}

///|
test "debug extend" {
  let log = @debug.debug("test:base")
  let extended = log.extend("sub")
  inspect(extended.get_namespace(), content="test:base:sub")
}

///|
test "debug enable and enabled" {
  // Disable all first
  let _ = @debug.disable()
  inspect(@debug.enabled("myapp:test"), content="false")

  // Enable namespace
  @debug.enable("myapp:*")
  inspect(@debug.enabled("myapp:test"), content="true")
  inspect(@debug.enabled("myapp:debug"), content="true")
  inspect(@debug.enabled("other:test"), content="false")

  // Cleanup
  let _ = @debug.disable()

}

///|
test "debug disable returns previous" {
  @debug.enable("app:*")
  let prev = @debug.disable()
  inspect(prev.contains("app:*"), content="true")
}

///|
test "debug is_enabled" {
  let log = @debug.debug("check:enabled")

  // Disable all first
  let _ = @debug.disable()
  inspect(log.is_enabled(), content="false")

  // Enable the namespace
  @debug.enable("check:*")
  inspect(log.is_enabled(), content="true")

  // Cleanup
  let _ = @debug.disable()

}

///|
test "debug set_enabled" {
  let log = @debug.debug("manual:control")

  // Manually enable
  log.set_enabled(true)
  inspect(log.is_enabled(), content="true")

  // Manually disable
  log.set_enabled(false)
  inspect(log.is_enabled(), content="false")
}

///|
test "debug log does not throw" {
  let log = @debug.debug("silent:log")
  // Should not throw even when disabled
  log.log("test message")
  log.log1("formatted %s", @core.any("value"))
  log.log2("two args %s %d", @core.any("str"), @core.any(42))
  log.log3("three args %s %d %s", @core.any("a"), @core.any(1), @core.any("b"))
  log.log_with("multiple args", [@core.any("x"), @core.any("y")])
}
