///|
/// Event - Base interface for all DOM events
/// https://developer.mozilla.org/en-US/docs/Web/API/Event
#external
pub type Event

///|
pub fn Event::as_any(self : Event) -> @core.Any = "%identity"

///|
/// Create a new Event
pub fn Event::new(
  event_type : String,
  bubbles? : Bool,
  cancelable? : Bool,
) -> Event {
  let entries : Array[(String, @core.Any)] = []
  if bubbles is Some(v) {
    entries.push(("bubbles", @core.any(v)))
  }
  if cancelable is Some(v) {
    entries.push(("cancelable", @core.any(v)))
  }
  ffi_new_event(event_type, @core.from_entries(entries))
}

///|
extern "js" fn ffi_new_event(event_type : String, options : @core.Any) -> Event =
  #|(type, options) => new Event(type, options)

///|
/// Get the event type
pub extern "js" fn Event::type_(self : Event) -> String =
  #| (self) => self.type

///|
/// Get the event target
pub extern "js" fn Event::target(self : Event) -> EventTarget? =
  #| (self) => self.target

///|
/// Get the current target
pub extern "js" fn Event::currentTarget(self : Event) -> EventTarget? =
  #| (self) => self.currentTarget

///|
/// Check if the event bubbles
pub extern "js" fn Event::bubbles(self : Event) -> Bool =
  #| (self) => self.bubbles

///|
/// Check if the event is cancelable
pub extern "js" fn Event::cancelable(self : Event) -> Bool =
  #| (self) => self.cancelable

///|
/// Prevent the default action
pub extern "js" fn Event::preventDefault(self : Event) -> Unit =
  #| (self) => self.preventDefault()

///|
/// Stop event propagation
pub extern "js" fn Event::stopPropagation(self : Event) -> Unit =
  #| (self) => self.stopPropagation()

///|
/// Stop immediate propagation
pub extern "js" fn Event::stopImmediatePropagation(self : Event) -> Unit =
  #| (self) => self.stopImmediatePropagation()

///|
/// Check if default was prevented
pub extern "js" fn Event::defaultPrevented(self : Event) -> Bool =
  #| (self) => self.defaultPrevented

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/Event/target
/// EventTarget is the base interface for objects that can receive events.
/// Types that can be event targets should provide as_event_target() method.
#external
pub type EventTarget

///|
pub fn EventTarget::as_any(self : EventTarget) -> @core.Any = "%identity"

///|
/// Add an event listener for the specified event type
/// This is the primary method for registering event handlers
#alias(add_event_listener)
pub fn EventTarget::addEventListener(
  self : EventTarget,
  event_type : String,
  handler : (@core.Any) -> Unit,
  capture? : Bool = false,
  once? : Bool = false,
  passive? : Bool = false,
  signal? : @js.AbortSignal,
) -> Unit {
  let entries : Array[(String, @core.Any)] = []
  entries.push(("capture", @core.any(capture)))
  entries.push(("once", @core.any(once)))
  entries.push(("passive", @core.any(passive)))
  if signal is Some(v) {
    entries.push(("signal", v |> @core.identity))
  }
  self
  .as_any()
  ._call("addEventListener", [
    @core.any(event_type),
    @core.any(@js.from_fn1(handler)),
    @core.from_entries(entries),
  ])
  |> ignore
}

///|
/// Short alias for addEventListener
pub fn EventTarget::on(
  self : EventTarget,
  event_type : String,
  handler : (@core.Any) -> Unit,
  capture? : Bool = false,
  once? : Bool = false,
  passive? : Bool = false,
  signal? : @js.AbortSignal,
) -> Unit {
  self.addEventListener(event_type, handler, capture~, once~, passive~, signal?)
}

///|
/// Remove a previously registered event listener
#alias(remove_event_listener)
pub fn EventTarget::removeEventListener(
  self : EventTarget,
  event_type : String,
  handler : (@core.Any) -> Unit,
  capture? : Bool = false,
) -> Unit {
  self
  .as_any()
  ._call("removeEventListener", [
    @core.any(event_type),
    @core.any(@js.from_fn1(handler)),
    @core.from_entries([("capture", @core.any(capture))]),
  ])
  |> ignore
}

///|
/// Short alias for removeEventListener
pub fn EventTarget::off(
  self : EventTarget,
  event_type : String,
  handler : (@core.Any) -> Unit,
  capture? : Bool = false,
) -> Unit {
  self.removeEventListener(event_type, handler, capture~)
}

///|
/// Dispatch an event to this target
#alias(dispatch_event)
pub fn EventTarget::dispatchEvent(self : EventTarget, event : Event) -> Bool {
  self.as_any()._call("dispatchEvent", [event.as_any()]).cast()
}
