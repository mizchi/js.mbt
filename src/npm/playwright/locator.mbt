///|
/// Locator type for Playwright
/// https://playwright.dev/docs/api/class-locator

///|
/// Locator - strict element selector
#external
pub type Locator

///|
pub fn Locator::to_any(self : Locator) -> @core.Any = "%identity"

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
  let options = @core.new_object()
  if has is Some(v) {
    options["has"] = v.to_any()
  }
  if hasNot is Some(v) {
    options["hasNot"] = v.to_any()
  }
  if hasText is Some(v) {
    options["hasText"] = @core.any(v)
  }
  if hasNotText is Some(v) {
    options["hasNotText"] = @core.any(v)
  }
  self.to_any()._call("filter", [options]) |> @core.identity
}

///|
/// Get first element
pub fn Locator::first(self : Locator) -> Locator {
  self.to_any()._call("first", []) |> @core.identity
}

///|
/// Get last element
pub fn Locator::last(self : Locator) -> Locator {
  self.to_any()._call("last", []) |> @core.identity
}

///|
/// Get nth element (0-indexed)
pub fn Locator::nth(self : Locator, index : Int) -> Locator {
  self.to_any()._call("nth", [@core.any(index)]) |> @core.identity
}

///|
/// Get locator within this locator
pub fn Locator::locator(self : Locator, selector : String) -> Locator {
  self.to_any()._call("locator", [@core.any(selector)]) |> @core.identity
}

///|
/// Get by role within this locator
pub fn Locator::getByRole(
  self : Locator,
  role : String,
  name? : String,
  exact? : Bool,
) -> Locator {
  let options = @core.new_object()
  if name is Some(v) {
    options["name"] = @core.any(v)
  }
  if exact is Some(v) {
    options["exact"] = @core.any(v)
  }
  self.to_any()._call("getByRole", [@core.any(role), options]) |> @core.identity
}

///|
/// Get by text within this locator
pub fn Locator::getByText(
  self : Locator,
  text : String,
  exact? : Bool,
) -> Locator {
  let options = @core.new_object()
  if exact is Some(v) {
    options["exact"] = @core.any(v)
  }
  self.to_any()._call("getByText", [@core.any(text), options]) |> @core.identity
}

///|
/// Get by label within this locator
pub fn Locator::getByLabel(
  self : Locator,
  text : String,
  exact? : Bool,
) -> Locator {
  let options = @core.new_object()
  if exact is Some(v) {
    options["exact"] = @core.any(v)
  }
  self.to_any()._call("getByLabel", [@core.any(text), options])
  |> @core.identity
}

///|
/// Get by placeholder within this locator
pub fn Locator::getByPlaceholder(
  self : Locator,
  text : String,
  exact? : Bool,
) -> Locator {
  let options = @core.new_object()
  if exact is Some(v) {
    options["exact"] = @core.any(v)
  }
  self.to_any()._call("getByPlaceholder", [@core.any(text), options])
  |> @core.identity
}

///|
/// Get by test ID within this locator
pub fn Locator::getByTestId(self : Locator, testId : String) -> Locator {
  self.to_any()._call("getByTestId", [@core.any(testId)]) |> @core.identity
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
  let options = @core.new_object()
  if button is Some(v) {
    options["button"] = @core.any(v)
  }
  if clickCount is Some(v) {
    options["clickCount"] = @core.any(v)
  }
  if delay is Some(v) {
    options["delay"] = @core.any(v)
  }
  if force is Some(v) {
    options["force"] = @core.any(v)
  }
  if modifiers is Some(v) {
    options["modifiers"] = @core.any(@core.any(v))
  }
  if noWaitAfter is Some(v) {
    options["noWaitAfter"] = @core.any(v)
  }
  if position is Some((x, y)) {
    let pos = @core.new_object()
    pos["x"] = @core.any(x)
    pos["y"] = @core.any(y)
    options["position"] = pos
  }
  if timeout is Some(v) {
    options["timeout"] = @core.any(v)
  }
  if trial is Some(v) {
    options["trial"] = @core.any(v)
  }
  let promise : @js.Promise[Unit] = self.to_any()._call("click", [options])
    |> @core.identity
  promise.wait()
}

