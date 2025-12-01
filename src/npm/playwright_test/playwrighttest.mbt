///|
/// @playwright/test bindings for MoonBit
/// https://playwright.dev/docs/api/class-test
///
/// This module provides bindings for Playwright Test framework.
/// Note: This is intended for use in JavaScript test runners, not moon test.

///| Test Runner Types

///|
/// Test function type - represents a Playwright test case
#external
pub type Test

///|
pub fn Test::to_any(self : Test) -> @nostd.Any = "%identity"

///|
/// Expect function type - for assertions
#external
pub type Expect

///|
pub fn Expect::to_any(self : Expect) -> @nostd.Any = "%identity"

///|
/// TestInfo - information about the currently running test
#external
pub type TestInfo

///|
pub fn TestInfo::to_any(self : TestInfo) -> @nostd.Any = "%identity"

///|
/// PageAssertions - assertions for Page
#external
pub type PageAssertions

///|
pub fn PageAssertions::to_any(self : PageAssertions) -> @nostd.Any = "%identity"

///|
/// LocatorAssertions - assertions for Locator
#external
pub type LocatorAssertions

///|
pub fn LocatorAssertions::to_any(self : LocatorAssertions) -> @nostd.Any =
  "%identity"

///| FFI Functions

///|
extern "js" fn ffi_test() -> Test =
  #| () => {
  #|   const { test } = require('@playwright/test');
  #|   return test;
  #| }

///|
extern "js" fn ffi_expect() -> Expect =
  #| () => {
  #|   const { expect } = require('@playwright/test');
  #|   return expect;
  #| }

///| Module Functions

///|
/// Get the test function
pub fn test_fn() -> Test {
  ffi_test()
}

///|
/// Get the expect function
pub fn expect_fn() -> Expect {
  ffi_expect()
}

///| Test Methods

///|
/// Call test function directly (test is callable)
extern "js" fn ffi_call_test(
  t : Test,
  name : String,
  callback : @nostd.Any,
) -> Unit =
  #| (t, name, callback) => t(name, callback)

///|
/// Define a test case
pub fn Test::run(self : Test, name : String, callback : @nostd.Any) -> Unit {
  ffi_call_test(self, name, callback)
}

///|
/// Define a test describe block
extern "js" fn ffi_describe(
  t : Test,
  name : String,
  callback : @nostd.Any,
) -> Unit =
  #| (t, name, callback) => t.describe(name, callback)

///|
pub fn Test::describe(self : Test, name : String, callback : @nostd.Any) -> Unit {
  ffi_describe(self, name, callback)
}

///|
/// Skip test(s)
extern "js" fn ffi_skip(t : Test) -> Unit =
  #| (t) => t.skip()

///|
extern "js" fn ffi_skip_if(t : Test, condition : Bool) -> Unit =
  #| (t, condition) => t.skip(condition)

///|
pub fn Test::skip(self : Test, condition? : Bool) -> Unit {
  match condition {
    Some(c) => ffi_skip_if(self, c)
    None => ffi_skip(self)
  }
}

///|
/// Mark test as slow (triples timeout)
extern "js" fn ffi_slow(t : Test) -> Unit =
  #| (t) => t.slow()

///|
pub fn Test::slow(self : Test) -> Unit {
  ffi_slow(self)
}

///|
/// Set test timeout
pub fn Test::setTimeout(self : Test, timeout_ms : Int) -> Unit {
  self.to_any()._call("setTimeout", [@nostd.any(timeout_ms)]) |> ignore
}

///|
/// beforeEach hook
extern "js" fn ffi_beforeEach(t : Test, callback : @nostd.Any) -> Unit =
  #| (t, callback) => t.beforeEach(callback)

///|
pub fn Test::beforeEach(self : Test, callback : @nostd.Any) -> Unit {
  ffi_beforeEach(self, callback)
}

///|
/// afterEach hook
extern "js" fn ffi_afterEach(t : Test, callback : @nostd.Any) -> Unit =
  #| (t, callback) => t.afterEach(callback)

