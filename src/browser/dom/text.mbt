///|
/// TextNode represents a text node in the DOM
#external
pub type Text

///|
pub fn Text::as_any(self : Text) -> @nostd.Any = "%identity"

///|
pub fn Text::as_event_target(self : Text) -> @event.EventTarget = "%identity"

///|
pub fn Text::as_node(self : Text) -> Node = "%identity"

///|
pub impl @js.JsImpl for Text
