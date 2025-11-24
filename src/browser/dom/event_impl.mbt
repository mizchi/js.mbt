///|
/// EventImpl trait - base interface for all DOM events
pub(open) trait EventImpl: @js.JsImpl {
  preventDefault(Self) -> Unit = _
  stopPropagation(Self) -> Unit = _
  stopImmediatePropagation(Self) -> Unit = _
  target(Self) -> Element = _
  currentTarget(Self) -> Element = _
  eventType(Self) -> String = _
  bubbles(Self) -> Bool = _
  cancelable(Self) -> Bool = _
  defaultPrevented(Self) -> Bool = _
}

///|
impl EventImpl with preventDefault(self) -> Unit {
  ignore(self.call0("preventDefault"))
}

///|
impl EventImpl with stopPropagation(self) -> Unit {
  ignore(self.call0("stopPropagation"))
}

///|
impl EventImpl with stopImmediatePropagation(self) -> Unit {
  ignore(self.call0("stopImmediatePropagation"))
}

///|
impl EventImpl with target(self) -> Element {
  self.get("target").cast()
}

///|
impl EventImpl with currentTarget(self) -> Element {
  self.get("currentTarget").cast()
}

///|
impl EventImpl with eventType(self) -> String {
  self.get("type").cast()
}

///|
impl EventImpl with bubbles(self) -> Bool {
  self.get("bubbles").cast()
}

///|
impl EventImpl with cancelable(self) -> Bool {
  self.get("cancelable").cast()
}

///|
impl EventImpl with defaultPrevented(self) -> Bool {
  self.get("defaultPrevented").cast()
}

///|
/// Event represents a DOM event
/// https://developer.mozilla.org/en-US/docs/Web/API/Event
#external
pub type Event

///|
pub impl @js.JsImpl for Event

///|
pub impl EventImpl for Event

///|
/// PointerEvent represents a pointer event
/// https://developer.mozilla.org/en-US/docs/Web/API/PointerEvent
pub(all) struct PointerEvent {
  pointerId : Int
  width : Double
  height : Double
  pressure : Double
  tangentialPressure : Double
  tiltX : Double
  tiltY : Double
  twist : Double
  altitudeAngle : Double
  azimuthAngle : Double
  pointerType : String
  isPrimary : Bool
} derive(Show)

///|
pub impl @js.JsImpl for PointerEvent

///|
pub impl EventImpl for PointerEvent

///|
/// MouseEvent represents a mouse event
/// https://developer.mozilla.org/en-US/docs/Web/API/MouseEvent
pub(all) struct MouseEvent {
  clientX : Double
  clientY : Double
  screenX : Double
  screenY : Double
  offsetX : Double
  offsetY : Double
  pageX : Double
  pageY : Double
  movementX : Double
  movementY : Double
  button : Int
  buttons : Int
  ctrlKey : Bool
  shiftKey : Bool
  altKey : Bool
  metaKey : Bool
} derive(Show)

///|
pub impl @js.JsImpl for MouseEvent

///|
pub impl EventImpl for MouseEvent

///|
/// Returns the secondary target for the mouse event
/// https://developer.mozilla.org/en-US/docs/Web/API/MouseEvent/relatedTarget
pub fn MouseEvent::relatedTarget(self : Self) -> Element? {
  self.get("relatedTarget") |> @js.identity_option
}

///|
/// KeyboardEvent represents a keyboard event
/// https://developer.mozilla.org/en-US/docs/Web/API/KeyboardEvent
pub(all) struct KeyboardEvent {
  key : String
  code : String
  keyCode : Int
  which : Int
  ctrlKey : Bool
  altKey : Bool
  shiftKey : Bool
  metaKey : Bool
  repeat : Bool
  location : Int
  isComposing : Bool
} derive(Show)

///|
pub impl @js.JsImpl for KeyboardEvent

///|
pub impl EventImpl for KeyboardEvent

///|
/// ChangeEvent represents a change event
pub(all) struct ChangeEvent {} derive(Show)

///|
pub impl @js.JsImpl for ChangeEvent

///|
pub impl EventImpl for ChangeEvent

///|
/// FocusEvent represents a focus event
/// https://developer.mozilla.org/en-US/docs/Web/API/FocusEvent
#external
pub type FocusEvent

///|
impl @js.JsImpl for FocusEvent

///|
pub impl EventImpl for FocusEvent

///|
/// Returns the related target (element losing/gaining focus)
pub fn FocusEvent::relatedTarget(self : FocusEvent) -> Element? {
  self.get("relatedTarget") |> @js.identity_option
}

