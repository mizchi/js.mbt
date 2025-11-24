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
  rtl.call("render", [element]).cast()
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
  self.call("rerender", [element]) |> ignore
}

///|
/// JS: result.unmount()
pub fn RenderResult::unmount(self : RenderResult) -> Unit {
  self.call0("unmount") |> ignore
}

///|
/// JS: result.asFragment()
pub fn RenderResult::asFragment(self : RenderResult) -> @js.Js {
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
pub fn act(callback : () -> Unit) -> @js.Js {
  let rtl = testing_library()
  rtl.call("act", [@js.identity(callback)])
}

///|
/// JS: configure(options)
pub fn configure(options : @js.Js) -> Unit {
  let rtl = testing_library()
  rtl.call("configure", [options]) |> ignore
}

///|
/// RenderHookResult returned by renderHook()
#external
pub type RenderHookResult

///|
pub impl @js.JsImpl for RenderHookResult

///|
/// JS: renderHook(hook, options?)
pub fn renderHook(hook : @js.Js) -> RenderHookResult {
  let rtl = testing_library()
  rtl.call("renderHook", [hook]).cast()
}

///|
/// JS: result.result
pub fn RenderHookResult::result(self : RenderHookResult) -> @js.Js {
  self.get("result")
}

///|
/// JS: result.rerender(props)
pub fn RenderHookResult::rerender(
  self : RenderHookResult,
  props : @js.Js,
) -> Unit {
  self.call("rerender", [props]) |> ignore
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
  self.call("click", [target]) |> ignore
}

///|
/// JS: fireEvent.change(target, event)
pub fn FireEvent::change(
  self : FireEvent,
  target : @dom.HTMLElement,
  event : @js.Js,
) -> Unit {
  self.call("change", [target, event]) |> ignore
}

///|
/// JS: fireEvent.input(target, event)
pub fn FireEvent::input(
  self : FireEvent,
  target : @dom.HTMLElement,
  event : @js.Js,
) -> Unit {
  self.call("input", [target, event]) |> ignore
}

///|
/// JS: fireEvent.submit(target)
pub fn FireEvent::submit(self : FireEvent, target : @dom.HTMLElement) -> Unit {
  self.call("submit", [target]) |> ignore
}

///|
/// JS: fireEvent.focus(target)
pub fn FireEvent::focus(self : FireEvent, target : @dom.HTMLElement) -> Unit {
  self.call("focus", [target]) |> ignore
}

///|
/// JS: fireEvent.blur(target)
pub fn FireEvent::blur(self : FireEvent, target : @dom.HTMLElement) -> Unit {
  self.call("blur", [target]) |> ignore
}

///|
/// JS: fireEvent.keyDown(target, event)
pub fn FireEvent::keyDown(
  self : FireEvent,
  target : @dom.HTMLElement,
  event : @js.Js,
) -> Unit {
  self.call("keyDown", [target, event]) |> ignore
}

///|
/// JS: fireEvent.keyUp(target, event)
pub fn FireEvent::keyUp(
  self : FireEvent,
  target : @dom.HTMLElement,
  event : @js.Js,
) -> Unit {
  self.call("keyUp", [target, event]) |> ignore
}

///|
/// JS: fireEvent.mouseEnter(target)
pub fn FireEvent::mouseEnter(
  self : FireEvent,
  target : @dom.HTMLElement,
) -> Unit {
  self.call("mouseEnter", [target]) |> ignore
}

///|
/// JS: fireEvent.mouseLeave(target)
pub fn FireEvent::mouseLeave(
  self : FireEvent,
  target : @dom.HTMLElement,
) -> Unit {
  self.call("mouseLeave", [target]) |> ignore
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
  self.call("getByRole", [role]).cast()
}

///|
/// JS: screen.getByLabelText(text, options?)
pub fn Screen::getByLabelText(self : Screen, text : String) -> ScreenResult {
  self.call("getByLabelText", [text]).cast()
}

///|
/// JS: screen.getByPlaceholderText(text, options?)
pub fn Screen::getByPlaceholderText(
  self : Screen,
  text : String,
) -> ScreenResult {
  self.call("getByPlaceholderText", [text]).cast()
}

///|
/// JS: screen.getByText(text, options?)
pub fn Screen::getByText(self : Screen, text : String) -> ScreenResult {
  self.call("getByText", [text]).cast()
}

///|
/// JS: screen.getByDisplayValue(value, options?)
pub fn Screen::getByDisplayValue(self : Screen, value : String) -> ScreenResult {
  self.call("getByDisplayValue", [value]).cast()
}

///|
/// JS: screen.getByAltText(text, options?)
pub fn Screen::getByAltText(self : Screen, text : String) -> ScreenResult {
  self.call("getByAltText", [text]).cast()
}

///|
/// JS: screen.getByTitle(title, options?)
pub fn Screen::getByTitle(self : Screen, title : String) -> ScreenResult {
  self.call("getByTitle", [title]).cast()
}

///|
/// JS: screen.getByTestId(testId)
pub fn Screen::getByTestId(self : Screen, testId : String) -> ScreenResult {
  self.call("getByTestId", [testId]).cast()
}

///| queryBy* queries - return null if not found

///|
/// JS: screen.queryByRole(role, options?)
pub fn Screen::queryByRole(self : Screen, role : String) -> ScreenResult? {
  self.call("queryByRole", [role]).cast()
}

///|
/// JS: screen.queryByLabelText(text, options?)
pub fn Screen::queryByLabelText(self : Screen, text : String) -> ScreenResult? {
  self.call("queryByLabelText", [text]).cast()
}

///|
/// JS: screen.queryByPlaceholderText(text, options?)
pub fn Screen::queryByPlaceholderText(
  self : Screen,
  text : String,
) -> ScreenResult? {
  self.call("queryByPlaceholderText", [text]).cast()
}

///|
/// JS: screen.queryByText(text, options?)
pub fn Screen::queryByText(self : Screen, text : String) -> ScreenResult? {
  self.call("queryByText", [text]).cast()
}

///|
/// JS: screen.queryByDisplayValue(value, options?)
pub fn Screen::queryByDisplayValue(
  self : Screen,
  value : String,
) -> ScreenResult? {
  self.call("queryByDisplayValue", [value]).cast()
}

///|
/// JS: screen.queryByAltText(text, options?)
pub fn Screen::queryByAltText(self : Screen, text : String) -> ScreenResult? {
  self.call("queryByAltText", [text]).cast()
}

///|
/// JS: screen.queryByTitle(title, options?)
pub fn Screen::queryByTitle(self : Screen, title : String) -> ScreenResult? {
  self.call("queryByTitle", [title]).cast()
}

///|
/// JS: screen.queryByTestId(testId)
pub fn Screen::queryByTestId(self : Screen, testId : String) -> ScreenResult? {
  self.call("queryByTestId", [testId]).cast()
}

///| findBy* queries - return Promise

///|
/// JS: screen.findByRole(role, options?)
pub fn Screen::findByRole(
  self : Screen,
  role : String,
) -> @js.Promise[ScreenResult] {
  self.call("findByRole", [role]).cast()
}

///|
/// JS: screen.findByLabelText(text, options?)
pub fn Screen::findByLabelText(
  self : Screen,
  text : String,
) -> @js.Promise[ScreenResult] {
  self.call("findByLabelText", [text]).cast()
}

///|
/// JS: screen.findByPlaceholderText(text, options?)
pub fn Screen::findByPlaceholderText(
  self : Screen,
  text : String,
) -> @js.Promise[ScreenResult] {
  self.call("findByPlaceholderText", [text]).cast()
}

///|
/// JS: screen.findByText(text, options?)
pub fn Screen::findByText(
  self : Screen,
  text : String,
) -> @js.Promise[ScreenResult] {
  self.call("findByText", [text]).cast()
}

///|
/// JS: screen.findByDisplayValue(value, options?)
pub fn Screen::findByDisplayValue(
  self : Screen,
  value : String,
) -> @js.Promise[ScreenResult] {
  self.call("findByDisplayValue", [value]).cast()
}

///|
/// JS: screen.findByAltText(text, options?)
pub fn Screen::findByAltText(
  self : Screen,
  text : String,
) -> @js.Promise[ScreenResult] {
  self.call("findByAltText", [text]).cast()
}

///|
/// JS: screen.findByTitle(title, options?)
pub fn Screen::findByTitle(
  self : Screen,
  title : String,
) -> @js.Promise[ScreenResult] {
  self.call("findByTitle", [title]).cast()
}

///|
/// JS: screen.findByTestId(testId)
pub fn Screen::findByTestId(
  self : Screen,
  testId : String,
) -> @js.Promise[ScreenResult] {
  self.call("findByTestId", [testId]).cast()
}

///| getAllBy* queries - return array, throw if not found

///|
/// JS: screen.getAllByRole(role, options?)
pub fn Screen::getAllByRole(self : Screen, role : String) -> ScreenResults {
  self.call("getAllByRole", [role]).cast()
}

///|
/// JS: screen.getAllByLabelText(text, options?)
pub fn Screen::getAllByLabelText(self : Screen, text : String) -> ScreenResults {
  self.call("getAllByLabelText", [text]).cast()
}

///|
/// JS: screen.getAllByPlaceholderText(text, options?)
pub fn Screen::getAllByPlaceholderText(
  self : Screen,
  text : String,
) -> ScreenResults {
  self.call("getAllByPlaceholderText", [text]).cast()
}

///|
/// JS: screen.getAllByText(text, options?)
pub fn Screen::getAllByText(self : Screen, text : String) -> ScreenResults {
  self.call("getAllByText", [text]).cast()
}

///|
/// JS: screen.getAllByDisplayValue(value, options?)
pub fn Screen::getAllByDisplayValue(
  self : Screen,
  value : String,
) -> ScreenResults {
  self.call("getAllByDisplayValue", [value]).cast()
}

///|
/// JS: screen.getAllByAltText(text, options?)
pub fn Screen::getAllByAltText(self : Screen, text : String) -> ScreenResults {
  self.call("getAllByAltText", [text]).cast()
}

///|
/// JS: screen.getAllByTitle(title, options?)
pub fn Screen::getAllByTitle(self : Screen, title : String) -> ScreenResults {
  self.call("getAllByTitle", [title]).cast()
}

///|
/// JS: screen.getAllByTestId(testId)
pub fn Screen::getAllByTestId(self : Screen, testId : String) -> ScreenResults {
  self.call("getAllByTestId", [testId]).cast()
}

///| queryAllBy* queries - return array, empty if not found

///|
/// JS: screen.queryAllByRole(role, options?)
pub fn Screen::queryAllByRole(self : Screen, role : String) -> ScreenResults {
  self.call("queryAllByRole", [role]).cast()
}

///|
/// JS: screen.queryAllByLabelText(text, options?)
pub fn Screen::queryAllByLabelText(
  self : Screen,
  text : String,
) -> ScreenResults {
  self.call("queryAllByLabelText", [text]).cast()
}

///|
/// JS: screen.queryAllByPlaceholderText(text, options?)
pub fn Screen::queryAllByPlaceholderText(
  self : Screen,
  text : String,
) -> ScreenResults {
  self.call("queryAllByPlaceholderText", [text]).cast()
}

///|
/// JS: screen.queryAllByText(text, options?)
pub fn Screen::queryAllByText(self : Screen, text : String) -> ScreenResults {
  self.call("queryAllByText", [text]).cast()
}

///|
/// JS: screen.queryAllByDisplayValue(value, options?)
pub fn Screen::queryAllByDisplayValue(
  self : Screen,
  value : String,
) -> ScreenResults {
  self.call("queryAllByDisplayValue", [value]).cast()
}

///|
/// JS: screen.queryAllByAltText(text, options?)
pub fn Screen::queryAllByAltText(self : Screen, text : String) -> ScreenResults {
  self.call("queryAllByAltText", [text]).cast()
}

///|
/// JS: screen.queryAllByTitle(title, options?)
pub fn Screen::queryAllByTitle(self : Screen, title : String) -> ScreenResults {
  self.call("queryAllByTitle", [title]).cast()
}

///|
/// JS: screen.queryAllByTestId(testId)
pub fn Screen::queryAllByTestId(
  self : Screen,
  testId : String,
) -> ScreenResults {
  self.call("queryAllByTestId", [testId]).cast()
}

///| findAllBy* queries - return Promise<array>

///|
/// JS: screen.findAllByRole(role, options?)
pub fn Screen::findAllByRole(
  self : Screen,
  role : String,
) -> @js.Promise[ScreenResults] {
  self.call("findAllByRole", [role]).cast()
}

///|
/// JS: screen.findAllByLabelText(text, options?)
pub fn Screen::findAllByLabelText(
  self : Screen,
  text : String,
) -> @js.Promise[ScreenResults] {
  self.call("findAllByLabelText", [text]).cast()
}

///|
/// JS: screen.findAllByPlaceholderText(text, options?)
pub fn Screen::findAllByPlaceholderText(
  self : Screen,
  text : String,
) -> @js.Promise[ScreenResults] {
  self.call("findAllByPlaceholderText", [text]).cast()
}

///|
/// JS: screen.findAllByText(text, options?)
pub fn Screen::findAllByText(
  self : Screen,
  text : String,
) -> @js.Promise[ScreenResults] {
  self.call("findAllByText", [text]).cast()
}

///|
/// JS: screen.findAllByDisplayValue(value, options?)
pub fn Screen::findAllByDisplayValue(
  self : Screen,
  value : String,
) -> @js.Promise[ScreenResults] {
  self.call("findAllByDisplayValue", [value]).cast()
}

///|
/// JS: screen.findAllByAltText(text, options?)
pub fn Screen::findAllByAltText(
  self : Screen,
  text : String,
) -> @js.Promise[ScreenResults] {
  self.call("findAllByAltText", [text]).cast()
}

///|
/// JS: screen.findAllByTitle(title, options?)
pub fn Screen::findAllByTitle(
  self : Screen,
  title : String,
) -> @js.Promise[ScreenResults] {
  self.call("findAllByTitle", [title]).cast()
}

///|
/// JS: screen.findAllByTestId(testId)
pub fn Screen::findAllByTestId(
  self : Screen,
  testId : String,
) -> @js.Promise[ScreenResults] {
  self.call("findAllByTestId", [testId]).cast()
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
pub fn get_property(element : @dom.HTMLElement, key : String) -> @js.Js {
  element.get(key)
}
