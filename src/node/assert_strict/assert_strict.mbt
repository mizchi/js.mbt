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
extern "js" fn assert_strict_module() -> @core.Any =
  #| () => require("node:assert/strict")

///| Basic Assertions

///|
/// Assert that a value is truthy
pub fn ok(value : Bool, message? : String) -> Unit {
  let a = assert_strict_module()
  match message {
    Some(msg) => a._call("ok", [@core.any(value), @core.any(msg)]) |> ignore
    None => a._call("ok", [@core.any(value)]) |> ignore
  }
}

///|
/// Assert strict equality (===)
/// In strict mode, equal() is an alias for strictEqual()
pub fn equal(
  actual : @core.Any,
  expected : @core.Any,
  message? : String,
) -> Unit {
  let a = assert_strict_module()
  match message {
    Some(msg) => a._call("equal", [actual, expected, @core.any(msg)]) |> ignore
    None => a._call("equal", [actual, expected]) |> ignore
  }
}

///|
/// Assert strict inequality (!==)
/// In strict mode, notEqual() is an alias for notStrictEqual()
pub fn notEqual(
  actual : @core.Any,
  expected : @core.Any,
  message? : String,
) -> Unit {
  let a = assert_strict_module()
  match message {
    Some(msg) =>
      a._call("notEqual", [actual, expected, @core.any(msg)]) |> ignore
    None => a._call("notEqual", [actual, expected]) |> ignore
  }
}

///|
/// Assert deep strict equality
/// In strict mode, deepEqual() is an alias for deepStrictEqual()
pub fn deepEqual(
  actual : @core.Any,
  expected : @core.Any,
  message? : String,
) -> Unit {
  let a = assert_strict_module()
  match message {
    Some(msg) =>
      a._call("deepEqual", [actual, expected, @core.any(msg)]) |> ignore
    None => a._call("deepEqual", [actual, expected]) |> ignore
  }
}

///|
/// Assert deep strict inequality
/// In strict mode, notDeepEqual() is an alias for notDeepStrictEqual()
pub fn notDeepEqual(
  actual : @core.Any,
  expected : @core.Any,
  message? : String,
) -> Unit {
  let a = assert_strict_module()
  match message {
    Some(msg) =>
      a._call("notDeepEqual", [actual, expected, @core.any(msg)]) |> ignore
    None => a._call("notDeepEqual", [actual, expected]) |> ignore
  }
}

///|
/// Assert strict equality (===) using Object.is()
pub fn strictEqual(
  actual : @core.Any,
  expected : @core.Any,
  message? : String,
) -> Unit {
  let a = assert_strict_module()
  match message {
    Some(msg) =>
      a._call("strictEqual", [actual, expected, @core.any(msg)]) |> ignore
    None => a._call("strictEqual", [actual, expected]) |> ignore
  }
}

///|
/// Assert strict inequality (!==)
pub fn notStrictEqual(
  actual : @core.Any,
  expected : @core.Any,
  message? : String,
) -> Unit {
  let a = assert_strict_module()
  match message {
    Some(msg) =>
      a._call("notStrictEqual", [actual, expected, @core.any(msg)]) |> ignore
    None => a._call("notStrictEqual", [actual, expected]) |> ignore
  }
}

///|
/// Assert deep strict equality recursively
pub fn deepStrictEqual(
  actual : @core.Any,
  expected : @core.Any,
  message? : String,
) -> Unit {
  let a = assert_strict_module()
  match message {
    Some(msg) =>
      a._call("deepStrictEqual", [actual, expected, @core.any(msg)]) |> ignore
    None => a._call("deepStrictEqual", [actual, expected]) |> ignore
  }
}

///|
/// Assert deep strict inequality
pub fn notDeepStrictEqual(
  actual : @core.Any,
  expected : @core.Any,
  message? : String,
) -> Unit {
  let a = assert_strict_module()
  match message {
    Some(msg) =>
      a._call("notDeepStrictEqual", [actual, expected, @core.any(msg)])
      |> ignore
    None => a._call("notDeepStrictEqual", [actual, expected]) |> ignore
  }
}

