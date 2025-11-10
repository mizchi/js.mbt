///|
#external
pub type Event

///|
pub impl Js for Event with to_js(self) -> Val {
  self |> js
}

///|
pub fn Event::prevent_default(self : Event) -> Unit {
  self.to_js().get("preventDefault").call([]) |> ignore
}

///|
pub fn Event::stop_propagation(self : Event) -> Unit {
  self.to_js().get("stopPropagation").call([]) |> ignore
}

///|
pub fn Event::target(self : Self) -> Element {
  self.to_js().get("target").cast()
}

///|
#external
pub type PointerEvent

///|
pub impl Js for PointerEvent with to_js(self) {
  self |> js
}

///|
pub fn PointerEvent::width(self : Self) -> Double {
  self.to_js().get("width").cast()
}

///|
pub fn PointerEvent::height(self : Self) -> Double {
  self.to_js().get("height").cast()
}

///|
#external
pub type MouseEvent

///|
pub impl Js for MouseEvent with to_js(self) -> Val {
  self |> js
}

///|
pub fn MouseEvent::client_x(self : Self) -> Int {
  self.to_js().get("clientX").cast()
}

///|
pub fn MouseEvent::client_y(self : Self) -> Int {
  self.to_js().get("clientY").cast()
}

///|
/// screenX
pub fn MouseEvent::screen_x(self : MouseEvent) -> Int {
  self.to_js().get("screenX").cast()
}

///|
pub fn MouseEvent::screen_y(self : MouseEvent) -> Int {
  self.to_js().get("screenY").cast()
}

///|
#external
pub type KeyboardEvent

///|
impl Js for KeyboardEvent with to_js(self) -> Val {
  self |> js
}

///|
pub fn KeyboardEvent::target(self : KeyboardEvent) -> Element {
  self.to_js().get("target").cast()
}

///|
pub fn KeyboardEvent::key(self : KeyboardEvent) -> String {
  self.to_js().get("key").cast()
}

///|
pub fn KeyboardEvent::key_code(self : KeyboardEvent) -> Int {
  self.to_js().get("keyCode").cast()
}

///|
pub fn KeyboardEvent::which(self : KeyboardEvent) -> Int {
  self.to_js().get("which").cast()
}

///|
pub fn KeyboardEvent::code(self : KeyboardEvent) -> String {
  let value : Val = self |> js
  value.get("code").cast()
}

///|
pub fn KeyboardEvent::ctrl_key(self : KeyboardEvent) -> Bool {
  let value : Val = self |> js
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
  let value : Val = self |> js
  value.get("target").cast()
}

///|
#external
pub type FocusEvent

///|
impl Js for FocusEvent with to_js(self) -> Val {
  self |> js
}

///|
pub fn FocusEvent::target(self : FocusEvent) -> Element {
  self.to_js().get("target").cast()
}

///|
#external
pub type FormEvent

///|
impl Js for FormEvent with to_js(self) -> Val {
  self |> js
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

///|
#external
pub type DragStartEvent

///|
pub impl Js for DragStartEvent with to_js(self) -> Val {
  self |> js
}

///|
pub fn DragStartEvent::target(self : Self) -> Element {
  self.to_js().get("target").cast()
}

///|
#external
pub type DragEvent

///|
pub impl Js for DragEvent with to_js(self) -> Val {
  self |> js
}

///|
pub fn DragEvent::target(self : Self) -> Element {
  self.to_js().get("target").cast()
}

///|
#external
pub type DragEnterEvent

///|
pub impl Js for DragEnterEvent with to_js(self) -> Val {
  self |> js
}

///|
pub fn DragEnterEvent::target(self : Self) -> Element {
  self.to_js().get("target").cast()
}

///|
#external
pub type DragOverEvent

///|
pub impl Js for DragOverEvent with to_js(self) -> Val {
  self |> js
}

///|
pub fn DragOverEvent::target(self : Self) -> Element {
  self.to_js().get("target").cast()
}

///|
#external
pub type DragLeaveEvent

///|
pub impl Js for DragLeaveEvent with to_js(self) -> Val {
  self |> js
}

///|
pub fn DragLeaveEvent::target(self : Self) -> Element {
  self.to_js().get("target").cast()
}

///|
#external
pub type DragEndEvent

///|
pub impl Js for DragEndEvent with to_js(self) -> Val {
  self |> js
}

///|
pub fn DragEndEvent::target(self : Self) -> Element {
  self.to_js().get("target").cast()
}

///|
#external
pub type DropEvent

///|
pub impl Js for DropEvent with to_js(self) -> Val {
  self |> js
}

///|
pub fn DragEvent::data_transfer(self : Self) -> Val {
  self.to_js().get("dataTransfer")
}
