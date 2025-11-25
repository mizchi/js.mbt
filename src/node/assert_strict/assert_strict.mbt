///|
/// node:assert/strict module - Strict assertion mode
/// https://nodejs.org/api/assert.html#strict-assertion-mode
///
/// In strict assertion mode:
/// - equal() uses strictEqual() (===)
/// - notEqual() uses notStrictEqual() (!==)
/// - deepEqual() uses deepStrictEqual()
/// - notDeepEqual() uses notDeepStrictEqual()

///|
extern "js" fn assert_strict_module() -> @js.Any =
  #| () => require("node:assert/strict")

///| Basic Assertions

///|
/// Assert that a value is truthy
pub fn ok(value : Bool, message? : String) -> Unit {
  let a = assert_strict_module()
  match message {
    Some(msg) => a.call2("ok", value, msg) |> ignore
    None => a.call("ok", [value]) |> ignore
  }
}

///|
/// Assert strict equality (===)
/// In strict mode, equal() is an alias for strictEqual()
pub fn equal(
  actual : &@js.JsImpl,
  expected : &@js.JsImpl,
  message? : String,
) -> Unit {
  let a = assert_strict_module()
  match message {
    Some(msg) =>
      a.call("equal", [actual.to_any(), expected.to_any(), msg]) |> ignore
    None => a.call2("equal", actual.to_any(), expected.to_any()) |> ignore
  }
}

///|
/// Assert strict inequality (!==)
/// In strict mode, notEqual() is an alias for notStrictEqual()
pub fn notEqual(
  actual : &@js.JsImpl,
  expected : &@js.JsImpl,
  message? : String,
) -> Unit {
  let a = assert_strict_module()
  match message {
    Some(msg) =>
      a.call("notEqual", [actual.to_any(), expected.to_any(), msg]) |> ignore
    None => a.call2("notEqual", actual.to_any(), expected.to_any()) |> ignore
  }
}

///|
/// Assert deep strict equality
/// In strict mode, deepEqual() is an alias for deepStrictEqual()
pub fn deepEqual(
  actual : &@js.JsImpl,
  expected : &@js.JsImpl,
  message? : String,
) -> Unit {
  let a = assert_strict_module()
  match message {
    Some(msg) =>
      a.call("deepEqual", [actual.to_any(), expected.to_any(), msg]) |> ignore
    None => a.call2("deepEqual", actual.to_any(), expected.to_any()) |> ignore
  }
}

///|
/// Assert deep strict inequality
/// In strict mode, notDeepEqual() is an alias for notDeepStrictEqual()
pub fn notDeepEqual(
  actual : &@js.JsImpl,
  expected : &@js.JsImpl,
  message? : String,
) -> Unit {
  let a = assert_strict_module()
  match message {
    Some(msg) =>
      a.call("notDeepEqual", [actual.to_any(), expected.to_any(), msg])
      |> ignore
    None =>
      a.call2("notDeepEqual", actual.to_any(), expected.to_any()) |> ignore
  }
}

///|
/// Assert strict equality (===) using Object.is()
pub fn strictEqual(
  actual : &@js.JsImpl,
  expected : &@js.JsImpl,
  message? : String,
) -> Unit {
  let a = assert_strict_module()
  match message {
    Some(msg) =>
      a.call("strictEqual", [actual.to_any(), expected.to_any(), msg]) |> ignore
    None => a.call2("strictEqual", actual.to_any(), expected.to_any()) |> ignore
  }
}

///|
/// Assert strict inequality (!==)
pub fn notStrictEqual(
  actual : &@js.JsImpl,
  expected : &@js.JsImpl,
  message? : String,
) -> Unit {
  let a = assert_strict_module()
  match message {
    Some(msg) =>
      a.call("notStrictEqual", [actual.to_any(), expected.to_any(), msg])
      |> ignore
    None =>
      a.call2("notStrictEqual", actual.to_any(), expected.to_any()) |> ignore
  }
}

///|
/// Assert deep strict equality recursively
pub fn deepStrictEqual(
  actual : &@js.JsImpl,
  expected : &@js.JsImpl,
  message? : String,
) -> Unit {
  let a = assert_strict_module()
  match message {
    Some(msg) =>
      a.call("deepStrictEqual", [actual.to_any(), expected.to_any(), msg])
      |> ignore
    None =>
      a.call2("deepStrictEqual", actual.to_any(), expected.to_any()) |> ignore
  }
}

