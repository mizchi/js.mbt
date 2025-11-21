// React Testing Library

///|
#external
pub type ReactTestingLibrary

///|
impl @js.JsImpl for ReactTestingLibrary

///|
fn testing_library() -> ReactTestingLibrary {
  @node.require("@testing-library/react") |> @js.unsafe_cast
}

///|
/// JS: render(element)
pub fn render(element : @react.Element) -> Unit {
  let rtl = testing_library()
  rtl.call("render", [element]) |> ignore
}

///|
/// JS: cleanup()
pub fn cleanup() -> Unit {
  let rtl = testing_library()
  rtl.call0("cleanup") |> ignore
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
  rtl.get("fireEvent") |> @js.unsafe_cast
}

///|
/// JS: fireEvent.click(target)
pub fn FireEvent::click(self : FireEvent, target : @js.Js) -> Unit {
  self.call("click", [target]) |> ignore
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
  rtl.get("screen") |> @js.unsafe_cast
}

///|
/// JS: screen.debug()
pub fn Screen::debug(self : Self) -> Unit {
  self.call0("debug") |> ignore
}

///|
/// JS: screen.getByText(text)
pub fn Screen::getByText(self : Screen, text : String) -> @js.Js {
  self.call("getByText", [text]) |> @js.unsafe_cast
}

///|
/// JS: screen.getByRole(role)
pub fn Screen::getByRole(self : Screen, role : String) -> @js.Js {
  self.call("getByRole", [role]) |> @js.unsafe_cast
}
