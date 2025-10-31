///|
using @val {type Val, trait Js, js, new_object, unsafe_cast}
using @promise {type Promise}

///|
#external
pub type ReactTestingLibrary

///|
impl Js for ReactTestingLibrary with to_js(self) {
  self |> js
}

///|
pub async fn ReactTestingLibrary::load() -> ReactTestingLibrary {
  @module.import_module("global-jsdom/register") |> ignore
  @module.import_module("@testing-library/react") |> unsafe_cast
}

///|
pub fn ReactTestingLibrary::cleanup(self : Self) -> Unit {
  self.to_js().get("cleanup").call([]) |> ignore
}

///|
pub fn ReactTestingLibrary::render(
  self : ReactTestingLibrary,
  element : @react.Element,
) -> Unit {
  self.to_js().get("render").call([element]).cast()
}

///|
pub fn ReactTestingLibrary::screen(self : Self) -> Screen {
  self.to_js().get("screen").cast()
}

///|
pub fn ReactTestingLibrary::fire_event(self : Self) -> FireEvent {
  self.to_js().get("fireEvent").cast()
}

///|
#external
pub type Screen

///|
impl Js for Screen with to_js(self) {
  self |> js
}

///|
/// screen.getByText()
pub fn Screen::get_by_text(self : Screen, text : String) -> @dom.Element {
  self.to_js().get("getByText").call([text]).cast()
}

///|
/// srceen.getByRole()
pub fn Screen::get_by_role(self : Screen, text : String) -> @dom.Element {
  self.to_js().get("getByRole").call([text]).cast()
}

///|
/// srceen.getByLabelText()
pub fn Screen::get_by_label_text(self : Screen, text : String) -> @dom.Element {
  self.to_js().get("getByLabelText").call([text]).cast()
}

///|
/// srceen.getByTestId()
pub fn Screen::get_by_test_id(self : Screen, text : String) -> @dom.Element {
  self.to_js().get("getByTestId").call([text]).cast()
}

///|
#external
pub type FireEvent

///|
impl Js for FireEvent with to_js(self) {
  self |> js
}

///|
pub fn FireEvent::click(self : FireEvent, element : @dom.Element) -> Unit {
  self.to_js().get("click").call([element]).cast()
}

///|
pub fn FireEvent::key_down(
  self : FireEvent,
  element : @dom.Element,
  key? : String,
  code? : String,
  char_code? : Int,
) -> Promise[Unit] {
  let event_obj = new_object()
  if key is Some(k) {
    event_obj["key"] = k |> js
  }
  if code is Some(c) {
    event_obj["code"] = c |> js
  }
  if char_code is Some(cc) {
    event_obj["charCode"] = cc |> js
  }
  self.to_js().get("keyDown").call([element, event_obj]).cast()
}

///|
pub fn FireEvent::key_up(
  self : Self,
  element : @dom.Element,
  key? : String,
  code? : String,
  char_code? : Int,
) -> Promise[Unit] {
  let event_obj : Val = new_object()
  if key is Some(k) {
    event_obj["key"] = k |> js
  }
  if code is Some(c) {
    event_obj["code"] = c |> js
  }
  if char_code is Some(cc) {
    event_obj["charCode"] = cc |> js
  }
  self.to_js().get("keyUp").call([element, event_obj]).cast()
}

///|
/// UserEvent.change(element, { target: { value: "new value" } })
pub fn FireEvent::change_target_value(
  self : FireEvent,
  element : @dom.Element,
  value~ : String,
) -> Promise[Unit] {
  let change_obj = new_object()
  change_obj["target"] = { "value": value |> js } |> js
  self.to_js().get("change").call([element, change_obj]).cast()
}
