///|
/// Lighthouse - Web performance auditing
/// https://github.com/GoogleChrome/lighthouse
///
/// Lighthouse analyzes web apps and pages, collecting modern performance metrics
/// and insights on developer best practices.

///| FFI

///|
extern "js" fn ffi_require_lighthouse() -> @nostd.Any =
  #|() => require("lighthouse")

///| Core Types

///|
/// Lighthouse Result (LHR) - the main output of a Lighthouse audit
#external
pub type LighthouseResult

///|
pub fn LighthouseResult::to_any(self : LighthouseResult) -> @nostd.Any =
  "%identity"

///|
/// Get the final displayed URL after redirects
pub fn LighthouseResult::finalDisplayedUrl(self : LighthouseResult) -> String {
  self.to_any()["finalDisplayedUrl"].cast()
}

///|
/// Get the final URL (may differ from finalDisplayedUrl)
pub fn LighthouseResult::finalUrl(self : LighthouseResult) -> String {
  self.to_any()["finalUrl"].cast()
}

///|
/// Get the requested URL
pub fn LighthouseResult::requestedUrl(self : LighthouseResult) -> String {
  self.to_any()["requestedUrl"].cast()
}

///|
/// Get the fetch time as ISO string
pub fn LighthouseResult::fetchTime(self : LighthouseResult) -> String {
  self.to_any()["fetchTime"].cast()
}

///|
/// Get the Lighthouse version used
pub fn LighthouseResult::lighthouseVersion(self : LighthouseResult) -> String {
  self.to_any()["lighthouseVersion"].cast()
}

///|
/// Get the user agent used
pub fn LighthouseResult::userAgent(self : LighthouseResult) -> String {
  self.to_any()["userAgent"].cast()
}

///|
/// Get all categories
pub fn LighthouseResult::categories(self : LighthouseResult) -> Categories {
  self.to_any()["categories"] |> @nostd.identity
}

///|
/// Get all audits
pub fn LighthouseResult::audits(self : LighthouseResult) -> @nostd.Any {
  self.to_any()["audits"] |> @nostd.identity
}

///|
/// Get a specific audit by id
pub fn LighthouseResult::audit(self : LighthouseResult, id : String) -> Audit? {
  let audits = self.to_any()["audits"]
  let audit = audits[id]
  if @nostd.is_nullish(audit) {
    None
  } else {
    Some(audit |> @nostd.identity)
  }
}

///|
/// Categories in Lighthouse result
#external
pub type Categories

///|
pub fn Categories::to_any(self : Categories) -> @nostd.Any = "%identity"

///|
/// Get performance category
pub fn Categories::performance(self : Categories) -> Category? {
  @nostd.identity_option(self.to_any()["performance"])
}

///|
/// Get accessibility category
pub fn Categories::accessibility(self : Categories) -> Category? {
  @nostd.identity_option(self.to_any()["accessibility"])
}

///|
/// Get best-practices category
pub fn Categories::bestPractices(self : Categories) -> Category? {
  @nostd.identity_option(self.to_any()["best-practices"])
}

///|
/// Get SEO category
pub fn Categories::seo(self : Categories) -> Category? {
  @nostd.identity_option(self.to_any()["seo"])
}

///|
/// Get PWA category
pub fn Categories::pwa(self : Categories) -> Category? {
  @nostd.identity_option(self.to_any()["pwa"])
}

///|
/// A Lighthouse category (performance, accessibility, etc.)
#external
pub type Category

///|
pub fn Category::to_any(self : Category) -> @nostd.Any = "%identity"

///|
/// Get the category title
pub fn Category::title(self : Category) -> String {
  self.to_any()["title"].cast()
}

///|
/// Get the category id
pub fn Category::id(self : Category) -> String {
  self.to_any()["id"].cast()
}

///|
/// Get the category score (0-1)
pub fn Category::score(self : Category) -> Double {
  self.to_any()["score"].cast()
}

///|
/// Get the category score as percentage (0-100)
pub fn Category::scorePercent(self : Category) -> Int {
  let score : Double = self.to_any()["score"].cast()
  (score * 100.0).to_int()
}

///|
/// A Lighthouse audit result
#external
pub type Audit

///|
pub fn Audit::to_any(self : Audit) -> @nostd.Any = "%identity"

///|
/// Get the audit id
pub fn Audit::id(self : Audit) -> String {
  self.to_any()["id"].cast()
}

///|
/// Get the audit title
pub fn Audit::title(self : Audit) -> String {
  self.to_any()["title"].cast()
}

///|
/// Get the audit description
pub fn Audit::description(self : Audit) -> String {
  self.to_any()["description"].cast()
}

///|
/// Get the audit score (0-1 or null for informational)
pub fn Audit::score(self : Audit) -> Double? {
  let score = self.to_any()["score"]
  if @nostd.is_nullish(score) {
    None
  } else {
    Some(score.cast())
  }
}

