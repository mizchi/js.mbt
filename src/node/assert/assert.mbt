///|
#module("node:assert")
extern "js" fn ffi_ok(value : Bool, message : String?) -> Unit = "ok"

///|
#module("node:assert")
extern "js" fn ffi_equal(
  actual : @core.Any,
  expected : @core.Any,
  message : String?,
) -> Unit = "equal"

///|
#module("node:assert")
extern "js" fn ffi_not_equal(
  actual : @core.Any,
  expected : @core.Any,
  message : String?,
) -> Unit = "notEqual"

///|
#module("node:assert")
extern "js" fn ffi_deep_equal(
  actual : @core.Any,
  expected : @core.Any,
  message : String?,
) -> Unit = "deepEqual"

///|
#module("node:assert")
extern "js" fn ffi_not_deep_equal(
  actual : @core.Any,
  expected : @core.Any,
  message : String?,
) -> Unit = "notDeepEqual"

///|
#module("node:assert")
extern "js" fn ffi_strict_equal(
  actual : @core.Any,
  expected : @core.Any,
  message : String?,
) -> Unit = "strictEqual"

///|
#module("node:assert")
extern "js" fn ffi_not_strict_equal(
  actual : @core.Any,
  expected : @core.Any,
  message : String?,
) -> Unit = "notStrictEqual"

///|
#module("node:assert")
extern "js" fn ffi_deep_strict_equal(
  actual : @core.Any,
  expected : @core.Any,
  message : String?,
) -> Unit = "deepStrictEqual"

///|
#module("node:assert")
extern "js" fn ffi_not_deep_strict_equal(
  actual : @core.Any,
  expected : @core.Any,
  message : String?,
) -> Unit = "notDeepStrictEqual"

///|
#module("node:assert")
extern "js" fn ffi_throws(fn_ : () -> Unit, message : String?) -> Unit = "throws"

///|
#module("node:assert")
extern "js" fn ffi_does_not_throw(fn_ : () -> Unit, message : String?) -> Unit = "doesNotThrow"

///|
#module("node:assert")
extern "js" fn ffi_fail(message : String?) -> Unit = "fail"

///|
#module("node:assert")
extern "js" fn ffi_if_error(value : @core.Any) -> Unit = "ifError"

///|
#module("node:assert")
extern "js" fn ffi_rejects(
  promise : @core.Any,
  error : @core.Any,
  message : String?,
) -> @core.Promise[Unit] = "rejects"

///|
#module("node:assert")
extern "js" fn ffi_does_not_reject(
  promise : @core.Any,
  message : String?,
) -> @core.Promise[Unit] = "doesNotReject"

///|
#module("node:assert")
extern "js" fn ffi_match(
  actual : String,
  regex : @core.Any,
  message : String?,
) -> Unit = "match"

///|
#module("node:assert")
extern "js" fn ffi_does_not_match(
  actual : String,
  regex : @core.Any,
  message : String?,
) -> Unit = "doesNotMatch"

///|
extern "js" fn ffi_undefined() -> @core.Any =
  #| () => undefined

///| Basic Assertions

///|
/// Assert that a value is truthy
pub fn ok(value : Bool, message? : String) -> Unit {
  ffi_ok(value, message)
}

///|
/// Assert equality (==)
pub fn equal(
  actual : @core.Any,
  expected : @core.Any,
  message? : String,
) -> Unit {
  ffi_equal(actual, expected, message)
}

///|
/// Assert inequality (!=)
pub fn notEqual(
  actual : @core.Any,
  expected : @core.Any,
  message? : String,
) -> Unit {
  ffi_not_equal(actual, expected, message)
}

///|
/// Assert deep equality
pub fn deepEqual(
  actual : @core.Any,
  expected : @core.Any,
  message? : String,
) -> Unit {
  ffi_deep_equal(actual, expected, message)
}

///|
/// Assert deep inequality
pub fn notDeepEqual(
  actual : @core.Any,
  expected : @core.Any,
  message? : String,
) -> Unit {
  ffi_not_deep_equal(actual, expected, message)
}

///|
/// Assert strict equality (===)
pub fn strictEqual(
  actual : @core.Any,
  expected : @core.Any,
  message? : String,
) -> Unit {
  ffi_strict_equal(actual, expected, message)
}

///|
/// Assert strict inequality (!==)
pub fn notStrictEqual(
  actual : @core.Any,
  expected : @core.Any,
  message? : String,
) -> Unit {
  ffi_not_strict_equal(actual, expected, message)
}

///|
/// Assert deep strict equality recursively
pub fn deepStrictEqual(
  actual : @core.Any,
  expected : @core.Any,
  message? : String,
) -> Unit {
  ffi_deep_strict_equal(actual, expected, message)
}

///|
/// Assert deep strict inequality
pub fn notDeepStrictEqual(
  actual : @core.Any,
  expected : @core.Any,
  message? : String,
) -> Unit {
  ffi_not_deep_strict_equal(actual, expected, message)
}

///| Error Assertions

///|
/// Assert that a function throws
pub fn throws(fn_ : () -> Unit, message? : String) -> Unit {
  ffi_throws(fn_, message)
}

///|
/// Assert that a function does not throw
pub fn doesNotThrow(fn_ : () -> Unit, message? : String) -> Unit {
  ffi_does_not_throw(fn_, message)
}

///|
/// Assert that a promise rejects
pub async fn rejects(
  promise : @core.Any,
  error? : @core.Any,
  message? : String,
) -> Unit {
  let err = match error {
    Some(e) => e
    None => ffi_undefined()
  }
  ffi_rejects(promise, err, message).wait()
}

///|
/// Assert that a promise does not reject
pub async fn doesNotReject(promise : @core.Any, message? : String) -> Unit {
  ffi_does_not_reject(promise, message).wait()
}

///| Other Assertions

///|
/// Always fails
pub fn fail(message? : String) -> Unit {
  ffi_fail(message)
}

///|
/// Create RegExp from string
extern "js" fn create_regexp(pattern : String) -> @core.Any =
  #|(pattern) => new RegExp(pattern)

///|
/// Assert regex match
pub fn match_(actual : String, regexp : String, message? : String) -> Unit {
  ffi_match(actual, create_regexp(regexp), message)
}

///|
/// Assert regex does not match
pub fn doesNotMatch(
  actual : String,
  regexp : String,
  message? : String,
) -> Unit {
  ffi_does_not_match(actual, create_regexp(regexp), message)
}

///|
/// Throws value if value is not undefined or null
/// Useful for testing error argument in callbacks
pub fn ifError(value : @core.Any) -> Unit {
  ffi_if_error(value)
}
