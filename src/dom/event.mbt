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
#external
pub type MouseEvent

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
#external
pub type KeyboardEvent

///|
pub fn KeyboardEvent::target(self : KeyboardEvent) -> Element {
  let value : Value = self |> @js.identity
  value.get("target").cast()
}

///|
pub fn KeyboardEvent::key(self : KeyboardEvent) -> String {
  let value : Value = self |> @js.identity
  value.get("key").cast()
}

///|
pub fn KeyboardEvent::key_code(self : KeyboardEvent) -> Int {
  let value : Value = self |> @js.identity
  value.get("keyCode").cast()
}

///|
pub fn KeyboardEvent::which(self : KeyboardEvent) -> Int {
  let value : Value = self |> @js.identity
  value.get("which").cast()
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
  let value : Value = self |> @js.identity
  value.get("altKey").cast()
}

///|
pub fn KeyboardEvent::shift_key(self : KeyboardEvent) -> Bool {
  let value : Value = self |> @js.identity
  value.get("shiftKey").cast()
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

///|
pub fn FocusEvent::target(self : FocusEvent) -> Element {
  let value : Value = self |> @js.identity
  value.get("target").cast()
}

///|
#external
pub type FormEvent

///|
pub fn FormEvent::target(self : FormEvent) -> Element {
  let value : Value = self |> @js.identity
  value.get("target").cast()
}

///|
pub fn FormEvent::current_target(self : FormEvent) -> Element {
  let value : Value = self |> @js.identity
  value.get("currentTarget").cast()
}

///|
pub fn FormEvent::form_data(self : FormEvent) -> Element {
  let value : Value = self |> @js.identity
  value.get("formData").cast()
}

///|