///|
pub fn Test::afterEach(self : Test, callback : @nostd.Any) -> Unit {
  ffi_afterEach(self, callback)
}

///|
/// beforeAll hook
extern "js" fn ffi_beforeAll(t : Test, callback : @nostd.Any) -> Unit =
  #| (t, callback) => t.beforeAll(callback)

///|
pub fn Test::beforeAll(self : Test, callback : @nostd.Any) -> Unit {
  ffi_beforeAll(self, callback)
}

///|
/// afterAll hook
extern "js" fn ffi_afterAll(t : Test, callback : @nostd.Any) -> Unit =
  #| (t, callback) => t.afterAll(callback)

///|
pub fn Test::afterAll(self : Test, callback : @nostd.Any) -> Unit {
  ffi_afterAll(self, callback)
}

///|
/// Configure test options
extern "js" fn ffi_use(t : Test, options : @nostd.Any) -> Unit =
  #| (t, options) => t.use(options)

///|
pub fn Test::use_options(self : Test, options : @nostd.Any) -> Unit {
  ffi_use(self, options)
}

///| Expect Methods

///|
/// Call expect function (expect is callable)
extern "js" fn ffi_expect_value(expect : Expect, value : @nostd.Any) -> @nostd.Any =
  #| (expect, value) => expect(value)

///|
/// Create expectation for a value
pub fn Expect::value(self : Expect, value : @nostd.Any) -> @nostd.Any {
  ffi_expect_value(self, value)
}

///|
/// Create page assertions
pub fn Expect::page(self : Expect, page : @playwright.Page) -> PageAssertions {
  @js.identity(ffi_expect_value(self, page.to_any() |> @js.identity))
}

///|
/// Create locator assertions
pub fn Expect::locator(
  self : Expect,
  locator : @playwright.Locator,
) -> LocatorAssertions {
  @js.identity(ffi_expect_value(self, locator.to_any() |> @js.identity))
}

///| Page Assertions

///|
/// Assert page has expected title
pub async fn PageAssertions::toHaveTitle(
  self : PageAssertions,
  title : String,
  timeout? : Int,
) -> Unit {
  let options = @nostd.Object::new()
  if timeout is Some(v) {
    options["timeout"] = @nostd.any(v)
  }
  let promise : @js.Promise[Unit] = @js.identity(
    self.to_any()._call("toHaveTitle", [@nostd.any(title), options])
    |> @js.identity,
  )
  promise.wait()
}

///|
/// Assert page has expected URL
pub async fn PageAssertions::toHaveURL(
  self : PageAssertions,
  url : String,
  timeout? : Int,
) -> Unit {
  let options = @nostd.Object::new()
  if timeout is Some(v) {
    options["timeout"] = @nostd.any(v)
  }
  let promise : @js.Promise[Unit] = @js.identity(
    self.to_any()._call("toHaveURL", [@nostd.any(url), options]) |> @js.identity,
  )
  promise.wait()
}

///| Locator Assertions

///|
/// Assert locator is visible
pub async fn LocatorAssertions::toBeVisible(
  self : LocatorAssertions,
  timeout? : Int,
) -> Unit {
  let options = @nostd.Object::new()
  if timeout is Some(v) {
    options["timeout"] = @nostd.any(v)
  }
  let promise : @js.Promise[Unit] = @js.identity(
    self.to_any()._call("toBeVisible", [options]) |> @js.identity,
  )
  promise.wait()
}

///|
/// Assert locator is hidden
pub async fn LocatorAssertions::toBeHidden(
  self : LocatorAssertions,
  timeout? : Int,
) -> Unit {
  let options = @nostd.Object::new()
  if timeout is Some(v) {
    options["timeout"] = @nostd.any(v)
  }
  let promise : @js.Promise[Unit] = @js.identity(
    self.to_any()._call("toBeHidden", [options]) |> @js.identity,
  )
  promise.wait()
}

