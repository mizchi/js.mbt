///|
/// Locator type for Playwright
/// https://playwright.dev/docs/api/class-locator

///|
/// Locator - strict element selector
#external
pub type Locator

///|
pub impl @js.JsImpl for Locator

///| Filtering Methods

///|
/// Filter locator
pub fn Locator::filter(
  self : Locator,
  has? : Locator,
  hasNot? : Locator,
  hasText? : String,
  hasNotText? : String,
) -> Locator {
  let options = @js.Object::new()
  if has is Some(v) {
    options["has"] = v
  }
  if hasNot is Some(v) {
    options["hasNot"] = v
  }
  if hasText is Some(v) {
    options["hasText"] = v
  }
  if hasNotText is Some(v) {
    options["hasNotText"] = v
  }
  @js.identity(self.call("filter", [options.to_any()]))
}

///|
/// Get first element
pub fn Locator::first(self : Locator) -> Locator {
  @js.identity(self.call("first", []))
}

///|
/// Get last element
pub fn Locator::last(self : Locator) -> Locator {
  @js.identity(self.call("last", []))
}

///|
/// Get nth element (0-indexed)
pub fn Locator::nth(self : Locator, index : Int) -> Locator {
  @js.identity(self.call("nth", [index]))
}

///|
/// Get locator within this locator
pub fn Locator::locator(self : Locator, selector : String) -> Locator {
  @js.identity(self.call("locator", [selector]))
}

///|
/// Get by role within this locator
pub fn Locator::getByRole(
  self : Locator,
  role : String,
  name? : String,
  exact? : Bool,
) -> Locator {
  let options = @js.Object::new()
  if name is Some(v) {
    options["name"] = v
  }
  if exact is Some(v) {
    options["exact"] = v
  }
  @js.identity(self.call("getByRole", [@js.any(role), options.to_any()]))
}

///|
/// Get by text within this locator
pub fn Locator::getByText(
  self : Locator,
  text : String,
  exact? : Bool,
) -> Locator {
  let options = @js.Object::new()
  if exact is Some(v) {
    options["exact"] = v
  }
  @js.identity(self.call("getByText", [@js.any(text), options.to_any()]))
}

///|
/// Get by label within this locator
pub fn Locator::getByLabel(
  self : Locator,
  text : String,
  exact? : Bool,
) -> Locator {
  let options = @js.Object::new()
  if exact is Some(v) {
    options["exact"] = v
  }
  @js.identity(self.call("getByLabel", [text, options]))
}

///|
/// Get by placeholder within this locator
pub fn Locator::getByPlaceholder(
  self : Locator,
  text : String,
  exact? : Bool,
) -> Locator {
  let options = @js.Object::new()
  if exact is Some(v) {
    options["exact"] = v
  }
  @js.identity(self.call("getByPlaceholder", [text, options]))
}

///|
/// Get by test ID within this locator
pub fn Locator::getByTestId(self : Locator, testId : String) -> Locator {
  @js.identity(self.call("getByTestId", [testId]))
}

///| Action Methods

///|
/// Click element
pub async fn Locator::click(
  self : Locator,
  button? : String,
  clickCount? : Int,
  delay? : Int,
  force? : Bool,
  modifiers? : Array[String],
  noWaitAfter? : Bool,
  position? : (Double, Double),
  timeout? : Int,
  trial? : Bool,
) -> Unit {
  let options = @js.Object::new()
  if button is Some(v) {
    options["button"] = v
  }
  if clickCount is Some(v) {
    options["clickCount"] = v
  }
  if delay is Some(v) {
    options["delay"] = v
  }
  if force is Some(v) {
    options["force"] = v
  }
  if modifiers is Some(v) {
    options["modifiers"] = @js.from_array(v)
  }
  if noWaitAfter is Some(v) {
    options["noWaitAfter"] = v
  }
  if position is Some((x, y)) {
    let pos = @js.Object::new()
    pos["x"] = x
    pos["y"] = y
    options["position"] = pos.to_any()
  }
  if timeout is Some(v) {
    options["timeout"] = v
  }
  if trial is Some(v) {
    options["trial"] = v
  }
  let promise : @js.Promise[Unit] = @js.identity(
    self.call("click", [options.to_any()]),
  )
  promise.wait()
}

///|
/// Double click element
pub async fn Locator::dblclick(
  self : Locator,
  timeout? : Int,
  force? : Bool,
) -> Unit {
  let options = @js.Object::new()
  if timeout is Some(v) {
    options["timeout"] = v
  }
  if force is Some(v) {
    options["force"] = v
  }
  let promise : @js.Promise[Unit] = @js.identity(
    self.call("dblclick", [options.to_any()]),
  )
  promise.wait()
}

