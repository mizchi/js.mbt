///|
/// DOMRectReadOnly represents a read-only rectangle
/// https://developer.mozilla.org/en-US/docs/Web/API/DOMRect
pub(all) struct DOMRect {
  x : Double
  y : Double
  width : Double
  height : Double
  top : Double
  right : Double
  bottom : Double
  left : Double
}

///|
pub fn DOMRect::as_any(self : DOMRect) -> @core.Any = "%identity"

///|
/// DOMRectReadOnly represents a read-only rectangle
/// https://developer.mozilla.org/en-US/docs/Web/API/DOMRectReadOnly
pub(all) struct DOMRectReadOnly {
  x : Double
  y : Double
  width : Double
  height : Double
  top : Double
  right : Double
  bottom : Double
  left : Double
}

///|
pub fn DOMRectReadOnly::as_any(self : DOMRectReadOnly) -> @core.Any = "%identity"
