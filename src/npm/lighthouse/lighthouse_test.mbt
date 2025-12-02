///|
/// Skip: requires lighthouse and puppeteer installed
#skip("can't exit cleanly due to lighthouse issue")
async test "lighthouse - run performance audit" {
  let browser = @puppeteer.launch(headless=true)
  // defer browser.close() |> ignore
  let page = browser.newPage()
  let flags = LighthouseFlags::new(
    onlyCategories=performance_only,
    output="json",
  )
  let result = run("https://example.com", page~, flags~)
  let lhr = result.lhr()
  inspect(lhr.finalDisplayedUrl(), content="https://example.com/")
  let categories = lhr.categories()
  let perf = categories.performance().unwrap()
  inspect(perf.id(), content="performance")
  // Score should be between 0 and 100
  let score = perf.scorePercent()
  assert_true(score >= 0 && score <= 100)
  browser.close()
}

///|
test "lighthouse - flags serialization" {
  let flags = LighthouseFlags::new(
    logLevel="info",
    output="html",
    onlyCategories=["performance", "accessibility"],
    formFactor="desktop",
    port=9222,
  )
  let js = flags.to_any()
  let log_level : String = js["logLevel"].cast()
  inspect(log_level, content="info")
  let output : String = js["output"].cast()
  inspect(output, content="html")
  let form_factor : String = js["formFactor"].cast()
  inspect(form_factor, content="desktop")
  let port : Int = js["port"].cast()
  inspect(port, content="9222")
}

///|
test "lighthouse - desktop config" {
  let config : @core.Any = desktop_config() |> @core.any
  let settings = config["settings"]
  let form_factor : String = settings["formFactor"].cast()
  inspect(form_factor, content="desktop")
  let screen = settings["screenEmulation"]
  let mobile : Bool = screen["mobile"].cast()
  inspect(mobile, content="false")
  let width : Int = screen["width"].cast()
  inspect(width, content="1350")
}

///|
test "lighthouse - mobile config" {
  let config : @core.Any = mobile_config() |> @core.any
  let settings = config["settings"]
  let form_factor : String = settings["formFactor"].cast()
  inspect(form_factor, content="mobile")
  let screen = settings["screenEmulation"]
  let mobile : Bool = screen["mobile"].cast()
  inspect(mobile, content="true")
  let width : Int = screen["width"].cast()
  inspect(width, content="412")
}

///|
test "lighthouse - category constants" {
  inspect(all_categories.length(), content="5")
  inspect(performance_only.length(), content="1")
  inspect(performance_only[0], content="performance")
  inspect(accessibility_only.length(), content="1")
  inspect(accessibility_only[0], content="accessibility")
}