///|
/// Get the score display mode
pub fn Audit::scoreDisplayMode(self : Audit) -> String {
  self.to_any()["scoreDisplayMode"].cast()
}

///|
/// Get the display value (human readable)
pub fn Audit::displayValue(self : Audit) -> String? {
  let value = self.to_any()["displayValue"]
  if @nostd.is_nullish(value) {
    None
  } else {
    Some(value.cast())
  }
}

///|
/// Get the numeric value (e.g., milliseconds for timing audits)
pub fn Audit::numericValue(self : Audit) -> Double? {
  let value = self.to_any()["numericValue"]
  if @nostd.is_nullish(value) {
    None
  } else {
    Some(value.cast())
  }
}

///|
/// Get the numeric unit (e.g., "millisecond")
pub fn Audit::numericUnit(self : Audit) -> String? {
  let value = self.to_any()["numericUnit"]
  if @nostd.is_nullish(value) {
    None
  } else {
    Some(value.cast())
  }
}

///|
/// Runner result from lighthouse
#external
pub type RunnerResult

///|
pub fn RunnerResult::to_any(self : RunnerResult) -> @nostd.Any = "%identity"

///|
/// Get the Lighthouse Result (lhr)
pub fn RunnerResult::lhr(self : RunnerResult) -> LighthouseResult {
  self.to_any()["lhr"] |> @nostd.identity
}

///|
/// Get the report as string (HTML, JSON, or CSV depending on output option)
pub fn RunnerResult::report(self : RunnerResult) -> String {
  self.to_any()["report"].cast()
}

///|
/// Get the artifacts collected during the audit
pub fn RunnerResult::artifacts(self : RunnerResult) -> @nostd.Any {
  self.to_any()["artifacts"] |> @nostd.identity
}

///| Lighthouse Options

///|
/// Lighthouse flags/options
pub(all) struct LighthouseFlags {
  /// Logging level: 'silent' | 'error' | 'warn' | 'info' | 'verbose'
  logLevel : String?
  /// Output format: 'json' | 'html' | 'csv'
  output : String?
  /// Only run specific categories
  onlyCategories : Array[String]?
  /// Skip specific audits
  skipAudits : Array[String]?
  /// Only run specific audits
  onlyAudits : Array[String]?
  /// Chrome debugging port
  port : Int?
  /// Form factor: 'mobile' | 'desktop'
  formFactor : String?
  /// Screen emulation settings
  screenEmulation : @nostd.Any?
  /// Throttling settings
  throttling : @nostd.Any?
  /// Throttling method: 'simulate' | 'devtools' | 'provided'
  throttlingMethod : String?
  /// Extra HTTP headers
  extraHeaders : @nostd.Any?
  /// Maximum wait time for page load in ms
  maxWaitForLoad : Int?
  /// Disable storage reset
  disableStorageReset : Bool?
}

///|
pub fn LighthouseFlags::new(
  logLevel? : String,
  output? : String,
  onlyCategories? : Array[String],
  skipAudits? : Array[String],
  onlyAudits? : Array[String],
  port? : Int,
  formFactor? : String,
  screenEmulation? : @nostd.Any,
  throttling? : @nostd.Any,
  throttlingMethod? : String,
  extraHeaders? : @nostd.Any,
  maxWaitForLoad? : Int,
  disableStorageReset? : Bool,
) -> LighthouseFlags {
  {
    logLevel,
    output,
    onlyCategories,
    skipAudits,
    onlyAudits,
    port,
    formFactor,
    screenEmulation,
    throttling,
    throttlingMethod,
    extraHeaders,
    maxWaitForLoad,
    disableStorageReset,
  }
}

///|
pub fn LighthouseFlags::to_any(self : LighthouseFlags) -> @nostd.Any {
  let obj = @nostd.Object::new()
  if self.logLevel is Some(v) {
    obj["logLevel"] = @nostd.any(v)
  }
  if self.output is Some(v) {
    obj["output"] = @nostd.any(v)
  }
  if self.onlyCategories is Some(v) {
    obj["onlyCategories"] = @nostd.any(v)
  }
  if self.skipAudits is Some(v) {
    obj["skipAudits"] = @nostd.any(v)
  }
  if self.onlyAudits is Some(v) {
    obj["onlyAudits"] = @nostd.any(v)
  }
  if self.port is Some(v) {
    obj["port"] = @nostd.any(v)
  }
  if self.formFactor is Some(v) {
    obj["formFactor"] = @nostd.any(v)
  }
  if self.screenEmulation is Some(v) {
    obj["screenEmulation"] = @nostd.any(v)
  }
  if self.throttling is Some(v) {
    obj["throttling"] = @nostd.any(v)
  }
  if self.throttlingMethod is Some(v) {
    obj["throttlingMethod"] = @nostd.any(v)
  }
  if self.extraHeaders is Some(v) {
    obj["extraHeaders"] = @nostd.any(v)
  }
  if self.maxWaitForLoad is Some(v) {
    obj["maxWaitForLoad"] = @nostd.any(v)
  }
  if self.disableStorageReset is Some(v) {
    obj["disableStorageReset"] = @nostd.any(v)
  }
  obj
}

