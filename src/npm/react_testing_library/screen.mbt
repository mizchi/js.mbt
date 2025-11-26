///|
/// ReactTestingLibrary.Screen
#external
pub type Screen

///|
pub impl @js.JsImpl for Screen

///|
/// JS: import { screen } from '@testing-library/react'
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
/// Query Result Types
pub type ScreenResult = @dom.HTMLElement

///|
pub type ScreenResults = Array[@dom.HTMLElement]

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
pub fn Screen::getByLabelText(
  self : Screen,
  text : String,
  exact? : Bool? = None,
  trim? : Bool? = None,
  collapse_whitespace? : Bool? = None,
  selector? : String? = None,
) -> ScreenResult {
  match
    build_selector_matcher_options(
      exact~,
      trim~,
      collapse_whitespace~,
      selector~,
    ) {
    Some(opts) => self.call2("getByLabelText", text, opts).cast()
    None => self.call1("getByLabelText", text).cast()
  }
}

///|
/// JS: screen.getByPlaceholderText(text, options?)
pub fn Screen::getByPlaceholderText(
  self : Screen,
  text : String,
  exact? : Bool? = None,
  trim? : Bool? = None,
  collapse_whitespace? : Bool? = None,
) -> ScreenResult {
  match build_matcher_options(exact~, trim~, collapse_whitespace~) {
    Some(opts) => self.call2("getByPlaceholderText", text, opts).cast()
    None => self.call1("getByPlaceholderText", text).cast()
  }
}

///|
/// JS: screen.getByText(text, options?)
pub fn Screen::getByText(
  self : Screen,
  text : String,
  exact? : Bool? = None,
  trim? : Bool? = None,
  collapse_whitespace? : Bool? = None,
  selector? : String? = None,
) -> ScreenResult {
  match
    build_selector_matcher_options(
      exact~,
      trim~,
      collapse_whitespace~,
      selector~,
    ) {
    Some(opts) => self.call2("getByText", text, opts).cast()
    None => self.call1("getByText", text).cast()
  }
}

///|
/// JS: screen.getByDisplayValue(value, options?)
pub fn Screen::getByDisplayValue(
  self : Screen,
  value : String,
  exact? : Bool? = None,
  trim? : Bool? = None,
  collapse_whitespace? : Bool? = None,
) -> ScreenResult {
  match build_matcher_options(exact~, trim~, collapse_whitespace~) {
    Some(opts) => self.call2("getByDisplayValue", value, opts).cast()
    None => self.call1("getByDisplayValue", value).cast()
  }
}

///|
/// JS: screen.getByAltText(text, options?)
pub fn Screen::getByAltText(
  self : Screen,
  text : String,
  exact? : Bool? = None,
  trim? : Bool? = None,
  collapse_whitespace? : Bool? = None,
) -> ScreenResult {
  match build_matcher_options(exact~, trim~, collapse_whitespace~) {
    Some(opts) => self.call2("getByAltText", text, opts).cast()
    None => self.call1("getByAltText", text).cast()
  }
}

///|
/// JS: screen.getByTitle(title, options?)
pub fn Screen::getByTitle(
  self : Screen,
  title : String,
  exact? : Bool? = None,
  trim? : Bool? = None,
  collapse_whitespace? : Bool? = None,
) -> ScreenResult {
  match build_matcher_options(exact~, trim~, collapse_whitespace~) {
    Some(opts) => self.call2("getByTitle", title, opts).cast()
    None => self.call1("getByTitle", title).cast()
  }
}

///|
/// JS: screen.getByTestId(testId)
pub fn Screen::getByTestId(self : Screen, testId : String) -> ScreenResult {
  self.call1("getByTestId", testId).cast()
}

///| queryBy* queries - return null if not found

///|
/// JS: screen.queryByRole(role, options?)
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
pub fn Screen::queryByLabelText(
  self : Screen,
  text : String,
  exact? : Bool? = None,
  trim? : Bool? = None,
  collapse_whitespace? : Bool? = None,
  selector? : String? = None,
) -> ScreenResult? {
  match
    build_selector_matcher_options(
      exact~,
      trim~,
      collapse_whitespace~,
      selector~,
    ) {
    Some(opts) => self.call2("queryByLabelText", text, opts).cast()
    None => self.call1("queryByLabelText", text).cast()
  }
}

