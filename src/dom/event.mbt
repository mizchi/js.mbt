///|
#external
pub type Event

///|
pub extern "js" fn Event::prevent_default(self : Event) -> Unit =
  #| (event) => event.preventDefault()

///|
pub extern "js" fn Event::stop_propagation(self : Event) -> Unit =
  #| (event) => event.stopPropagation()

///|
pub extern "js" fn Event::target(self : Event) -> Element =
  #| (event) => event.target

///|
pub struct MouseEvent(Value)

///|
pub fn MouseEvent::from(value : Value) -> MouseEvent {
  MouseEvent(value.cast())
}

///|
pub extern "js" fn MouseEvent::client_x(self : MouseEvent) -> Int =
  #| (event) => event.clientX

///|
pub extern "js" fn MouseEvent::client_y(self : MouseEvent) -> Int =
  #| (event) => event.clientY

///|
/// screenX
pub extern "js" fn MouseEvent::screen_x(self : MouseEvent) -> Int =
  #| (event) => event.screenX

///|
pub extern "js" fn MouseEvent::screen_y(self : MouseEvent) -> Int =
  #| (event) => event.screenY

///|
pub struct KeyboardEvent(Value)

///|
pub fn KeyboardEvent::from(value : Value) -> KeyboardEvent {
  KeyboardEvent(value)
}

///|
pub fn KeyboardEvent::target(self : KeyboardEvent) -> Element {
  self.0.get("target").cast()
}

///|
pub fn KeyboardEvent::key(self : KeyboardEvent) -> String {
  self.0.get("key").cast()
}

///|
pub fn KeyboardEvent::key_code(self : KeyboardEvent) -> Int {
  self.0.get("keyCode").cast()
}

///|
pub fn KeyboardEvent::which(self : KeyboardEvent) -> Int {
  self.0.get("which").cast()
}

///|
pub fn KeyboardEvent::code(self : KeyboardEvent) -> String {
  self.0.get("code").cast()
}

///|
pub fn KeyboardEvent::ctrl_key(self : KeyboardEvent) -> Bool {
  self.0.get("ctrlKey").cast()
}

///|
pub fn KeyboardEvent::alt_key(self : KeyboardEvent) -> Bool {
  self.0.get("altKey").cast()
}

///|
pub fn KeyboardEvent::shift_key(self : KeyboardEvent) -> Bool {
  self.0.get("shiftKey").cast()
}

///|
pub struct ChangeEvent(Value)

///|
pub fn ChangeEvent::from(value : Value) -> ChangeEvent {
  ChangeEvent(value)
}

///|
pub fn ChangeEvent::target(self : ChangeEvent) -> Element {
  self.0.get("target").cast()
}

///|
pub struct FocusEvent(Value)

///|
pub fn FocusEvent::from(value : Value) -> FocusEvent {
  FocusEvent(value)
}

///|
pub fn FocusEvent::target(self : FocusEvent) -> Element {
  self.0.get("target").cast()
}
