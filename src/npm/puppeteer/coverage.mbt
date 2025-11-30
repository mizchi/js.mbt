///|
/// Code coverage support for Puppeteer
/// See: https://pptr.dev/api/puppeteer.coverage

///|
/// Coverage type
/// See: https://pptr.dev/api/puppeteer.coverage
#external
pub type Coverage

///|
pub fn Coverage::as_any(self : Coverage) -> @js.Any = "%identity"

// Internal helper functions for method calls

///|
fn Coverage::call0(self : Coverage, name : String) -> @js.Any {
  self.as_any().call(name, [])
}

///|
fn[T] Coverage::call1(self : Coverage, name : String, arg : T) -> @js.Any {
  self.as_any().call(name, [@js.identity(arg)])
}

///|
/// CoverageRange type
/// Represents a range of used code
pub(all) struct CoverageRange {
  start : Int
  end : Int
} derive(Show)

///|
/// JSCoverageEntry type
pub(all) struct JSCoverageEntry {
  url : String
  text : String
  ranges : Array[@js.Any]
} derive(Show)

///|
/// CSSCoverageEntry type
pub(all) struct CSSCoverageEntry {
  url : String
  text : String
  ranges : Array[@js.Any]
} derive(Show)

///| Page methods (coverage)

///|
/// Page: Get coverage instance
/// JS: page.coverage
pub fn Page::coverage(self : Page) -> Coverage {
  self.as_any().get("coverage").cast()
}

///| Coverage methods

///|
/// Coverage: Start JavaScript coverage
/// JS: coverage.startJSCoverage(options)
/// See: https://pptr.dev/api/puppeteer.coverage.startjscoverage
pub async fn Coverage::startJSCoverage(self : Coverage) -> Unit {
  let promise : @js.Promise[Unit] = @js.identity(self.call0("startJSCoverage"))
  promise.wait()
}

///|
/// Coverage: Start JavaScript coverage with options
/// JS: coverage.startJSCoverage(options)
pub async fn Coverage::startJSCoverage_with(
  self : Coverage,
  options : @js.Any,
) -> Unit {
  let promise : @js.Promise[Unit] = @js.identity(
    self.call1("startJSCoverage", options),
  )
  promise.wait()
}

///|
/// Coverage: Stop JavaScript coverage
/// JS: coverage.stopJSCoverage()
/// See: https://pptr.dev/api/puppeteer.coverage.stopjscoverage
/// Returns array of coverage entries
pub async fn Coverage::stopJSCoverage(self : Coverage) -> Array[@js.Any] {
  let promise : @js.Promise[Array[@js.Any]] = @js.identity(
    self.call0("stopJSCoverage"),
  )
  promise.wait()
}

///|
/// Coverage: Start CSS coverage
/// JS: coverage.startCSSCoverage(options)
/// See: https://pptr.dev/api/puppeteer.coverage.startcsscoverage
pub async fn Coverage::startCSSCoverage(self : Coverage) -> Unit {
  let promise : @js.Promise[Unit] = @js.identity(self.call0("startCSSCoverage"))
  promise.wait()
}

///|
/// Coverage: Start CSS coverage with options
/// JS: coverage.startCSSCoverage(options)
pub async fn Coverage::startCSSCoverage_with(
  self : Coverage,
  options : @js.Any,
) -> Unit {
  let promise : @js.Promise[Unit] = @js.identity(
    self.call1("startCSSCoverage", options),
  )
  promise.wait()
}

///|
/// Coverage: Stop CSS coverage
/// JS: coverage.stopCSSCoverage()
/// See: https://pptr.dev/api/puppeteer.coverage.stopcsscoverage
/// Returns array of coverage entries
pub async fn Coverage::stopCSSCoverage(self : Coverage) -> Array[@js.Any] {
  let promise : @js.Promise[Array[@js.Any]] = @js.identity(
    self.call0("stopCSSCoverage"),
  )
  promise.wait()
}
