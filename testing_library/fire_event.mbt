///|
/// FireEvent type - common for all testing libraries
#external
pub type FireEvent

///|
pub fn FireEvent::as_any(self : FireEvent) -> @core.Any = "%identity"

///|
/// JS: fireEvent.click(target)
pub fn FireEvent::click(self : FireEvent, target : ScreenResult) -> Bool {
  self.as_any()._call("click", [target.as_element().as_any()]).cast()
}

///|
/// JS: fireEvent.dblClick(target)
pub fn FireEvent::dblClick(self : FireEvent, target : ScreenResult) -> Bool {
  self.as_any()._call("dblClick", [target.as_element().as_any()]).cast()
}

///|
/// JS: fireEvent.change(target, event)
pub fn FireEvent::change(
  self : FireEvent,
  target : ScreenResult,
  event : @core.Any,
) -> Bool {
  self.as_any()._call("change", [target.as_element().as_any(), event]).cast()
}

///|
/// JS: fireEvent.input(target, event)
pub fn FireEvent::input(
  self : FireEvent,
  target : ScreenResult,
  event : @core.Any,
) -> Bool {
  self.as_any()._call("input", [target.as_element().as_any(), event]).cast()
}

///|
/// JS: fireEvent.submit(target) - for HTMLElement (e.g., form element)
pub fn FireEvent::submit(self : FireEvent, target : @dom.HTMLElement) -> Bool {
  self.as_any()._call("submit", [target.as_any()]).cast()
}

///|
/// JS: fireEvent.focus(target)
pub fn FireEvent::focus(self : FireEvent, target : ScreenResult) -> Bool {
  self.as_any()._call("focus", [target.as_element().as_any()]).cast()
}

///|
/// JS: fireEvent.blur(target)
pub fn FireEvent::blur(self : FireEvent, target : ScreenResult) -> Bool {
  self.as_any()._call("blur", [target.as_element().as_any()]).cast()
}

///|
/// JS: fireEvent.keyDown(target, event)
pub fn FireEvent::keyDown(
  self : FireEvent,
  target : ScreenResult,
  event : @core.Any,
) -> Bool {
  self.as_any()._call("keyDown", [target.as_element().as_any(), event]).cast()
}

///|
/// JS: fireEvent.keyUp(target, event)
pub fn FireEvent::keyUp(
  self : FireEvent,
  target : ScreenResult,
  event : @core.Any,
) -> Bool {
  self.as_any()._call("keyUp", [target.as_element().as_any(), event]).cast()
}

///|
/// JS: fireEvent.keyPress(target, event)
pub fn FireEvent::keyPress(
  self : FireEvent,
  target : ScreenResult,
  event : @core.Any,
) -> Bool {
  self.as_any()._call("keyPress", [target.as_element().as_any(), event]).cast()
}

///|
/// JS: fireEvent.mouseDown(target)
pub fn FireEvent::mouseDown(self : FireEvent, target : ScreenResult) -> Bool {
  self.as_any()._call("mouseDown", [target.as_element().as_any()]).cast()
}

///|
/// JS: fireEvent.mouseUp(target)
pub fn FireEvent::mouseUp(self : FireEvent, target : ScreenResult) -> Bool {
  self.as_any()._call("mouseUp", [target.as_element().as_any()]).cast()
}

///|
/// JS: fireEvent.mouseEnter(target)
pub fn FireEvent::mouseEnter(self : FireEvent, target : ScreenResult) -> Bool {
  self.as_any()._call("mouseEnter", [target.as_element().as_any()]).cast()
}

///|
/// JS: fireEvent.mouseLeave(target)
pub fn FireEvent::mouseLeave(self : FireEvent, target : ScreenResult) -> Bool {
  self.as_any()._call("mouseLeave", [target.as_element().as_any()]).cast()
}

///|
/// JS: fireEvent.mouseMove(target)
pub fn FireEvent::mouseMove(self : FireEvent, target : ScreenResult) -> Bool {
  self.as_any()._call("mouseMove", [target.as_element().as_any()]).cast()
}

///|
/// JS: fireEvent.mouseOver(target)
pub fn FireEvent::mouseOver(self : FireEvent, target : ScreenResult) -> Bool {
  self.as_any()._call("mouseOver", [target.as_element().as_any()]).cast()
}

///|
/// JS: fireEvent.mouseOut(target)
pub fn FireEvent::mouseOut(self : FireEvent, target : ScreenResult) -> Bool {
  self.as_any()._call("mouseOut", [target.as_element().as_any()]).cast()
}

