///|
/// Document represents the web page loaded in the browser
/// https://developer.mozilla.org/en-US/docs/Web/API/DocumentFragment
#external
pub type DocumentFragment

///|
pub fn DocumentFragment::as_any(self : DocumentFragment) -> @core.Any = "%identity"

///|
pub fn DocumentFragment::as_event_target(
  self : DocumentFragment,
) -> @event.EventTarget = "%identity"

///|
pub fn DocumentFragment::as_node(self : DocumentFragment) -> Node = "%identity"

///|
