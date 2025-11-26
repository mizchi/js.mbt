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
  rtl.get("fireEvent").cast()
}

///|
/// JS: fireEvent.click(target)
pub fn FireEvent::click(self : FireEvent, target : ScreenResult) -> Bool {
  self.call1("click", target.as_element()).cast()
}

///|
/// JS: fireEvent.dblClick(target)
pub fn FireEvent::dblClick(self : FireEvent, target : ScreenResult) -> Bool {
  self.call1("dblClick", target.as_element()).cast()
}

///|
/// JS: fireEvent.change(target, event)
pub fn FireEvent::change(
  self : FireEvent,
  target : ScreenResult,
  event : @js.Any,
) -> Bool {
  self.call2("change", target.as_element(), event).cast()
}

///|
/// JS: fireEvent.input(target, event)
pub fn FireEvent::input(
  self : FireEvent,
  target : ScreenResult,
  event : @js.Any,
) -> Bool {
  self.call2("input", target.as_element(), event).cast()
}

///|
/// JS: fireEvent.submit(target) - for HTMLElement (e.g., form element)
pub fn FireEvent::submit(self : FireEvent, target : @dom.HTMLElement) -> Bool {
  self.call1("submit", target).cast()
}

///|
/// JS: fireEvent.focus(target)
pub fn FireEvent::focus(self : FireEvent, target : ScreenResult) -> Bool {
  self.call1("focus", target.as_element()).cast()
}

///|
/// JS: fireEvent.blur(target)
pub fn FireEvent::blur(self : FireEvent, target : ScreenResult) -> Bool {
  self.call1("blur", target.as_element()).cast()
}

///|
/// JS: fireEvent.keyDown(target, event)
pub fn FireEvent::keyDown(
  self : FireEvent,
  target : ScreenResult,
  event : @js.Any,
) -> Bool {
  self.call2("keyDown", target.as_element(), event).cast()
}

///|
/// JS: fireEvent.keyUp(target, event)
pub fn FireEvent::keyUp(
  self : FireEvent,
  target : ScreenResult,
  event : @js.Any,
) -> Bool {
  self.call2("keyUp", target.as_element(), event).cast()
}

///|
/// JS: fireEvent.keyPress(target, event)
pub fn FireEvent::keyPress(
  self : FireEvent,
  target : ScreenResult,
  event : @js.Any,
) -> Bool {
  self.call2("keyPress", target.as_element(), event).cast()
}

///|
/// JS: fireEvent.mouseDown(target)
pub fn FireEvent::mouseDown(self : FireEvent, target : ScreenResult) -> Bool {
  self.call1("mouseDown", target.as_element()).cast()
}

///|
/// JS: fireEvent.mouseUp(target)
pub fn FireEvent::mouseUp(self : FireEvent, target : ScreenResult) -> Bool {
  self.call1("mouseUp", target.as_element()).cast()
}

///|
/// JS: fireEvent.mouseEnter(target)
pub fn FireEvent::mouseEnter(self : FireEvent, target : ScreenResult) -> Bool {
  self.call1("mouseEnter", target.as_element()).cast()
}

///|
/// JS: fireEvent.mouseLeave(target)
pub fn FireEvent::mouseLeave(self : FireEvent, target : ScreenResult) -> Bool {
  self.call1("mouseLeave", target.as_element()).cast()
}

///|
/// JS: fireEvent.mouseMove(target)
pub fn FireEvent::mouseMove(self : FireEvent, target : ScreenResult) -> Bool {
  self.call1("mouseMove", target.as_element()).cast()
}

///|
/// JS: fireEvent.mouseOver(target)
pub fn FireEvent::mouseOver(self : FireEvent, target : ScreenResult) -> Bool {
  self.call1("mouseOver", target.as_element()).cast()
}

///|
/// JS: fireEvent.mouseOut(target)
pub fn FireEvent::mouseOut(self : FireEvent, target : ScreenResult) -> Bool {
  self.call1("mouseOut", target.as_element()).cast()
}

