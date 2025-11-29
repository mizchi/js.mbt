///|
/// TextMatch trait - allows String or RegExp to be used as text matchers
pub trait TextMatch {
  to_any(Self) -> @js.Any = _
}

///|
impl TextMatch with to_any(self) -> @js.Any {
  @js.identity(self)
}

///|
pub impl TextMatch for String

///|
pub impl TextMatch for @regexp.RegExp

///|
/// VueTestingLibrary.Screen
#external
pub type Screen

///|
pub impl @js.JsImpl for Screen

///|
/// JS: import { screen } from '@testing-library/vue'
pub fn screen() -> Screen {
  testing_library().get("screen").cast()
}

///|
pub fn Screen::debug(self : Self) -> Unit {
  self.call0("debug") |> ignore
}

///|
#external
pub type ScreenResult

///|
pub fn ScreenResult::as_element(self : ScreenResult) -> @dom.HTMLElement {
  @js.identity(self)
}

///|
fn[T : @js.JsImpl] set_opt(obj : @js.Any, key : String, val : T?) -> Bool {
  match val {
    Some(v) => {
      obj.set(key, v)
      true
    }
    None => false
  }
}

///|
fn to_options(obj : @js.Any, has_any : Bool) -> @js.Any? {
  if has_any {
    Some(obj)
  } else {
    None
  }
}

///|
fn build_matcher_options(
  exact? : Bool? = None,
  trim? : Bool? = None,
  collapse_whitespace? : Bool? = None,
) -> @js.Any? {
  let obj = @js.Object::new()
  let has = set_opt(obj, "exact", exact) ||
    set_opt(obj, "trim", trim) ||
    set_opt(obj, "collapseWhitespace", collapse_whitespace)
  to_options(obj, has)
}

///|
fn build_selector_matcher_options(
  exact? : Bool? = None,
  trim? : Bool? = None,
  collapse_whitespace? : Bool? = None,
  selector? : String? = None,
) -> @js.Any? {
  let obj = @js.Object::new()
  let has = set_opt(obj, "exact", exact) ||
    set_opt(obj, "trim", trim) ||
    set_opt(obj, "collapseWhitespace", collapse_whitespace) ||
    set_opt(obj, "selector", selector)
  to_options(obj, has)
}

///|
fn build_role_options(
  name? : String? = None,
  hidden? : Bool? = None,
  selected? : Bool? = None,
  checked? : Bool? = None,
  pressed? : Bool? = None,
  expanded? : Bool? = None,
  level? : Int? = None,
  description? : String? = None,
) -> @js.Any? {
  let obj = @js.Object::new()
  let has = set_opt(obj, "name", name) ||
    set_opt(obj, "hidden", hidden) ||
    set_opt(obj, "selected", selected) ||
    set_opt(obj, "checked", checked) ||
    set_opt(obj, "pressed", pressed) ||
    set_opt(obj, "expanded", expanded) ||
    set_opt(obj, "level", level) ||
    set_opt(obj, "description", description)
  to_options(obj, has)
}

///|
#alias(get_by_role)
pub fn Screen::getByRole(
  self : Screen,
  role : String,
  name? : String? = None,
  hidden? : Bool? = None,
  selected? : Bool? = None,
  checked? : Bool? = None,
  pressed? : Bool? = None,
  expanded? : Bool? = None,
  level? : Int? = None,
  description? : String? = None,
) -> ScreenResult {
  match
    build_role_options(
      name~,
      hidden~,
      selected~,
      checked~,
      pressed~,
      expanded~,
      level~,
      description~,
    ) {
    Some(opts) => self.call2("getByRole", role, opts).cast()
    None => self.call1("getByRole", role).cast()
  }
}

///|
#alias(get_by_label_text)
pub fn[T : TextMatch] Screen::getByLabelText(
  self : Screen,
  text : T,
  exact? : Bool? = None,
  trim? : Bool? = None,
  collapse_whitespace? : Bool? = None,
  selector? : String? = None,
) -> ScreenResult {
  let text_js = text.to_any()
  match
    build_selector_matcher_options(
      exact~,
      trim~,
      collapse_whitespace~,
      selector~,
    ) {
    Some(opts) => self.call2("getByLabelText", text_js, opts).cast()
    None => self.call1("getByLabelText", text_js).cast()
  }
}

///|
#alias(get_by_placeholder_text)
pub fn[T : TextMatch] Screen::getByPlaceholderText(
  self : Screen,
  text : T,
  exact? : Bool? = None,
  trim? : Bool? = None,
  collapse_whitespace? : Bool? = None,
) -> ScreenResult {
  let text_js = text.to_any()
  match build_matcher_options(exact~, trim~, collapse_whitespace~) {
    Some(opts) => self.call2("getByPlaceholderText", text_js, opts).cast()
    None => self.call1("getByPlaceholderText", text_js).cast()
  }
}

///|
#alias(get_by_text)
pub fn[T : TextMatch] Screen::getByText(
  self : Screen,
  text : T,
  exact? : Bool? = None,
  trim? : Bool? = None,
  collapse_whitespace? : Bool? = None,
  selector? : String? = None,
) -> ScreenResult {
  let text_js = text.to_any()
  match
    build_selector_matcher_options(
      exact~,
      trim~,
      collapse_whitespace~,
      selector~,
    ) {
    Some(opts) => self.call2("getByText", text_js, opts).cast()
    None => self.call1("getByText", text_js).cast()
  }
}

