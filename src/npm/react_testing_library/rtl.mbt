// React Testing Library

///|
#external
pub type ReactTestingLibrary

///|
impl @js.JsImpl for ReactTestingLibrary

///|
fn testing_library() -> ReactTestingLibrary {
  @node.require("@testing-library/react").cast()
}

///|
/// RenderResult returned by render()
#external
pub type RenderResult

///|
pub impl @js.JsImpl for RenderResult

///|
/// JS: render(element, options?)
/// Returns: RenderResult with queries, container, baseElement, debug, rerender, unmount, asFragment
pub fn render(element : @react.Element) -> RenderResult {
  let rtl = testing_library()
  rtl.call1("render", element).cast()
}

///|
/// JS: result.container
pub fn RenderResult::container(self : RenderResult) -> @dom.HTMLElement {
  self.get("container").cast()
}

///|
/// JS: result.baseElement
pub fn RenderResult::baseElement(self : RenderResult) -> @dom.HTMLElement {
  self.get("baseElement").cast()
}

///|
/// JS: result.debug()
pub fn RenderResult::debug(self : RenderResult) -> Unit {
  self.call0("debug") |> ignore
}

///|
/// JS: result.rerender(element)
pub fn RenderResult::rerender(
  self : RenderResult,
  element : @react.Element,
) -> Unit {
  self.call1("rerender", element) |> ignore
}

///|
/// JS: result.unmount()
pub fn RenderResult::unmount(self : RenderResult) -> Unit {
  self.call0("unmount") |> ignore
}

///|
/// JS: result.asFragment()
pub fn RenderResult::asFragment(self : RenderResult) -> @js.Any {
  self.call0("asFragment")
}

///|
/// JS: cleanup()
pub fn cleanup() -> Unit {
  let rtl = testing_library()
  rtl.call0("cleanup") |> ignore
}

///|
/// JS: act(callback)
pub fn act(callback : () -> Unit) -> @js.Any {
  let rtl = testing_library()
  rtl.call1("act", @js.identity(callback))
}

///|
/// JS: configure(options)
pub fn configure(options : @js.Any) -> Unit {
  let rtl = testing_library()
  rtl.call1("configure", options) |> ignore
}

///|
/// RenderHookResult returned by renderHook()
#external
pub type RenderHookResult

///|
pub impl @js.JsImpl for RenderHookResult

///|
/// JS: renderHook(hook, options?)
pub fn renderHook(hook : @js.Any) -> RenderHookResult {
  let rtl = testing_library()
  rtl.call1("renderHook", hook).cast()
}

///|
/// JS: result.result
pub fn RenderHookResult::result(self : RenderHookResult) -> @js.Any {
  self.get("result")
}

///|
/// JS: result.rerender(props)
pub fn RenderHookResult::rerender(
  self : RenderHookResult,
  props : @js.Any,
) -> Unit {
  self.call1("rerender", props) |> ignore
}

///|
/// JS: result.unmount()
pub fn RenderHookResult::unmount(self : RenderHookResult) -> Unit {
  self.call0("unmount") |> ignore
}

///|
/// ReactTestingLibrary.FireEvent
#external
pub type FireEvent

///|
pub impl @js.JsImpl for FireEvent

///|
/// JS: import { fireEvent } from '@testing-library/react'
#alias(fire_event)
pub fn fireEvent() -> FireEvent {
  let rtl = testing_library()
  rtl.get("fireEvent").cast()
}

///|
/// JS: fireEvent.click(target)
pub fn FireEvent::click(self : FireEvent, target : @dom.HTMLElement) -> Bool {
  self.call1("click", target).cast()
}

///|
/// JS: fireEvent.dblClick(target)
pub fn FireEvent::dblClick(self : FireEvent, target : @dom.HTMLElement) -> Bool {
  self.call1("dblClick", target).cast()
}

///|
/// JS: fireEvent.change(target, event)
pub fn FireEvent::change(
  self : FireEvent,
  target : @dom.HTMLElement,
  event : @js.Any,
) -> Bool {
  self.call2("change", target, event).cast()
}

///|
/// JS: fireEvent.input(target, event)
pub fn FireEvent::input(
  self : FireEvent,
  target : @dom.HTMLElement,
  event : @js.Any,
) -> Bool {
  self.call2("input", target, event).cast()
}

///|
/// JS: fireEvent.submit(target)
pub fn FireEvent::submit(self : FireEvent, target : @dom.HTMLElement) -> Bool {
  self.call1("submit", target).cast()
}

