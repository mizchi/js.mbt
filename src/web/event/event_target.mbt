///|
/// Event - Base interface for all DOM events
/// https://developer.mozilla.org/en-US/docs/Web/API/Event
#external
pub type Event

///|
pub fn Event::as_any(self : Event) -> @nostd.Any = "%identity"

///|
/// Create a new Event
pub fn Event::new(
  event_type : String,
  bubbles? : Bool,
  cancelable? : Bool,
) -> Event {
  ffi_new_event(
    event_type,
    @mbtconv.from_option_map({
      "bubbles": bubbles.map(fn(x) { @nostd.any(x) }),
      "cancelable": cancelable.map(fn(x) { @nostd.any(x) }),
    }).cast(),
  )
}

///|
extern "js" fn ffi_new_event(event_type : String, options : @nostd.Any) -> Event =
  #|(type, options) => new Event(type, options)

///|
/// Get the event type
pub fn Event::type_(self : Event) -> String {
  self.as_any()._get("type").cast()
}

///|
/// Get the event target
pub fn Event::target(self : Event) -> EventTarget? {
  let v : @nostd.Any = self.as_any()._get("target").cast()
  v |> @nostd.identity_option
}

///|
/// Get the current target
pub fn Event::currentTarget(self : Event) -> EventTarget? {
  let v : @nostd.Any = self.as_any()._get("currentTarget").cast()
  v |> @nostd.identity_option
}

///|
/// Check if the event bubbles
pub fn Event::bubbles(self : Event) -> Bool {
  self.as_any()._get("bubbles").cast()
}

///|
/// Check if the event is cancelable
pub fn Event::cancelable(self : Event) -> Bool {
  self.as_any()._get("cancelable").cast()
}

///|
/// Prevent the default action
pub fn Event::preventDefault(self : Event) -> Unit {
  self.as_any()._call("preventDefault", []) |> ignore
}

///|
/// Stop event propagation
pub fn Event::stopPropagation(self : Event) -> Unit {
  self.as_any()._call("stopPropagation", []) |> ignore
}

///|
/// Stop immediate propagation
pub fn Event::stopImmediatePropagation(self : Event) -> Unit {
  self.as_any()._call("stopImmediatePropagation", []) |> ignore
}

///|
/// Check if default was prevented
pub fn Event::defaultPrevented(self : Event) -> Bool {
  self.as_any()._get("defaultPrevented").cast()
}

///|
/// @deprecated Use as_event_target() pattern instead
/// Generic event target trait - kept for backward compatibility
pub(open) trait EventTargetImpl {
  as_any(Self) -> @nostd.Any
  addEventListener(
    Self,
    String,
    (@nostd.Any) -> Unit,
    capture? : Bool,
    once? : Bool,
    passive? : Bool,
    signal? : @js.AbortSignal,
  ) -> Unit = _
  removeEventListener(Self, String, (@nostd.Any) -> Unit, capture? : Bool) -> Unit = _
  dispatchEvent(Self, Event) -> Bool = _
}

///|
impl EventTargetImpl with addEventListener(
  self,
  event_type,
  handler,
  capture? : Bool = false,
  once? : Bool = false,
  passive? : Bool = false,
  signal? : @js.AbortSignal,
) -> Unit {
  self
  .as_any()
  ._call("addEventListener", [
    @nostd.any(event_type),
    @nostd.any(@js.from_fn1(handler)),
    @mbtconv.from_option_map({
      "capture": Some(@nostd.any(capture)),
      "once": Some(@nostd.any(once)),
      "passive": Some(@nostd.any(passive)),
      "signal": signal.map(fn(x) { x |> @nostd.identity }),
    }),
  ])
  |> ignore
}

///|
impl EventTargetImpl with removeEventListener(
  self,
  event_type,
  handler,
  capture? : Bool = false,
) -> Unit {
  self
  .as_any()
  ._call("removeEventListener", [
    @nostd.any(event_type),
    @nostd.any(@js.from_fn1(handler)),
    @mbtconv.from_option_map({ "capture": Some(@nostd.any(capture)) }),
  ])
  |> ignore
}

///|
impl EventTargetImpl with dispatchEvent(self, event) -> Bool {
  self.as_any()._call("dispatchEvent", [event.as_any()]).cast()
}

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/Event/target
/// EventTarget is the base interface for objects that can receive events.
/// Types that can be event targets should provide as_event_target() method.
#external
pub type EventTarget

///|
pub fn EventTarget::as_any(self : EventTarget) -> @nostd.Any = "%identity"

///|
pub impl EventTargetImpl for EventTarget with as_any(self) -> @nostd.Any {
  self.as_any()
}

///|
/// Add an event listener for the specified event type
/// This is the primary method for registering event handlers
#alias(add_event_listener)
pub fn EventTarget::addEventListener(
  self : EventTarget,
  event_type : String,
  handler : (@nostd.Any) -> Unit,
  capture? : Bool = false,
  once? : Bool = false,
  passive? : Bool = false,
  signal? : @js.AbortSignal,
) -> Unit {
  self
  .as_any()
  ._call("addEventListener", [
    @nostd.any(event_type),
    @nostd.any(@js.from_fn1(handler)),
    @mbtconv.from_option_map({
      "capture": Some(@nostd.any(capture)),
      "once": Some(@nostd.any(once)),
      "passive": Some(@nostd.any(passive)),
      "signal": signal.map(fn(x) { x |> @nostd.identity }),
    }),
  ])
  |> ignore
}

///|
/// Short alias for addEventListener
pub fn EventTarget::on(
  self : EventTarget,
  event_type : String,
  handler : (@nostd.Any) -> Unit,
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
  handler : (@nostd.Any) -> Unit,
  capture? : Bool = false,
) -> Unit {
  self
  .as_any()
  ._call("removeEventListener", [
    @nostd.any(event_type),
    @nostd.any(@js.from_fn1(handler)),
    @mbtconv.from_option_map({ "capture": Some(@nostd.any(capture)) }),
  ])
  |> ignore
}

///|
/// Short alias for removeEventListener
pub fn EventTarget::off(
  self : EventTarget,
  event_type : String,
  handler : (@nostd.Any) -> Unit,
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