///|
/// JS: screen.queryByPlaceholderText(text, options?)
pub fn Screen::queryByPlaceholderText(
  self : Screen,
  text : String,
  exact? : Bool? = None,
  trim? : Bool? = None,
  collapse_whitespace? : Bool? = None,
) -> ScreenResult? {
  match build_matcher_options(exact~, trim~, collapse_whitespace~) {
    Some(opts) => self.call2("queryByPlaceholderText", text, opts).cast()
    None => self.call1("queryByPlaceholderText", text).cast()
  }
}

///|
/// JS: screen.queryByText(text, options?)
pub fn Screen::queryByText(
  self : Screen,
  text : String,
  exact? : Bool? = None,
  trim? : Bool? = None,
  collapse_whitespace? : Bool? = None,
  selector? : String? = None,
) -> ScreenResult? {
  match
    build_selector_matcher_options(
      exact~,
      trim~,
      collapse_whitespace~,
      selector~,
    ) {
    Some(opts) => self.call2("queryByText", text, opts).cast()
    None => self.call1("queryByText", text).cast()
  }
}

///|
/// JS: screen.queryByDisplayValue(value, options?)
pub fn Screen::queryByDisplayValue(
  self : Screen,
  value : String,
  exact? : Bool? = None,
  trim? : Bool? = None,
  collapse_whitespace? : Bool? = None,
) -> ScreenResult? {
  match build_matcher_options(exact~, trim~, collapse_whitespace~) {
    Some(opts) => self.call2("queryByDisplayValue", value, opts).cast()
    None => self.call1("queryByDisplayValue", value).cast()
  }
}

///|
/// JS: screen.queryByAltText(text, options?)
pub fn Screen::queryByAltText(
  self : Screen,
  text : String,
  exact? : Bool? = None,
  trim? : Bool? = None,
  collapse_whitespace? : Bool? = None,
) -> ScreenResult? {
  match build_matcher_options(exact~, trim~, collapse_whitespace~) {
    Some(opts) => self.call2("queryByAltText", text, opts).cast()
    None => self.call1("queryByAltText", text).cast()
  }
}

///|
/// JS: screen.queryByTitle(title, options?)
pub fn Screen::queryByTitle(
  self : Screen,
  title : String,
  exact? : Bool? = None,
  trim? : Bool? = None,
  collapse_whitespace? : Bool? = None,
) -> ScreenResult? {
  match build_matcher_options(exact~, trim~, collapse_whitespace~) {
    Some(opts) => self.call2("queryByTitle", title, opts).cast()
    None => self.call1("queryByTitle", title).cast()
  }
}

///|
/// JS: screen.queryByTestId(testId)
pub fn Screen::queryByTestId(self : Screen, testId : String) -> ScreenResult? {
  self.call1("queryByTestId", testId).cast()
}

///| findBy* queries - async, throw error if not found

///|
/// JS: screen.findByRole(role, options?)
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
pub async fn Screen::findByLabelText(
  self : Screen,
  text : String,
  exact? : Bool? = None,
  trim? : Bool? = None,
  collapse_whitespace? : Bool? = None,
  selector? : String? = None,
) -> ScreenResult {
  let promise : @js.Promise[ScreenResult] = match
    build_selector_matcher_options(
      exact~,
      trim~,
      collapse_whitespace~,
      selector~,
    ) {
    Some(opts) => self.call2("findByLabelText", text, opts).cast()
    None => self.call1("findByLabelText", text).cast()
  }
  promise.wait()
}

///|
/// JS: screen.findByPlaceholderText(text, options?)
pub async fn Screen::findByPlaceholderText(
  self : Screen,
  text : String,
  exact? : Bool? = None,
  trim? : Bool? = None,
  collapse_whitespace? : Bool? = None,
) -> ScreenResult {
  let promise : @js.Promise[ScreenResult] = match
    build_matcher_options(exact~, trim~, collapse_whitespace~) {
    Some(opts) => self.call2("findByPlaceholderText", text, opts).cast()
    None => self.call1("findByPlaceholderText", text).cast()
  }
  promise.wait()
}

///|
/// JS: screen.findByText(text, options?)
pub async fn Screen::findByText(
  self : Screen,
  text : String,
  exact? : Bool? = None,
  trim? : Bool? = None,
  collapse_whitespace? : Bool? = None,
  selector? : String? = None,
) -> ScreenResult {
  let promise : @js.Promise[ScreenResult] = match
    build_selector_matcher_options(
      exact~,
      trim~,
      collapse_whitespace~,
      selector~,
    ) {
    Some(opts) => self.call2("findByText", text, opts).cast()
    None => self.call1("findByText", text).cast()
  }
  promise.wait()
}

