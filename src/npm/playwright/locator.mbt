///|
/// Locator type for Playwright
/// https://playwright.dev/docs/api/class-locator

///|
/// Locator - strict element selector
#external
pub type Locator

///|
pub fn Locator::to_any(self : Locator) -> @nostd.Any = "%identity"

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
  let options = @nostd.Object::new()
  if has is Some(v) {
    options["has"] = v.to_any()
  }
  if hasNot is Some(v) {
    options["hasNot"] = v.to_any()
  }
  if hasText is Some(v) {
    options["hasText"] = @nostd.any(v)
  }
  if hasNotText is Some(v) {
    options["hasNotText"] = @nostd.any(v)
  }
  self.to_any()._call("filter", [options]) |> @nostd.identity
}

///|
/// Get first element
pub fn Locator::first(self : Locator) -> Locator {
  self.to_any()._call("first", []) |> @nostd.identity
}

///|
/// Get last element
pub fn Locator::last(self : Locator) -> Locator {
  self.to_any()._call("last", []) |> @nostd.identity
}

///|
/// Get nth element (0-indexed)
pub fn Locator::nth(self : Locator, index : Int) -> Locator {
  self.to_any()._call("nth", [@nostd.any(index)]) |> @nostd.identity
}

///|
/// Get locator within this locator
pub fn Locator::locator(self : Locator, selector : String) -> Locator {
  self.to_any()._call("locator", [@nostd.any(selector)]) |> @nostd.identity
}

///|
/// Get by role within this locator
pub fn Locator::getByRole(
  self : Locator,
  role : String,
  name? : String,
  exact? : Bool,
) -> Locator {
  let options = @nostd.Object::new()
  if name is Some(v) {
    options["name"] = @nostd.any(v)
  }
  if exact is Some(v) {
    options["exact"] = @nostd.any(v)
  }
  self.to_any()._call("getByRole", [@nostd.any(role), options])
  |> @nostd.identity
}

///|
/// Get by text within this locator
pub fn Locator::getByText(
  self : Locator,
  text : String,
  exact? : Bool,
) -> Locator {
  let options = @nostd.Object::new()
  if exact is Some(v) {
    options["exact"] = @nostd.any(v)
  }
  self.to_any()._call("getByText", [@nostd.any(text), options])
  |> @nostd.identity
}

///|
/// Get by label within this locator
pub fn Locator::getByLabel(
  self : Locator,
  text : String,
  exact? : Bool,
) -> Locator {
  let options = @nostd.Object::new()
  if exact is Some(v) {
    options["exact"] = @nostd.any(v)
  }
  self.to_any()._call("getByLabel", [@nostd.any(text), options])
  |> @nostd.identity
}

///|
/// Get by placeholder within this locator
pub fn Locator::getByPlaceholder(
  self : Locator,
  text : String,
  exact? : Bool,
) -> Locator {
  let options = @nostd.Object::new()
  if exact is Some(v) {
    options["exact"] = @nostd.any(v)
  }
  self.to_any()._call("getByPlaceholder", [@nostd.any(text), options])
  |> @nostd.identity
}

///|
/// Get by test ID within this locator
pub fn Locator::getByTestId(self : Locator, testId : String) -> Locator {
  self.to_any()._call("getByTestId", [@nostd.any(testId)]) |> @nostd.identity
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
  let options = @nostd.Object::new()
  if button is Some(v) {
    options["button"] = @nostd.any(v)
  }
  if clickCount is Some(v) {
    options["clickCount"] = @nostd.any(v)
  }
  if delay is Some(v) {
    options["delay"] = @nostd.any(v)
  }
  if force is Some(v) {
    options["force"] = @nostd.any(v)
  }
  if modifiers is Some(v) {
    options["modifiers"] = @nostd.any(@nostd.any(v))
  }
  if noWaitAfter is Some(v) {
    options["noWaitAfter"] = @nostd.any(v)
  }
  if position is Some((x, y)) {
    let pos = @nostd.Object::new()
    pos["x"] = @nostd.any(x)
    pos["y"] = @nostd.any(y)
    options["position"] = pos
  }
  if timeout is Some(v) {
    options["timeout"] = @nostd.any(v)
  }
  if trial is Some(v) {
    options["trial"] = @nostd.any(v)
  }
  let promise : @js.Promise[Unit] = self.to_any()._call("click", [options])
    |> @nostd.identity
  promise.wait()
}

