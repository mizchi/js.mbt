///|
/// Lighthouse - Web performance auditing
/// https://github.com/GoogleChrome/lighthouse
///
/// Lighthouse analyzes web apps and pages, collecting modern performance metrics
/// and insights on developer best practices.

///| FFI

///|
extern "js" fn ffi_require_lighthouse() -> @js.Any =
  #|() => require("lighthouse")

///| Core Types

///|
/// Lighthouse Result (LHR) - the main output of a Lighthouse audit
#external
pub type LighthouseResult

///|
pub impl @js.JsImpl for LighthouseResult

///|
/// Get the final displayed URL after redirects
pub fn LighthouseResult::finalDisplayedUrl(self : LighthouseResult) -> String {
  self.get("finalDisplayedUrl").cast()
}

///|
/// Get the final URL (may differ from finalDisplayedUrl)
pub fn LighthouseResult::finalUrl(self : LighthouseResult) -> String {
  self.get("finalUrl").cast()
}

///|
/// Get the requested URL
pub fn LighthouseResult::requestedUrl(self : LighthouseResult) -> String {
  self.get("requestedUrl").cast()
}

///|
/// Get the fetch time as ISO string
pub fn LighthouseResult::fetchTime(self : LighthouseResult) -> String {
  self.get("fetchTime").cast()
}

///|
/// Get the Lighthouse version used
pub fn LighthouseResult::lighthouseVersion(self : LighthouseResult) -> String {
  self.get("lighthouseVersion").cast()
}

///|
/// Get the user agent used
pub fn LighthouseResult::userAgent(self : LighthouseResult) -> String {
  self.get("userAgent").cast()
}

///|
/// Get all categories
pub fn LighthouseResult::categories(self : LighthouseResult) -> Categories {
  @js.identity(self.get("categories"))
}

///|
/// Get all audits
pub fn LighthouseResult::audits(self : LighthouseResult) -> @js.Any {
  self.get("audits")
}

///|
/// Get a specific audit by id
pub fn LighthouseResult::audit(self : LighthouseResult, id : String) -> Audit? {
  let audits = self.get("audits")
  let audit = audits.get(id)
  if @js.is_nullish(audit) {
    None
  } else {
    Some(@js.identity(audit))
  }
}

///|
/// Categories in Lighthouse result
#external
pub type Categories

///|
pub impl @js.JsImpl for Categories

///|
/// Get performance category
pub fn Categories::performance(self : Categories) -> Category? {
  self.get("performance") |> @js.identity_option
}

///|
/// Get accessibility category
pub fn Categories::accessibility(self : Categories) -> Category? {
  self.get("accessibility") |> @js.identity_option
}

///|
/// Get best-practices category
pub fn Categories::bestPractices(self : Categories) -> Category? {
  self.get("best-practices") |> @js.identity_option
}

///|
/// Get SEO category
pub fn Categories::seo(self : Categories) -> Category? {
  self.get("seo") |> @js.identity_option
}

///|
/// Get PWA category
pub fn Categories::pwa(self : Categories) -> Category? {
  self.get("pwa") |> @js.identity_option
}

///|
/// A Lighthouse category (performance, accessibility, etc.)
#external
pub type Category

///|
pub impl @js.JsImpl for Category

///|
/// Get the category title
pub fn Category::title(self : Category) -> String {
  self.get("title").cast()
}

///|
/// Get the category id
pub fn Category::id(self : Category) -> String {
  self.get("id").cast()
}

///|
/// Get the category score (0-1)
pub fn Category::score(self : Category) -> Double {
  self.get("score").cast()
}

///|
/// Get the category score as percentage (0-100)
pub fn Category::scorePercent(self : Category) -> Int {
  let score : Double = self.get("score").cast()
  (score * 100.0).to_int()
}

///|
/// A Lighthouse audit result
#external
pub type Audit

///|
pub impl @js.JsImpl for Audit

///|
/// Get the audit id
pub fn Audit::id(self : Audit) -> String {
  self.get("id").cast()
}

///|
/// Get the audit title
pub fn Audit::title(self : Audit) -> String {
  self.get("title").cast()
}

///|
/// Get the audit description
pub fn Audit::description(self : Audit) -> String {
  self.get("description").cast()
}

///|
/// Get the audit score (0-1 or null for informational)
pub fn Audit::score(self : Audit) -> Double? {
  let score = self.get("score")
  if @js.is_nullish(score) {
    None
  } else {
    Some(score.cast())
  }
}

///|
/// Get the score display mode
pub fn Audit::scoreDisplayMode(self : Audit) -> String {
  self.get("scoreDisplayMode").cast()
}

///|
/// Get the display value (human readable)
pub fn Audit::displayValue(self : Audit) -> String? {
  let value = self.get("displayValue")
  if @js.is_nullish(value) {
    None
  } else {
    Some(value.cast())
  }
}

///|
/// Get the numeric value (e.g., milliseconds for timing audits)
pub fn Audit::numericValue(self : Audit) -> Double? {
  let value = self.get("numericValue")
  if @js.is_nullish(value) {
    None
  } else {
    Some(value.cast())
  }
}

