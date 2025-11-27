///|
/// TextMatch trait - allows String or RegExp to be used as text matchers
/// This matches the TypeScript type: string | RegExp | ((content: string, element: Element) => boolean)
pub trait TextMatch {
  to_any(Self) -> @js.Any = _
}

///|
impl TextMatch with to_any(self) -> @js.Any {
  @js.identity(self)
}

///|
/// String implements TextMatch
pub impl TextMatch for String

///|
/// RegExp implements TextMatch
pub impl TextMatch for @regexp.RegExp

///|
/// PreactTestingLibrary.Screen
#external
pub type Screen

///|
pub impl @js.JsImpl for Screen

///|
/// JS: import { screen } from '@testing-library/preact'
pub fn screen() -> Screen {
  let rtl = testing_library()
  rtl.get("screen").cast()
}

///|
/// JS: screen.debug()
pub fn Screen::debug(self : Self) -> Unit {
  self.call0("debug") |> ignore
}

///|
/// Query Result Types - opaque wrapper around HTMLElement
#external
pub type ScreenResult

///|
pub fn ScreenResult::as_element(self : ScreenResult) -> @dom.HTMLElement {
  @js.identity(self)
}

///| getBy* queries - throw error if not found

///|
/// Helper to build MatcherOptions object for text-based queries
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
/// Helper to build SelectorMatcherOptions object for label queries
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
/// Helper to build ByRoleOptions object
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
/// JS: screen.getByRole(role, options?)
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
/// JS: screen.getByLabelText(text, options?)
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
/// JS: screen.getByPlaceholderText(text, options?)
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
/// JS: screen.getByText(text, options?)
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
/// JS: screen.getByDisplayValue(value, options?)
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
/// JS: screen.getByAltText(text, options?)
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
/// JS: screen.getByTitle(title, options?)
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
/// JS: screen.getByTestId(testId)
#alias(get_by_test_id)
pub fn Screen::getByTestId(self : Screen, testId : String) -> ScreenResult {
  self.call1("getByTestId", testId).cast()
}

///| queryBy* queries - return null if not found

///|
/// JS: screen.queryByRole(role, options?)
#alias(query_by_role)
pub fn Screen::queryByRole(
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
) -> ScreenResult? {
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
    Some(opts) => self.call2("queryByRole", role, opts).cast()
    None => self.call1("queryByRole", role).cast()
  }
}

///|
/// JS: screen.queryByLabelText(text, options?)
#alias(query_by_label_text)
pub fn[T : TextMatch] Screen::queryByLabelText(
  self : Screen,
  text : T,
  exact? : Bool? = None,
  trim? : Bool? = None,
  collapse_whitespace? : Bool? = None,
  selector? : String? = None,
) -> ScreenResult? {
  let text_js = text.to_any()
  match
    build_selector_matcher_options(
      exact~,
      trim~,
      collapse_whitespace~,
      selector~,
    ) {
    Some(opts) => self.call2("queryByLabelText", text_js, opts).cast()
    None => self.call1("queryByLabelText", text_js).cast()
  }
}

///|
/// JS: screen.queryByPlaceholderText(text, options?)
#alias(query_by_placeholder_text)
pub fn[T : TextMatch] Screen::queryByPlaceholderText(
  self : Screen,
  text : T,
  exact? : Bool? = None,
  trim? : Bool? = None,
  collapse_whitespace? : Bool? = None,
) -> ScreenResult? {
  let text_js = text.to_any()
  match build_matcher_options(exact~, trim~, collapse_whitespace~) {
    Some(opts) => self.call2("queryByPlaceholderText", text_js, opts).cast()
    None => self.call1("queryByPlaceholderText", text_js).cast()
  }
}

///|
/// JS: screen.queryByText(text, options?)
#alias(query_by_text)
pub fn[T : TextMatch] Screen::queryByText(
  self : Screen,
  text : T,
  exact? : Bool? = None,
  trim? : Bool? = None,
  collapse_whitespace? : Bool? = None,
  selector? : String? = None,
) -> ScreenResult? {
  let text_js = text.to_any()
  match
    build_selector_matcher_options(
      exact~,
      trim~,
      collapse_whitespace~,
      selector~,
    ) {
    Some(opts) => self.call2("queryByText", text_js, opts).cast()
    None => self.call1("queryByText", text_js).cast()
  }
}