///| Main Functions

///|
/// Run Lighthouse audit on a URL with a Puppeteer page
/// This is the recommended way to use Lighthouse with Puppeteer
///
/// Example:
/// ```moonbit no-check
/// let browser = @puppeteer.launch(headless=true)
/// let page = browser.newPage()
/// let result = run("https://example.com", page=page)
/// let perf_score = result.lhr().categories().performance().unwrap().scorePercent()
/// browser.close()
/// ```
pub async fn run(
  url : String,
  page? : @puppeteer.Page,
  flags? : LighthouseFlags,
  config? : @nostd.Any,
) -> RunnerResult {
  let lighthouse_fn : @nostd.Any = ffi_require_lighthouse() |> @nostd.any
  let js_flags : @nostd.Any = match flags {
    Some(f) => f.to_any()
    None => @global.undefined() |> @nostd.any
  }
  let js_config : @nostd.Any = match config {
    Some(c) => c |> @nostd.any
    None => @global.undefined() |> @nostd.any
  }
  let js_page : @nostd.Any = match page {
    Some(p) => p.to_any()
    None => @global.undefined() |> @nostd.any
  }
  let promise : @js.Promise[RunnerResult] = lighthouse_fn
    ._invoke([@nostd.any(url), js_flags, js_config, js_page])
    |> @nostd.identity
  promise.wait()
}

///|
/// Run Lighthouse audit using only URL and port (chrome-launcher style)
/// Use this when Chrome is already running with remote debugging enabled
///
/// Example:
/// ```moonbit no-check
/// let result = run_with_port("https://example.com", port=9222)
/// ```
pub async fn run_with_port(
  url : String,
  port : Int,
  flags? : LighthouseFlags,
  config? : @nostd.Any,
) -> RunnerResult {
  let lighthouse_fn : @nostd.Any = ffi_require_lighthouse() |> @nostd.any
  let base_flags = match flags {
    Some(f) => f
    None => LighthouseFlags::new()
  }
  let flags_with_port = { ..base_flags, port: Some(port) }
  let js_config : @nostd.Any = match config {
    Some(c) => c |> @nostd.any
    None => @global.undefined() |> @nostd.any
  }
  let promise : @js.Promise[RunnerResult] = lighthouse_fn
    ._invoke([@nostd.any(url), flags_with_port.to_any(), js_config])
    |> @nostd.identity
  promise.wait()
}

///| Preset Configurations

///|
/// Desktop configuration preset
pub fn desktop_config() -> @nostd.Any {
  let config = @nostd.Object::new()
  let settings = @nostd.Object::new()
  settings["formFactor"] = @nostd.any("desktop")
  settings["throttlingMethod"] = @nostd.any("simulate")
  let screen = @nostd.Object::new()
  screen["mobile"] = @nostd.any(false)
  screen["width"] = @nostd.any(1350)
  screen["height"] = @nostd.any(940)
  screen["deviceScaleFactor"] = @nostd.any(1)
  settings["screenEmulation"] = screen
  let throttling = @nostd.Object::new()
  throttling["rttMs"] = @nostd.any(40)
  throttling["throughputKbps"] = @nostd.any(10240)
  throttling["cpuSlowdownMultiplier"] = @nostd.any(1)
  settings["throttling"] = throttling
  config["settings"] = settings
  config |> @nostd.identity
}

///|
/// Mobile configuration preset (default Lighthouse behavior)
pub fn mobile_config() -> @nostd.Any {
  let config = @nostd.Object::new()
  let settings = @nostd.Object::new()
  settings["formFactor"] = @nostd.any("mobile")
  settings["throttlingMethod"] = @nostd.any("simulate")
  let screen = @nostd.Object::new()
  screen["mobile"] = @nostd.any(true)
  screen["width"] = @nostd.any(412)
  screen["height"] = @nostd.any(823)
  screen["deviceScaleFactor"] = @nostd.any(1.75)
  settings["screenEmulation"] = screen
  config["settings"] = settings
  config |> @nostd.identity
}

///| Common Categories

///|
/// All available Lighthouse categories
pub let all_categories : Array[String] = [
  "performance", "accessibility", "best-practices", "seo", "pwa",
]

///|
/// Performance category only
pub let performance_only : Array[String] = ["performance"]

///|
/// Accessibility category only
pub let accessibility_only : Array[String] = ["accessibility"]