///|
/// Get the numeric unit (e.g., "millisecond")
pub fn Audit::numericUnit(self : Audit) -> String? {
  let value = self.get("numericUnit")
  if @js.is_nullish(value) {
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
pub impl @js.JsImpl for RunnerResult

///|
/// Get the Lighthouse Result (lhr)
pub fn RunnerResult::lhr(self : RunnerResult) -> LighthouseResult {
  @js.identity(self.get("lhr"))
}

///|
/// Get the report as string (HTML, JSON, or CSV depending on output option)
pub fn RunnerResult::report(self : RunnerResult) -> String {
  self.get("report").cast()
}

///|
/// Get the artifacts collected during the audit
pub fn RunnerResult::artifacts(self : RunnerResult) -> @js.Any {
  self.get("artifacts")
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
  screenEmulation : @js.Any?
  /// Throttling settings
  throttling : @js.Any?
  /// Throttling method: 'simulate' | 'devtools' | 'provided'
  throttlingMethod : String?
  /// Extra HTTP headers
  extraHeaders : @js.Any?
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
  screenEmulation? : @js.Any,
  throttling? : @js.Any,
  throttlingMethod? : String,
  extraHeaders? : @js.Any,
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
pub impl @js.JsImpl for LighthouseFlags with as_any(self) -> @js.Any {
  @js.from_option_map({
    "logLevel": self.logLevel.map(fn(x) { @js.any(x) }),
    "output": self.output.map(fn(x) { @js.any(x) }),
    "onlyCategories": self.onlyCategories.map(fn(x) { @js.from_array(x) }),
    "skipAudits": self.skipAudits.map(fn(x) { @js.from_array(x) }),
    "onlyAudits": self.onlyAudits.map(fn(x) { @js.from_array(x) }),
    "port": self.port.map(fn(x) { @js.any(x) }),
    "formFactor": self.formFactor.map(fn(x) { @js.any(x) }),
    "screenEmulation": self.screenEmulation,
    "throttling": self.throttling,
    "throttlingMethod": self.throttlingMethod.map(fn(x) { @js.any(x) }),
    "extraHeaders": self.extraHeaders,
    "maxWaitForLoad": self.maxWaitForLoad.map(fn(x) { @js.any(x) }),
    "disableStorageReset": self.disableStorageReset.map(fn(x) { @js.any(x) }),
  })
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
  config? : @js.Any,
) -> RunnerResult {
  let lighthouse_fn = ffi_require_lighthouse()
  let js_flags = match flags {
    Some(f) => f.as_any()
    None => @js.undefined()
  }
  let js_config = match config {
    Some(c) => c
    None => @js.undefined()
  }
  let js_page = match page {
    Some(p) => p.as_any()
    None => @js.undefined()
  }
  let promise : @js.Promise[RunnerResult] = @js.identity(
    lighthouse_fn.call_self([url, js_flags, js_config, js_page]),
  )
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
  config? : @js.Any,
) -> RunnerResult {
  let lighthouse_fn = ffi_require_lighthouse()
  let base_flags = match flags {
    Some(f) => f
    None => LighthouseFlags::new()
  }
  let flags_with_port = { ..base_flags, port: Some(port) }
  let js_config = match config {
    Some(c) => c
    None => @js.undefined()
  }
  let promise : @js.Promise[RunnerResult] = @js.identity(
    lighthouse_fn.call_self([url, flags_with_port.as_any(), js_config]),
  )
  promise.wait()
}

///| Preset Configurations

///|
/// Desktop configuration preset
pub fn desktop_config() -> @js.Any {
  let config = @js.Object::new()
  let settings = @js.Object::new()
  settings.set("formFactor", @js.any("desktop"))
  settings.set("throttlingMethod", @js.any("simulate"))
  let screen = @js.Object::new()
  screen.set("mobile", @js.any(false))
  screen.set("width", @js.any(1350))
  screen.set("height", @js.any(940))
  screen.set("deviceScaleFactor", @js.any(1))
  settings.set("screenEmulation", screen.as_any())
  let throttling = @js.Object::new()
  throttling.set("rttMs", @js.any(40))
  throttling.set("throughputKbps", @js.any(10240))
  throttling.set("cpuSlowdownMultiplier", @js.any(1))
  settings.set("throttling", throttling.as_any())
  config.set("settings", settings.as_any())
  config.as_any()
}

///|
/// Mobile configuration preset (default Lighthouse behavior)
pub fn mobile_config() -> @js.Any {
  let config = @js.Object::new()
  let settings = @js.Object::new()
  settings.set("formFactor", @js.any("mobile"))
  settings.set("throttlingMethod", @js.any("simulate"))
  let screen = @js.Object::new()
  screen.set("mobile", @js.any(true))
  screen.set("width", @js.any(412))
  screen.set("height", @js.any(823))
  screen.set("deviceScaleFactor", @js.any(1.75))
  settings.set("screenEmulation", screen.as_any())
  config.set("settings", settings.as_any())
  config.as_any()
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