///|
/// JS: screen.queryByDisplayValue(value, options?)
#alias(query_by_display_value)
pub fn[T : TextMatch] Screen::queryByDisplayValue(
  self : Screen,
  value : T,
  exact? : Bool? = None,
  trim? : Bool? = None,
  collapse_whitespace? : Bool? = None,
) -> ScreenResult? {
  let value_js = value.to_any()
  match build_matcher_options(exact~, trim~, collapse_whitespace~) {
    Some(opts) => self.call2("queryByDisplayValue", value_js, opts).cast()
    None => self.call1("queryByDisplayValue", value_js).cast()
  }
}

///|
/// JS: screen.queryByAltText(text, options?)
#alias(query_by_alt_text)
pub fn[T : TextMatch] Screen::queryByAltText(
  self : Screen,
  text : T,
  exact? : Bool? = None,
  trim? : Bool? = None,
  collapse_whitespace? : Bool? = None,
) -> ScreenResult? {
  let text_js = text.to_any()
  match build_matcher_options(exact~, trim~, collapse_whitespace~) {
    Some(opts) => self.call2("queryByAltText", text_js, opts).cast()
    None => self.call1("queryByAltText", text_js).cast()
  }
}

///|
/// JS: screen.queryByTitle(title, options?)
#alias(query_by_title)
pub fn[T : TextMatch] Screen::queryByTitle(
  self : Screen,
  title : T,
  exact? : Bool? = None,
  trim? : Bool? = None,
  collapse_whitespace? : Bool? = None,
) -> ScreenResult? {
  let title_js = title.to_any()
  match build_matcher_options(exact~, trim~, collapse_whitespace~) {
    Some(opts) => self.call2("queryByTitle", title_js, opts).cast()
    None => self.call1("queryByTitle", title_js).cast()
  }
}

///|
/// JS: screen.queryByTestId(testId)
#alias(query_by_test_id)
pub fn Screen::queryByTestId(self : Screen, testId : String) -> ScreenResult? {
  self.call1("queryByTestId", testId).cast()
}

///| findBy* queries - async, throw error if not found

///|
/// JS: screen.findByRole(role, options?)
#alias(find_by_role)
pub async fn Screen::findByRole(
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
  let promise : @js.Promise[ScreenResult] = match
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
    Some(opts) => self.call2("findByRole", role, opts).cast()
    None => self.call1("findByRole", role).cast()
  }
  promise.wait()
}

///|
/// JS: screen.findByLabelText(text, options?)
#alias(find_by_label_text)
pub async fn[T : TextMatch] Screen::findByLabelText(
  self : Screen,
  text : T,
  exact? : Bool? = None,
  trim? : Bool? = None,
  collapse_whitespace? : Bool? = None,
  selector? : String? = None,
) -> ScreenResult {
  let text_js = text.to_any()
  let promise : @js.Promise[ScreenResult] = match
    build_selector_matcher_options(
      exact~,
      trim~,
      collapse_whitespace~,
      selector~,
    ) {
    Some(opts) => self.call2("findByLabelText", text_js, opts).cast()
    None => self.call1("findByLabelText", text_js).cast()
  }
  promise.wait()
}

///|
/// JS: screen.findByPlaceholderText(text, options?)
#alias(find_by_placeholder_text)
pub async fn[T : TextMatch] Screen::findByPlaceholderText(
  self : Screen,
  text : T,
  exact? : Bool? = None,
  trim? : Bool? = None,
  collapse_whitespace? : Bool? = None,
) -> ScreenResult {
  let text_js = text.to_any()
  let promise : @js.Promise[ScreenResult] = match
    build_matcher_options(exact~, trim~, collapse_whitespace~) {
    Some(opts) => self.call2("findByPlaceholderText", text_js, opts).cast()
    None => self.call1("findByPlaceholderText", text_js).cast()
  }
  promise.wait()
}