///|
/// JS: screen.findByDisplayValue(value, options?)
pub async fn Screen::findByDisplayValue(
  self : Screen,
  value : String,
  exact? : Bool? = None,
  trim? : Bool? = None,
  collapse_whitespace? : Bool? = None,
) -> ScreenResult {
  let promise : @js.Promise[ScreenResult] = match
    build_matcher_options(exact~, trim~, collapse_whitespace~) {
    Some(opts) => self.call2("findByDisplayValue", value, opts).cast()
    None => self.call1("findByDisplayValue", value).cast()
  }
  promise.wait()
}

///|
/// JS: screen.findByAltText(text, options?)
pub async fn Screen::findByAltText(
  self : Screen,
  text : String,
  exact? : Bool? = None,
  trim? : Bool? = None,
  collapse_whitespace? : Bool? = None,
) -> ScreenResult {
  let promise : @js.Promise[ScreenResult] = match
    build_matcher_options(exact~, trim~, collapse_whitespace~) {
    Some(opts) => self.call2("findByAltText", text, opts).cast()
    None => self.call1("findByAltText", text).cast()
  }
  promise.wait()
}

///|
/// JS: screen.findByTitle(title, options?)
pub async fn Screen::findByTitle(
  self : Screen,
  title : String,
  exact? : Bool? = None,
  trim? : Bool? = None,
  collapse_whitespace? : Bool? = None,
) -> ScreenResult {
  let promise : @js.Promise[ScreenResult] = match
    build_matcher_options(exact~, trim~, collapse_whitespace~) {
    Some(opts) => self.call2("findByTitle", title, opts).cast()
    None => self.call1("findByTitle", title).cast()
  }
  promise.wait()
}

