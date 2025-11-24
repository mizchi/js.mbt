///|
/// Code coverage support for Puppeteer
/// See: https://pptr.dev/api/puppeteer.coverage

///|
/// Coverage type
/// See: https://pptr.dev/api/puppeteer.coverage
#external
pub type Coverage

///|
pub impl @js.JsImpl for Coverage

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
  ranges : Array[@js.Js]
} derive(Show)

///|
/// CSSCoverageEntry type
pub(all) struct CSSCoverageEntry {
  url : String
  text : String
  ranges : Array[@js.Js]
} derive(Show)

///| Page methods (coverage)

///|
/// Page: Get coverage instance
/// JS: page.coverage
pub fn Page::coverage(self : Page) -> Coverage {
  self.get("coverage") |> @js.unsafe_cast
}

///| Coverage methods

///|
/// Coverage: Start JavaScript coverage
/// JS: coverage.startJSCoverage(options)
/// See: https://pptr.dev/api/puppeteer.coverage.startjscoverage
pub async fn Coverage::startJSCoverage(self : Coverage) -> Unit {
  let promise : @js.Promise[Unit] = @js.unsafe_cast(
    self.call("startJSCoverage", []),
  )
  promise.wait()
}

///|
/// Coverage: Start JavaScript coverage with options
/// JS: coverage.startJSCoverage(options)
pub async fn Coverage::startJSCoverage_with(
  self : Coverage,
  options : @js.Js,
) -> Unit {
  let promise : @js.Promise[Unit] = @js.unsafe_cast(
    self.call("startJSCoverage", [options]),
  )
  promise.wait()
}

///|
/// Coverage: Stop JavaScript coverage
/// JS: coverage.stopJSCoverage()
/// See: https://pptr.dev/api/puppeteer.coverage.stopjscoverage
/// Returns array of coverage entries
pub async fn Coverage::stopJSCoverage(self : Coverage) -> Array[@js.Js] {
  let promise : @js.Promise[Array[@js.Js]] = @js.unsafe_cast(
    self.call("stopJSCoverage", []),
  )
  promise.wait()
}

///|
/// Coverage: Start CSS coverage
/// JS: coverage.startCSSCoverage(options)
/// See: https://pptr.dev/api/puppeteer.coverage.startcsscoverage
pub async fn Coverage::startCSSCoverage(self : Coverage) -> Unit {
  let promise : @js.Promise[Unit] = @js.unsafe_cast(
    self.call("startCSSCoverage", []),
  )
  promise.wait()
}

///|
/// Coverage: Start CSS coverage with options
/// JS: coverage.startCSSCoverage(options)
pub async fn Coverage::startCSSCoverage_with(
  self : Coverage,
  options : @js.Js,
) -> Unit {
  let promise : @js.Promise[Unit] = @js.unsafe_cast(
    self.call("startCSSCoverage", [options]),
  )
  promise.wait()
}

///|
/// Coverage: Stop CSS coverage
/// JS: coverage.stopCSSCoverage()
/// See: https://pptr.dev/api/puppeteer.coverage.stopcsscoverage
/// Returns array of coverage entries
pub async fn Coverage::stopCSSCoverage(self : Coverage) -> Array[@js.Js] {
  let promise : @js.Promise[Array[@js.Js]] = @js.unsafe_cast(
    self.call("stopCSSCoverage", []),
  )
  promise.wait()
}
