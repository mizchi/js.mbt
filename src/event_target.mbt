///|
/// Generic EventTarget trait for objects that can receive events
/// This is a base trait used by DOM, Worker, WebSocket, and other Web APIs
///
/// Unlike the DOM-specific EventTargetImpl, this trait uses generic Val for events
/// to support various event types across different APIs.

///|
/// Generic event target trait - base interface for objects that can receive events
/// This trait is implemented by:
/// - DOM elements (Document, Element, Window, etc.)
/// - Worker API (Worker, MessagePort, BroadcastChannel)
/// - Network APIs (WebSocket, EventSource, XMLHttpRequest)
/// - Media APIs (MediaStream, AudioContext, etc.)
pub(open) trait EventTarget: Js {
  /// Add an event listener for the specified event type
  /// The listener receives a generic Val which should be cast to the appropriate event type
  addEventListener(Self, String, (Val) -> Unit) -> Unit = _

  /// Remove a previously registered event listener
  removeEventListener(Self, String, (Val) -> Unit) -> Unit = _

  /// Dispatch an event to this target
  dispatchEvent(Self, Val) -> Bool = _
}

///|
/// Default implementation using JavaScript's addEventListener/removeEventListener
impl EventTarget with addEventListener(self, event_type, handler) -> Unit {
  self.invoke("addEventListener", [event_type, js(handler)]) |> ignore
}

///|
impl EventTarget with removeEventListener(self, event_type, handler) -> Unit {
  self.invoke("removeEventListener", [event_type, js(handler)]) |> ignore
}

///|
impl EventTarget with dispatchEvent(self, event) -> Bool {
  self.invoke("dispatchEvent", [event]) |> unsafe_cast
}