///|
/// JS: screen.findByText(text, options?)
#alias(find_by_text)
pub async fn[T : TextMatch] Screen::findByText(
  self : Screen,
  text : T,
  exact? : Bool? = None,
  trim? : Bool? = None,
  collapse_whitespace? : Bool? = None,
  selector? : String? = None,
) -> ScreenResult {
  let text_js = text.to_any()
  let promise : @js.Promise[ScreenResult] = match
    build_selector_matcher_options(
      exact~,
      trim~,
      collapse_whitespace~,
      selector~,
    ) {
    Some(opts) => self.call2("findByText", text_js, opts).cast()
    None => self.call1("findByText", text_js).cast()
  }
  promise.wait()
}

///|
/// JS: screen.findByDisplayValue(value, options?)
#alias(find_by_display_value)
pub async fn[T : TextMatch] Screen::findByDisplayValue(
  self : Screen,
  value : T,
  exact? : Bool? = None,
  trim? : Bool? = None,
  collapse_whitespace? : Bool? = None,
) -> ScreenResult {
  let value_js = value.to_any()
  let promise : @js.Promise[ScreenResult] = match
    build_matcher_options(exact~, trim~, collapse_whitespace~) {
    Some(opts) => self.call2("findByDisplayValue", value_js, opts).cast()
    None => self.call1("findByDisplayValue", value_js).cast()
  }
  promise.wait()
}

///|
/// JS: screen.findByAltText(text, options?)
#alias(find_by_alt_text)
pub async fn[T : TextMatch] Screen::findByAltText(
  self : Screen,
  text : T,
  exact? : Bool? = None,
  trim? : Bool? = None,
  collapse_whitespace? : Bool? = None,
) -> ScreenResult {
  let text_js = text.to_any()
  let promise : @js.Promise[ScreenResult] = match
    build_matcher_options(exact~, trim~, collapse_whitespace~) {
    Some(opts) => self.call2("findByAltText", text_js, opts).cast()
    None => self.call1("findByAltText", text_js).cast()
  }
  promise.wait()
}

///|
/// JS: screen.findByTitle(title, options?)
#alias(find_by_title)
pub async fn[T : TextMatch] Screen::findByTitle(
  self : Screen,
  title : T,
  exact? : Bool? = None,
  trim? : Bool? = None,
  collapse_whitespace? : Bool? = None,
) -> ScreenResult {
  let title_js = title.to_any()
  let promise : @js.Promise[ScreenResult] = match
    build_matcher_options(exact~, trim~, collapse_whitespace~) {
    Some(opts) => self.call2("findByTitle", title_js, opts).cast()
    None => self.call1("findByTitle", title_js).cast()
  }
  promise.wait()
}

///|
/// JS: screen.findByTestId(testId)
#alias(find_by_test_id)
pub async fn Screen::findByTestId(
  self : Screen,
  testId : String,
) -> ScreenResult {
  let promise : @js.Promise[ScreenResult] = self
    .call1("findByTestId", testId)
    .cast()
  promise.wait()
}

///| getAllBy* queries - return array, throw if not found

///|
/// JS: screen.getAllByRole(role, options?)
#alias(get_all_by_role)
pub fn Screen::getAllByRole(
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
) -> Array[ScreenResult] {
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
    Some(opts) => self.call2("getAllByRole", role, opts).cast()
    None => self.call1("getAllByRole", role).cast()
  }
}

///|
/// JS: screen.getAllByLabelText(text, options?)
#alias(get_all_by_label_text)
pub fn[T : TextMatch] Screen::getAllByLabelText(
  self : Screen,
  text : T,
  exact? : Bool? = None,
  trim? : Bool? = None,
  collapse_whitespace? : Bool? = None,
  selector? : String? = None,
) -> Array[ScreenResult] {
  let text_js = text.to_any()
  match
    build_selector_matcher_options(
      exact~,
      trim~,
      collapse_whitespace~,
      selector~,
    ) {
    Some(opts) => self.call2("getAllByLabelText", text_js, opts).cast()
    None => self.call1("getAllByLabelText", text_js).cast()
  }
}

///|
/// JS: screen.getAllByPlaceholderText(text, options?)
#alias(get_all_by_placeholder_text)
pub fn[T : TextMatch] Screen::getAllByPlaceholderText(
  self : Screen,
  text : T,
  exact? : Bool? = None,
  trim? : Bool? = None,
  collapse_whitespace? : Bool? = None,
) -> Array[ScreenResult] {
  let text_js = text.to_any()
  match build_matcher_options(exact~, trim~, collapse_whitespace~) {
    Some(opts) => self.call2("getAllByPlaceholderText", text_js, opts).cast()
    None => self.call1("getAllByPlaceholderText", text_js).cast()
  }
}