///|
/// Double click element
pub async fn Locator::dblclick(
  self : Locator,
  timeout? : Int,
  force? : Bool,
) -> Unit {
  let options = @core.new_object()
  if timeout is Some(v) {
    options["timeout"] = @core.any(v)
  }
  if force is Some(v) {
    options["force"] = @core.any(v)
  }
  let promise : @js.Promise[Unit] = self.to_any()._call("dblclick", [options])
    |> @core.identity
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
  let options = @core.new_object()
  if force is Some(v) {
    options["force"] = @core.any(v)
  }
  if noWaitAfter is Some(v) {
    options["noWaitAfter"] = @core.any(v)
  }
  if timeout is Some(v) {
    options["timeout"] = @core.any(v)
  }
  let promise : @js.Promise[Unit] = self
    .to_any()
    ._call("fill", [@core.any(value), options])
    |> @core.identity
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
  let options = @core.new_object()
  if force is Some(v) {
    options["force"] = @core.any(v)
  }
  if noWaitAfter is Some(v) {
    options["noWaitAfter"] = @core.any(v)
  }
  if timeout is Some(v) {
    options["timeout"] = @core.any(v)
  }
  let promise : @js.Promise[Unit] = self.to_any()._call("clear", [options])
    |> @core.identity
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
  let options = @core.new_object()
  if delay is Some(v) {
    options["delay"] = @core.any(v)
  }
  if noWaitAfter is Some(v) {
    options["noWaitAfter"] = @core.any(v)
  }
  if timeout is Some(v) {
    options["timeout"] = @core.any(v)
  }
  let promise : @js.Promise[Unit] = self
    .to_any()
    ._call("type", [@core.any(text), options])
    |> @core.identity
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
  let options = @core.new_object()
  if delay is Some(v) {
    options["delay"] = @core.any(v)
  }
  if noWaitAfter is Some(v) {
    options["noWaitAfter"] = @core.any(v)
  }
  if timeout is Some(v) {
    options["timeout"] = @core.any(v)
  }
  let promise : @js.Promise[Unit] = self
    .to_any()
    ._call("press", [@core.any(key), options])
    |> @core.identity
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
  let options = @core.new_object()
  if force is Some(v) {
    options["force"] = @core.any(v)
  }
  if noWaitAfter is Some(v) {
    options["noWaitAfter"] = @core.any(v)
  }
  if timeout is Some(v) {
    options["timeout"] = @core.any(v)
  }
  let promise : @js.Promise[Unit] = self.to_any()._call("check", [options])
    |> @core.identity
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
  let options = @core.new_object()
  if force is Some(v) {
    options["force"] = @core.any(v)
  }
  if noWaitAfter is Some(v) {
    options["noWaitAfter"] = @core.any(v)
  }
  if timeout is Some(v) {
    options["timeout"] = @core.any(v)
  }
  let promise : @js.Promise[Unit] = self.to_any()._call("uncheck", [options])
    |> @core.identity
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
  let options = @core.new_object()
  if force is Some(v) {
    options["force"] = @core.any(v)
  }
  if noWaitAfter is Some(v) {
    options["noWaitAfter"] = @core.any(v)
  }
  if timeout is Some(v) {
    options["timeout"] = @core.any(v)
  }
  let promise : @js.Promise[Unit] = self
    .to_any()
    ._call("setChecked", [@core.any(checked), options])
    |> @core.identity
  promise.wait()
}

///|
/// Select option(s) in dropdown
pub async fn Locator::selectOption(
  self : Locator,
  values : @core.Any,
  force? : Bool,
  noWaitAfter? : Bool,
  timeout? : Int,
) -> Array[String] {
  let options = @core.new_object()
  if force is Some(v) {
    options["force"] = @core.any(v)
  }
  if noWaitAfter is Some(v) {
    options["noWaitAfter"] = @core.any(v)
  }
  if timeout is Some(v) {
    options["timeout"] = @core.any(v)
  }
  let promise : @js.Promise[Array[String]] = self
    .to_any()
    ._call("selectOption", [@core.any(values), options])
    |> @core.identity
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
  let options = @core.new_object()
  if force is Some(v) {
    options["force"] = @core.any(v)
  }
  if modifiers is Some(v) {
    options["modifiers"] = @core.any(@core.any(v))
  }
  if position is Some((x, y)) {
    let pos = @core.new_object()
    pos["x"] = @core.any(x)
    pos["y"] = @core.any(y)
    options["position"] = pos
  }
  if timeout is Some(v) {
    options["timeout"] = @core.any(v)
  }
  if trial is Some(v) {
    options["trial"] = @core.any(v)
  }
  let promise : @js.Promise[Unit] = self.to_any()._call("hover", [options])
    |> @core.identity
  promise.wait()
}