///|
/// JS: fireEvent.scroll(target)
pub fn FireEvent::scroll(self : FireEvent, target : ScreenResult) -> Bool {
  self.call1("scroll", target.as_element()).cast()
}

///|
/// JS: fireEvent.drag(target)
pub fn FireEvent::drag(self : FireEvent, target : ScreenResult) -> Bool {
  self.call1("drag", target.as_element()).cast()
}

///|
/// JS: fireEvent.drop(target)
pub fn FireEvent::drop(self : FireEvent, target : ScreenResult) -> Bool {
  self.call1("drop", target.as_element()).cast()
}

///|
/// JS: fireEvent.dragStart(target)
pub fn FireEvent::dragStart(self : FireEvent, target : ScreenResult) -> Bool {
  self.call1("dragStart", target.as_element()).cast()
}

///|
/// JS: fireEvent.dragEnd(target)
pub fn FireEvent::dragEnd(self : FireEvent, target : ScreenResult) -> Bool {
  self.call1("dragEnd", target.as_element()).cast()
}

///|
/// JS: fireEvent.dragEnter(target)
pub fn FireEvent::dragEnter(self : FireEvent, target : ScreenResult) -> Bool {
  self.call1("dragEnter", target.as_element()).cast()
}

///|
/// JS: fireEvent.dragLeave(target)
pub fn FireEvent::dragLeave(self : FireEvent, target : ScreenResult) -> Bool {
  self.call1("dragLeave", target.as_element()).cast()
}

///|
/// JS: fireEvent.dragOver(target)
pub fn FireEvent::dragOver(self : FireEvent, target : ScreenResult) -> Bool {
  self.call1("dragOver", target.as_element()).cast()
}

///|
/// JS: fireEvent.copy(target)
pub fn FireEvent::copy(self : FireEvent, target : ScreenResult) -> Bool {
  self.call1("copy", target.as_element()).cast()
}

///|
/// JS: fireEvent.cut(target)
pub fn FireEvent::cut(self : FireEvent, target : ScreenResult) -> Bool {
  self.call1("cut", target.as_element()).cast()
}

///|
/// JS: fireEvent.paste(target)
pub fn FireEvent::paste(self : FireEvent, target : ScreenResult) -> Bool {
  self.call1("paste", target.as_element()).cast()
}

///|
/// JS: fireEvent.select(target)
pub fn FireEvent::select(self : FireEvent, target : ScreenResult) -> Bool {
  self.call1("select", target.as_element()).cast()
}

///|
/// JS: fireEvent.touchStart(target)
pub fn FireEvent::touchStart(self : FireEvent, target : ScreenResult) -> Bool {
  self.call1("touchStart", target.as_element()).cast()
}

///|
/// JS: fireEvent.touchEnd(target)
pub fn FireEvent::touchEnd(self : FireEvent, target : ScreenResult) -> Bool {
  self.call1("touchEnd", target.as_element()).cast()
}

///|
/// JS: fireEvent.touchMove(target)
pub fn FireEvent::touchMove(self : FireEvent, target : ScreenResult) -> Bool {
  self.call1("touchMove", target.as_element()).cast()
}

///|
/// JS: fireEvent.touchCancel(target)
pub fn FireEvent::touchCancel(self : FireEvent, target : ScreenResult) -> Bool {
  self.call1("touchCancel", target.as_element()).cast()
}

///|
/// JS: fireEvent.load(target)
pub fn FireEvent::load(self : FireEvent, target : ScreenResult) -> Bool {
  self.call1("load", target.as_element()).cast()
}

///|
/// JS: fireEvent.error(target)
pub fn FireEvent::error(self : FireEvent, target : ScreenResult) -> Bool {
  self.call1("error", target.as_element()).cast()
}

///|
/// JS: fireEvent.contextMenu(target)
pub fn FireEvent::contextMenu(self : FireEvent, target : ScreenResult) -> Bool {
  self.call1("contextMenu", target.as_element()).cast()
}
