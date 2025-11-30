///|
/// Document represents the web page loaded in the browser
/// https://developer.mozilla.org/en-US/docs/Web/API/DocumentFragment
#external
pub type DocumentFragment

///|
pub fn DocumentFragment::as_any(self : DocumentFragment) -> @nostd.Any = "%identity"

///|
pub impl @js.JsImpl for DocumentFragment

///|
pub impl @event.EventTargetImpl for DocumentFragment

///|
pub impl NodeImpl for DocumentFragment
