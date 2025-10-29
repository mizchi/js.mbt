using @js {to_js}
///|
#external
pub type ReactTestingLibrary
///|
pub async fn ReactTestingLibrary::load() -> ReactTestingLibrary {
  let _ = @js.import_module("global-jsdom/register")
  let testing_library = @js.import_module("@testing-library/react")
  testing_library |> @js.identity
}

///|
pub fn ReactTestingLibrary::cleanup(self: Self) -> Unit {
  let v: @js.Value = self |> @js.identity
  v.get("cleanup").call([]) |> ignore
}

///|
pub fn ReactTestingLibrary::render(
  self : ReactTestingLibrary,
  element : @react.Element,
) -> Unit {
  let v : @js.Value = self |> @js.identity
  v.get("render").call([element |> to_js]).cast()
}

pub fn ReactTestingLibrary::screen(self: ReactTestingLibrary) -> Screen {
  let v : @js.Value = self |> @js.identity
  v.get("screen").cast()
}

pub fn ReactTestingLibrary::fire_event(self: ReactTestingLibrary) -> FireEvent {
  let v : @js.Value = self |> @js.identity
  v.get("fireEvent").cast()
}



///|
#external
pub type Screen
///|
/// screen.getByText()
pub fn Screen::get_by_text(self : Screen, text : String) -> @dom.Element {
  let v : @js.Value = self |> @js.identity
  v.get("getByText").call([text |> to_js]).cast()
}

///|
/// srceen.getByRole()
pub fn Screen::get_by_role(self : Screen, text : String) -> @dom.Element {
  let v : @js.Value = self |> @js.identity
  v.get("getByRole").call([text |> to_js]).cast()
}

///|
/// srceen.getByLabelText()
pub fn Screen::get_by_label_text(self : Screen, text : String) -> @dom.Element {
  let v : @js.Value = self |> @js.identity
  v.get("getByLabelText").call([text |> to_js]).cast()
}

///|
/// srceen.getByTestId()
pub fn Screen::get_by_test_id(self : Screen, text : String) -> @dom.Element {
  let v : @js.Value = self |> @js.identity
  v.get("getByTestId").call([text |> to_js]).cast()
}

///|
#external
pub type FireEvent
pub fn FireEvent::click(self: FireEvent, element: @dom.Element) -> Unit {
  let v : @js.Value = self |> @js.identity
  v.get("click").call([element |> to_js]).cast()
}

pub fn FireEvent::key_down(self: FireEvent, element: @dom.Element, key?: String, code?: String, char_code?: Int) -> @js.Promise[Unit] {
  let v : @js.Value = self |> @js.identity
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
  v.get("keyDown").call([element |> to_js, event_obj]).cast()
}

pub fn FireEvent::key_up(self: FireEvent, element: @dom.Element, key?: String, code?: String, char_code?: Int) -> @js.Promise[Unit] {
  let v : @js.Value = self |> @js.identity
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
  v.get("keyUp").call([element |> to_js, event_obj]).cast()
}


///|
/// UserEvent.change(element, { target: { value: "new value" } })
pub fn FireEvent::change_target_value(self: FireEvent, element: @dom.Element, value~: String ) -> @js.Promise[Unit] {
  let v : @js.Value = self |> @js.identity
  let change_obj : @js.Value = @js.new_object()
  change_obj["target"] = {
    "value": value |> to_js
  } |> to_js
  v.get("change").call([element |> to_js, change_obj]).cast()
}