///|
/// Fill input
pub async fn Locator::fill(
  self : Locator,
  value : String,
  force? : Bool,
  noWaitAfter? : Bool,
  timeout? : Int,
) -> Unit {
  let options = @js.Object::new()
  if force is Some(v) {
    options["force"] = v
  }
  if noWaitAfter is Some(v) {
    options["noWaitAfter"] = v
  }
  if timeout is Some(v) {
    options["timeout"] = v
  }
  let promise : @js.Promise[Unit] = @js.identity(
    self.call("fill", [@js.any(value), options.to_any()]),
  )
  promise.wait()
}

///|
/// Clear input
pub async fn Locator::clear(
  self : Locator,
  force? : Bool,
  noWaitAfter? : Bool,
  timeout? : Int,
) -> Unit {
  let options = @js.Object::new()
  if force is Some(v) {
    options["force"] = v
  }
  if noWaitAfter is Some(v) {
    options["noWaitAfter"] = v
  }
  if timeout is Some(v) {
    options["timeout"] = v
  }
  let promise : @js.Promise[Unit] = @js.identity(
    self.call("clear", [options.to_any()]),
  )
  promise.wait()
}

///|
/// Type text (keystroke by keystroke)
pub async fn Locator::type_(
  self : Locator,
  text : String,
  delay? : Int,
  noWaitAfter? : Bool,
  timeout? : Int,
) -> Unit {
  let options = @js.Object::new()
  if delay is Some(v) {
    options["delay"] = v
  }
  if noWaitAfter is Some(v) {
    options["noWaitAfter"] = v
  }
  if timeout is Some(v) {
    options["timeout"] = v
  }
  let promise : @js.Promise[Unit] = @js.identity(
    self.call("type", [@js.any(text), options.to_any()]),
  )
  promise.wait()
}

///|
/// Press key
pub async fn Locator::press(
  self : Locator,
  key : String,
  delay? : Int,
  noWaitAfter? : Bool,
  timeout? : Int,
) -> Unit {
  let options = @js.Object::new()
  if delay is Some(v) {
    options["delay"] = v
  }
  if noWaitAfter is Some(v) {
    options["noWaitAfter"] = v
  }
  if timeout is Some(v) {
    options["timeout"] = v
  }
  let promise : @js.Promise[Unit] = @js.identity(
    self.call("press", [@js.any(key), options.to_any()]),
  )
  promise.wait()
}

///|
/// Check checkbox
pub async fn Locator::check(
  self : Locator,
  force? : Bool,
  noWaitAfter? : Bool,
  timeout? : Int,
) -> Unit {
  let options = @js.Object::new()
  if force is Some(v) {
    options["force"] = v
  }
  if noWaitAfter is Some(v) {
    options["noWaitAfter"] = v
  }
  if timeout is Some(v) {
    options["timeout"] = v
  }
  let promise : @js.Promise[Unit] = @js.identity(
    self.call("check", [options.to_any()]),
  )
  promise.wait()
}

///|
/// Uncheck checkbox
pub async fn Locator::uncheck(
  self : Locator,
  force? : Bool,
  noWaitAfter? : Bool,
  timeout? : Int,
) -> Unit {
  let options = @js.Object::new()
  if force is Some(v) {
    options["force"] = v
  }
  if noWaitAfter is Some(v) {
    options["noWaitAfter"] = v
  }
  if timeout is Some(v) {
    options["timeout"] = v
  }
  let promise : @js.Promise[Unit] = @js.identity(
    self.call("uncheck", [options.to_any()]),
  )
  promise.wait()
}

///|
/// Set checkbox state
pub async fn Locator::setChecked(
  self : Locator,
  checked : Bool,
  force? : Bool,
  noWaitAfter? : Bool,
  timeout? : Int,
) -> Unit {
  let options = @js.Object::new()
  if force is Some(v) {
    options["force"] = v
  }
  if noWaitAfter is Some(v) {
    options["noWaitAfter"] = v
  }
  if timeout is Some(v) {
    options["timeout"] = v
  }
  let promise : @js.Promise[Unit] = @js.identity(
    self.call("setChecked", [@js.any(checked), options.to_any()]),
  )
  promise.wait()
}

///|
/// Select option(s) in dropdown
pub async fn Locator::selectOption(
  self : Locator,
  values : @js.Any,
  force? : Bool,
  noWaitAfter? : Bool,
  timeout? : Int,
) -> Array[String] {
  let options = @js.Object::new()
  if force is Some(v) {
    options["force"] = v
  }
  if noWaitAfter is Some(v) {
    options["noWaitAfter"] = v
  }
  if timeout is Some(v) {
    options["timeout"] = v
  }
  let promise : @js.Promise[Array[String]] = @js.identity(
    self.call("selectOption", [values, options.to_any()]),
  )
  promise.wait()
}

