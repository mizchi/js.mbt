///|
/// DOM-specific EventTarget trait hierarchy following TypeScript/Web IDL standards
/// EventTarget -> Node -> Element -> HTMLElement

///|
/// DOM-specific EventTarget trait - interface for DOM objects that can receive events
/// This trait uses the DOM Event type, unlike the generic EventTarget trait
pub(open) trait EventTargetImpl: Js {
  add_event_listener(Self, String, (Event) -> Unit) -> Unit = _
  remove_event_listener(Self, String, (Event) -> Unit) -> Unit = _
  dispatch_event(Self, Event) -> Bool = _
}

///|
impl EventTargetImpl with add_event_listener(self, event_type, handler) -> Unit {
  ignore(self.invoke("addEventListener", [event_type, @js.js(handler)]))
}

///|
impl EventTargetImpl with remove_event_listener(self, event_type, handler) -> Unit {
  ignore(self.invoke("removeEventListener", [event_type, @js.js(handler)]))
}

///|
impl EventTargetImpl with dispatch_event(self, event) -> Bool {
  self.invoke("dispatchEvent", [event]) |> @js.unsafe_cast
}
