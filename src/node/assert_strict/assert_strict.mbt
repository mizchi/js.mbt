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
/// (kept for functions with optional message arg)
extern "js" fn assert_strict_module() -> @core.Any =
  #| () => require("node:assert/strict")

///|
#module("node:assert/strict")
extern "js" fn ffi_ok_1(value : Bool) -> Unit = "ok"

///|
#module("node:assert/strict")
extern "js" fn ffi_equal_2(actual : @core.Any, expected : @core.Any) -> Unit = "equal"

///|
#module("node:assert/strict")
extern "js" fn ffi_not_equal_2(
  actual : @core.Any,
  expected : @core.Any,
) -> Unit = "notEqual"

///|
#module("node:assert/strict")
extern "js" fn ffi_deep_equal_2(
  actual : @core.Any,
  expected : @core.Any,
) -> Unit = "deepEqual"

///|
#module("node:assert/strict")
extern "js" fn ffi_not_deep_equal_2(
  actual : @core.Any,
  expected : @core.Any,
) -> Unit = "notDeepEqual"

///|
#module("node:assert/strict")
extern "js" fn ffi_strict_equal_2(
  actual : @core.Any,
  expected : @core.Any,
) -> Unit = "strictEqual"

///|
#module("node:assert/strict")
extern "js" fn ffi_not_strict_equal_2(
  actual : @core.Any,
  expected : @core.Any,
) -> Unit = "notStrictEqual"

///|
#module("node:assert/strict")
extern "js" fn ffi_deep_strict_equal_2(
  actual : @core.Any,
  expected : @core.Any,
) -> Unit = "deepStrictEqual"

///|
#module("node:assert/strict")
extern "js" fn ffi_not_deep_strict_equal_2(
  actual : @core.Any,
  expected : @core.Any,
) -> Unit = "notDeepStrictEqual"

///|
#module("node:assert/strict")
extern "js" fn ffi_throws_1(fn_ : () -> Unit) -> Unit = "throws"

///|
#module("node:assert/strict")
extern "js" fn ffi_does_not_throw_1(fn_ : () -> Unit) -> Unit = "doesNotThrow"

///|
#module("node:assert/strict")
extern "js" fn ffi_fail_0() -> Unit = "fail"

///|
#module("node:assert/strict")
extern "js" fn ffi_if_error(value : @core.Any) -> Unit = "ifError"

///| Basic Assertions

///|
/// Assert that a value is truthy
pub fn ok(value : Bool, message? : String) -> Unit {
  match message {
    Some(msg) =>
      assert_strict_module()._call("ok", [@core.any(value), @core.any(msg)])
      |> ignore
    None => ffi_ok_1(value)
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
  match message {
    Some(msg) =>
      assert_strict_module()._call("equal", [actual, expected, @core.any(msg)])
      |> ignore
    None => ffi_equal_2(actual, expected)
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
  match message {
    Some(msg) =>
      assert_strict_module()._call("notEqual", [
        actual,
        expected,
        @core.any(msg),
      ])
      |> ignore
    None => ffi_not_equal_2(actual, expected)
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
  match message {
    Some(msg) =>
      assert_strict_module()._call("deepEqual", [
        actual,
        expected,
        @core.any(msg),
      ])
      |> ignore
    None => ffi_deep_equal_2(actual, expected)
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
  match message {
    Some(msg) =>
      assert_strict_module()._call("notDeepEqual", [
        actual,
        expected,
        @core.any(msg),
      ])
      |> ignore
    None => ffi_not_deep_equal_2(actual, expected)
  }
}

///|
/// Assert strict equality (===) using Object.is()
pub fn strictEqual(
  actual : @core.Any,
  expected : @core.Any,
  message? : String,
) -> Unit {
  match message {
    Some(msg) =>
      assert_strict_module()._call("strictEqual", [
        actual,
        expected,
        @core.any(msg),
      ])
      |> ignore
    None => ffi_strict_equal_2(actual, expected)
  }
}

///|
/// Assert strict inequality (!==)
pub fn notStrictEqual(
  actual : @core.Any,
  expected : @core.Any,
  message? : String,
) -> Unit {
  match message {
    Some(msg) =>
      assert_strict_module()._call("notStrictEqual", [
        actual,
        expected,
        @core.any(msg),
      ])
      |> ignore
    None => ffi_not_strict_equal_2(actual, expected)
  }
}

///|
/// Assert deep strict equality recursively
pub fn deepStrictEqual(
  actual : @core.Any,
  expected : @core.Any,
  message? : String,
) -> Unit {
  match message {
    Some(msg) =>
      assert_strict_module()._call("deepStrictEqual", [
        actual,
        expected,
        @core.any(msg),
      ])
      |> ignore
    None => ffi_deep_strict_equal_2(actual, expected)
  }
}

///|
/// Assert deep strict inequality
pub fn notDeepStrictEqual(
  actual : @core.Any,
  expected : @core.Any,
  message? : String,
) -> Unit {
  match message {
    Some(msg) =>
      assert_strict_module()._call("notDeepStrictEqual", [
        actual,
        expected,
        @core.any(msg),
      ])
      |> ignore
    None => ffi_not_deep_strict_equal_2(actual, expected)
  }
}

///| Error Assertions

///|
/// Assert that a function throws
pub fn throws(fn_ : () -> Unit, message? : String) -> Unit {
  match message {
    Some(msg) =>
      assert_strict_module()._call("throws", [
        @core.from_fn0(fn_),
        @core.any(msg),
      ])
      |> ignore
    None => ffi_throws_1(fn_)
  }
}

///|
/// Assert that a function does not throw
pub fn doesNotThrow(fn_ : () -> Unit, message? : String) -> Unit {
  match message {
    Some(msg) =>
      assert_strict_module()._call("doesNotThrow", [
        @core.from_fn0(fn_),
        @core.any(msg),
      ])
      |> ignore
    None => ffi_does_not_throw_1(fn_)
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
  let p : @core.Promise[Unit] = match (error, message) {
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
  let p : @core.Promise[Unit] = match message {
    Some(msg) => a._call("doesNotReject", [promise, @core.any(msg)]).cast()
    None => a._call("doesNotReject", [promise]).cast()
  }
  p.wait()
}

///| Other Assertions

///|
/// Always fails with AssertionError
pub fn fail(message? : String) -> Unit {
  match message {
    Some(msg) =>
      assert_strict_module()._call("fail", [@core.any(msg)]) |> ignore
    None => ffi_fail_0()
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
  ffi_if_error(value)
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
