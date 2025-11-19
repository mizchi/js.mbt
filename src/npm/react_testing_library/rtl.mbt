// React Testing Library
//

///|
using @js {trait JsImpl, type Js, unsafe_cast}

///|
#external
pub type ReactTestingLibrary

///|
impl JsImpl for ReactTestingLibrary

///|
fn testing_library() -> ReactTestingLibrary {
  @node.require("@testing-library/react") |> unsafe_cast
}

///|
/// JS: render(element)
pub fn render(element : @react.Element) -> Unit {
  let rtl = testing_library()
  rtl.invoke("render", [element]) |> ignore
}

///|
/// JS: cleanup()
pub fn cleanup() -> Unit {
  let rtl = testing_library()
  rtl.invoke("cleanup", []) |> ignore
}

///|
/// ReactTestingLibrary.FireEvent
#external
pub type FireEvent

///|
pub impl JsImpl for FireEvent

///|
/// JS: import { fireEvent } from '@testing-library/react'
#alias(fire_event)
pub fn fireEvent() -> FireEvent {
  let rtl = testing_library()
  unsafe_cast(rtl.get("fireEvent"))
}

///|
/// JS: fireEvent.click(target)
pub fn FireEvent::click(self : FireEvent, target : Js) -> Unit {
  self.invoke("click", [target]) |> ignore
}

///|
/// ReactTestingLibrary.Screen
#external
pub type Screen

///|
pub impl JsImpl for Screen

///|
/// JS: import { screen } from '@testing-library/react'
pub fn screen() -> Screen {
  let rtl = testing_library()
  unsafe_cast(rtl.get("screen"))
}

///|
/// JS: screen.debug()
pub fn Screen::debug(self : Self) -> Unit {
  self.invoke("debug", []) |> ignore
}

///|
/// JS: screen.getByText(text)
pub fn Screen::getByText(self : Screen, text : String) -> Js {
  self.invoke("getByText", [text]) |> @js.unsafe_cast
}

///|
/// JS: screen.getByRole(role)
pub fn Screen::getByRole(self : Screen, role : String) -> Js {
  self.invoke("getByRole", [role]) |> unsafe_cast
}
