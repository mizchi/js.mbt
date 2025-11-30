///|
/// Jest-DOM style matchers for React Testing Library
/// Usage: expect(element).toHaveTextContent("Hello")
///
/// These matchers use @testing-library/jest-dom under the hood.
/// Call setup_matchers() once before using matchers.

///|
/// Error type for matcher failures
pub suberror ExpectError String

///|
/// Matcher result { pass: Bool, message: () -> String }
#external
priv type MatcherResult

///|
impl @js.JsImpl for MatcherResult

///|
/// Check if matcher passed
fn MatcherResult::pass(self : MatcherResult) -> Bool {
  self.get("pass").cast()
}

///|
/// Get error message (call only on failure)
fn MatcherResult::message(self : MatcherResult) -> String {
  let msg_fn = self.get("message")
  msg_fn.call_self0().cast()
}

///|
/// Cached jest-dom matchers module
let jest_dom_matchers : Ref[@js.Any?] = Ref::new(None)

///|
/// Cached matcher context
let matcher_context : Ref[@js.Any?] = Ref::new(None)

///|
/// Setup jest-dom matchers. Call once before using matchers.
pub fn setup_matchers() -> Unit {
  if jest_dom_matchers.val is Some(_) {
    return
  }
  // Load @testing-library/jest-dom/matchers
  jest_dom_matchers.val = Some(
    @node.require("@testing-library/jest-dom/matchers"),
  )
  // Create matcher context with minimal utils (no colors)
  let utils = @js.Object::new()
  // matcherHint function
  let matcher_hint : (String, String, String) -> String = fn(
    matcher_name,
    received,
    _expected,
  ) {
    "expect(" + received + ")" + matcher_name
  }
  utils.set("matcherHint", @js.from_fn3(matcher_hint))
  // printReceived - identity function (no color)
  let print_received : (String) -> String = fn(value) { value }
  utils.set("printReceived", @js.from_fn1(print_received))
  // printExpected - identity function (no color)
  let print_expected : (String) -> String = fn(value) { value }
  utils.set("printExpected", @js.from_fn1(print_expected))
  // printWithType
  let print_with_type : (String, @js.Any, @js.Any) -> String = fn(
    name,
    value,
    print,
  ) {
    let printed : String = print.call_self([value]).cast()
    name + ": " + printed
  }
  utils.set("printWithType", @js.from_fn3(print_with_type))
  // Color functions - identity functions (no color)
  let identity : (String) -> String = fn(s) { s }
  utils.set("RECEIVED_COLOR", @js.from_fn1(identity))
  utils.set("EXPECTED_COLOR", @js.from_fn1(identity))
  utils.set("BOLD_WEIGHT", @js.from_fn1(identity))
  utils.set("DIM_COLOR", @js.from_fn1(identity))
  // Create context
  let ctx = @js.Object::new()
  ctx.set("isNot", false)
  ctx.set("utils", utils)
  // equals function for some matchers (using Object.is)
  let equals_fn : (@js.Any, @js.Any) -> Bool = fn(a, b) { a == b }
  ctx.set("equals", @js.from_fn2(equals_fn))
  matcher_context.val = Some(ctx)
}

///|
/// Internal: call a jest-dom matcher
fn call_matcher(
  element : @dom.HTMLElement,
  matcher_name : String,
  args : Array[@nostd.Any],
) -> MatcherResult {
  guard jest_dom_matchers.val is Some(matchers) else {
    abort("setup_matchers() must be called before using matchers")
  }
  guard matcher_context.val is Some(ctx) else {
    abort("setup_matchers() must be called before using matchers")
  }
  let matcher : @nostd.Any = matchers.get(matcher_name) |> @nostd.identity
  // matcher.call(ctx, element, ...args)
  let all_args : Array[@nostd.Any] = [@nostd.identity(ctx), element.as_any()]
  for arg in args {
    all_args.push(arg)
  }
  matcher._call("call", all_args).cast()
}

///|
/// Assert and raise ExpectError on failure
fn assert_matcher(
  element : @dom.HTMLElement,
  matcher_name : String,
  args : Array[@nostd.Any],
) -> Unit raise ExpectError {
  let result = call_matcher(element, matcher_name, args)
  if not(result.pass()) {
    raise ExpectError(result.message())
  }
}

