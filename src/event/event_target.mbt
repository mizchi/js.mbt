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
  addEventListener(Self, String, (@js.Js) -> Unit) -> Unit = _

  /// Remove a previously registered event listener
  removeEventListener(Self, String, (@js.Js) -> Unit) -> Unit = _

  /// Dispatch an event to this target
  dispatchEvent(Self, @js.Js) -> Bool = _
}

///|
/// Default implementation using JavaScript's addEventListener/removeEventListener
impl EventTargetImpl with addEventListener(self, event_type, handler) -> Unit {
  self.call("addEventListener", [event_type, @js.from_fn1(handler)]) |> ignore
}

///|
impl EventTargetImpl with removeEventListener(self, event_type, handler) -> Unit {
  self.call("removeEventListener", [event_type, @js.from_fn1(handler)])
  |> ignore
}

///|
impl EventTargetImpl with dispatchEvent(self, event) -> Bool {
  self.call("dispatchEvent", [event]) |> @js.unsafe_cast
}