///|
/// Hover over element
pub async fn Locator::hover(
  self : Locator,
  force? : Bool,
  modifiers? : Array[String],
  position? : (Double, Double),
  timeout? : Int,
  trial? : Bool,
) -> Unit {
  let options = @js.Object::new()
  if force is Some(v) {
    options["force"] = v
  }
  if modifiers is Some(v) {
    options["modifiers"] = @js.from_array(v)
  }
  if position is Some((x, y)) {
    let pos = @js.Object::new()
    pos["x"] = x
    pos["y"] = y
    options["position"] = pos.to_any()
  }
  if timeout is Some(v) {
    options["timeout"] = v
  }
  if trial is Some(v) {
    options["trial"] = v
  }
  let promise : @js.Promise[Unit] = @js.identity(
    self.call("hover", [options.to_any()]),
  )
  promise.wait()
}

///|
/// Focus element
pub async fn Locator::focus(self : Locator, timeout? : Int) -> Unit {
  let options = @js.Object::new()
  if timeout is Some(v) {
    options["timeout"] = v
  }
  let promise : @js.Promise[Unit] = @js.identity(
    self.call("focus", [options.to_any()]),
  )
  promise.wait()
}

///|
/// Blur element
pub async fn Locator::blur(self : Locator, timeout? : Int) -> Unit {
  let options = @js.Object::new()
  if timeout is Some(v) {
    options["timeout"] = v
  }
  let promise : @js.Promise[Unit] = @js.identity(
    self.call("blur", [options.to_any()]),
  )
  promise.wait()
}

///|
/// Scroll element into view
pub async fn Locator::scrollIntoViewIfNeeded(
  self : Locator,
  timeout? : Int,
) -> Unit {
  let options = @js.Object::new()
  if timeout is Some(v) {
    options["timeout"] = v
  }
  let promise : @js.Promise[Unit] = @js.identity(
    self.call("scrollIntoViewIfNeeded", [options.to_any()]),
  )
  promise.wait()
}

///| Property Methods

///|
/// Get inner text
pub async fn Locator::innerText(self : Locator, timeout? : Int) -> String {
  let options = @js.Object::new()
  if timeout is Some(v) {
    options["timeout"] = v
  }
  let promise : @js.Promise[String] = @js.identity(
    self.call("innerText", [options.to_any()]),
  )
  promise.wait()
}

///|
/// Get inner HTML
pub async fn Locator::innerHTML(self : Locator, timeout? : Int) -> String {
  let options = @js.Object::new()
  if timeout is Some(v) {
    options["timeout"] = v
  }
  let promise : @js.Promise[String] = @js.identity(
    self.call("innerHTML", [options.to_any()]),
  )
  promise.wait()
}

///|
/// Get text content
pub async fn Locator::textContent(self : Locator, timeout? : Int) -> String? {
  let options = @js.Object::new()
  if timeout is Some(v) {
    options["timeout"] = v
  }
  let promise : @js.Promise[@js.Any] = @js.identity(
    self.call("textContent", [options.to_any()]),
  )
  let result = promise.wait()
  if @js.is_nullish(result) {
    None
  } else {
    Some(result.cast())
  }
}

///|
/// Get all text contents
pub async fn Locator::allTextContents(self : Locator) -> Array[String] {
  let promise : @js.Promise[Array[String]] = @js.identity(
    self.call("allTextContents", []),
  )
  promise.wait()
}

///|
/// Get all inner texts
pub async fn Locator::allInnerTexts(self : Locator) -> Array[String] {
  let promise : @js.Promise[Array[String]] = @js.identity(
    self.call("allInnerTexts", []),
  )
  promise.wait()
}

///|
/// Get attribute
pub async fn Locator::getAttribute(
  self : Locator,
  name : String,
  timeout? : Int,
) -> String? {
  let options = @js.Object::new()
  if timeout is Some(v) {
    options["timeout"] = v
  }
  let promise : @js.Promise[@js.Any] = @js.identity(
    self.call("getAttribute", [@js.any(name), options.to_any()]),
  )
  let result = promise.wait()
  if @js.is_nullish(result) {
    None
  } else {
    Some(result.cast())
  }
}

///|
/// Get input value
pub async fn Locator::inputValue(self : Locator, timeout? : Int) -> String {
  let options = @js.Object::new()
  if timeout is Some(v) {
    options["timeout"] = v
  }
  let promise : @js.Promise[String] = @js.identity(
    self.call("inputValue", [options.to_any()]),
  )
  promise.wait()
}

///|
/// Check if element is visible
pub async fn Locator::isVisible(self : Locator, timeout? : Int) -> Bool {
  let options = @js.Object::new()
  if timeout is Some(v) {
    options["timeout"] = v
  }
  let promise : @js.Promise[Bool] = @js.identity(
    self.call("isVisible", [options.to_any()]),
  )
  promise.wait()
}