///|
/// Focus element
pub async fn Locator::focus(self : Locator, timeout? : Int) -> Unit {
  let options = @core.new_object()
  if timeout is Some(v) {
    options["timeout"] = @core.any(v)
  }
  let promise : @js.Promise[Unit] = self.to_any()._call("focus", [options])
    |> @core.identity
  promise.wait()
}

///|
/// Blur element
pub async fn Locator::blur(self : Locator, timeout? : Int) -> Unit {
  let options = @core.new_object()
  if timeout is Some(v) {
    options["timeout"] = @core.any(v)
  }
  let promise : @js.Promise[Unit] = self.to_any()._call("blur", [options])
    |> @core.identity
  promise.wait()
}

///|
/// Scroll element into view
pub async fn Locator::scrollIntoViewIfNeeded(
  self : Locator,
  timeout? : Int,
) -> Unit {
  let options = @core.new_object()
  if timeout is Some(v) {
    options["timeout"] = @core.any(v)
  }
  let promise : @js.Promise[Unit] = self
    .to_any()
    ._call("scrollIntoViewIfNeeded", [options])
    |> @core.identity
  promise.wait()
}

///| Property Methods

///|
/// Get inner text
pub async fn Locator::innerText(self : Locator, timeout? : Int) -> String {
  let options = @core.new_object()
  if timeout is Some(v) {
    options["timeout"] = @core.any(v)
  }
  let promise : @js.Promise[String] = self
    .to_any()
    ._call("innerText", [options])
    |> @core.identity
  promise.wait()
}

///|
/// Get inner HTML
pub async fn Locator::innerHTML(self : Locator, timeout? : Int) -> String {
  let options = @core.new_object()
  if timeout is Some(v) {
    options["timeout"] = @core.any(v)
  }
  let promise : @js.Promise[String] = self
    .to_any()
    ._call("innerHTML", [options])
    |> @core.identity
  promise.wait()
}