///| Error Assertions

///|
/// Assert that a function throws
pub fn throws(fn_ : () -> Unit, message? : String) -> Unit {
  let a = assert_strict_module()
  match message {
    Some(msg) =>
      a._call("throws", [@core.from_fn0(fn_), @core.any(msg)]) |> ignore
    None => a._call("throws", [@core.from_fn0(fn_)]) |> ignore
  }
}

///|
/// Assert that a function does not throw
pub fn doesNotThrow(fn_ : () -> Unit, message? : String) -> Unit {
  let a = assert_strict_module()
  match message {
    Some(msg) =>
      a._call("doesNotThrow", [@core.from_fn0(fn_), @core.any(msg)]) |> ignore
    None => a._call("doesNotThrow", [@core.from_fn0(fn_)]) |> ignore
  }
}

///|
/// Assert that a promise rejects
pub async fn rejects(
  promise : @core.Any,
  error? : @core.Any,
  message? : String,
) -> Unit {
  let a = assert_strict_module()
  let p : @js.Promise[Unit] = match (error, message) {
    (Some(err), Some(msg)) =>
      a._call("rejects", [promise, err, @core.any(msg)]).cast()
    (Some(err), None) => a._call("rejects", [promise, err]).cast()
    (None, Some(msg)) => a._call("rejects", [promise, @core.any(msg)]).cast()
    (None, None) => a._call("rejects", [promise]).cast()
  }
  p.wait()
}

///|
/// Assert that a promise does not reject
pub async fn doesNotReject(promise : @core.Any, message? : String) -> Unit {
  let a = assert_strict_module()
  let p : @js.Promise[Unit] = match message {
    Some(msg) => a._call("doesNotReject", [promise, @core.any(msg)]).cast()
    None => a._call("doesNotReject", [promise]).cast()
  }
  p.wait()
}

///| Other Assertions

///|
/// Always fails with AssertionError
pub fn fail(message? : String) -> Unit {
  let a = assert_strict_module()
  match message {
    Some(msg) => a._call("fail", [@core.any(msg)]) |> ignore
    None => a._call("fail", []) |> ignore
  }
}

///|
/// Create RegExp from string
extern "js" fn create_regexp(pattern : String) -> @core.Any =
  #|(pattern) => new RegExp(pattern)

///|
/// Assert regex match
pub fn match_(actual : String, regexp : String, message? : String) -> Unit {
  let a = assert_strict_module()
  let regex = create_regexp(regexp)
  match message {
    Some(msg) =>
      a._call("match", [@core.any(actual), regex, @core.any(msg)]) |> ignore
    None => a._call("match", [@core.any(actual), regex]) |> ignore
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
    Some(msg) =>
      a._call("doesNotMatch", [@core.any(actual), regex, @core.any(msg)])
      |> ignore
    None => a._call("doesNotMatch", [@core.any(actual), regex]) |> ignore
  }
}

///|
/// Throws value if value is not undefined or null
/// Useful for testing error argument in callbacks
pub fn ifError(value : @core.Any) -> Unit {
  let a = assert_strict_module()
  a._call("ifError", [value]) |> ignore
}

///|
/// Assert partial deep strict equality (Node.js 20+)
/// Tests that expected is a subset of actual
#alert(deprecated, "This function is experimental in Node.js")
pub fn partialDeepStrictEqual(
  actual : @core.Any,
  expected : @core.Any,
  message? : String,
) -> Unit {
  let a = assert_strict_module()
  match message {
    Some(msg) =>
      a._call("partialDeepStrictEqual", [actual, expected, @core.any(msg)])
      |> ignore
    None => a._call("partialDeepStrictEqual", [actual, expected]) |> ignore
  }
}