///|
/// JS: fireEvent.focus(target)
pub fn FireEvent::focus(self : FireEvent, target : @dom.HTMLElement) -> Bool {
  self.call1("focus", target).cast()
}

///|
/// JS: fireEvent.blur(target)
pub fn FireEvent::blur(self : FireEvent, target : @dom.HTMLElement) -> Bool {
  self.call1("blur", target).cast()
}

///|
/// JS: fireEvent.keyDown(target, event)
pub fn FireEvent::keyDown(
  self : FireEvent,
  target : @dom.HTMLElement,
  event : @js.Any,
) -> Bool {
  self.call2("keyDown", target, event).cast()
}

///|
/// JS: fireEvent.keyUp(target, event)
pub fn FireEvent::keyUp(
  self : FireEvent,
  target : @dom.HTMLElement,
  event : @js.Any,
) -> Bool {
  self.call2("keyUp", target, event).cast()
}

///|
/// JS: fireEvent.keyPress(target, event)
pub fn FireEvent::keyPress(
  self : FireEvent,
  target : @dom.HTMLElement,
  event : @js.Any,
) -> Bool {
  self.call2("keyPress", target, event).cast()
}

///|
/// JS: fireEvent.mouseDown(target)
pub fn FireEvent::mouseDown(
  self : FireEvent,
  target : @dom.HTMLElement,
) -> Bool {
  self.call1("mouseDown", target).cast()
}

///|
/// JS: fireEvent.mouseUp(target)
pub fn FireEvent::mouseUp(self : FireEvent, target : @dom.HTMLElement) -> Bool {
  self.call1("mouseUp", target).cast()
}

///|
/// JS: fireEvent.mouseEnter(target)
pub fn FireEvent::mouseEnter(
  self : FireEvent,
  target : @dom.HTMLElement,
) -> Bool {
  self.call1("mouseEnter", target).cast()
}

///|
/// JS: fireEvent.mouseLeave(target)
pub fn FireEvent::mouseLeave(
  self : FireEvent,
  target : @dom.HTMLElement,
) -> Bool {
  self.call1("mouseLeave", target).cast()
}

///|
/// JS: fireEvent.mouseMove(target)
pub fn FireEvent::mouseMove(
  self : FireEvent,
  target : @dom.HTMLElement,
) -> Bool {
  self.call1("mouseMove", target).cast()
}

///|
/// JS: fireEvent.mouseOver(target)
pub fn FireEvent::mouseOver(
  self : FireEvent,
  target : @dom.HTMLElement,
) -> Bool {
  self.call1("mouseOver", target).cast()
}

///|
/// JS: fireEvent.mouseOut(target)
pub fn FireEvent::mouseOut(self : FireEvent, target : @dom.HTMLElement) -> Bool {
  self.call1("mouseOut", target).cast()
}

///|
/// JS: fireEvent.scroll(target)
pub fn FireEvent::scroll(self : FireEvent, target : @dom.HTMLElement) -> Bool {
  self.call1("scroll", target).cast()
}

///|
/// JS: fireEvent.drag(target)
pub fn FireEvent::drag(self : FireEvent, target : @dom.HTMLElement) -> Bool {
  self.call1("drag", target).cast()
}

///|
/// JS: fireEvent.drop(target)
pub fn FireEvent::drop(self : FireEvent, target : @dom.HTMLElement) -> Bool {
  self.call1("drop", target).cast()
}

///|
/// JS: fireEvent.dragStart(target)
pub fn FireEvent::dragStart(
  self : FireEvent,
  target : @dom.HTMLElement,
) -> Bool {
  self.call1("dragStart", target).cast()
}

///|
/// JS: fireEvent.dragEnd(target)
pub fn FireEvent::dragEnd(self : FireEvent, target : @dom.HTMLElement) -> Bool {
  self.call1("dragEnd", target).cast()
}

///|
/// JS: fireEvent.dragEnter(target)
pub fn FireEvent::dragEnter(
  self : FireEvent,
  target : @dom.HTMLElement,
) -> Bool {
  self.call1("dragEnter", target).cast()
}

///|
/// JS: fireEvent.dragLeave(target)
pub fn FireEvent::dragLeave(
  self : FireEvent,
  target : @dom.HTMLElement,
) -> Bool {
  self.call1("dragLeave", target).cast()
}

///|
/// JS: fireEvent.dragOver(target)
pub fn FireEvent::dragOver(self : FireEvent, target : @dom.HTMLElement) -> Bool {
  self.call1("dragOver", target).cast()
}

