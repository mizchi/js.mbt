///|
#external
pub type FireEvent

///|
pub impl @js.JsImpl for FireEvent

///|
#alias(fire_event)
pub fn fireEvent() -> FireEvent {
  let vtl = testing_library()
  vtl.get("fireEvent").cast()
}

///|
pub fn FireEvent::click(self : FireEvent, target : ScreenResult) -> Bool {
  self.call1("click", target.as_element()).cast()
}

///|
pub fn FireEvent::dblClick(self : FireEvent, target : ScreenResult) -> Bool {
  self.call1("dblClick", target.as_element()).cast()
}

///|
pub fn FireEvent::change(
  self : FireEvent,
  target : ScreenResult,
  event : @js.Any,
) -> Bool {
  self.call2("change", target.as_element(), event).cast()
}

///|
pub fn FireEvent::input(
  self : FireEvent,
  target : ScreenResult,
  event : @js.Any,
) -> Bool {
  self.call2("input", target.as_element(), event).cast()
}

///|
pub fn FireEvent::submit(self : FireEvent, target : @dom.HTMLElement) -> Bool {
  self.call1("submit", target).cast()
}

///|
pub fn FireEvent::focus(self : FireEvent, target : ScreenResult) -> Bool {
  self.call1("focus", target.as_element()).cast()
}

///|
pub fn FireEvent::blur(self : FireEvent, target : ScreenResult) -> Bool {
  self.call1("blur", target.as_element()).cast()
}

///|
pub fn FireEvent::keyDown(
  self : FireEvent,
  target : ScreenResult,
  event : @js.Any,
) -> Bool {
  self.call2("keyDown", target.as_element(), event).cast()
}

///|
pub fn FireEvent::keyUp(
  self : FireEvent,
  target : ScreenResult,
  event : @js.Any,
) -> Bool {
  self.call2("keyUp", target.as_element(), event).cast()
}

///|
pub fn FireEvent::keyPress(
  self : FireEvent,
  target : ScreenResult,
  event : @js.Any,
) -> Bool {
  self.call2("keyPress", target.as_element(), event).cast()
}

///|
pub fn FireEvent::mouseDown(self : FireEvent, target : ScreenResult) -> Bool {
  self.call1("mouseDown", target.as_element()).cast()
}

///|
pub fn FireEvent::mouseUp(self : FireEvent, target : ScreenResult) -> Bool {
  self.call1("mouseUp", target.as_element()).cast()
}

///|
pub fn FireEvent::mouseEnter(self : FireEvent, target : ScreenResult) -> Bool {
  self.call1("mouseEnter", target.as_element()).cast()
}

///|
pub fn FireEvent::mouseLeave(self : FireEvent, target : ScreenResult) -> Bool {
  self.call1("mouseLeave", target.as_element()).cast()
}

///|
pub fn FireEvent::scroll(self : FireEvent, target : ScreenResult) -> Bool {
  self.call1("scroll", target.as_element()).cast()
}
