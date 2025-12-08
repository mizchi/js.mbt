///|
extern "js" fn nodetest() -> @core.Any =
  #| () => require("node:test")

///|
#external
pub type TestContext

///|
pub fn TestContext::as_any(self : TestContext) -> @core.Any = "%identity"

///|
#external
pub type SuiteContext

///|
pub fn SuiteContext::as_any(self : SuiteContext) -> @core.Any = "%identity"

///| TestContext methods

///|
pub fn TestContext::skip(self : Self, message? : String) -> Unit {
  match message {
    Some(msg) => self.as_any()._call("skip", [@core.any(msg)]) |> ignore
    None => self.as_any()._call("skip", []) |> ignore
  }
}

///|
pub fn TestContext::todo(self : Self, message? : String) -> Unit {
  match message {
    Some(msg) => self.as_any()._call("todo", [@core.any(msg)]) |> ignore
    None => self.as_any()._call("todo", []) |> ignore
  }
}

///|
pub fn TestContext::diagnostic(self : Self, message : String) -> Unit {
  self.as_any()._call("diagnostic", [@core.any(message)]) |> ignore
}

///|
pub fn TestContext::plan(self : Self, count : Int) -> Unit {
  self.as_any()._call("plan", [@core.any(count)]) |> ignore
}

///|
pub fn TestContext::runOnly(self : Self, shouldRunOnlyTests : Bool) -> Unit {
  self.as_any()._call("runOnly", [@core.any(shouldRunOnlyTests)]) |> ignore
}

///| TestContext assertion methods

///|
/// Get assert object from context
fn TestContext::assert_obj(self : Self) -> @core.Any {
  self.as_any()["assert"]
}

///|
/// JS: context.assert.ok(value, message?)
pub fn TestContext::assert_ok(
  self : Self,
  value : Bool,
  message? : String,
) -> Unit {
  let assert_obj = self.assert_obj()
  match message {
    Some(msg) =>
      assert_obj._call("ok", [@core.any(value), @core.any(msg)]) |> ignore
    None => assert_obj._call("ok", [@core.any(value)]) |> ignore
  }
}

///|
/// JS: context.assert.strictEqual(actual, expected, message?)
pub fn TestContext::assert_strict_equal(
  self : Self,
  actual : @core.Any,
  expected : @core.Any,
  message? : String,
) -> Unit {
  let assert_obj = self.assert_obj()
  match message {
    Some(msg) =>
      assert_obj._call("strictEqual", [actual, expected, @core.any(msg)])
      |> ignore
    None => assert_obj._call("strictEqual", [actual, expected]) |> ignore
  }
}

///|
/// JS: context.assert.notStrictEqual(actual, expected, message?)
pub fn TestContext::assert_not_strict_equal(
  self : Self,
  actual : @core.Any,
  expected : @core.Any,
  message? : String,
) -> Unit {
  let assert_obj = self.assert_obj()
  match message {
    Some(msg) =>
      assert_obj._call("notStrictEqual", [actual, expected, @core.any(msg)])
      |> ignore
    None => assert_obj._call("notStrictEqual", [actual, expected]) |> ignore
  }
}

///|
/// JS: context.assert.deepStrictEqual(actual, expected, message?)
pub fn TestContext::assert_deep_strict_equal(
  self : Self,
  actual : @core.Any,
  expected : @core.Any,
  message? : String,
) -> Unit {
  let assert_obj = self.assert_obj()
  match message {
    Some(msg) =>
      assert_obj._call("deepStrictEqual", [actual, expected, @core.any(msg)])
      |> ignore
    None => assert_obj._call("deepStrictEqual", [actual, expected]) |> ignore
  }
}

///|
/// JS: context.assert.notDeepStrictEqual(actual, expected, message?)
pub fn TestContext::assert_not_deep_strict_equal(
  self : Self,
  actual : @core.Any,
  expected : @core.Any,
  message? : String,
) -> Unit {
  let assert_obj = self.assert_obj()
  match message {
    Some(msg) =>
      assert_obj._call("notDeepStrictEqual", [actual, expected, @core.any(msg)])
      |> ignore
    None => assert_obj._call("notDeepStrictEqual", [actual, expected]) |> ignore
  }
}

