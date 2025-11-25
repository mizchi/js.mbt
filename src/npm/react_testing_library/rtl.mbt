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
pub fn FireEvent::click(self : FireEvent, target : @dom.HTMLElement) -> Unit {
  self.call1("click", target) |> ignore
}

///|
/// JS: fireEvent.change(target, event)
pub fn FireEvent::change(
  self : FireEvent,
  target : @dom.HTMLElement,
  event : @js.Any,
) -> Unit {
  self.call2("change", target, event) |> ignore
}

///|
/// JS: fireEvent.input(target, event)
pub fn FireEvent::input(
  self : FireEvent,
  target : @dom.HTMLElement,
  event : @js.Any,
) -> Unit {
  self.call2("input", target, event) |> ignore
}

///|
/// JS: fireEvent.submit(target)
pub fn FireEvent::submit(self : FireEvent, target : @dom.HTMLElement) -> Unit {
  self.call1("submit", target) |> ignore
}

///|
/// JS: fireEvent.focus(target)
pub fn FireEvent::focus(self : FireEvent, target : @dom.HTMLElement) -> Unit {
  self.call1("focus", target) |> ignore
}

///|
/// JS: fireEvent.blur(target)
pub fn FireEvent::blur(self : FireEvent, target : @dom.HTMLElement) -> Unit {
  self.call1("blur", target) |> ignore
}

///|
/// JS: fireEvent.keyDown(target, event)
pub fn FireEvent::keyDown(
  self : FireEvent,
  target : @dom.HTMLElement,
  event : @js.Any,
) -> Unit {
  self.call2("keyDown", target, event) |> ignore
}

///|
/// JS: fireEvent.keyUp(target, event)
pub fn FireEvent::keyUp(
  self : FireEvent,
  target : @dom.HTMLElement,
  event : @js.Any,
) -> Unit {
  self.call2("keyUp", target, event) |> ignore
}

///|
/// JS: fireEvent.mouseEnter(target)
pub fn FireEvent::mouseEnter(
  self : FireEvent,
  target : @dom.HTMLElement,
) -> Unit {
  self.call1("mouseEnter", target) |> ignore
}