///|
/// Get text content
pub async fn Locator::textContent(self : Locator, timeout? : Int) -> String? {
  let options = @core.new_object()
  if timeout is Some(v) {
    options["timeout"] = @core.any(v)
  }
  let promise : @js.Promise[@core.Any] = self
    .to_any()
    ._call("textContent", [options])
    |> @core.identity
  let result : @core.Any = promise.wait() |> @core.any
  if @core.is_nullish(result) {
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
    |> @core.identity
  promise.wait()
}

///|
/// Get all inner texts
pub async fn Locator::allInnerTexts(self : Locator) -> Array[String] {
  let promise : @js.Promise[Array[String]] = self
    .to_any()
    ._call("allInnerTexts", [])
    |> @core.identity
  promise.wait()
}

///|
/// Get attribute
pub async fn Locator::getAttribute(
  self : Locator,
  name : String,
  timeout? : Int,
) -> String? {
  let options = @core.new_object()
  if timeout is Some(v) {
    options["timeout"] = @core.any(v)
  }
  let promise : @js.Promise[@core.Any] = self
    .to_any()
    ._call("getAttribute", [@core.any(name), options])
    |> @core.identity
  let result : @core.Any = promise.wait() |> @core.any
  if @core.is_nullish(result) {
    None
  } else {
    Some(result.cast())
  }
}

///|
/// Get input value
pub async fn Locator::inputValue(self : Locator, timeout? : Int) -> String {
  let options = @core.new_object()
  if timeout is Some(v) {
    options["timeout"] = @core.any(v)
  }
  let promise : @js.Promise[String] = self
    .to_any()
    ._call("inputValue", [options])
    |> @core.identity
  promise.wait()
}

///|
/// Check if element is visible
pub async fn Locator::isVisible(self : Locator, timeout? : Int) -> Bool {
  let options = @core.new_object()
  if timeout is Some(v) {
    options["timeout"] = @core.any(v)
  }
  let promise : @js.Promise[Bool] = self.to_any()._call("isVisible", [options])
    |> @core.identity
  promise.wait()
}

///|
/// Check if element is hidden
pub async fn Locator::isHidden(self : Locator, timeout? : Int) -> Bool {
  let options = @core.new_object()
  if timeout is Some(v) {
    options["timeout"] = @core.any(v)
  }
  let promise : @js.Promise[Bool] = self.to_any()._call("isHidden", [options])
    |> @core.identity
  promise.wait()
}

///|
/// Check if element is enabled
pub async fn Locator::isEnabled(self : Locator, timeout? : Int) -> Bool {
  let options = @core.new_object()
  if timeout is Some(v) {
    options["timeout"] = @core.any(v)
  }
  let promise : @js.Promise[Bool] = self.to_any()._call("isEnabled", [options])
    |> @core.identity
  promise.wait()
}

///|
/// Check if element is disabled
pub async fn Locator::isDisabled(self : Locator, timeout? : Int) -> Bool {
  let options = @core.new_object()
  if timeout is Some(v) {
    options["timeout"] = @core.any(v)
  }
  let promise : @js.Promise[Bool] = self.to_any()._call("isDisabled", [options])
    |> @core.identity
  promise.wait()
}

///|
/// Check if element is editable
pub async fn Locator::isEditable(self : Locator, timeout? : Int) -> Bool {
  let options = @core.new_object()
  if timeout is Some(v) {
    options["timeout"] = @core.any(v)
  }
  let promise : @js.Promise[Bool] = self.to_any()._call("isEditable", [options])
    |> @core.identity
  promise.wait()
}

///|
/// Check if checkbox is checked
pub async fn Locator::isChecked(self : Locator, timeout? : Int) -> Bool {
  let options = @core.new_object()
  if timeout is Some(v) {
    options["timeout"] = @core.any(v)
  }
  let promise : @js.Promise[Bool] = self.to_any()._call("isChecked", [options])
    |> @core.identity
  promise.wait()
}

///|
/// Get element count
pub async fn Locator::count(self : Locator) -> Int {
  let promise : @js.Promise[Int] = self.to_any()._call("count", [])
    |> @core.identity
  promise.wait()
}

///|
/// Get bounding box
pub async fn Locator::boundingBox(self : Locator, timeout? : Int) -> @core.Any {
  let options = @core.new_object()
  if timeout is Some(v) {
    options["timeout"] = @core.any(v)
  }
  let promise : @js.Promise[@core.Any] = self
    .to_any()
    ._call("boundingBox", [options])
    |> @core.identity
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
  let options = @core.new_object()
  if state is Some(v) {
    options["state"] = @core.any(v)
  }
  if timeout is Some(v) {
    options["timeout"] = @core.any(v)
  }
  let promise : @js.Promise[Unit] = self.to_any()._call("waitFor", [options])
    |> @core.identity
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
) -> @core.Any {
  let options = @core.new_object()
  if path is Some(v) {
    options["path"] = @core.any(v)
  }
  if type_ is Some(v) {
    options["type"] = @core.any(v)
  }
  if quality is Some(v) {
    options["quality"] = @core.any(v)
  }
  if omitBackground is Some(v) {
    options["omitBackground"] = @core.any(v)
  }
  if timeout is Some(v) {
    options["timeout"] = @core.any(v)
  }
  if scale is Some(v) {
    options["scale"] = @core.any(v)
  }
  let promise : @js.Promise[@core.Any] = self
    .to_any()
    ._call("screenshot", [options])
    |> @core.identity
  promise.wait()
}

///| Evaluate

///|
/// Evaluate JavaScript in element context
pub async fn Locator::evaluate(
  self : Locator,
  pageFunction : String,
  arg? : @core.Any,
  timeout? : Int,
) -> @core.Any {
  let options = @core.new_object()
  if timeout is Some(v) {
    options["timeout"] = @core.any(v)
  }
  let promise : @js.Promise[@core.Any] = match arg {
    Some(a) =>
      self
      .to_any()
      ._call("evaluate", [@core.any(pageFunction), @core.any(a), options])
      |> @core.identity
    None =>
      self.to_any()._call("evaluate", [@core.any(pageFunction), options])
      |> @core.identity
  }
  promise.wait()
}

///|
/// Evaluate all matching elements
pub async fn Locator::evaluateAll(
  self : Locator,
  pageFunction : String,
  arg? : @core.Any,
) -> @core.Any {
  let promise : @js.Promise[@core.Any] = match arg {
    Some(a) =>
      self
      .to_any()
      ._call("evaluateAll", [@core.any(pageFunction), @core.any(a)])
      |> @core.identity
    None =>
      self.to_any()._call("evaluateAll", [@core.any(pageFunction)])
      |> @core.identity
  }
  promise.wait()
}
