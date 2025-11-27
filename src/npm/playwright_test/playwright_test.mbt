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
pub impl @js.JsImpl for Test

///|
/// Expect function type - for assertions
#external
pub type Expect

///|
pub impl @js.JsImpl for Expect

///|
/// TestInfo - information about the currently running test
#external
pub type TestInfo

///|
pub impl @js.JsImpl for TestInfo

///|
/// PageAssertions - assertions for Page
#external
pub type PageAssertions

///|
pub impl @js.JsImpl for PageAssertions

///|
/// LocatorAssertions - assertions for Locator
#external
pub type LocatorAssertions

///|
pub impl @js.JsImpl for LocatorAssertions

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
extern "js" fn ffi_call_test(t : Test, name : String, callback : @js.Any) -> Unit =
  #| (t, name, callback) => t(name, callback)

///|
/// Define a test case
pub fn Test::run(self : Test, name : String, callback : @js.Any) -> Unit {
  ffi_call_test(self, name, callback)
}

///|
/// Define a test describe block
extern "js" fn ffi_describe(t : Test, name : String, callback : @js.Any) -> Unit =
  #| (t, name, callback) => t.describe(name, callback)

///|
pub fn Test::describe(self : Test, name : String, callback : @js.Any) -> Unit {
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
  let _ = self.call("setTimeout", [timeout_ms])
}

///|
/// beforeEach hook
extern "js" fn ffi_beforeEach(t : Test, callback : @js.Any) -> Unit =
  #| (t, callback) => t.beforeEach(callback)

///|
pub fn Test::beforeEach(self : Test, callback : @js.Any) -> Unit {
  ffi_beforeEach(self, callback)
}

///|
/// afterEach hook
extern "js" fn ffi_afterEach(t : Test, callback : @js.Any) -> Unit =
  #| (t, callback) => t.afterEach(callback)

///|
pub fn Test::afterEach(self : Test, callback : @js.Any) -> Unit {
  ffi_afterEach(self, callback)
}

///|
/// beforeAll hook
extern "js" fn ffi_beforeAll(t : Test, callback : @js.Any) -> Unit =
  #| (t, callback) => t.beforeAll(callback)

///|
pub fn Test::beforeAll(self : Test, callback : @js.Any) -> Unit {
  ffi_beforeAll(self, callback)
}

///|
/// afterAll hook
extern "js" fn ffi_afterAll(t : Test, callback : @js.Any) -> Unit =
  #| (t, callback) => t.afterAll(callback)

///|
pub fn Test::afterAll(self : Test, callback : @js.Any) -> Unit {
  ffi_afterAll(self, callback)
}

///|
/// Configure test options
extern "js" fn ffi_use(t : Test, options : @js.Any) -> Unit =
  #| (t, options) => t.use(options)

///|
pub fn Test::use_options(self : Test, options : @js.Any) -> Unit {
  ffi_use(self, options)
}

///| Expect Methods

///|
/// Call expect function (expect is callable)
extern "js" fn ffi_expect_value(expect : Expect, value : @js.Any) -> @js.Any =
  #| (expect, value) => expect(value)

///|
/// Create expectation for a value
pub fn Expect::value(self : Expect, value : @js.Any) -> @js.Any {
  ffi_expect_value(self, value)
}

///|
/// Create page assertions
pub fn Expect::page(self : Expect, page : @playwright.Page) -> PageAssertions {
  @js.identity(ffi_expect_value(self, page.to_any()))
}

///|
/// Create locator assertions
pub fn Expect::locator(
  self : Expect,
  locator : @playwright.Locator,
) -> LocatorAssertions {
  @js.identity(ffi_expect_value(self, locator.to_any()))
}

///| Page Assertions

