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
  dispatchEvent(Self, @js.Any) -> Bool = _
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
    @js.from_entries_option([
      ("capture", Some(capture)),
      ("once", Some(once)),
      ("passive", Some(passive)),
      ("signal", signal.map(x => x)),
    ]),
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
    @js.from_entries_option_cast([("capture", Some(capture))]),
  ])
  |> ignore
}

///|
impl EventTargetImpl with dispatchEvent(self, event) -> Bool {
  self.call("dispatchEvent", [event]).cast()
}
