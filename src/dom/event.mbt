///|
#external
pub type Event

///|
pub impl ToJs for Event with to_js(self) -> @js.Value {
  self |> @js.to_js
}

///|
pub fn prevent_default(self : Event) -> Unit {
  self.to_js().get("preventDefault").call([]) |> ignore
}

///|
pub fn stop_propagation(self : Event) -> Unit {
  self.to_js().get("stopPropagation").call([]) |> ignore
}

///|
pub fn target(self : Event) -> Element {
  self.to_js().get("target").cast()
}

///|
#external
pub type MouseEvent
///|
pub impl @js.ToJs for MouseEvent with to_js(self) -> @js.Value {
  self |> @js.to_js
}

///|
pub fn client_x(self : MouseEvent) -> Int {
  self.to_js().get("clientX").cast()
}

///|
pub fn client_y(self : MouseEvent) -> Int {
  self.to_js().get("clientY").cast()
}

///|
/// screenX
pub fn screen_x(self : MouseEvent) -> Int {
  self.to_js().get("screenX").cast()
}

///|
pub fn screen_y(self : MouseEvent) -> Int {
  self.to_js().get("screenY").cast()
}

///|
#external
pub type KeyboardEvent
impl @js.ToJs for KeyboardEvent with to_js(self) -> @js.Value {
  self |> @js.to_js
}

///|
pub fn target(self : KeyboardEvent) -> Element {
  self.to_js().get("target").cast()
}

///|
pub fn key(self : KeyboardEvent) -> String {
  self.to_js().get("key").cast()
}

///|
pub fn key_code(self : KeyboardEvent) -> Int {
  self.to_js().get("keyCode").cast()
}

///|
pub fn KeyboardEvent::which(self : KeyboardEvent) -> Int {
  self.to_js().get("which").cast()
}

///|
pub fn KeyboardEvent::code(self : KeyboardEvent) -> String {
  let value : Value = self |> @js.identity
  value.get("code").cast()
}

///|
pub fn KeyboardEvent::ctrl_key(self : KeyboardEvent) -> Bool {
  let value : Value = self |> @js.identity
  value.get("ctrlKey").cast()
}

///|
pub fn KeyboardEvent::alt_key(self : KeyboardEvent) -> Bool {
  self.to_js().get("altKey").cast()
}

///|
pub fn KeyboardEvent::shift_key(self : KeyboardEvent) -> Bool {
  self.to_js().get("shiftKey").cast()
}

///|
#external
pub type ChangeEvent

///|
pub fn ChangeEvent::target(self : ChangeEvent) -> Element {
  let value : Value = self |> @js.identity
  value.get("target").cast()
}

///|
#external
pub type FocusEvent
impl @js.ToJs for FocusEvent with to_js(self) -> @js.Value {
  self |> @js.to_js
}

///|
pub fn FocusEvent::target(self : FocusEvent) -> Element {
  self.to_js().get("target").cast()
}

///|
#external
pub type FormEvent
impl @js.ToJs for FormEvent with to_js(self) -> @js.Value {
  self |> @js.to_js
}

///|
pub fn FormEvent::target(self : FormEvent) -> Element {
  self.to_js().get("target").cast()
}

///|
pub fn FormEvent::current_target(self : FormEvent) -> Element {
  self.to_js().get("currentTarget").cast()
}

///|
pub fn FormEvent::form_data(self : FormEvent) -> Element {
  self.to_js().get("formData").cast()
}