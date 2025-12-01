///|
/// Code coverage support for Puppeteer
/// See: https://pptr.dev/api/puppeteer.coverage

///|
/// Coverage type
/// See: https://pptr.dev/api/puppeteer.coverage
#external
pub type Coverage

///|
pub fn Coverage::to_any(self : Coverage) -> @nostd.Any = "%identity"

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
  ranges : Array[@nostd.Any]
} derive(Show)

///|
/// CSSCoverageEntry type
pub(all) struct CSSCoverageEntry {
  url : String
  text : String
  ranges : Array[@nostd.Any]
} derive(Show)

///| Page methods (coverage)

///|
/// Page: Get coverage instance
/// JS: page.coverage
pub fn Page::coverage(self : Page) -> Coverage {
  self.to_any()["coverage"] |> @nostd.identity
}

///| Coverage methods

///|
/// Coverage: Start JavaScript coverage
/// JS: coverage.startJSCoverage(options)
/// See: https://pptr.dev/api/puppeteer.coverage.startjscoverage
pub async fn Coverage::startJSCoverage(self : Coverage) -> Unit {
  let promise : @js.Promise[Unit] = self.to_any()._call("startJSCoverage", [])
    |> @js.identity
  promise.wait()
}

///|
/// Coverage: Start JavaScript coverage with options
/// JS: coverage.startJSCoverage(options)
pub async fn Coverage::startJSCoverage_with(
  self : Coverage,
  options : @nostd.Any,
) -> Unit {
  let promise : @js.Promise[Unit] = self
    .to_any()
    ._call("startJSCoverage", [@nostd.any(options)])
    |> @js.identity
  promise.wait()
}

///|
/// Coverage: Stop JavaScript coverage
/// JS: coverage.stopJSCoverage()
/// See: https://pptr.dev/api/puppeteer.coverage.stopjscoverage
/// Returns array of coverage entries
pub async fn Coverage::stopJSCoverage(self : Coverage) -> Array[@nostd.Any] {
  let promise : @js.Promise[Array[@nostd.Any]] = self
    .to_any()
    ._call("stopJSCoverage", [])
    |> @js.identity
  promise.wait()
}

///|
/// Coverage: Start CSS coverage
/// JS: coverage.startCSSCoverage(options)
/// See: https://pptr.dev/api/puppeteer.coverage.startcsscoverage
pub async fn Coverage::startCSSCoverage(self : Coverage) -> Unit {
  let promise : @js.Promise[Unit] = self.to_any()._call("startCSSCoverage", [])
    |> @js.identity
  promise.wait()
}

///|
/// Coverage: Start CSS coverage with options
/// JS: coverage.startCSSCoverage(options)
pub async fn Coverage::startCSSCoverage_with(
  self : Coverage,
  options : @nostd.Any,
) -> Unit {
  let promise : @js.Promise[Unit] = self
    .to_any()
    ._call("startCSSCoverage", [@nostd.any(options)])
    |> @js.identity
  promise.wait()
}

///|
/// Coverage: Stop CSS coverage
/// JS: coverage.stopCSSCoverage()
/// See: https://pptr.dev/api/puppeteer.coverage.stopcsscoverage
/// Returns array of coverage entries
pub async fn Coverage::stopCSSCoverage(self : Coverage) -> Array[@nostd.Any] {
  let promise : @js.Promise[Array[@nostd.Any]] = self
    .to_any()
    ._call("stopCSSCoverage", [])
    |> @js.identity
  promise.wait()
}