///|
/// FormEvent represents a form event
pub(all) struct FormEvent {
  formData : @http.FormData?
}

///|
pub impl @js.JsImpl for FormEvent

///|
pub impl EventImpl for FormEvent

///|
/// DragEvent represents a drag and drop event
/// https://developer.mozilla.org/en-US/docs/Web/API/DragEvent
pub(all) struct DragEvent {
  dataTransfer : @js.Nullable[DataTransfer]
}

///|
pub impl @js.JsImpl for DragEvent

///|
pub impl EventImpl for DragEvent

///|
/// InputEvent represents an input event
/// https://developer.mozilla.org/en-US/docs/Web/API/InputEvent
pub(all) struct InputEvent {
  data : @js.Nullable[String]
  dataTransfer : @js.Nullable[DataTransfer]
  inputType : String
  isComposing : Bool
}

///|
pub impl @js.JsImpl for InputEvent

///|
pub impl EventImpl for InputEvent

///|
/// WheelEvent represents a wheel event
/// https://developer.mozilla.org/en-US/docs/Web/API/WheelEvent
pub(all) struct WheelEvent {
  deltaX : Double
  deltaY : Double
  deltaZ : Double
  deltaMode : Int
} derive(Show)

///|
pub impl @js.JsImpl for WheelEvent

///|
pub impl EventImpl for WheelEvent

///|
/// TouchEvent represents a touch event
/// https://developer.mozilla.org/en-US/docs/Web/API/TouchEvent
pub(all) struct TouchEvent {
  touches : Array[Touch]
  targetTouches : Array[Touch]
  changedTouches : Array[Touch]
  altKey : Bool
  ctrlKey : Bool
  shiftKey : Bool
  metaKey : Bool
} derive(Show)

///|
pub impl @js.JsImpl for TouchEvent

///|
pub impl EventImpl for TouchEvent

///|
/// Touch represents a single touch point
/// https://developer.mozilla.org/en-US/docs/Web/API/Touch
pub(all) struct Touch {
  identifier : Int
  clientX : Double
  clientY : Double
  screenX : Double
  screenY : Double
  pageX : Double
  pageY : Double
  radiusX : Double
  radiusY : Double
  rotationAngle : Double
  force : Double
} derive(Show)

///|
pub impl @js.JsImpl for Touch

///|
/// Returns the target element
pub fn Touch::target(self : Self) -> Element {
  self.get("target").cast()
}

///|
/// ClipboardEvent represents a clipboard event
/// https://developer.mozilla.org/en-US/docs/Web/API/ClipboardEvent
pub(all) struct ClipboardEvent {
  clipboardData : ClipboardData?
}

///|
pub impl @js.JsImpl for ClipboardEvent

///|
pub impl EventImpl for ClipboardEvent

///|
/// TransitionEvent represents a CSS transition event
/// https://developer.mozilla.org/en-US/docs/Web/API/TransitionEvent
pub(all) struct TransitionEvent {
  propertyName : String
  elapsedTime : Double
  pseudoElement : String
} derive(Show)

///|
pub impl @js.JsImpl for TransitionEvent

///|
pub impl EventImpl for TransitionEvent

///|
/// AnimationEvent represents a CSS animation event
/// https://developer.mozilla.org/en-US/docs/Web/API/AnimationEvent
pub(all) struct AnimationEvent {
  animationName : String
  elapsedTime : Double
  pseudoElement : String
} derive(Show)

///|
pub impl @js.JsImpl for AnimationEvent

///|
pub impl EventImpl for AnimationEvent

///|
/// ScrollEvent represents a scroll event
pub(all) struct ScrollEvent {} derive(Show)

///|
pub impl @js.JsImpl for ScrollEvent

///|
pub impl EventImpl for ScrollEvent

///|
/// MessageEvent is fired when a message is received from another browsing context
/// https://developer.mozilla.org/en-US/docs/Web/API/MessageEvent
pub(all) struct MessageEvent {
  data : @js.Any
  origin : String
  lastEventId : String
  ports : Array[@message.MessagePort]
} derive(Show)

///|
pub impl @js.JsImpl for MessageEvent

///|
pub impl EventImpl for MessageEvent

///|
/// Returns the source window of the message
/// https://developer.mozilla.org/en-US/docs/Web/API/MessageEvent/source
pub fn MessageEvent::source(self : Self) -> Window? {
  self.get("source") |> @js.identity_option()
}
