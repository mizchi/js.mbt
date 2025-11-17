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
  add_event_listener(Self, String, (Val) -> Unit) -> Unit = _

  /// Remove a previously registered event listener
  remove_event_listener(Self, String, (Val) -> Unit) -> Unit = _

  /// Dispatch an event to this target
  dispatch_event(Self, Val) -> Bool = _
}

///|
/// Default implementation using JavaScript's addEventListener/removeEventListener
impl EventTarget with add_event_listener(self, event_type, handler) -> Unit {
  ignore(self.invoke("addEventListener", [event_type, js(handler)]))
}

///|
impl EventTarget with remove_event_listener(self, event_type, handler) -> Unit {
  ignore(self.invoke("removeEventListener", [event_type, js(handler)]))
}

///|
impl EventTarget with dispatch_event(self, event) -> Bool {
  self.invoke("dispatchEvent", [event]) |> unsafe_cast
}
