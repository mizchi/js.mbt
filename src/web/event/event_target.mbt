///|
/// Event - Base interface for all DOM events
/// https://developer.mozilla.org/en-US/docs/Web/API/Event
#external
pub type Event

///|
pub impl @js.JsImpl for Event

///|
/// Create a new Event
pub fn Event::new(
  event_type : String,
  bubbles? : Bool,
  cancelable? : Bool,
) -> Event {
  ffi_new_event(
    event_type,
    @js.from_option_map({
      "bubbles": bubbles.map(fn(x) { @js.any(x) }),
      "cancelable": cancelable.map(fn(x) { @js.any(x) }),
    }),
  )
}

///|
extern "js" fn ffi_new_event(event_type : String, options : @js.Any) -> Event =
  #|(type, options) => new Event(type, options)

///|
/// Get the event type
pub fn Event::type_(self : Event) -> String {
  self.get("type").cast()
}

///|
/// Get the event target
pub fn Event::target(self : Event) -> EventTarget? {
  self.get("target") |> @js.identity_option
}

///|
/// Get the current target
pub fn Event::currentTarget(self : Event) -> EventTarget? {
  self.get("currentTarget") |> @js.identity_option
}

///|
/// Check if the event bubbles
pub fn Event::bubbles(self : Event) -> Bool {
  self.get("bubbles").cast()
}

///|
/// Check if the event is cancelable
pub fn Event::cancelable(self : Event) -> Bool {
  self.get("cancelable").cast()
}

///|
/// Prevent the default action
pub fn Event::preventDefault(self : Event) -> Unit {
  self.call0("preventDefault") |> ignore
}

///|
/// Stop event propagation
pub fn Event::stopPropagation(self : Event) -> Unit {
  self.call0("stopPropagation") |> ignore
}

///|
/// Stop immediate propagation
pub fn Event::stopImmediatePropagation(self : Event) -> Unit {
  self.call0("stopImmediatePropagation") |> ignore
}

///|
/// Check if default was prevented
pub fn Event::defaultPrevented(self : Event) -> Bool {
  self.get("defaultPrevented").cast()
}

///|
/// Generic EventTarget trait for objects that can receive events
/// This is a base trait used by DOM, Worker, WebSocket, and other Web APIs
///
/// Unlike the DOM-specific EventTarget, this trait uses generic Val for events
/// to support various event types across different APIs.

///|
/// Generic event target trait - base interface for objects that can receive events
/// This trait is implemented by:
/// - DOM elements (Document, Element, Window, etc.)
/// - Worker API (Worker, MessagePort, BroadcastChannel)
/// - Network APIs (WebSocket, EventSource, XMLHttpRequest)
/// - Media APIs (MediaStream, AudioContext, etc.)
pub(open) trait EventTargetImpl: @js.JsImpl {
  /// Add an event listener for the specified event type
  /// The listener receives a generic Val which should be cast to the appropriate event type
  /// Options:
  /// - capture: if true, the listener will be triggered during the capture phase
  /// - once: if true, the listener will be automatically removed after being invoked once
  /// - passive: if true, indicates that the listener will never call preventDefault()
  /// - signal: an @js.AbortSignal to remove the listener when aborted
  addEventListener(
    Self,
    String,
    (@js.Any) -> Unit,
    capture? : Bool,
    once? : Bool,
    passive? : Bool,
    signal? : @js.AbortSignal,
  ) -> Unit = _

  /// Remove a previously registered event listener
  /// Options:
  /// - capture: must match the capture value used when adding the listener
  removeEventListener(Self, String, (@js.Any) -> Unit, capture? : Bool) -> Unit = _

  /// Dispatch an event to this target
  /// Accepts Event or any subtype (CustomEvent, MouseEvent, etc.)
  dispatchEvent(Self, &@js.JsImpl) -> Bool = _
}

///|
/// Default implementation using JavaScript's addEventListener/removeEventListener
impl EventTargetImpl with addEventListener(
  self,
  event_type,
  handler,
  capture? : Bool = false,
  once? : Bool = false,
  passive? : Bool = false,
  signal? : @js.AbortSignal,
) -> Unit {
  self.call("addEventListener", [
    event_type,
    @js.from_fn1(handler),
    @js.from_option_map({
      "capture": Some(@js.any(capture)),
      "once": Some(@js.any(once)),
      "passive": Some(@js.any(passive)),
      "signal": signal.map(fn(x) { x |> @js.identity }),
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
  self.call("removeEventListener", [
    event_type,
    @js.from_fn1(handler),
    @js.from_option_map({ "capture": Some(@js.any(capture)) }),
  ])
  |> ignore
}

///|
impl EventTargetImpl with dispatchEvent(self, event) -> Bool {
  self.call("dispatchEvent", [event]).cast()
}

///|
/// https://developer.mozilla.org/en-US/docs/Web/API/Event/target
#external
pub type EventTarget

///|
pub impl @js.JsImpl for EventTarget

///|
pub impl EventTargetImpl for EventTarget