///|
/// JS: context.assert.match(string, regexp, message?)
pub fn TestContext::assert_match(
  self : Self,
  string : String,
  regexp : @regexp.RegExp,
  message? : String,
) -> Unit {
  let assert_obj = self.assert_obj()
  match message {
    Some(msg) =>
      assert_obj._call("match", [
        @core.any(string),
        @core.any(regexp),
        @core.any(msg),
      ])
      |> ignore
    None =>
      assert_obj._call("match", [@core.any(string), @core.any(regexp)])
      |> ignore
  }
}

///|
/// JS: context.assert.doesNotMatch(string, regexp, message?)
pub fn TestContext::assert_does_not_match(
  self : Self,
  string : String,
  regexp : @regexp.RegExp,
  message? : String,
) -> Unit {
  let assert_obj = self.assert_obj()
  match message {
    Some(msg) =>
      assert_obj._call("doesNotMatch", [
        @core.any(string),
        @core.any(regexp),
        @core.any(msg),
      ])
      |> ignore
    None =>
      assert_obj._call("doesNotMatch", [@core.any(string), @core.any(regexp)])
      |> ignore
  }
}

///|
/// JS: context.assert.throws(fn, error?, message?)
pub fn TestContext::assert_throws(
  self : Self,
  fn_ : () -> Unit,
  error? : @core.Any,
  message? : String,
) -> Unit {
  let assert_obj = self.assert_obj()
  let fn_js = @core.any(@core.from_fn0(fn_))
  match (error, message) {
    (Some(err), Some(msg)) =>
      assert_obj._call("throws", [fn_js, err, @core.any(msg)]) |> ignore
    (Some(err), None) => assert_obj._call("throws", [fn_js, err]) |> ignore
    (None, Some(msg)) =>
      assert_obj._call("throws", [fn_js, @core.any(msg)]) |> ignore
    (None, None) => assert_obj._call("throws", [fn_js]) |> ignore
  }
}

///|
/// JS: context.assert.doesNotThrow(fn, error?, message?)
pub fn TestContext::assert_does_not_throw(
  self : Self,
  fn_ : () -> Unit,
  error? : @core.Any,
  message? : String,
) -> Unit {
  let assert_obj = self.assert_obj()
  let fn_js = @core.any(@core.from_fn0(fn_))
  match (error, message) {
    (Some(err), Some(msg)) =>
      assert_obj._call("doesNotThrow", [fn_js, err, @core.any(msg)]) |> ignore
    (Some(err), None) =>
      assert_obj._call("doesNotThrow", [fn_js, err]) |> ignore
    (None, Some(msg)) =>
      assert_obj._call("doesNotThrow", [fn_js, @core.any(msg)]) |> ignore
    (None, None) => assert_obj._call("doesNotThrow", [fn_js]) |> ignore
  }
}

///|
/// Not Tested
/// JS: context.assert.rejects(asyncFn, error?, message?)
pub fn TestContext::assert_rejects(
  self : Self,
  asyncFn : async () -> Unit,
  error? : @core.Any,
  message? : String,
) -> Unit {
  let assert_obj = self.assert_obj()
  let promise_js : @core.Any = @core.promisify0(asyncFn)() |> @core.any
  match (error, message) {
    (Some(err), Some(msg)) =>
      assert_obj._call("rejects", [promise_js, err, @core.any(msg)]) |> ignore
    (Some(err), None) =>
      assert_obj._call("rejects", [promise_js, err]) |> ignore
    (None, Some(msg)) =>
      assert_obj._call("rejects", [promise_js, @core.any(msg)]) |> ignore
    (None, None) => assert_obj._call("rejects", [promise_js]) |> ignore
  }
}

///|
/// JS: context.assert.doesNotReject(asyncFn, error?, message?)
pub fn TestContext::assert_does_not_reject(
  self : Self,
  asyncFn : async () -> Unit,
  error? : @core.Any,
  message? : String,
) -> Unit {
  let assert_obj = self.assert_obj()
  let promise_js : @core.Any = @core.promisify0(asyncFn)() |> @core.any
  match (error, message) {
    (Some(err), Some(msg)) =>
      assert_obj._call("doesNotReject", [promise_js, err, @core.any(msg)])
      |> ignore
    (Some(err), None) =>
      assert_obj._call("doesNotReject", [promise_js, err]) |> ignore
    (None, Some(msg)) =>
      assert_obj._call("doesNotReject", [promise_js, @core.any(msg)]) |> ignore
    (None, None) => assert_obj._call("doesNotReject", [promise_js]) |> ignore
  }
}

