///|
/// TextNode represents a text node in the DOM
#external
pub type Text

///|
pub fn Text::as_any(self : Text) -> @nostd.Any = "%identity"

///|
pub impl @js.JsImpl for Text

///|
pub impl @event.EventTargetImpl for Text

///|
pub impl NodeImpl for Text