// ============================================================
// Expect wrapper
// ============================================================

///|
/// Expect wrapper for fluent assertions
/// Usage: expect(screen.getByText("Hello"))..toHaveTextContent("Hello")
pub struct Expect {
  element : @dom.HTMLElement
}

///|
/// Create an Expect wrapper for a ScreenResult (from screen queries)
pub fn expect(result : @testing_library.ScreenResult) -> Expect {
  { element: result.as_element() }
}

// ============================================================
// Text Content Matchers
// ============================================================

///|
/// Assert element has expected text content (String or RegExp)
/// Usage: expect(element)..toHaveTextContent("Hello World")
/// Usage: expect(element)..toHaveTextContent(@regexp.new("Hello"))
#alias(to_have_text_content)
pub fn[T : @testing_library.TextMatch] Expect::toHaveTextContent(
  self : Expect,
  expected : T,
) -> Unit raise ExpectError {
  assert_matcher(
    self.element,
    "toHaveTextContent",
    [expected.as_any()].map(@nostd.any),
  )
}

// ============================================================
// Attribute Matchers
// ============================================================

///|
/// Assert element has attribute
/// Usage: expect(element)..toHaveAttribute("disabled")
#alias(to_have_attribute)
pub fn Expect::toHaveAttribute(
  self : Expect,
  attr : String,
) -> Unit raise ExpectError {
  assert_matcher(self.element, "toHaveAttribute", [attr].map(@nostd.any))
}

///|
/// Assert element has attribute with value
/// Usage: expect(element)..toHaveAttributeValue("type", "submit")
#alias(to_have_attribute_value)
pub fn Expect::toHaveAttributeValue(
  self : Expect,
  attr : String,
  value : String,
) -> Unit raise ExpectError {
  assert_matcher(self.element, "toHaveAttribute", [attr, value].map(@nostd.any))
}

///|
/// Assert element has class
/// Usage: expect(element)..toHaveClass("active")
#alias(to_have_class)
pub fn Expect::toHaveClass(
  self : Expect,
  class_name : String,
) -> Unit raise ExpectError {
  assert_matcher(self.element, "toHaveClass", [class_name].map(@nostd.any))
}

///|
/// Assert element has style
/// Usage: expect(element)..toHaveStyle("display: none")
#alias(to_have_style)
pub fn Expect::toHaveStyle(
  self : Expect,
  style : String,
) -> Unit raise ExpectError {
  assert_matcher(self.element, "toHaveStyle", [style].map(@nostd.any))
}

///|
/// Assert element has value (for inputs)
/// Usage: expect(input)..toHaveValue("hello")
#alias(to_have_value)
pub fn Expect::toHaveValue(
  self : Expect,
  value : String,
) -> Unit raise ExpectError {
  assert_matcher(self.element, "toHaveValue", [value].map(@nostd.any))
}

///|
/// Assert element has display value (for inputs/selects)
/// Usage: expect(select)..toHaveDisplayValue("Option 1")
#alias(to_have_display_value)
pub fn Expect::toHaveDisplayValue(
  self : Expect,
  value : String,
) -> Unit raise ExpectError {
  assert_matcher(self.element, "toHaveDisplayValue", [value].map(@nostd.any))
}

// ============================================================
// State Matchers
// ============================================================

///|
/// Assert element is in the document
/// Usage: expect(element)..toBeInTheDocument()
#alias(to_be_in_the_document)
pub fn Expect::toBeInTheDocument(self : Expect) -> Unit raise ExpectError {
  assert_matcher(self.element, "toBeInTheDocument", ([] : Array[@nostd.Any]))
}

///|
/// Assert element is visible
/// Usage: expect(element)..toBeVisible()
#alias(to_be_visible)
pub fn Expect::toBeVisible(self : Expect) -> Unit raise ExpectError {
  assert_matcher(self.element, "toBeVisible", ([] : Array[@nostd.Any]))
}

///|
/// Assert element is disabled
/// Usage: expect(button)..toBeDisabled()
#alias(to_be_disabled)
pub fn Expect::toBeDisabled(self : Expect) -> Unit raise ExpectError {
  assert_matcher(self.element, "toBeDisabled", ([] : Array[@nostd.Any]))
}