///|
/// JS: fireEvent.mouseLeave(target)
pub fn FireEvent::mouseLeave(
  self : FireEvent,
  target : @dom.HTMLElement,
) -> Unit {
  self.call1("mouseLeave", target) |> ignore
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
/// JS: screen.getByRole(role, options?)
pub fn Screen::getByRole(self : Screen, role : String) -> ScreenResult {
  self.call1("getByRole", role).cast()
}

///|
/// JS: screen.getByLabelText(text, options?)
pub fn Screen::getByLabelText(self : Screen, text : String) -> ScreenResult {
  self.call1("getByLabelText", text).cast()
}

///|
/// JS: screen.getByPlaceholderText(text, options?)
pub fn Screen::getByPlaceholderText(
  self : Screen,
  text : String,
) -> ScreenResult {
  self.call1("getByPlaceholderText", text).cast()
}

///|
/// JS: screen.getByText(text, options?)
pub fn Screen::getByText(self : Screen, text : String) -> ScreenResult {
  self.call1("getByText", text).cast()
}

///|
/// JS: screen.getByDisplayValue(value, options?)
pub fn Screen::getByDisplayValue(self : Screen, value : String) -> ScreenResult {
  self.call1("getByDisplayValue", value).cast()
}

///|
/// JS: screen.getByAltText(text, options?)
pub fn Screen::getByAltText(self : Screen, text : String) -> ScreenResult {
  self.call1("getByAltText", text).cast()
}

///|
/// JS: screen.getByTitle(title, options?)
pub fn Screen::getByTitle(self : Screen, title : String) -> ScreenResult {
  self.call1("getByTitle", title).cast()
}

///|
/// JS: screen.getByTestId(testId)
pub fn Screen::getByTestId(self : Screen, testId : String) -> ScreenResult {
  self.call1("getByTestId", testId).cast()
}

///| queryBy* queries - return null if not found

///|
/// JS: screen.queryByRole(role, options?)
pub fn Screen::queryByRole(self : Screen, role : String) -> ScreenResult? {
  self.call1("queryByRole", role).cast()
}

///|
/// JS: screen.queryByLabelText(text, options?)
pub fn Screen::queryByLabelText(self : Screen, text : String) -> ScreenResult? {
  self.call1("queryByLabelText", text).cast()
}

///|
/// JS: screen.queryByPlaceholderText(text, options?)
pub fn Screen::queryByPlaceholderText(
  self : Screen,
  text : String,
) -> ScreenResult? {
  self.call1("queryByPlaceholderText", text).cast()
}

///|
/// JS: screen.queryByText(text, options?)
pub fn Screen::queryByText(self : Screen, text : String) -> ScreenResult? {
  self.call1("queryByText", text).cast()
}

///|
/// JS: screen.queryByDisplayValue(value, options?)
pub fn Screen::queryByDisplayValue(
  self : Screen,
  value : String,
) -> ScreenResult? {
  self.call1("queryByDisplayValue", value).cast()
}

///|
/// JS: screen.queryByAltText(text, options?)
pub fn Screen::queryByAltText(self : Screen, text : String) -> ScreenResult? {
  self.call1("queryByAltText", text).cast()
}

///|
/// JS: screen.queryByTitle(title, options?)
pub fn Screen::queryByTitle(self : Screen, title : String) -> ScreenResult? {
  self.call1("queryByTitle", title).cast()
}

///|
/// JS: screen.queryByTestId(testId)
pub fn Screen::queryByTestId(self : Screen, testId : String) -> ScreenResult? {
  self.call1("queryByTestId", testId).cast()
}

///| findBy* queries - async, throw error if not found

///|
/// JS: screen.findByRole(role, options?)
pub async fn Screen::findByRole(self : Screen, role : String) -> ScreenResult {
  let promise : @js.Promise[ScreenResult] = self
    .call1("findByRole", role)
    .cast()
  promise.wait()
}

///|
/// JS: screen.findByLabelText(text, options?)
pub async fn Screen::findByLabelText(
  self : Screen,
  text : String,
) -> ScreenResult {
  let promise : @js.Promise[ScreenResult] = self
    .call1("findByLabelText", text)
    .cast()
  promise.wait()
}

///|
/// JS: screen.findByPlaceholderText(text, options?)
pub async fn Screen::findByPlaceholderText(
  self : Screen,
  text : String,
) -> ScreenResult {
  let promise : @js.Promise[ScreenResult] = self
    .call1("findByPlaceholderText", text)
    .cast()
  promise.wait()
}

///|
/// JS: screen.findByText(text, options?)
pub async fn Screen::findByText(self : Screen, text : String) -> ScreenResult {
  let promise : @js.Promise[ScreenResult] = self
    .call1("findByText", text)
    .cast()
  promise.wait()
}

///|
/// JS: screen.findByDisplayValue(value, options?)
pub async fn Screen::findByDisplayValue(
  self : Screen,
  value : String,
) -> ScreenResult {
  let promise : @js.Promise[ScreenResult] = self
    .call1("findByDisplayValue", value)
    .cast()
  promise.wait()
}

///|
/// JS: screen.findByAltText(text, options?)
pub async fn Screen::findByAltText(
  self : Screen,
  text : String,
) -> ScreenResult {
  let promise : @js.Promise[ScreenResult] = self
    .call1("findByAltText", text)
    .cast()
  promise.wait()
}

///|
/// JS: screen.findByTitle(title, options?)
pub async fn Screen::findByTitle(self : Screen, title : String) -> ScreenResult {
  let promise : @js.Promise[ScreenResult] = self
    .call1("findByTitle", title)
    .cast()
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
pub fn Screen::getAllByRole(self : Screen, role : String) -> ScreenResults {
  self.call1("getAllByRole", role).cast()
}

///|
/// JS: screen.getAllByLabelText(text, options?)
pub fn Screen::getAllByLabelText(self : Screen, text : String) -> ScreenResults {
  self.call1("getAllByLabelText", text).cast()
}

///|
/// JS: screen.getAllByPlaceholderText(text, options?)
pub fn Screen::getAllByPlaceholderText(
  self : Screen,
  text : String,
) -> ScreenResults {
  self.call1("getAllByPlaceholderText", text).cast()
}

///|
/// JS: screen.getAllByText(text, options?)
pub fn Screen::getAllByText(self : Screen, text : String) -> ScreenResults {
  self.call1("getAllByText", text).cast()
}

///|
/// JS: screen.getAllByDisplayValue(value, options?)
pub fn Screen::getAllByDisplayValue(
  self : Screen,
  value : String,
) -> ScreenResults {
  self.call1("getAllByDisplayValue", value).cast()
}

///|
/// JS: screen.getAllByAltText(text, options?)
pub fn Screen::getAllByAltText(self : Screen, text : String) -> ScreenResults {
  self.call1("getAllByAltText", text).cast()
}

///|
/// JS: screen.getAllByTitle(title, options?)
pub fn Screen::getAllByTitle(self : Screen, title : String) -> ScreenResults {
  self.call1("getAllByTitle", title).cast()
}

///|
/// JS: screen.getAllByTestId(testId)
pub fn Screen::getAllByTestId(self : Screen, testId : String) -> ScreenResults {
  self.call1("getAllByTestId", testId).cast()
}

///| queryAllBy* queries - return array, empty if not found

///|
/// JS: screen.queryAllByRole(role, options?)
pub fn Screen::queryAllByRole(self : Screen, role : String) -> ScreenResults {
  self.call1("queryAllByRole", role).cast()
}

///|
/// JS: screen.queryAllByLabelText(text, options?)
pub fn Screen::queryAllByLabelText(
  self : Screen,
  text : String,
) -> ScreenResults {
  self.call1("queryAllByLabelText", text).cast()
}

///|
/// JS: screen.queryAllByPlaceholderText(text, options?)
pub fn Screen::queryAllByPlaceholderText(
  self : Screen,
  text : String,
) -> ScreenResults {
  self.call1("queryAllByPlaceholderText", text).cast()
}

///|
/// JS: screen.queryAllByText(text, options?)
pub fn Screen::queryAllByText(self : Screen, text : String) -> ScreenResults {
  self.call1("queryAllByText", text).cast()
}

///|
/// JS: screen.queryAllByDisplayValue(value, options?)
pub fn Screen::queryAllByDisplayValue(
  self : Screen,
  value : String,
) -> ScreenResults {
  self.call1("queryAllByDisplayValue", value).cast()
}

///|
/// JS: screen.queryAllByAltText(text, options?)
pub fn Screen::queryAllByAltText(self : Screen, text : String) -> ScreenResults {
  self.call1("queryAllByAltText", text).cast()
}

///|
/// JS: screen.queryAllByTitle(title, options?)
pub fn Screen::queryAllByTitle(self : Screen, title : String) -> ScreenResults {
  self.call1("queryAllByTitle", title).cast()
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
) -> ScreenResults {
  let promise : @js.Promise[ScreenResults] = self
    .call1("findAllByRole", role)
    .cast()
  promise.wait()
}

///|
/// JS: screen.findAllByLabelText(text, options?)
pub async fn Screen::findAllByLabelText(
  self : Screen,
  text : String,
) -> ScreenResults {
  let promise : @js.Promise[ScreenResults] = self
    .call1("findAllByLabelText", text)
    .cast()
  promise.wait()
}

///|
/// JS: screen.findAllByPlaceholderText(text, options?)
pub async fn Screen::findAllByPlaceholderText(
  self : Screen,
  text : String,
) -> ScreenResults {
  let promise : @js.Promise[ScreenResults] = self
    .call1("findAllByPlaceholderText", text)
    .cast()
  promise.wait()
}

///|
/// JS: screen.findAllByText(text, options?)
pub async fn Screen::findAllByText(
  self : Screen,
  text : String,
) -> ScreenResults {
  let promise : @js.Promise[ScreenResults] = self
    .call1("findAllByText", text)
    .cast()
  promise.wait()
}

///|
/// JS: screen.findAllByDisplayValue(value, options?)
pub async fn Screen::findAllByDisplayValue(
  self : Screen,
  value : String,
) -> ScreenResults {
  let promise : @js.Promise[ScreenResults] = self
    .call1("findAllByDisplayValue", value)
    .cast()
  promise.wait()
}

///|
/// JS: screen.findAllByAltText(text, options?)
pub async fn Screen::findAllByAltText(
  self : Screen,
  text : String,
) -> ScreenResults {
  let promise : @js.Promise[ScreenResults] = self
    .call1("findAllByAltText", text)
    .cast()
  promise.wait()
}

///|
/// JS: screen.findAllByTitle(title, options?)
pub async fn Screen::findAllByTitle(
  self : Screen,
  title : String,
) -> ScreenResults {
  let promise : @js.Promise[ScreenResults] = self
    .call1("findAllByTitle", title)
    .cast()
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

///| Helper functions to reduce @js.identity in tests

///|
/// Get textContent property from HTMLElement
pub fn text_content(element : @dom.HTMLElement) -> String {
  element.get("textContent").cast()
}

///|
/// Get any string property from HTMLElement
pub fn get_string_property(element : @dom.HTMLElement, key : String) -> String {
  element.get(key).cast()
}

///|
/// Get any property from HTMLElement as Js
pub fn get_property(element : @dom.HTMLElement, key : String) -> @js.Any {
  element.get(key)
}
