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
pub fn FireEvent::click(self : FireEvent, target : @dom.HTMLElement) -> Bool {
  self.call1("click", target).cast()
}

///|
/// JS: fireEvent.dblClick(target)
pub fn FireEvent::dblClick(self : FireEvent, target : @dom.HTMLElement) -> Bool {
  self.call1("dblClick", target).cast()
}

///|
/// JS: fireEvent.change(target, event)
pub fn FireEvent::change(
  self : FireEvent,
  target : @dom.HTMLElement,
  event : @js.Any,
) -> Bool {
  self.call2("change", target, event).cast()
}

///|
/// JS: fireEvent.input(target, event)
pub fn FireEvent::input(
  self : FireEvent,
  target : @dom.HTMLElement,
  event : @js.Any,
) -> Bool {
  self.call2("input", target, event).cast()
}

///|
/// JS: fireEvent.submit(target)
pub fn FireEvent::submit(self : FireEvent, target : @dom.HTMLElement) -> Bool {
  self.call1("submit", target).cast()
}

///|
/// JS: fireEvent.focus(target)
pub fn FireEvent::focus(self : FireEvent, target : @dom.HTMLElement) -> Bool {
  self.call1("focus", target).cast()
}

///|
/// JS: fireEvent.blur(target)
pub fn FireEvent::blur(self : FireEvent, target : @dom.HTMLElement) -> Bool {
  self.call1("blur", target).cast()
}

///|
/// JS: fireEvent.keyDown(target, event)
pub fn FireEvent::keyDown(
  self : FireEvent,
  target : @dom.HTMLElement,
  event : @js.Any,
) -> Bool {
  self.call2("keyDown", target, event).cast()
}

///|
/// JS: fireEvent.keyUp(target, event)
pub fn FireEvent::keyUp(
  self : FireEvent,
  target : @dom.HTMLElement,
  event : @js.Any,
) -> Bool {
  self.call2("keyUp", target, event).cast()
}

///|
/// JS: fireEvent.keyPress(target, event)
pub fn FireEvent::keyPress(
  self : FireEvent,
  target : @dom.HTMLElement,
  event : @js.Any,
) -> Bool {
  self.call2("keyPress", target, event).cast()
}

///|
/// JS: fireEvent.mouseDown(target)
pub fn FireEvent::mouseDown(
  self : FireEvent,
  target : @dom.HTMLElement,
) -> Bool {
  self.call1("mouseDown", target).cast()
}

///|
/// JS: fireEvent.mouseUp(target)
pub fn FireEvent::mouseUp(self : FireEvent, target : @dom.HTMLElement) -> Bool {
  self.call1("mouseUp", target).cast()
}

///|
/// JS: fireEvent.mouseEnter(target)
pub fn FireEvent::mouseEnter(
  self : FireEvent,
  target : @dom.HTMLElement,
) -> Bool {
  self.call1("mouseEnter", target).cast()
}

///|
/// JS: fireEvent.mouseLeave(target)
pub fn FireEvent::mouseLeave(
  self : FireEvent,
  target : @dom.HTMLElement,
) -> Bool {
  self.call1("mouseLeave", target).cast()
}

///|
/// JS: fireEvent.mouseMove(target)
pub fn FireEvent::mouseMove(
  self : FireEvent,
  target : @dom.HTMLElement,
) -> Bool {
  self.call1("mouseMove", target).cast()
}

///|
/// JS: fireEvent.mouseOver(target)
pub fn FireEvent::mouseOver(
  self : FireEvent,
  target : @dom.HTMLElement,
) -> Bool {
  self.call1("mouseOver", target).cast()
}

///|
/// JS: fireEvent.mouseOut(target)
pub fn FireEvent::mouseOut(self : FireEvent, target : @dom.HTMLElement) -> Bool {
  self.call1("mouseOut", target).cast()
}