///|
/// JS: screen.getAllByText(text, options?)
#alias(get_all_by_text)
pub fn[T : TextMatch] Screen::getAllByText(
  self : Screen,
  text : T,
  exact? : Bool? = None,
  trim? : Bool? = None,
  collapse_whitespace? : Bool? = None,
  selector? : String? = None,
) -> Array[ScreenResult] {
  let text_js = text.to_any()
  match
    build_selector_matcher_options(
      exact~,
      trim~,
      collapse_whitespace~,
      selector~,
    ) {
    Some(opts) => self.call2("getAllByText", text_js, opts).cast()
    None => self.call1("getAllByText", text_js).cast()
  }
}

///|
/// JS: screen.getAllByDisplayValue(value, options?)
#alias(get_all_by_display_value)
pub fn[T : TextMatch] Screen::getAllByDisplayValue(
  self : Screen,
  value : T,
  exact? : Bool? = None,
  trim? : Bool? = None,
  collapse_whitespace? : Bool? = None,
) -> Array[ScreenResult] {
  let value_js = value.to_any()
  match build_matcher_options(exact~, trim~, collapse_whitespace~) {
    Some(opts) => self.call2("getAllByDisplayValue", value_js, opts).cast()
    None => self.call1("getAllByDisplayValue", value_js).cast()
  }
}

///|
/// JS: screen.getAllByAltText(text, options?)
#alias(get_all_by_alt_text)
pub fn[T : TextMatch] Screen::getAllByAltText(
  self : Screen,
  text : T,
  exact? : Bool? = None,
  trim? : Bool? = None,
  collapse_whitespace? : Bool? = None,
) -> Array[ScreenResult] {
  let text_js = text.to_any()
  match build_matcher_options(exact~, trim~, collapse_whitespace~) {
    Some(opts) => self.call2("getAllByAltText", text_js, opts).cast()
    None => self.call1("getAllByAltText", text_js).cast()
  }
}

///|
/// JS: screen.getAllByTitle(title, options?)
#alias(get_all_by_title)
pub fn[T : TextMatch] Screen::getAllByTitle(
  self : Screen,
  title : T,
  exact? : Bool? = None,
  trim? : Bool? = None,
  collapse_whitespace? : Bool? = None,
) -> Array[ScreenResult] {
  let title_js = title.to_any()
  match build_matcher_options(exact~, trim~, collapse_whitespace~) {
    Some(opts) => self.call2("getAllByTitle", title_js, opts).cast()
    None => self.call1("getAllByTitle", title_js).cast()
  }
}

///|
/// JS: screen.getAllByTestId(testId)
#alias(get_all_by_test_id)
pub fn Screen::getAllByTestId(
  self : Screen,
  testId : String,
) -> Array[ScreenResult] {
  self.call1("getAllByTestId", testId).cast()
}

///| queryAllBy* queries - return array, empty if not found

///|
/// JS: screen.queryAllByRole(role, options?)
#alias(query_all_by_role)
pub fn Screen::queryAllByRole(
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
) -> Array[ScreenResult] {
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
    Some(opts) => self.call2("queryAllByRole", role, opts).cast()
    None => self.call1("queryAllByRole", role).cast()
  }
}

///|
/// JS: screen.queryAllByLabelText(text, options?)
#alias(query_all_by_label_text)
pub fn[T : TextMatch] Screen::queryAllByLabelText(
  self : Screen,
  text : T,
  exact? : Bool? = None,
  trim? : Bool? = None,
  collapse_whitespace? : Bool? = None,
  selector? : String? = None,
) -> Array[ScreenResult] {
  let text_js = text.to_any()
  match
    build_selector_matcher_options(
      exact~,
      trim~,
      collapse_whitespace~,
      selector~,
    ) {
    Some(opts) => self.call2("queryAllByLabelText", text_js, opts).cast()
    None => self.call1("queryAllByLabelText", text_js).cast()
  }
}