///|
/// JS: fireEvent.scroll(target)
pub fn FireEvent::scroll(self : FireEvent, target : ScreenResult) -> Bool {
  self.as_any()._call("scroll", [target.as_element().as_any()]).cast()
}

///|
/// JS: fireEvent.drag(target)
pub fn FireEvent::drag(self : FireEvent, target : ScreenResult) -> Bool {
  self.as_any()._call("drag", [target.as_element().as_any()]).cast()
}

///|
/// JS: fireEvent.drop(target)
pub fn FireEvent::drop(self : FireEvent, target : ScreenResult) -> Bool {
  self.as_any()._call("drop", [target.as_element().as_any()]).cast()
}

///|
/// JS: fireEvent.dragStart(target)
pub fn FireEvent::dragStart(self : FireEvent, target : ScreenResult) -> Bool {
  self.as_any()._call("dragStart", [target.as_element().as_any()]).cast()
}

///|
/// JS: fireEvent.dragEnd(target)
pub fn FireEvent::dragEnd(self : FireEvent, target : ScreenResult) -> Bool {
  self.as_any()._call("dragEnd", [target.as_element().as_any()]).cast()
}

///|
/// JS: fireEvent.dragEnter(target)
pub fn FireEvent::dragEnter(self : FireEvent, target : ScreenResult) -> Bool {
  self.as_any()._call("dragEnter", [target.as_element().as_any()]).cast()
}

///|
/// JS: fireEvent.dragLeave(target)
pub fn FireEvent::dragLeave(self : FireEvent, target : ScreenResult) -> Bool {
  self.as_any()._call("dragLeave", [target.as_element().as_any()]).cast()
}

///|
/// JS: fireEvent.dragOver(target)
pub fn FireEvent::dragOver(self : FireEvent, target : ScreenResult) -> Bool {
  self.as_any()._call("dragOver", [target.as_element().as_any()]).cast()
}

///|
/// JS: fireEvent.copy(target)
pub fn FireEvent::copy(self : FireEvent, target : ScreenResult) -> Bool {
  self.as_any()._call("copy", [target.as_element().as_any()]).cast()
}

///|
/// JS: fireEvent.cut(target)
pub fn FireEvent::cut(self : FireEvent, target : ScreenResult) -> Bool {
  self.as_any()._call("cut", [target.as_element().as_any()]).cast()
}

///|
/// JS: fireEvent.paste(target)
pub fn FireEvent::paste(self : FireEvent, target : ScreenResult) -> Bool {
  self.as_any()._call("paste", [target.as_element().as_any()]).cast()
}

///|
/// JS: fireEvent.select(target)
pub fn FireEvent::select(self : FireEvent, target : ScreenResult) -> Bool {
  self.as_any()._call("select", [target.as_element().as_any()]).cast()
}

///|
/// JS: fireEvent.touchStart(target)
pub fn FireEvent::touchStart(self : FireEvent, target : ScreenResult) -> Bool {
  self.as_any()._call("touchStart", [target.as_element().as_any()]).cast()
}

///|
/// JS: fireEvent.touchEnd(target)
pub fn FireEvent::touchEnd(self : FireEvent, target : ScreenResult) -> Bool {
  self.as_any()._call("touchEnd", [target.as_element().as_any()]).cast()
}

///|
/// JS: fireEvent.touchMove(target)
pub fn FireEvent::touchMove(self : FireEvent, target : ScreenResult) -> Bool {
  self.as_any()._call("touchMove", [target.as_element().as_any()]).cast()
}

///|
/// JS: fireEvent.touchCancel(target)
pub fn FireEvent::touchCancel(self : FireEvent, target : ScreenResult) -> Bool {
  self.as_any()._call("touchCancel", [target.as_element().as_any()]).cast()
}

///|
/// JS: fireEvent.load(target)
pub fn FireEvent::load(self : FireEvent, target : ScreenResult) -> Bool {
  self.as_any()._call("load", [target.as_element().as_any()]).cast()
}

///|
/// JS: fireEvent.error(target)
pub fn FireEvent::error(self : FireEvent, target : ScreenResult) -> Bool {
  self.as_any()._call("error", [target.as_element().as_any()]).cast()
}

///|
/// JS: fireEvent.contextMenu(target)
pub fn FireEvent::contextMenu(self : FireEvent, target : ScreenResult) -> Bool {
  self.as_any()._call("contextMenu", [target.as_element().as_any()]).cast()
}
