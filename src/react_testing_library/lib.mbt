///|
using @js {to_js}

///|
#external
pub type ReactTestingLibrary
impl @js.ToJs for ReactTestingLibrary with to_js(self) {
  self |> @js.to_js
}

///|
pub async fn ReactTestingLibrary::load() -> ReactTestingLibrary {
  let _ = @js.import_module("global-jsdom/register")
  @js.import_module("@testing-library/react").cast()
}

///|
pub fn ReactTestingLibrary::cleanup(self : Self) -> Unit {
  self.to_js().get("cleanup").call0() |> ignore
}

///|
pub fn ReactTestingLibrary::render(
  self : ReactTestingLibrary,
  element : @react.Element,
) -> Unit {
  self.to_js().get("render").call1(element).cast()
}

///|
pub fn screen(self : ReactTestingLibrary) -> Screen {
  self.to_js().get("screen").cast()
}

///|
pub fn fire_event(self : ReactTestingLibrary) -> FireEvent {
  self.to_js().get("fireEvent").cast()
}

///|
#external
pub type Screen
impl @js.ToJs for Screen with to_js(self) {
  self |> @js.to_js
}

///|
/// screen.getByText()
pub fn Screen::get_by_text(self : Screen, text : String) -> @dom.Element {
  self.to_js().get("getByText").call([text |> to_js]).cast()
}

///|
/// srceen.getByRole()
pub fn Screen::get_by_role(self : Screen, text : String) -> @dom.Element {
  self.to_js().get("getByRole").call([text |> to_js]).cast()
}

///|
/// srceen.getByLabelText()
pub fn Screen::get_by_label_text(self : Screen, text : String) -> @dom.Element {
  self.to_js().get("getByLabelText").call([text |> to_js]).cast()
}

///|
/// srceen.getByTestId()
pub fn Screen::get_by_test_id(self : Screen, text : String) -> @dom.Element {
  self.to_js().get("getByTestId").call([text |> to_js]).cast()
}

///|
#external
pub type FireEvent
impl @js.ToJs for FireEvent with to_js(self) {
  self |> @js.to_js
}

///|
pub fn FireEvent::click(self : FireEvent, element : @dom.Element) -> Unit {
  self.to_js().get("click").call([element |> to_js]).cast()
}

///|
pub fn key_down(
  self : FireEvent,
  element : @dom.Element,
  key? : String,
  code? : String,
  char_code? : Int,
) -> @js.Promise[Unit] {
  let event_obj = @js.new_object()
  if key is Some(k) {
    event_obj["key"] = k |> to_js
  }
  if code is Some(c) {
    event_obj["code"] = c |> to_js
  }
  if char_code is Some(cc) {
    event_obj["charCode"] = cc |> to_js
  }
  self.to_js().get("keyDown").call2(element, event_obj).cast()
}

///|
pub fn key_up(
  self : FireEvent,
  element : @dom.Element,
  key? : String,
  code? : String,
  char_code? : Int,
) -> @js.Promise[Unit] {
  let event_obj : @js.Value = @js.new_object()
  if key is Some(k) {
    event_obj["key"] = k |> to_js
  }
  if code is Some(c) {
    event_obj["code"] = c |> to_js
  }
  if char_code is Some(cc) {
    event_obj["charCode"] = cc |> to_js
  }
  self.to_js().get("keyUp").call2(element, event_obj).cast()
}

///|
/// UserEvent.change(element, { target: { value: "new value" } })
pub fn FireEvent::change_target_value(
  self : FireEvent,
  element : @dom.Element,
  value~ : String,
) -> @js.Promise[Unit] {
  let change_obj = @js.new_object()
  change_obj["target"] = { "value": value |> to_js } |> to_js
  self.to_js().get("change").call([element |> to_js, change_obj]).cast()
}