///|
/// JS: screen.findByTestId(testId)
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
) -> ScreenResults {
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
pub fn Screen::getAllByLabelText(
  self : Screen,
  text : String,
  exact? : Bool? = None,
  trim? : Bool? = None,
  collapse_whitespace? : Bool? = None,
  selector? : String? = None,
) -> ScreenResults {
  match
    build_selector_matcher_options(
      exact~,
      trim~,
      collapse_whitespace~,
      selector~,
    ) {
    Some(opts) => self.call2("getAllByLabelText", text, opts).cast()
    None => self.call1("getAllByLabelText", text).cast()
  }
}

///|
/// JS: screen.getAllByPlaceholderText(text, options?)
pub fn Screen::getAllByPlaceholderText(
  self : Screen,
  text : String,
  exact? : Bool? = None,
  trim? : Bool? = None,
  collapse_whitespace? : Bool? = None,
) -> ScreenResults {
  match build_matcher_options(exact~, trim~, collapse_whitespace~) {
    Some(opts) => self.call2("getAllByPlaceholderText", text, opts).cast()
    None => self.call1("getAllByPlaceholderText", text).cast()
  }
}

///|
/// JS: screen.getAllByText(text, options?)
pub fn Screen::getAllByText(
  self : Screen,
  text : String,
  exact? : Bool? = None,
  trim? : Bool? = None,
  collapse_whitespace? : Bool? = None,
  selector? : String? = None,
) -> ScreenResults {
  match
    build_selector_matcher_options(
      exact~,
      trim~,
      collapse_whitespace~,
      selector~,
    ) {
    Some(opts) => self.call2("getAllByText", text, opts).cast()
    None => self.call1("getAllByText", text).cast()
  }
}

///|
/// JS: screen.getAllByDisplayValue(value, options?)
pub fn Screen::getAllByDisplayValue(
  self : Screen,
  value : String,
  exact? : Bool? = None,
  trim? : Bool? = None,
  collapse_whitespace? : Bool? = None,
) -> ScreenResults {
  match build_matcher_options(exact~, trim~, collapse_whitespace~) {
    Some(opts) => self.call2("getAllByDisplayValue", value, opts).cast()
    None => self.call1("getAllByDisplayValue", value).cast()
  }
}

///|
/// JS: screen.getAllByAltText(text, options?)
pub fn Screen::getAllByAltText(
  self : Screen,
  text : String,
  exact? : Bool? = None,
  trim? : Bool? = None,
  collapse_whitespace? : Bool? = None,
) -> ScreenResults {
  match build_matcher_options(exact~, trim~, collapse_whitespace~) {
    Some(opts) => self.call2("getAllByAltText", text, opts).cast()
    None => self.call1("getAllByAltText", text).cast()
  }
}

///|
/// JS: screen.getAllByTitle(title, options?)
pub fn Screen::getAllByTitle(
  self : Screen,
  title : String,
  exact? : Bool? = None,
  trim? : Bool? = None,
  collapse_whitespace? : Bool? = None,
) -> ScreenResults {
  match build_matcher_options(exact~, trim~, collapse_whitespace~) {
    Some(opts) => self.call2("getAllByTitle", title, opts).cast()
    None => self.call1("getAllByTitle", title).cast()
  }
}

///|
/// JS: screen.getAllByTestId(testId)
pub fn Screen::getAllByTestId(self : Screen, testId : String) -> ScreenResults {
  self.call1("getAllByTestId", testId).cast()
}

///| queryAllBy* queries - return array, empty if not found

///|
/// JS: screen.queryAllByRole(role, options?)
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
) -> ScreenResults {
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
pub fn Screen::queryAllByLabelText(
  self : Screen,
  text : String,
  exact? : Bool? = None,
  trim? : Bool? = None,
  collapse_whitespace? : Bool? = None,
  selector? : String? = None,
) -> ScreenResults {
  match
    build_selector_matcher_options(
      exact~,
      trim~,
      collapse_whitespace~,
      selector~,
    ) {
    Some(opts) => self.call2("queryAllByLabelText", text, opts).cast()
    None => self.call1("queryAllByLabelText", text).cast()
  }
}

///|
/// JS: screen.queryAllByPlaceholderText(text, options?)
pub fn Screen::queryAllByPlaceholderText(
  self : Screen,
  text : String,
  exact? : Bool? = None,
  trim? : Bool? = None,
  collapse_whitespace? : Bool? = None,
) -> ScreenResults {
  match build_matcher_options(exact~, trim~, collapse_whitespace~) {
    Some(opts) => self.call2("queryAllByPlaceholderText", text, opts).cast()
    None => self.call1("queryAllByPlaceholderText", text).cast()
  }
}

///|
/// JS: screen.queryAllByText(text, options?)
pub fn Screen::queryAllByText(
  self : Screen,
  text : String,
  exact? : Bool? = None,
  trim? : Bool? = None,
  collapse_whitespace? : Bool? = None,
  selector? : String? = None,
) -> ScreenResults {
  match
    build_selector_matcher_options(
      exact~,
      trim~,
      collapse_whitespace~,
      selector~,
    ) {
    Some(opts) => self.call2("queryAllByText", text, opts).cast()
    None => self.call1("queryAllByText", text).cast()
  }
}

///|
/// JS: screen.queryAllByDisplayValue(value, options?)
pub fn Screen::queryAllByDisplayValue(
  self : Screen,
  value : String,
  exact? : Bool? = None,
  trim? : Bool? = None,
  collapse_whitespace? : Bool? = None,
) -> ScreenResults {
  match build_matcher_options(exact~, trim~, collapse_whitespace~) {
    Some(opts) => self.call2("queryAllByDisplayValue", value, opts).cast()
    None => self.call1("queryAllByDisplayValue", value).cast()
  }
}

///|
/// JS: screen.queryAllByAltText(text, options?)
pub fn Screen::queryAllByAltText(
  self : Screen,
  text : String,
  exact? : Bool? = None,
  trim? : Bool? = None,
  collapse_whitespace? : Bool? = None,
) -> ScreenResults {
  match build_matcher_options(exact~, trim~, collapse_whitespace~) {
    Some(opts) => self.call2("queryAllByAltText", text, opts).cast()
    None => self.call1("queryAllByAltText", text).cast()
  }
}

///|
/// JS: screen.queryAllByTitle(title, options?)
pub fn Screen::queryAllByTitle(
  self : Screen,
  title : String,
  exact? : Bool? = None,
  trim? : Bool? = None,
  collapse_whitespace? : Bool? = None,
) -> ScreenResults {
  match build_matcher_options(exact~, trim~, collapse_whitespace~) {
    Some(opts) => self.call2("queryAllByTitle", title, opts).cast()
    None => self.call1("queryAllByTitle", title).cast()
  }
}

///|
/// JS: screen.queryAllByTestId(testId)
pub fn Screen::queryAllByTestId(
  self : Screen,
  testId : String,
) -> ScreenResults {
  self.call1("queryAllByTestId", testId).cast()
}

///| findAllBy* queries - async, return array

///|
/// JS: screen.findAllByRole(role, options?)
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
) -> ScreenResults {
  let promise : @js.Promise[ScreenResults] = match
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
pub async fn Screen::findAllByLabelText(
  self : Screen,
  text : String,
  exact? : Bool? = None,
  trim? : Bool? = None,
  collapse_whitespace? : Bool? = None,
  selector? : String? = None,
) -> ScreenResults {
  let promise : @js.Promise[ScreenResults] = match
    build_selector_matcher_options(
      exact~,
      trim~,
      collapse_whitespace~,
      selector~,
    ) {
    Some(opts) => self.call2("findAllByLabelText", text, opts).cast()
    None => self.call1("findAllByLabelText", text).cast()
  }
  promise.wait()
}

///|
/// JS: screen.findAllByPlaceholderText(text, options?)
pub async fn Screen::findAllByPlaceholderText(
  self : Screen,
  text : String,
  exact? : Bool? = None,
  trim? : Bool? = None,
  collapse_whitespace? : Bool? = None,
) -> ScreenResults {
  let promise : @js.Promise[ScreenResults] = match
    build_matcher_options(exact~, trim~, collapse_whitespace~) {
    Some(opts) => self.call2("findAllByPlaceholderText", text, opts).cast()
    None => self.call1("findAllByPlaceholderText", text).cast()
  }
  promise.wait()
}

///|
/// JS: screen.findAllByText(text, options?)
pub async fn Screen::findAllByText(
  self : Screen,
  text : String,
  exact? : Bool? = None,
  trim? : Bool? = None,
  collapse_whitespace? : Bool? = None,
  selector? : String? = None,
) -> ScreenResults {
  let promise : @js.Promise[ScreenResults] = match
    build_selector_matcher_options(
      exact~,
      trim~,
      collapse_whitespace~,
      selector~,
    ) {
    Some(opts) => self.call2("findAllByText", text, opts).cast()
    None => self.call1("findAllByText", text).cast()
  }
  promise.wait()
}

///|
/// JS: screen.findAllByDisplayValue(value, options?)
pub async fn Screen::findAllByDisplayValue(
  self : Screen,
  value : String,
  exact? : Bool? = None,
  trim? : Bool? = None,
  collapse_whitespace? : Bool? = None,
) -> ScreenResults {
  let promise : @js.Promise[ScreenResults] = match
    build_matcher_options(exact~, trim~, collapse_whitespace~) {
    Some(opts) => self.call2("findAllByDisplayValue", value, opts).cast()
    None => self.call1("findAllByDisplayValue", value).cast()
  }
  promise.wait()
}

///|
/// JS: screen.findAllByAltText(text, options?)
pub async fn Screen::findAllByAltText(
  self : Screen,
  text : String,
  exact? : Bool? = None,
  trim? : Bool? = None,
  collapse_whitespace? : Bool? = None,
) -> ScreenResults {
  let promise : @js.Promise[ScreenResults] = match
    build_matcher_options(exact~, trim~, collapse_whitespace~) {
    Some(opts) => self.call2("findAllByAltText", text, opts).cast()
    None => self.call1("findAllByAltText", text).cast()
  }
  promise.wait()
}

///|
/// JS: screen.findAllByTitle(title, options?)
pub async fn Screen::findAllByTitle(
  self : Screen,
  title : String,
  exact? : Bool? = None,
  trim? : Bool? = None,
  collapse_whitespace? : Bool? = None,
) -> ScreenResults {
  let promise : @js.Promise[ScreenResults] = match
    build_matcher_options(exact~, trim~, collapse_whitespace~) {
    Some(opts) => self.call2("findAllByTitle", title, opts).cast()
    None => self.call1("findAllByTitle", title).cast()
  }
  promise.wait()
}

///|
/// JS: screen.findAllByTestId(testId)
pub async fn Screen::findAllByTestId(
  self : Screen,
  testId : String,
) -> ScreenResults {
  let promise : @js.Promise[ScreenResults] = self
    .call1("findAllByTestId", testId)
    .cast()
  promise.wait()
}