///|
/// Assert locator is enabled
pub async fn LocatorAssertions::toBeEnabled(
  self : LocatorAssertions,
  timeout? : Int,
) -> Unit {
  let options = @nostd.Object::new()
  if timeout is Some(v) {
    options["timeout"] = @nostd.any(v)
  }
  let promise : @js.Promise[Unit] = @js.identity(
    self.to_any()._call("toBeEnabled", [options]) |> @js.identity,
  )
  promise.wait()
}

///|
/// Assert locator is disabled
pub async fn LocatorAssertions::toBeDisabled(
  self : LocatorAssertions,
  timeout? : Int,
) -> Unit {
  let options = @nostd.Object::new()
  if timeout is Some(v) {
    options["timeout"] = @nostd.any(v)
  }
  let promise : @js.Promise[Unit] = @js.identity(
    self.to_any()._call("toBeDisabled", [options]) |> @js.identity,
  )
  promise.wait()
}

///|
/// Assert locator is checked
pub async fn LocatorAssertions::toBeChecked(
  self : LocatorAssertions,
  checked? : Bool,
  timeout? : Int,
) -> Unit {
  let options = @nostd.Object::new()
  if checked is Some(v) {
    options["checked"] = @nostd.any(v)
  }
  if timeout is Some(v) {
    options["timeout"] = @nostd.any(v)
  }
  let promise : @js.Promise[Unit] = @js.identity(
    self.to_any()._call("toBeChecked", [options]) |> @js.identity,
  )
  promise.wait()
}

///|
/// Assert locator has expected text
pub async fn LocatorAssertions::toHaveText(
  self : LocatorAssertions,
  text : String,
  ignoreCase? : Bool,
  timeout? : Int,
) -> Unit {
  let options = @nostd.Object::new()
  if ignoreCase is Some(v) {
    options["ignoreCase"] = @nostd.any(v)
  }
  if timeout is Some(v) {
    options["timeout"] = @nostd.any(v)
  }
  let promise : @js.Promise[Unit] = @js.identity(
    self.to_any()._call("toHaveText", [@nostd.any(text), options])
    |> @js.identity,
  )
  promise.wait()
}

///|
/// Assert locator contains expected text
pub async fn LocatorAssertions::toContainText(
  self : LocatorAssertions,
  text : String,
  ignoreCase? : Bool,
  timeout? : Int,
) -> Unit {
  let options = @nostd.Object::new()
  if ignoreCase is Some(v) {
    options["ignoreCase"] = @nostd.any(v)
  }
  if timeout is Some(v) {
    options["timeout"] = @nostd.any(v)
  }
  let promise : @js.Promise[Unit] = @js.identity(
    self.to_any()._call("toContainText", [@nostd.any(text), options])
    |> @js.identity,
  )
  promise.wait()
}

///|
/// Assert locator has expected value
pub async fn LocatorAssertions::toHaveValue(
  self : LocatorAssertions,
  value : String,
  timeout? : Int,
) -> Unit {
  let options = @nostd.Object::new()
  if timeout is Some(v) {
    options["timeout"] = @nostd.any(v)
  }
  let promise : @js.Promise[Unit] = @js.identity(
    self.to_any()._call("toHaveValue", [@nostd.any(value), options])
    |> @js.identity,
  )
  promise.wait()
}

///|
/// Assert locator has expected attribute
pub async fn LocatorAssertions::toHaveAttribute(
  self : LocatorAssertions,
  name : String,
  value : String,
  timeout? : Int,
) -> Unit {
  let options = @nostd.Object::new()
  if timeout is Some(v) {
    options["timeout"] = @nostd.any(v)
  }
  let promise : @js.Promise[Unit] = @js.identity(
    self
    .to_any()
    ._call("toHaveAttribute", [@nostd.any(name), @nostd.any(value), options])
    |> @js.identity,
  )
  promise.wait()
}