///|
/// Assert page has expected title
pub async fn PageAssertions::toHaveTitle(
  self : PageAssertions,
  title : String,
  timeout? : Int,
) -> Unit {
  let options = @js.Object::new()
  if timeout is Some(v) {
    options["timeout"] = v
  }
  let promise : @js.Promise[Unit] = @js.identity(
    self.call("toHaveTitle", [@js.any(title), options.to_any()]),
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
  let options = @js.Object::new()
  if timeout is Some(v) {
    options["timeout"] = v
  }
  let promise : @js.Promise[Unit] = @js.identity(
    self.call("toHaveURL", [@js.any(url), options.to_any()]),
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
  let options = @js.Object::new()
  if timeout is Some(v) {
    options["timeout"] = v
  }
  let promise : @js.Promise[Unit] = @js.identity(
    self.call("toBeVisible", [options.to_any()]),
  )
  promise.wait()
}

///|
/// Assert locator is hidden
pub async fn LocatorAssertions::toBeHidden(
  self : LocatorAssertions,
  timeout? : Int,
) -> Unit {
  let options = @js.Object::new()
  if timeout is Some(v) {
    options["timeout"] = v
  }
  let promise : @js.Promise[Unit] = @js.identity(
    self.call("toBeHidden", [options.to_any()]),
  )
  promise.wait()
}

///|
/// Assert locator is enabled
pub async fn LocatorAssertions::toBeEnabled(
  self : LocatorAssertions,
  timeout? : Int,
) -> Unit {
  let options = @js.Object::new()
  if timeout is Some(v) {
    options["timeout"] = v
  }
  let promise : @js.Promise[Unit] = @js.identity(
    self.call("toBeEnabled", [options.to_any()]),
  )
  promise.wait()
}

///|
/// Assert locator is disabled
pub async fn LocatorAssertions::toBeDisabled(
  self : LocatorAssertions,
  timeout? : Int,
) -> Unit {
  let options = @js.Object::new()
  if timeout is Some(v) {
    options["timeout"] = v
  }
  let promise : @js.Promise[Unit] = @js.identity(
    self.call("toBeDisabled", [options.to_any()]),
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
  let options = @js.Object::new()
  if checked is Some(v) {
    options["checked"] = v
  }
  if timeout is Some(v) {
    options["timeout"] = v
  }
  let promise : @js.Promise[Unit] = @js.identity(
    self.call("toBeChecked", [options.to_any()]),
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
  let options = @js.Object::new()
  if ignoreCase is Some(v) {
    options["ignoreCase"] = v
  }
  if timeout is Some(v) {
    options["timeout"] = v
  }
  let promise : @js.Promise[Unit] = @js.identity(
    self.call("toHaveText", [@js.any(text), options.to_any()]),
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
  let options = @js.Object::new()
  if ignoreCase is Some(v) {
    options["ignoreCase"] = v
  }
  if timeout is Some(v) {
    options["timeout"] = v
  }
  let promise : @js.Promise[Unit] = @js.identity(
    self.call("toContainText", [@js.any(text), options.to_any()]),
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
  let options = @js.Object::new()
  if timeout is Some(v) {
    options["timeout"] = v
  }
  let promise : @js.Promise[Unit] = @js.identity(
    self.call("toHaveValue", [@js.any(value), options.to_any()]),
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
  let options = @js.Object::new()
  if timeout is Some(v) {
    options["timeout"] = v
  }
  let promise : @js.Promise[Unit] = @js.identity(
    self.call("toHaveAttribute", [@js.any(name), @js.any(value), options.to_any()]),
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
  let options = @js.Object::new()
  if timeout is Some(v) {
    options["timeout"] = v
  }
  let promise : @js.Promise[Unit] = @js.identity(
    self.call("toHaveClass", [@js.any(class_), options.to_any()]),
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
  let options = @js.Object::new()
  if timeout is Some(v) {
    options["timeout"] = v
  }
  let promise : @js.Promise[Unit] = @js.identity(
    self.call("toHaveCount", [@js.any(count), options.to_any()]),
  )
  promise.wait()
}

///|
/// Assert locator has focus
pub async fn LocatorAssertions::toBeFocused(
  self : LocatorAssertions,
  timeout? : Int,
) -> Unit {
  let options = @js.Object::new()
  if timeout is Some(v) {
    options["timeout"] = v
  }
  let promise : @js.Promise[Unit] = @js.identity(
    self.call("toBeFocused", [options.to_any()]),
  )
  promise.wait()
}

///| TestInfo Methods

///|
/// Get test title
pub fn TestInfo::title(self : TestInfo) -> String {
  self.get("title").cast()
}

///|
/// Get test file path
pub fn TestInfo::file(self : TestInfo) -> String {
  self.get("file").cast()
}

///|
/// Get test line number
pub fn TestInfo::line(self : TestInfo) -> Int {
  self.get("line").cast()
}

///|
/// Get test column number
pub fn TestInfo::column(self : TestInfo) -> Int {
  self.get("column").cast()
}

///|
/// Get test timeout
pub fn TestInfo::timeout(self : TestInfo) -> Int {
  self.get("timeout").cast()
}

///|
/// Get test retry count
pub fn TestInfo::retry(self : TestInfo) -> Int {
  self.get("retry").cast()
}

///|
/// Get test status
pub fn TestInfo::status(self : TestInfo) -> String? {
  let status = self.get("status")
  if @js.is_nullish(status) {
    None
  } else {
    Some(status.cast())
  }
}

///|
/// Skip the test
pub fn TestInfo::skip(self : TestInfo, message? : String) -> Unit {
  match message {
    Some(m) => {
      let _ = self.call("skip", [@js.any(true), @js.any(m)])
    }
    None => {
      let _ = self.call("skip", [@js.any(true)])
    }
  }
}

///|
/// Fail the test
pub fn TestInfo::fail(self : TestInfo, message? : String) -> Unit {
  match message {
    Some(m) => {
      let _ = self.call("fail", [@js.any(true), @js.any(m)])
    }
    None => {
      let _ = self.call("fail", [@js.any(true)])
    }
  }
}

///|
/// Mark test as slow
pub fn TestInfo::slow(self : TestInfo) -> Unit {
  let _ = self.call("slow", [@js.any(true)])
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
  let options = @js.Object::new()
  if path is Some(v) {
    options["path"] = v
  }
  if body is Some(v) {
    options["body"] = v
  }
  if contentType is Some(v) {
    options["contentType"] = v
  }
  let promise : @js.Promise[Unit] = @js.identity(
    self.call("attach", [@js.any(name), options.to_any()]),
  )
  promise.wait()
}