///|
/// Assert deep strict inequality
pub fn notDeepStrictEqual(
  actual : &@js.JsImpl,
  expected : &@js.JsImpl,
  message? : String,
) -> Unit {
  let a = assert_strict_module()
  match message {
    Some(msg) =>
      a.call("notDeepStrictEqual", [actual.to_any(), expected.to_any(), msg])
      |> ignore
    None =>
      a.call2("notDeepStrictEqual", actual.to_any(), expected.to_any())
      |> ignore
  }
}

///| Error Assertions

///|
/// Assert that a function throws
pub fn throws(fn_ : () -> Unit, message? : String) -> Unit {
  let a = assert_strict_module()
  match message {
    Some(msg) => a.call2("throws", @js.from_fn0(fn_), msg) |> ignore
    None => a.call("throws", [@js.from_fn0(fn_)]) |> ignore
  }
}

///|
/// Assert that a function does not throw
pub fn doesNotThrow(fn_ : () -> Unit, message? : String) -> Unit {
  let a = assert_strict_module()
  match message {
    Some(msg) => a.call2("doesNotThrow", @js.from_fn0(fn_), msg) |> ignore
    None => a.call("doesNotThrow", [@js.from_fn0(fn_)]) |> ignore
  }
}

///|
/// Assert that a promise rejects
pub async fn rejects(
  promise : &@js.JsImpl,
  error? : &@js.JsImpl,
  message? : String,
) -> Unit {
  let a = assert_strict_module()
  let p : @js.Promise[Unit] = match (error, message) {
    (Some(err), Some(msg)) =>
      a.call("rejects", [promise.to_any(), err.to_any(), msg]).cast()
    (Some(err), None) =>
      a.call2("rejects", promise.to_any(), err.to_any()).cast()
    (None, Some(msg)) => a.call2("rejects", promise.to_any(), msg).cast()
    (None, None) => a.call("rejects", [promise.to_any()]).cast()
  }
  p.wait()
}

///|
/// Assert that a promise does not reject
pub async fn doesNotReject(promise : &@js.JsImpl, message? : String) -> Unit {
  let a = assert_strict_module()
  let p : @js.Promise[Unit] = match message {
    Some(msg) => a.call2("doesNotReject", promise.to_any(), msg).cast()
    None => a.call("doesNotReject", [promise.to_any()]).cast()
  }
  p.wait()
}

///| Other Assertions

///|
/// Always fails with AssertionError
pub fn fail(message? : String) -> Unit {
  let a = assert_strict_module()
  match message {
    Some(msg) => a.call("fail", [msg]) |> ignore
    None => a.call0("fail") |> ignore
  }
}

///|
/// Create RegExp from string
extern "js" fn create_regexp(pattern : String) -> @js.Any =
  #|(pattern) => new RegExp(pattern)

///|
/// Assert regex match
pub fn match_(actual : String, regexp : String, message? : String) -> Unit {
  let a = assert_strict_module()
  let regex = create_regexp(regexp)
  match message {
    Some(msg) => a.call("match", [actual, regex, msg]) |> ignore
    None => a.call2("match", actual, regex) |> ignore
  }
}

///|
/// Assert regex does not match
pub fn doesNotMatch(
  actual : String,
  regexp : String,
  message? : String,
) -> Unit {
  let a = assert_strict_module()
  let regex = create_regexp(regexp)
  match message {
    Some(msg) => a.call("doesNotMatch", [actual, regex, msg]) |> ignore
    None => a.call2("doesNotMatch", actual, regex) |> ignore
  }
}

///|
/// Throws value if value is not undefined or null
/// Useful for testing error argument in callbacks
pub fn ifError(value : @js.Any) -> Unit {
  let a = assert_strict_module()
  a.call("ifError", [value]) |> ignore
}

///|
/// Assert partial deep strict equality (Node.js 20+)
/// Tests that expected is a subset of actual
#alert(deprecated, "This function is experimental in Node.js")
pub fn partialDeepStrictEqual(
  actual : &@js.JsImpl,
  expected : &@js.JsImpl,
  message? : String,
) -> Unit {
  let a = assert_strict_module()
  match message {
    Some(msg) =>
      a.call("partialDeepStrictEqual", [actual.to_any(), expected.to_any(), msg])
      |> ignore
    None =>
      a.call2("partialDeepStrictEqual", actual.to_any(), expected.to_any())
      |> ignore
  }
}