///|
/// JS: fireEvent.copy(target)
pub fn FireEvent::copy(self : FireEvent, target : @dom.HTMLElement) -> Bool {
  self.call1("copy", target).cast()
}

///|
/// JS: fireEvent.cut(target)
pub fn FireEvent::cut(self : FireEvent, target : @dom.HTMLElement) -> Bool {
  self.call1("cut", target).cast()
}

///|
/// JS: fireEvent.paste(target)
pub fn FireEvent::paste(self : FireEvent, target : @dom.HTMLElement) -> Bool {
  self.call1("paste", target).cast()
}

///|
/// JS: fireEvent.select(target)
pub fn FireEvent::select(self : FireEvent, target : @dom.HTMLElement) -> Bool {
  self.call1("select", target).cast()
}

///|
/// JS: fireEvent.touchStart(target)
pub fn FireEvent::touchStart(
  self : FireEvent,
  target : @dom.HTMLElement,
) -> Bool {
  self.call1("touchStart", target).cast()
}

///|
/// JS: fireEvent.touchEnd(target)
pub fn FireEvent::touchEnd(self : FireEvent, target : @dom.HTMLElement) -> Bool {
  self.call1("touchEnd", target).cast()
}

///|
/// JS: fireEvent.touchMove(target)
pub fn FireEvent::touchMove(
  self : FireEvent,
  target : @dom.HTMLElement,
) -> Bool {
  self.call1("touchMove", target).cast()
}

///|
/// JS: fireEvent.touchCancel(target)
pub fn FireEvent::touchCancel(
  self : FireEvent,
  target : @dom.HTMLElement,
) -> Bool {
  self.call1("touchCancel", target).cast()
}

///|
/// JS: fireEvent.load(target)
pub fn FireEvent::load(self : FireEvent, target : @dom.HTMLElement) -> Bool {
  self.call1("load", target).cast()
}

///|
/// JS: fireEvent.error(target)
pub fn FireEvent::error(self : FireEvent, target : @dom.HTMLElement) -> Bool {
  self.call1("error", target).cast()
}

///|
/// JS: fireEvent.contextMenu(target)
pub fn FireEvent::contextMenu(
  self : FireEvent,
  target : @dom.HTMLElement,
) -> Bool {
  self.call1("contextMenu", target).cast()
}

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
  let mut has_options = false
  match exact {
    Some(v) => {
      obj.set("exact", v)
      has_options = true
    }
    None => ()
  }
  match trim {
    Some(v) => {
      obj.set("trim", v)
      has_options = true
    }
    None => ()
  }
  match collapse_whitespace {
    Some(v) => {
      obj.set("collapseWhitespace", v)
      has_options = true
    }
    None => ()
  }
  if has_options {
    Some(obj)
  } else {
    None
  }
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
  let mut has_options = false
  match exact {
    Some(v) => {
      obj.set("exact", v)
      has_options = true
    }
    None => ()
  }
  match trim {
    Some(v) => {
      obj.set("trim", v)
      has_options = true
    }
    None => ()
  }
  match collapse_whitespace {
    Some(v) => {
      obj.set("collapseWhitespace", v)
      has_options = true
    }
    None => ()
  }
  match selector {
    Some(v) => {
      obj.set("selector", v)
      has_options = true
    }
    None => ()
  }
  if has_options {
    Some(obj)
  } else {
    None
  }
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
  let mut has_options = false
  match name {
    Some(v) => {
      obj.set("name", v)
      has_options = true
    }
    None => ()
  }
  match hidden {
    Some(v) => {
      obj.set("hidden", v)
      has_options = true
    }
    None => ()
  }
  match selected {
    Some(v) => {
      obj.set("selected", v)
      has_options = true
    }
    None => ()
  }
  match checked {
    Some(v) => {
      obj.set("checked", v)
      has_options = true
    }
    None => ()
  }
  match pressed {
    Some(v) => {
      obj.set("pressed", v)
      has_options = true
    }
    None => ()
  }
  match expanded {
    Some(v) => {
      obj.set("expanded", v)
      has_options = true
    }
    None => ()
  }
  match level {
    Some(v) => {
      obj.set("level", v)
      has_options = true
    }
    None => ()
  }
  match description {
    Some(v) => {
      obj.set("description", v)
      has_options = true
    }
    None => ()
  }
  if has_options {
    Some(obj)
  } else {
    None
  }
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