///|
#alias(get_by_display_value)
pub fn[T : TextMatch] Screen::getByDisplayValue(
  self : Screen,
  value : T,
  exact? : Bool? = None,
  trim? : Bool? = None,
  collapse_whitespace? : Bool? = None,
) -> ScreenResult {
  let value_js = value.to_any()
  match build_matcher_options(exact~, trim~, collapse_whitespace~) {
    Some(opts) => self.call2("getByDisplayValue", value_js, opts).cast()
    None => self.call1("getByDisplayValue", value_js).cast()
  }
}

///|
#alias(get_by_alt_text)
pub fn[T : TextMatch] Screen::getByAltText(
  self : Screen,
  text : T,
  exact? : Bool? = None,
  trim? : Bool? = None,
  collapse_whitespace? : Bool? = None,
) -> ScreenResult {
  let text_js = text.to_any()
  match build_matcher_options(exact~, trim~, collapse_whitespace~) {
    Some(opts) => self.call2("getByAltText", text_js, opts).cast()
    None => self.call1("getByAltText", text_js).cast()
  }
}

///|
#alias(get_by_title)
pub fn[T : TextMatch] Screen::getByTitle(
  self : Screen,
  title : T,
  exact? : Bool? = None,
  trim? : Bool? = None,
  collapse_whitespace? : Bool? = None,
) -> ScreenResult {
  let title_js = title.to_any()
  match build_matcher_options(exact~, trim~, collapse_whitespace~) {
    Some(opts) => self.call2("getByTitle", title_js, opts).cast()
    None => self.call1("getByTitle", title_js).cast()
  }
}

///|
#alias(get_by_test_id)
pub fn Screen::getByTestId(self : Screen, testId : String) -> ScreenResult {
  self.call1("getByTestId", testId).cast()
}

///|
#alias(get_all_by_role)
pub fn Screen::getAllByRole(
  self : Screen,
  role : String,
  name? : String? = None,
) -> Array[ScreenResult] {
  match build_role_options(name~) {
    Some(opts) => self.call2("getAllByRole", role, opts).cast()
    None => self.call1("getAllByRole", role).cast()
  }
}

///|
#alias(get_all_by_text)
pub fn[T : TextMatch] Screen::getAllByText(
  self : Screen,
  text : T,
) -> Array[ScreenResult] {
  self.call1("getAllByText", text.to_any()).cast()
}

///|
#alias(get_all_by_test_id)
pub fn Screen::getAllByTestId(
  self : Screen,
  testId : String,
) -> Array[ScreenResult] {
  self.call1("getAllByTestId", testId).cast()
}

///|
#alias(query_by_role)
pub fn Screen::queryByRole(
  self : Screen,
  role : String,
  name? : String? = None,
) -> ScreenResult? {
  match build_role_options(name~) {
    Some(opts) => @js.identity_option(self.call2("queryByRole", role, opts))
    None => @js.identity_option(self.call1("queryByRole", role))
  }
}

///|
#alias(query_by_text)
pub fn[T : TextMatch] Screen::queryByText(
  self : Screen,
  text : T,
) -> ScreenResult? {
  @js.identity_option(self.call1("queryByText", text.to_any()))
}

///|
#alias(query_by_test_id)
pub fn Screen::queryByTestId(self : Screen, testId : String) -> ScreenResult? {
  @js.identity_option(self.call1("queryByTestId", testId))
}

///|
#alias(query_all_by_role)
pub fn Screen::queryAllByRole(
  self : Screen,
  role : String,
  name? : String? = None,
) -> Array[ScreenResult] {
  match build_role_options(name~) {
    Some(opts) => self.call2("queryAllByRole", role, opts).cast()
    None => self.call1("queryAllByRole", role).cast()
  }
}

///|
#alias(query_all_by_text)
pub fn[T : TextMatch] Screen::queryAllByText(
  self : Screen,
  text : T,
) -> Array[ScreenResult] {
  self.call1("queryAllByText", text.to_any()).cast()
}

///|
#alias(query_all_by_test_id)
pub fn Screen::queryAllByTestId(
  self : Screen,
  testId : String,
) -> Array[ScreenResult] {
  self.call1("queryAllByTestId", testId).cast()
}

///|
#alias(find_by_text)
pub fn Screen::findByText(self : Screen, text : String) -> ScreenResult {
  self.call1("findByText", text).cast()
}

///|
#alias(find_by_role)
pub fn Screen::findByRole(self : Screen, role : String) -> ScreenResult {
  self.call1("findByRole", role).cast()
}

///|
#alias(find_by_test_id)
pub fn Screen::findByTestId(self : Screen, testId : String) -> ScreenResult {
  self.call1("findByTestId", testId).cast()
}

///|
#alias(find_all_by_role)
pub fn Screen::findAllByRole(
  self : Screen,
  role : String,
) -> Array[ScreenResult] {
  self.call1("findAllByRole", role).cast()
}

///|
#alias(find_all_by_text)
pub fn Screen::findAllByText(
  self : Screen,
  text : String,
) -> Array[ScreenResult] {
  self.call1("findAllByText", text).cast()
}

///|
#alias(find_all_by_test_id)
pub fn Screen::findAllByTestId(
  self : Screen,
  testId : String,
) -> Array[ScreenResult] {
  self.call1("findAllByTestId", testId).cast()
}