///|
/// Check if element is hidden
pub async fn Locator::isHidden(self : Locator, timeout? : Int) -> Bool {
  let options = @js.Object::new()
  if timeout is Some(v) {
    options["timeout"] = v
  }
  let promise : @js.Promise[Bool] = @js.identity(
    self.call("isHidden", [options.to_any()]),
  )
  promise.wait()
}

///|
/// Check if element is enabled
pub async fn Locator::isEnabled(self : Locator, timeout? : Int) -> Bool {
  let options = @js.Object::new()
  if timeout is Some(v) {
    options["timeout"] = v
  }
  let promise : @js.Promise[Bool] = @js.identity(
    self.call("isEnabled", [options.to_any()]),
  )
  promise.wait()
}

///|
/// Check if element is disabled
pub async fn Locator::isDisabled(self : Locator, timeout? : Int) -> Bool {
  let options = @js.Object::new()
  if timeout is Some(v) {
    options["timeout"] = v
  }
  let promise : @js.Promise[Bool] = @js.identity(
    self.call("isDisabled", [options.to_any()]),
  )
  promise.wait()
}

///|
/// Check if element is editable
pub async fn Locator::isEditable(self : Locator, timeout? : Int) -> Bool {
  let options = @js.Object::new()
  if timeout is Some(v) {
    options["timeout"] = v
  }
  let promise : @js.Promise[Bool] = @js.identity(
    self.call("isEditable", [options.to_any()]),
  )
  promise.wait()
}

///|
/// Check if checkbox is checked
pub async fn Locator::isChecked(self : Locator, timeout? : Int) -> Bool {
  let options = @js.Object::new()
  if timeout is Some(v) {
    options["timeout"] = v
  }
  let promise : @js.Promise[Bool] = @js.identity(
    self.call("isChecked", [options.to_any()]),
  )
  promise.wait()
}

///|
/// Get element count
pub async fn Locator::count(self : Locator) -> Int {
  let promise : @js.Promise[Int] = @js.identity(self.call("count", []))
  promise.wait()
}

///|
/// Get bounding box
pub async fn Locator::boundingBox(self : Locator, timeout? : Int) -> @js.Any {
  let options = @js.Object::new()
  if timeout is Some(v) {
    options["timeout"] = v
  }
  let promise : @js.Promise[@js.Any] = @js.identity(
    self.call("boundingBox", [options.to_any()]),
  )
  promise.wait()
}

///| Wait Methods

///|
/// Wait for element to be visible/hidden/attached/detached
pub async fn Locator::waitFor(
  self : Locator,
  state? : String,
  timeout? : Int,
) -> Unit {
  let options = @js.Object::new()
  if state is Some(v) {
    options["state"] = v
  }
  if timeout is Some(v) {
    options["timeout"] = v
  }
  let promise : @js.Promise[Unit] = @js.identity(
    self.call("waitFor", [options.to_any()]),
  )
  promise.wait()
}

///| Screenshot

///|
/// Take screenshot of element
pub async fn Locator::screenshot(
  self : Locator,
  path? : String,
  type_? : String,
  quality? : Int,
  omitBackground? : Bool,
  timeout? : Int,
  scale? : String,
) -> @js.Any {
  let options = @js.Object::new()
  if path is Some(v) {
    options["path"] = v
  }
  if type_ is Some(v) {
    options["type"] = v
  }
  if quality is Some(v) {
    options["quality"] = v
  }
  if omitBackground is Some(v) {
    options["omitBackground"] = v
  }
  if timeout is Some(v) {
    options["timeout"] = v
  }
  if scale is Some(v) {
    options["scale"] = v
  }
  let promise : @js.Promise[@js.Any] = @js.identity(
    self.call("screenshot", [options.to_any()]),
  )
  promise.wait()
}

///| Evaluate

///|
/// Evaluate JavaScript in element context
pub async fn Locator::evaluate(
  self : Locator,
  pageFunction : String,
  arg? : @js.Any,
  timeout? : Int,
) -> @js.Any {
  let options = @js.Object::new()
  if timeout is Some(v) {
    options["timeout"] = v
  }
  let promise : @js.Promise[@js.Any] = match arg {
    Some(a) =>
      @js.identity(self.call("evaluate", [pageFunction, a, options.to_any()]))
    None =>
      @js.identity(self.call("evaluate", [pageFunction, options.to_any()]))
  }
  promise.wait()
}

///|
/// Evaluate all matching elements
pub async fn Locator::evaluateAll(
  self : Locator,
  pageFunction : String,
  arg? : @js.Any,
) -> @js.Any {
  let promise : @js.Promise[@js.Any] = match arg {
    Some(a) => @js.identity(self.call("evaluateAll", [pageFunction, a]))
    None => @js.identity(self.call("evaluateAll", [pageFunction]))
  }
  promise.wait()
}