///|
/// Assert locator has expected class
pub async fn LocatorAssertions::toHaveClass(
  self : LocatorAssertions,
  class_ : String,
  timeout? : Int,
) -> Unit {
  let options = @nostd.Object::new()
  if timeout is Some(v) {
    options["timeout"] = @nostd.any(v)
  }
  let promise : @js.Promise[Unit] = @js.identity(
    self.to_any()._call("toHaveClass", [@nostd.any(class_), options])
    |> @js.identity,
  )
  promise.wait()
}

///|
/// Assert locator has expected count
pub async fn LocatorAssertions::toHaveCount(
  self : LocatorAssertions,
  count : Int,
  timeout? : Int,
) -> Unit {
  let options = @nostd.Object::new()
  if timeout is Some(v) {
    options["timeout"] = @nostd.any(v)
  }
  let promise : @js.Promise[Unit] = @js.identity(
    self.to_any()._call("toHaveCount", [@nostd.any(count), options])
    |> @js.identity,
  )
  promise.wait()
}

///|
/// Assert locator has focus
pub async fn LocatorAssertions::toBeFocused(
  self : LocatorAssertions,
  timeout? : Int,
) -> Unit {
  let options = @nostd.Object::new()
  if timeout is Some(v) {
    options["timeout"] = @nostd.any(v)
  }
  let promise : @js.Promise[Unit] = @js.identity(
    self.to_any()._call("toBeFocused", [options]) |> @js.identity,
  )
  promise.wait()
}

///| TestInfo Methods

///|
/// Get test title
pub fn TestInfo::title(self : TestInfo) -> String {
  self.to_any()["title"].cast()
}

///|
/// Get test file path
pub fn TestInfo::file(self : TestInfo) -> String {
  self.to_any()["file"].cast()
}

///|
/// Get test line number
pub fn TestInfo::line(self : TestInfo) -> Int {
  self.to_any()["line"].cast()
}

///|
/// Get test column number
pub fn TestInfo::column(self : TestInfo) -> Int {
  self.to_any()["column"].cast()
}

///|
/// Get test timeout
pub fn TestInfo::timeout(self : TestInfo) -> Int {
  self.to_any()["timeout"].cast()
}

///|
/// Get test retry count
pub fn TestInfo::retry(self : TestInfo) -> Int {
  self.to_any()["retry"].cast()
}

///|
/// Get test status
pub fn TestInfo::status(self : TestInfo) -> String? {
  let status = self.to_any()["status"]
  if @nostd.is_nullish(status) {
    None
  } else {
    Some(status.cast())
  }
}

///|
/// Skip the test
pub fn TestInfo::skip(self : TestInfo, message? : String) -> Unit {
  match message {
    Some(m) =>
      self.to_any()._call("skip", [@nostd.any(true), @nostd.any(m)]) |> ignore
    None => self.to_any()._call("skip", [@nostd.any(true)]) |> ignore
  }
}

///|
/// Fail the test
pub fn TestInfo::fail(self : TestInfo, message? : String) -> Unit {
  match message {
    Some(m) =>
      self.to_any()._call("fail", [@nostd.any(true), @nostd.any(m)]) |> ignore
    None => self.to_any()._call("fail", [@nostd.any(true)]) |> ignore
  }
}

///|
/// Mark test as slow
pub fn TestInfo::slow(self : TestInfo) -> Unit {
  self.to_any()._call("slow", [@nostd.any(true)]) |> ignore
}

///|
/// Attach file to test report
pub async fn TestInfo::attach(
  self : TestInfo,
  name : String,
  path? : String,
  body? : String,
  contentType? : String,
) -> Unit {
  let options = @nostd.Object::new()
  if path is Some(v) {
    options["path"] = @nostd.any(v)
  }
  if body is Some(v) {
    options["body"] = @nostd.any(v)
  }
  if contentType is Some(v) {
    options["contentType"] = @nostd.any(v)
  }
  let promise : @js.Promise[Unit] = @js.identity(
    self.to_any()._call("attach", [@nostd.any(name), options]) |> @js.identity,
  )
  promise.wait()
}