///|
/// JS: screen.queryAllByPlaceholderText(text, options?)
#alias(query_all_by_placeholder_text)
pub fn[T : TextMatch] Screen::queryAllByPlaceholderText(
  self : Screen,
  text : T,
  exact? : Bool? = None,
  trim? : Bool? = None,
  collapse_whitespace? : Bool? = None,
) -> Array[ScreenResult] {
  let text_js = text.to_any()
  match build_matcher_options(exact~, trim~, collapse_whitespace~) {
    Some(opts) => self.call2("queryAllByPlaceholderText", text_js, opts).cast()
    None => self.call1("queryAllByPlaceholderText", text_js).cast()
  }
}

///|
/// JS: screen.queryAllByText(text, options?)
#alias(query_all_by_text)
pub fn[T : TextMatch] Screen::queryAllByText(
  self : Screen,
  text : T,
  exact? : Bool? = None,
  trim? : Bool? = None,
  collapse_whitespace? : Bool? = None,
  selector? : String? = None,
) -> Array[ScreenResult] {
  let text_js = text.to_any()
  match
    build_selector_matcher_options(
      exact~,
      trim~,
      collapse_whitespace~,
      selector~,
    ) {
    Some(opts) => self.call2("queryAllByText", text_js, opts).cast()
    None => self.call1("queryAllByText", text_js).cast()
  }
}

///|
/// JS: screen.queryAllByDisplayValue(value, options?)
#alias(query_all_by_display_value)
pub fn[T : TextMatch] Screen::queryAllByDisplayValue(
  self : Screen,
  value : T,
  exact? : Bool? = None,
  trim? : Bool? = None,
  collapse_whitespace? : Bool? = None,
) -> Array[ScreenResult] {
  let value_js = value.to_any()
  match build_matcher_options(exact~, trim~, collapse_whitespace~) {
    Some(opts) => self.call2("queryAllByDisplayValue", value_js, opts).cast()
    None => self.call1("queryAllByDisplayValue", value_js).cast()
  }
}

///|
/// JS: screen.queryAllByAltText(text, options?)
#alias(query_all_by_alt_text)
pub fn[T : TextMatch] Screen::queryAllByAltText(
  self : Screen,
  text : T,
  exact? : Bool? = None,
  trim? : Bool? = None,
  collapse_whitespace? : Bool? = None,
) -> Array[ScreenResult] {
  let text_js = text.to_any()
  match build_matcher_options(exact~, trim~, collapse_whitespace~) {
    Some(opts) => self.call2("queryAllByAltText", text_js, opts).cast()
    None => self.call1("queryAllByAltText", text_js).cast()
  }
}

///|
/// JS: screen.queryAllByTitle(title, options?)
#alias(query_all_by_title)
pub fn[T : TextMatch] Screen::queryAllByTitle(
  self : Screen,
  title : T,
  exact? : Bool? = None,
  trim? : Bool? = None,
  collapse_whitespace? : Bool? = None,
) -> Array[ScreenResult] {
  let title_js = title.to_any()
  match build_matcher_options(exact~, trim~, collapse_whitespace~) {
    Some(opts) => self.call2("queryAllByTitle", title_js, opts).cast()
    None => self.call1("queryAllByTitle", title_js).cast()
  }
}

///|
/// JS: screen.queryAllByTestId(testId)
#alias(query_all_by_test_id)
pub fn Screen::queryAllByTestId(
  self : Screen,
  testId : String,
) -> Array[ScreenResult] {
  self.call1("queryAllByTestId", testId).cast()
}

///| findAllBy* queries - async, return array

///|
/// JS: screen.findAllByRole(role, options?)
#alias(find_all_by_role)
pub async fn Screen::findAllByRole(
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
) -> Array[ScreenResult] {
  let promise : @js.Promise[Array[ScreenResult]] = match
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
    Some(opts) => self.call2("findAllByRole", role, opts).cast()
    None => self.call1("findAllByRole", role).cast()
  }
  promise.wait()
}

///|
/// JS: screen.findAllByLabelText(text, options?)
#alias(find_all_by_label_text)
pub async fn[T : TextMatch] Screen::findAllByLabelText(
  self : Screen,
  text : T,
  exact? : Bool? = None,
  trim? : Bool? = None,
  collapse_whitespace? : Bool? = None,
  selector? : String? = None,
) -> Array[ScreenResult] {
  let text_js = text.to_any()
  let promise : @js.Promise[Array[ScreenResult]] = match
    build_selector_matcher_options(
      exact~,
      trim~,
      collapse_whitespace~,
      selector~,
    ) {
    Some(opts) => self.call2("findAllByLabelText", text_js, opts).cast()
    None => self.call1("findAllByLabelText", text_js).cast()
  }
  promise.wait()
}