///|
/// Double click element
pub async fn Locator::dblclick(
  self : Locator,
  timeout? : Int,
  force? : Bool,
) -> Unit {
  let options = @nostd.Object::new()
  if timeout is Some(v) {
    options["timeout"] = @nostd.any(v)
  }
  if force is Some(v) {
    options["force"] = @nostd.any(v)
  }
  let promise : @js.Promise[Unit] = self.to_any()._call("dblclick", [options])
    |> @nostd.identity
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
  let options = @nostd.Object::new()
  if force is Some(v) {
    options["force"] = @nostd.any(v)
  }
  if noWaitAfter is Some(v) {
    options["noWaitAfter"] = @nostd.any(v)
  }
  if timeout is Some(v) {
    options["timeout"] = @nostd.any(v)
  }
  let promise : @js.Promise[Unit] = self
    .to_any()
    ._call("fill", [@nostd.any(value), options])
    |> @nostd.identity
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
  let options = @nostd.Object::new()
  if force is Some(v) {
    options["force"] = @nostd.any(v)
  }
  if noWaitAfter is Some(v) {
    options["noWaitAfter"] = @nostd.any(v)
  }
  if timeout is Some(v) {
    options["timeout"] = @nostd.any(v)
  }
  let promise : @js.Promise[Unit] = self.to_any()._call("clear", [options])
    |> @nostd.identity
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
  let options = @nostd.Object::new()
  if delay is Some(v) {
    options["delay"] = @nostd.any(v)
  }
  if noWaitAfter is Some(v) {
    options["noWaitAfter"] = @nostd.any(v)
  }
  if timeout is Some(v) {
    options["timeout"] = @nostd.any(v)
  }
  let promise : @js.Promise[Unit] = self
    .to_any()
    ._call("type", [@nostd.any(text), options])
    |> @nostd.identity
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
  let options = @nostd.Object::new()
  if delay is Some(v) {
    options["delay"] = @nostd.any(v)
  }
  if noWaitAfter is Some(v) {
    options["noWaitAfter"] = @nostd.any(v)
  }
  if timeout is Some(v) {
    options["timeout"] = @nostd.any(v)
  }
  let promise : @js.Promise[Unit] = self
    .to_any()
    ._call("press", [@nostd.any(key), options])
    |> @nostd.identity
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
  let options = @nostd.Object::new()
  if force is Some(v) {
    options["force"] = @nostd.any(v)
  }
  if noWaitAfter is Some(v) {
    options["noWaitAfter"] = @nostd.any(v)
  }
  if timeout is Some(v) {
    options["timeout"] = @nostd.any(v)
  }
  let promise : @js.Promise[Unit] = self.to_any()._call("check", [options])
    |> @nostd.identity
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
  let options = @nostd.Object::new()
  if force is Some(v) {
    options["force"] = @nostd.any(v)
  }
  if noWaitAfter is Some(v) {
    options["noWaitAfter"] = @nostd.any(v)
  }
  if timeout is Some(v) {
    options["timeout"] = @nostd.any(v)
  }
  let promise : @js.Promise[Unit] = self.to_any()._call("uncheck", [options])
    |> @nostd.identity
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
  let options = @nostd.Object::new()
  if force is Some(v) {
    options["force"] = @nostd.any(v)
  }
  if noWaitAfter is Some(v) {
    options["noWaitAfter"] = @nostd.any(v)
  }
  if timeout is Some(v) {
    options["timeout"] = @nostd.any(v)
  }
  let promise : @js.Promise[Unit] = self
    .to_any()
    ._call("setChecked", [@nostd.any(checked), options])
    |> @nostd.identity
  promise.wait()
}

///|
/// Select option(s) in dropdown
pub async fn Locator::selectOption(
  self : Locator,
  values : @nostd.Any,
  force? : Bool,
  noWaitAfter? : Bool,
  timeout? : Int,
) -> Array[String] {
  let options = @nostd.Object::new()
  if force is Some(v) {
    options["force"] = @nostd.any(v)
  }
  if noWaitAfter is Some(v) {
    options["noWaitAfter"] = @nostd.any(v)
  }
  if timeout is Some(v) {
    options["timeout"] = @nostd.any(v)
  }
  let promise : @js.Promise[Array[String]] = self
    .to_any()
    ._call("selectOption", [@nostd.any(values), options])
    |> @nostd.identity
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
  let options = @nostd.Object::new()
  if force is Some(v) {
    options["force"] = @nostd.any(v)
  }
  if modifiers is Some(v) {
    options["modifiers"] = @nostd.any(@nostd.any(v))
  }
  if position is Some((x, y)) {
    let pos = @nostd.Object::new()
    pos["x"] = @nostd.any(x)
    pos["y"] = @nostd.any(y)
    options["position"] = pos
  }
  if timeout is Some(v) {
    options["timeout"] = @nostd.any(v)
  }
  if trial is Some(v) {
    options["trial"] = @nostd.any(v)
  }
  let promise : @js.Promise[Unit] = self.to_any()._call("hover", [options])
    |> @nostd.identity
  promise.wait()
}