///| Test definition functions

///|
/// test_(name, fn) - Define a test case (test is reserved keyword)
pub fn test_(
  name : String,
  skip? : Bool,
  todo? : Bool,
  only? : Bool,
  timeout? : Int,
  f : async (TestContext) -> Unit,
) -> Unit {
  let options = @core.new_object()
  if skip is Some(true) {
    options._set("skip", @core.any(true))
  }
  if todo is Some(true) {
    options._set("todo", @core.any(true))
  }
  if only is Some(true) {
    options._set("only", @core.any(true))
  }
  if timeout is Some(t) {
    options._set("timeout", @core.any(t))
  }
  nodetest()._call("test", [
    @core.any(name),
    options,
    @core.any(@core.promisify1(f) |> @core.from_fn1),
  ])
  |> ignore
}

///|
/// it(name, fn) - Alias for test()
pub fn it(
  name : String,
  skip? : String,
  todo? : String,
  only? : Bool,
  timeout? : Int,
  f : async (TestContext) -> Unit,
) -> Unit {
  let options = @core.new_object()
  if skip is Some(s) {
    options._set("skip", @core.any(s))
  }
  if todo is Some(t) {
    options._set("todo", @core.any(t))
  }
  if only is Some(true) {
    options._set("only", @core.any(true))
  }
  if timeout is Some(t) {
    options._set("timeout", @core.any(t))
  }
  nodetest()._call("it", [
    @core.any(name),
    options,
    @core.any(@core.promisify1(f) |> @core.from_fn1),
  ])
  |> ignore
}

///|
/// describe(name, fn) - Group related tests (BDD style)
pub fn describe(
  name : String,
  skip? : Bool,
  todo? : Bool,
  only? : Bool,
  timeout? : Int,
  f : async (SuiteContext) -> Unit,
) -> Unit {
  let options = @core.new_object()
  if skip is Some(true) {
    options._set("skip", @core.any(true))
  }
  if todo is Some(true) {
    options._set("todo", @core.any(true))
  }
  if only is Some(true) {
    options._set("only", @core.any(true))
  }
  if timeout is Some(t) {
    options._set("timeout", @core.any(t))
  }
  nodetest()._call("describe", [
    @core.any(name),
    options,
    @core.any(@core.promisify1(f) |> @core.from_fn1),
  ])
  |> ignore
}

///| Lifecycle hooks

///|
/// before(fn) - Run once before suite tests
pub fn before(f : async () -> Unit, timeout? : Int) -> Unit {
  let options = @core.new_object()
  if timeout is Some(t) {
    options._set("timeout", t |> @core.any)
  }
  nodetest()._call("before", [@core.promisify0(f) |> @core.from_fn0, options])
  |> ignore
}

///|
/// after(fn) - Run once after suite completion
pub fn after(f : async () -> Unit, timeout? : Int) -> Unit {
  let options = @core.new_object()
  if timeout is Some(t) {
    options._set("timeout", t |> @core.any)
  }
  nodetest()._call("after", [@core.promisify0(f) |> @core.from_fn0, options])
  |> ignore
}

///|
/// beforeEach(fn) - Run before each test
pub fn beforeEach(f : async () -> Unit, timeout? : Int) -> Unit {
  let options = @core.new_object()
  if timeout is Some(t) {
    options._set("timeout", t |> @core.any)
  }
  nodetest()._call("beforeEach", [
    @core.promisify0(f) |> @core.from_fn0,
    options,
  ])
  |> ignore
}

///|
/// afterEach(fn) - Run after each test
pub fn afterEach(f : async () -> Unit, timeout? : Int) -> Unit {
  let options = @core.new_object()
  if timeout is Some(t) {
    options._set("timeout", t |> @core.any)
  }
  nodetest()._call("afterEach", [@core.promisify0(f) |> @core.from_fn0, options])
  |> ignore
}

///|
/// Aliases for compatibility
#alias(before_all)
pub fn beforeAll(f : async () -> Unit) -> Unit {
  before(f)
}

///|
#alias(after_all)
pub fn afterAll(f : async () -> Unit) -> Unit {
  after(f)
}