///|
/// JS: screen.findAllByPlaceholderText(text, options?)
#alias(find_all_by_placeholder_text)
pub async fn[T : TextMatch] Screen::findAllByPlaceholderText(
  self : Screen,
  text : T,
  exact? : Bool? = None,
  trim? : Bool? = None,
  collapse_whitespace? : Bool? = None,
) -> Array[ScreenResult] {
  let text_js = text.to_any()
  let promise : @js.Promise[Array[ScreenResult]] = match
    build_matcher_options(exact~, trim~, collapse_whitespace~) {
    Some(opts) => self.call2("findAllByPlaceholderText", text_js, opts).cast()
    None => self.call1("findAllByPlaceholderText", text_js).cast()
  }
  promise.wait()
}

///|
/// JS: screen.findAllByText(text, options?)
#alias(find_all_by_text)
pub async fn[T : TextMatch] Screen::findAllByText(
  self : Screen,
  text : T,
  exact? : Bool? = None,
  trim? : Bool? = None,
  collapse_whitespace? : Bool? = None,
  selector? : String? = None,
) -> Array[ScreenResult] {
  let text_js = text.to_any()
  let promise : @js.Promise[Array[ScreenResult]] = match
    build_selector_matcher_options(
      exact~,
      trim~,
      collapse_whitespace~,
      selector~,
    ) {
    Some(opts) => self.call2("findAllByText", text_js, opts).cast()
    None => self.call1("findAllByText", text_js).cast()
  }
  promise.wait()
}

///|
/// JS: screen.findAllByDisplayValue(value, options?)
#alias(find_all_by_display_value)
pub async fn[T : TextMatch] Screen::findAllByDisplayValue(
  self : Screen,
  value : T,
  exact? : Bool? = None,
  trim? : Bool? = None,
  collapse_whitespace? : Bool? = None,
) -> Array[ScreenResult] {
  let value_js = value.to_any()
  let promise : @js.Promise[Array[ScreenResult]] = match
    build_matcher_options(exact~, trim~, collapse_whitespace~) {
    Some(opts) => self.call2("findAllByDisplayValue", value_js, opts).cast()
    None => self.call1("findAllByDisplayValue", value_js).cast()
  }
  promise.wait()
}

///|
/// JS: screen.findAllByAltText(text, options?)
#alias(find_all_by_alt_text)
pub async fn[T : TextMatch] Screen::findAllByAltText(
  self : Screen,
  text : T,
  exact? : Bool? = None,
  trim? : Bool? = None,
  collapse_whitespace? : Bool? = None,
) -> Array[ScreenResult] {
  let text_js = text.to_any()
  let promise : @js.Promise[Array[ScreenResult]] = match
    build_matcher_options(exact~, trim~, collapse_whitespace~) {
    Some(opts) => self.call2("findAllByAltText", text_js, opts).cast()
    None => self.call1("findAllByAltText", text_js).cast()
  }
  promise.wait()
}

///|
/// JS: screen.findAllByTitle(title, options?)
#alias(find_all_by_title)
pub async fn[T : TextMatch] Screen::findAllByTitle(
  self : Screen,
  title : T,
  exact? : Bool? = None,
  trim? : Bool? = None,
  collapse_whitespace? : Bool? = None,
) -> Array[ScreenResult] {
  let title_js = title.to_any()
  let promise : @js.Promise[Array[ScreenResult]] = match
    build_matcher_options(exact~, trim~, collapse_whitespace~) {
    Some(opts) => self.call2("findAllByTitle", title_js, opts).cast()
    None => self.call1("findAllByTitle", title_js).cast()
  }
  promise.wait()
}

///|
/// JS: screen.findAllByTestId(testId)
#alias(find_all_by_test_id)
pub async fn Screen::findAllByTestId(
  self : Screen,
  testId : String,
) -> Array[ScreenResult] {
  let promise : @js.Promise[Array[ScreenResult]] = self
    .call1("findAllByTestId", testId)
    .cast()
  promise.wait()
}