///|
/// JS: fireEvent.scroll(target)
pub fn FireEvent::scroll(self : FireEvent, target : @dom.HTMLElement) -> Bool {
  self.call1("scroll", target).cast()
}

///|
/// JS: fireEvent.drag(target)
pub fn FireEvent::drag(self : FireEvent, target : @dom.HTMLElement) -> Bool {
  self.call1("drag", target).cast()
}

///|
/// JS: fireEvent.drop(target)
pub fn FireEvent::drop(self : FireEvent, target : @dom.HTMLElement) -> Bool {
  self.call1("drop", target).cast()
}

///|
/// JS: fireEvent.dragStart(target)
pub fn FireEvent::dragStart(
  self : FireEvent,
  target : @dom.HTMLElement,
) -> Bool {
  self.call1("dragStart", target).cast()
}

///|
/// JS: fireEvent.dragEnd(target)
pub fn FireEvent::dragEnd(self : FireEvent, target : @dom.HTMLElement) -> Bool {
  self.call1("dragEnd", target).cast()
}

///|
/// JS: fireEvent.dragEnter(target)
pub fn FireEvent::dragEnter(
  self : FireEvent,
  target : @dom.HTMLElement,
) -> Bool {
  self.call1("dragEnter", target).cast()
}

///|
/// JS: fireEvent.dragLeave(target)
pub fn FireEvent::dragLeave(
  self : FireEvent,
  target : @dom.HTMLElement,
) -> Bool {
  self.call1("dragLeave", target).cast()
}

///|
/// JS: fireEvent.dragOver(target)
pub fn FireEvent::dragOver(self : FireEvent, target : @dom.HTMLElement) -> Bool {
  self.call1("dragOver", target).cast()
}

///|
/// JS: fireEvent.copy(target)
pub fn FireEvent::copy(self : FireEvent, target : @dom.HTMLElement) -> Bool {
  self.call1("copy", target).cast()
}

///|
/// JS: fireEvent.cut(target)
pub fn FireEvent::cut(self : FireEvent, target : @dom.HTMLElement) -> Bool {
  self.call1("cut", target).cast()
}

///|
/// JS: fireEvent.paste(target)
pub fn FireEvent::paste(self : FireEvent, target : @dom.HTMLElement) -> Bool {
  self.call1("paste", target).cast()
}

///|
/// JS: fireEvent.select(target)
pub fn FireEvent::select(self : FireEvent, target : @dom.HTMLElement) -> Bool {
  self.call1("select", target).cast()
}

///|
/// JS: fireEvent.touchStart(target)
pub fn FireEvent::touchStart(
  self : FireEvent,
  target : @dom.HTMLElement,
) -> Bool {
  self.call1("touchStart", target).cast()
}

///|
/// JS: fireEvent.touchEnd(target)
pub fn FireEvent::touchEnd(self : FireEvent, target : @dom.HTMLElement) -> Bool {
  self.call1("touchEnd", target).cast()
}

///|
/// JS: fireEvent.touchMove(target)
pub fn FireEvent::touchMove(
  self : FireEvent,
  target : @dom.HTMLElement,
) -> Bool {
  self.call1("touchMove", target).cast()
}

///|
/// JS: fireEvent.touchCancel(target)
pub fn FireEvent::touchCancel(
  self : FireEvent,
  target : @dom.HTMLElement,
) -> Bool {
  self.call1("touchCancel", target).cast()
}

///|
/// JS: fireEvent.load(target)
pub fn FireEvent::load(self : FireEvent, target : @dom.HTMLElement) -> Bool {
  self.call1("load", target).cast()
}

///|
/// JS: fireEvent.error(target)
pub fn FireEvent::error(self : FireEvent, target : @dom.HTMLElement) -> Bool {
  self.call1("error", target).cast()
}

///|
/// JS: fireEvent.contextMenu(target)
pub fn FireEvent::contextMenu(
  self : FireEvent,
  target : @dom.HTMLElement,
) -> Bool {
  self.call1("contextMenu", target).cast()
}