///|
/// Assert element is enabled
/// Usage: expect(button)..toBeEnabled()
#alias(to_be_enabled)
pub fn Expect::toBeEnabled(self : Expect) -> Unit raise ExpectError {
  assert_matcher(self.element, "toBeEnabled", ([] : Array[@nostd.Any]))
}

///|
/// Assert element is checked (checkbox/radio)
/// Usage: expect(checkbox)..toBeChecked()
#alias(to_be_checked)
pub fn Expect::toBeChecked(self : Expect) -> Unit raise ExpectError {
  assert_matcher(self.element, "toBeChecked", ([] : Array[@nostd.Any]))
}

///|
/// Assert element is required
/// Usage: expect(input)..toBeRequired()
#alias(to_be_required)
pub fn Expect::toBeRequired(self : Expect) -> Unit raise ExpectError {
  assert_matcher(self.element, "toBeRequired", ([] : Array[@nostd.Any]))
}

///|
/// Assert element is valid
/// Usage: expect(input)..toBeValid()
#alias(to_be_valid)
pub fn Expect::toBeValid(self : Expect) -> Unit raise ExpectError {
  assert_matcher(self.element, "toBeValid", ([] : Array[@nostd.Any]))
}

///|
/// Assert element is invalid
/// Usage: expect(input)..toBeInvalid()
#alias(to_be_invalid)
pub fn Expect::toBeInvalid(self : Expect) -> Unit raise ExpectError {
  assert_matcher(self.element, "toBeInvalid", ([] : Array[@nostd.Any]))
}

///|
/// Assert element has focus
/// Usage: expect(input)..toHaveFocus()
#alias(to_have_focus)
pub fn Expect::toHaveFocus(self : Expect) -> Unit raise ExpectError {
  assert_matcher(self.element, "toHaveFocus", ([] : Array[@nostd.Any]))
}

///|
/// Assert element is empty
/// Usage: expect(container)..toBeEmptyDOMElement()
#alias(to_be_empty_dom_element)
pub fn Expect::toBeEmptyDOMElement(self : Expect) -> Unit raise ExpectError {
  assert_matcher(self.element, "toBeEmptyDOMElement", ([] : Array[@nostd.Any]))
}

// ============================================================
// Accessibility Matchers
// ============================================================

///|
/// Assert element has accessible name
/// Usage: expect(button)..toHaveAccessibleName("Submit")
#alias(to_have_accessible_name)
pub fn Expect::toHaveAccessibleName(
  self : Expect,
  name : String,
) -> Unit raise ExpectError {
  assert_matcher(self.element, "toHaveAccessibleName", [name].map(@nostd.any))
}

///|
/// Assert element has accessible description
/// Usage: expect(input)..toHaveAccessibleDescription("Enter your name")
#alias(to_have_accessible_description)
pub fn Expect::toHaveAccessibleDescription(
  self : Expect,
  desc : String,
) -> Unit raise ExpectError {
  assert_matcher(
    self.element,
    "toHaveAccessibleDescription",
    [desc].map(@nostd.any),
  )
}

///|
/// Assert element has role
/// Usage: expect(element)..toHaveRole("button")
#alias(to_have_role)
pub fn Expect::toHaveRole(
  self : Expect,
  role : String,
) -> Unit raise ExpectError {
  assert_matcher(self.element, "toHaveRole", [role].map(@nostd.any))
}

// ============================================================
// Containment Matchers
// ============================================================

///|
/// Assert element contains another element
/// Usage: expect(container)..toContainElement(child)
#alias(to_contain_element)
pub fn Expect::toContainElement(
  self : Expect,
  child : @dom.HTMLElement,
) -> Unit raise ExpectError {
  assert_matcher(self.element, "toContainElement", [child].map(@nostd.any))
}

///|
/// Assert element contains HTML
/// Usage: expect(container)..toContainHTML("<span>Hello</span>")
#alias(to_contain_html)
pub fn Expect::toContainHTML(
  self : Expect,
  html : String,
) -> Unit raise ExpectError {
  assert_matcher(self.element, "toContainHTML", [html].map(@nostd.any))
}
