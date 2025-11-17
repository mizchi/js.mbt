///|
/// DOM-specific EventTarget trait hierarchy following TypeScript/Web IDL standards
/// EventTarget -> Node -> Element -> HTMLElement

///|
/// DOM-specific EventTarget trait - interface for DOM objects that can receive events
/// This trait uses the DOM Event type, unlike the generic EventTarget trait
pub(open) trait EventTargetImpl: Js {
  addEventListener(Self, String, (Event) -> Unit) -> Unit = _
  removeEventListener(Self, String, (Event) -> Unit) -> Unit = _
  dispatchEvent(Self, Event) -> Bool = _
}

///|
impl EventTargetImpl with addEventListener(self, event_type, handler) -> Unit {
  ignore(self.invoke("addEventListener", [event_type, @js.js(handler)]))
}

///|
impl EventTargetImpl with removeEventListener(self, event_type, handler) -> Unit {
  ignore(self.invoke("removeEventListener", [event_type, @js.js(handler)]))
}

///|
impl EventTargetImpl with dispatchEvent(self, event) -> Bool {
  self.invoke("dispatchEvent", [event]) |> @js.unsafe_cast
}