///|
/// Focus element
pub async fn Locator::focus(self : Locator, timeout? : Int) -> Unit {
  let options = @nostd.Object::new()
  if timeout is Some(v) {
    options["timeout"] = @nostd.any(v)
  }
  let promise : @js.Promise[Unit] = self.to_any()._call("focus", [options])
    |> @nostd.identity
  promise.wait()
}

///|
/// Blur element
pub async fn Locator::blur(self : Locator, timeout? : Int) -> Unit {
  let options = @nostd.Object::new()
  if timeout is Some(v) {
    options["timeout"] = @nostd.any(v)
  }
  let promise : @js.Promise[Unit] = self.to_any()._call("blur", [options])
    |> @nostd.identity
  promise.wait()
}

///|
/// Scroll element into view
pub async fn Locator::scrollIntoViewIfNeeded(
  self : Locator,
  timeout? : Int,
) -> Unit {
  let options = @nostd.Object::new()
  if timeout is Some(v) {
    options["timeout"] = @nostd.any(v)
  }
  let promise : @js.Promise[Unit] = self
    .to_any()
    ._call("scrollIntoViewIfNeeded", [options])
    |> @nostd.identity
  promise.wait()
}

///| Property Methods

///|
/// Get inner text
pub async fn Locator::innerText(self : Locator, timeout? : Int) -> String {
  let options = @nostd.Object::new()
  if timeout is Some(v) {
    options["timeout"] = @nostd.any(v)
  }
  let promise : @js.Promise[String] = self
    .to_any()
    ._call("innerText", [options])
    |> @nostd.identity
  promise.wait()
}

///|
/// Get inner HTML
pub async fn Locator::innerHTML(self : Locator, timeout? : Int) -> String {
  let options = @nostd.Object::new()
  if timeout is Some(v) {
    options["timeout"] = @nostd.any(v)
  }
  let promise : @js.Promise[String] = self
    .to_any()
    ._call("innerHTML", [options])
    |> @nostd.identity
  promise.wait()
}

///|
/// Get text content
pub async fn Locator::textContent(self : Locator, timeout? : Int) -> String? {
  let options = @nostd.Object::new()
  if timeout is Some(v) {
    options["timeout"] = @nostd.any(v)
  }
  let promise : @js.Promise[@nostd.Any] = self
    .to_any()
    ._call("textContent", [options])
    |> @nostd.identity
  let result : @nostd.Any = promise.wait() |> @nostd.any
  if @nostd.is_nullish(result) {
    None
  } else {
    Some(result.cast())
  }
}

///|
/// Get all text contents
pub async fn Locator::allTextContents(self : Locator) -> Array[String] {
  let promise : @js.Promise[Array[String]] = self
    .to_any()
    ._call("allTextContents", [])
    |> @nostd.identity
  promise.wait()
}

///|
/// Get all inner texts
pub async fn Locator::allInnerTexts(self : Locator) -> Array[String] {
  let promise : @js.Promise[Array[String]] = self
    .to_any()
    ._call("allInnerTexts", [])
    |> @nostd.identity
  promise.wait()
}

///|
/// Get attribute
pub async fn Locator::getAttribute(
  self : Locator,
  name : String,
  timeout? : Int,
) -> String? {
  let options = @nostd.Object::new()
  if timeout is Some(v) {
    options["timeout"] = @nostd.any(v)
  }
  let promise : @js.Promise[@nostd.Any] = self
    .to_any()
    ._call("getAttribute", [@nostd.any(name), options])
    |> @nostd.identity
  let result : @nostd.Any = promise.wait() |> @nostd.any
  if @nostd.is_nullish(result) {
    None
  } else {
    Some(result.cast())
  }
}

///|
/// Get input value
pub async fn Locator::inputValue(self : Locator, timeout? : Int) -> String {
  let options = @nostd.Object::new()
  if timeout is Some(v) {
    options["timeout"] = @nostd.any(v)
  }
  let promise : @js.Promise[String] = self
    .to_any()
    ._call("inputValue", [options])
    |> @nostd.identity
  promise.wait()
}

///|
/// Check if element is visible
pub async fn Locator::isVisible(self : Locator, timeout? : Int) -> Bool {
  let options = @nostd.Object::new()
  if timeout is Some(v) {
    options["timeout"] = @nostd.any(v)
  }
  let promise : @js.Promise[Bool] = self.to_any()._call("isVisible", [options])
    |> @nostd.identity
  promise.wait()
}

///|
/// Check if element is hidden
pub async fn Locator::isHidden(self : Locator, timeout? : Int) -> Bool {
  let options = @nostd.Object::new()
  if timeout is Some(v) {
    options["timeout"] = @nostd.any(v)
  }
  let promise : @js.Promise[Bool] = self.to_any()._call("isHidden", [options])
    |> @nostd.identity
  promise.wait()
}

