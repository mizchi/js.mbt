///|
/// DOM trait hierarchy following TypeScript/Web IDL standards
/// EventTarget_ -> Node_ -> Element_ -> HTMLElement_

///|
/// EventTarget_ trait - base interface for objects that can receive events
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
  self.invoke("dispatchEvent", [event]) |> unsafe_cast
}