///|
/// Check if element is enabled
pub async fn Locator::isEnabled(self : Locator, timeout? : Int) -> Bool {
  let options = @nostd.Object::new()
  if timeout is Some(v) {
    options["timeout"] = @nostd.any(v)
  }
  let promise : @js.Promise[Bool] = self.to_any()._call("isEnabled", [options])
    |> @nostd.identity
  promise.wait()
}

///|
/// Check if element is disabled
pub async fn Locator::isDisabled(self : Locator, timeout? : Int) -> Bool {
  let options = @nostd.Object::new()
  if timeout is Some(v) {
    options["timeout"] = @nostd.any(v)
  }
  let promise : @js.Promise[Bool] = self.to_any()._call("isDisabled", [options])
    |> @nostd.identity
  promise.wait()
}

///|
/// Check if element is editable
pub async fn Locator::isEditable(self : Locator, timeout? : Int) -> Bool {
  let options = @nostd.Object::new()
  if timeout is Some(v) {
    options["timeout"] = @nostd.any(v)
  }
  let promise : @js.Promise[Bool] = self.to_any()._call("isEditable", [options])
    |> @nostd.identity
  promise.wait()
}

///|
/// Check if checkbox is checked
pub async fn Locator::isChecked(self : Locator, timeout? : Int) -> Bool {
  let options = @nostd.Object::new()
  if timeout is Some(v) {
    options["timeout"] = @nostd.any(v)
  }
  let promise : @js.Promise[Bool] = self.to_any()._call("isChecked", [options])
    |> @nostd.identity
  promise.wait()
}

///|
/// Get element count
pub async fn Locator::count(self : Locator) -> Int {
  let promise : @js.Promise[Int] = self.to_any()._call("count", [])
    |> @nostd.identity
  promise.wait()
}

///|
/// Get bounding box
pub async fn Locator::boundingBox(self : Locator, timeout? : Int) -> @nostd.Any {
  let options = @nostd.Object::new()
  if timeout is Some(v) {
    options["timeout"] = @nostd.any(v)
  }
  let promise : @js.Promise[@nostd.Any] = self
    .to_any()
    ._call("boundingBox", [options])
    |> @nostd.identity
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
  let options = @nostd.Object::new()
  if state is Some(v) {
    options["state"] = @nostd.any(v)
  }
  if timeout is Some(v) {
    options["timeout"] = @nostd.any(v)
  }
  let promise : @js.Promise[Unit] = self.to_any()._call("waitFor", [options])
    |> @nostd.identity
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
) -> @nostd.Any {
  let options = @nostd.Object::new()
  if path is Some(v) {
    options["path"] = @nostd.any(v)
  }
  if type_ is Some(v) {
    options["type"] = @nostd.any(v)
  }
  if quality is Some(v) {
    options["quality"] = @nostd.any(v)
  }
  if omitBackground is Some(v) {
    options["omitBackground"] = @nostd.any(v)
  }
  if timeout is Some(v) {
    options["timeout"] = @nostd.any(v)
  }
  if scale is Some(v) {
    options["scale"] = @nostd.any(v)
  }
  let promise : @js.Promise[@nostd.Any] = self
    .to_any()
    ._call("screenshot", [options])
    |> @nostd.identity
  promise.wait()
}

///| Evaluate

///|
/// Evaluate JavaScript in element context
pub async fn Locator::evaluate(
  self : Locator,
  pageFunction : String,
  arg? : @nostd.Any,
  timeout? : Int,
) -> @nostd.Any {
  let options = @nostd.Object::new()
  if timeout is Some(v) {
    options["timeout"] = @nostd.any(v)
  }
  let promise : @js.Promise[@nostd.Any] = match arg {
    Some(a) =>
      self
      .to_any()
      ._call("evaluate", [@nostd.any(pageFunction), @nostd.any(a), options])
      |> @nostd.identity
    None =>
      self.to_any()._call("evaluate", [@nostd.any(pageFunction), options])
      |> @nostd.identity
  }
  promise.wait()
}

///|
/// Evaluate all matching elements
pub async fn Locator::evaluateAll(
  self : Locator,
  pageFunction : String,
  arg? : @nostd.Any,
) -> @nostd.Any {
  let promise : @js.Promise[@nostd.Any] = match arg {
    Some(a) =>
      self
      .to_any()
      ._call("evaluateAll", [@nostd.any(pageFunction), @nostd.any(a)])
      |> @nostd.identity
    None =>
      self.to_any()._call("evaluateAll", [@nostd.any(pageFunction)])
      |> @nostd.identity
  }
  promise.wait()
}
