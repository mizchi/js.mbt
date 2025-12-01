///|
/// EventImpl trait - base interface for all DOM events
pub(open) trait EventImpl {
  as_any(Self) -> @nostd.Any
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
  self.as_any()._call("preventDefault", []) |> ignore
}

///|
impl EventImpl with stopPropagation(self) -> Unit {
  self.as_any()._call("stopPropagation", []) |> ignore
}

///|
impl EventImpl with stopImmediatePropagation(self) -> Unit {
  self.as_any()._call("stopImmediatePropagation", []) |> ignore
}

///|
impl EventImpl with target(self) -> Element {
  self.as_any()._get("target").cast()
}

///|
impl EventImpl with currentTarget(self) -> Element {
  self.as_any()._get("currentTarget").cast()
}

///|
impl EventImpl with eventType(self) -> String {
  self.as_any()._get("type").cast()
}

///|
impl EventImpl with bubbles(self) -> Bool {
  self.as_any()._get("bubbles").cast()
}

///|
impl EventImpl with cancelable(self) -> Bool {
  self.as_any()._get("cancelable").cast()
}

///|
impl EventImpl with defaultPrevented(self) -> Bool {
  self.as_any()._get("defaultPrevented").cast()
}

///|
/// Event represents a DOM event
/// https://developer.mozilla.org/en-US/docs/Web/API/Event
#external
pub type Event

///|
pub fn Event::as_any(self : Event) -> @nostd.Any = "%identity"

///|
pub fn Event::as_event(self : Event) -> @event.Event = "%identity"

///|
pub impl EventImpl for Event with as_any(self) -> @nostd.Any {
  self.as_any()
}

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
pub fn PointerEvent::as_any(self : PointerEvent) -> @nostd.Any = "%identity"

///|
pub impl EventImpl for PointerEvent with as_any(self) -> @nostd.Any {
  self.as_any()
}

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
pub fn MouseEvent::as_any(self : MouseEvent) -> @nostd.Any = "%identity"

///|
pub impl EventImpl for MouseEvent with as_any(self) -> @nostd.Any {
  self.as_any()
}

///|
/// Returns the secondary target for the mouse event
/// https://developer.mozilla.org/en-US/docs/Web/API/MouseEvent/relatedTarget
pub fn MouseEvent::relatedTarget(self : Self) -> Element? {
  let v : @nostd.Any = self.as_any()._get("relatedTarget").cast()
  v |> @js.identity_option
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
pub fn KeyboardEvent::as_any(self : KeyboardEvent) -> @nostd.Any = "%identity"

///|
pub impl EventImpl for KeyboardEvent with as_any(self) -> @nostd.Any {
  self.as_any()
}

///|
/// ChangeEvent represents a change event
pub(all) struct ChangeEvent {} derive(Show)

///|
pub fn ChangeEvent::as_any(self : ChangeEvent) -> @nostd.Any = "%identity"

///|
pub impl EventImpl for ChangeEvent with as_any(self) -> @nostd.Any {
  self.as_any()
}

///|
/// FocusEvent represents a focus event
/// https://developer.mozilla.org/en-US/docs/Web/API/FocusEvent
#external
pub type FocusEvent

///|
pub fn FocusEvent::as_any(self : FocusEvent) -> @nostd.Any = "%identity"

///|

///|
pub impl EventImpl for FocusEvent with as_any(self) -> @nostd.Any {
  self.as_any()
}

///|
/// Returns the related target (element losing/gaining focus)
pub fn FocusEvent::relatedTarget(self : FocusEvent) -> Element? {
  let v : @nostd.Any = self.as_any()._get("relatedTarget").cast()
  v |> @js.identity_option
}

///|
/// FormEvent represents a form event
pub(all) struct FormEvent {
  formData : @http.FormData?
}

///|
pub fn FormEvent::as_any(self : FormEvent) -> @nostd.Any = "%identity"

///|
pub impl EventImpl for FormEvent with as_any(self) -> @nostd.Any {
  self.as_any()
}

///|
/// DragEvent represents a drag and drop event
/// https://developer.mozilla.org/en-US/docs/Web/API/DragEvent
pub(all) struct DragEvent {
  dataTransfer : @js.Nullable[DataTransfer]
}

///|
pub fn DragEvent::as_any(self : DragEvent) -> @nostd.Any = "%identity"

///|
pub impl EventImpl for DragEvent with as_any(self) -> @nostd.Any {
  self.as_any()
}

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
pub fn InputEvent::as_any(self : InputEvent) -> @nostd.Any = "%identity"

///|
pub impl EventImpl for InputEvent with as_any(self) -> @nostd.Any {
  self.as_any()
}

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
pub fn WheelEvent::as_any(self : WheelEvent) -> @nostd.Any = "%identity"

///|
pub impl EventImpl for WheelEvent with as_any(self) -> @nostd.Any {
  self.as_any()
}

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
pub fn TouchEvent::as_any(self : TouchEvent) -> @nostd.Any = "%identity"

///|
pub impl EventImpl for TouchEvent with as_any(self) -> @nostd.Any {
  self.as_any()
}

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
pub fn Touch::as_any(self : Touch) -> @nostd.Any = "%identity"

///|

///|
/// Returns the target element
pub fn Touch::target(self : Self) -> Element {
  self.as_any()._get("target").cast()
}

///|
/// ClipboardEvent represents a clipboard event
/// https://developer.mozilla.org/en-US/docs/Web/API/ClipboardEvent
pub(all) struct ClipboardEvent {
  clipboardData : ClipboardData?
}

///|
pub fn ClipboardEvent::as_any(self : ClipboardEvent) -> @nostd.Any = "%identity"

///|
pub impl EventImpl for ClipboardEvent with as_any(self) -> @nostd.Any {
  self.as_any()
}

///|
/// TransitionEvent represents a CSS transition event
/// https://developer.mozilla.org/en-US/docs/Web/API/TransitionEvent
pub(all) struct TransitionEvent {
  propertyName : String
  elapsedTime : Double
  pseudoElement : String
} derive(Show)

///|
pub fn TransitionEvent::as_any(self : TransitionEvent) -> @nostd.Any = "%identity"

///|
pub impl EventImpl for TransitionEvent with as_any(self) -> @nostd.Any {
  self.as_any()
}

///|
/// AnimationEvent represents a CSS animation event
/// https://developer.mozilla.org/en-US/docs/Web/API/AnimationEvent
pub(all) struct AnimationEvent {
  animationName : String
  elapsedTime : Double
  pseudoElement : String
} derive(Show)

///|
pub fn AnimationEvent::as_any(self : AnimationEvent) -> @nostd.Any = "%identity"

///|
pub impl EventImpl for AnimationEvent with as_any(self) -> @nostd.Any {
  self.as_any()
}

///|
/// ScrollEvent represents a scroll event
pub(all) struct ScrollEvent {} derive(Show)

///|
pub fn ScrollEvent::as_any(self : ScrollEvent) -> @nostd.Any = "%identity"

///|
pub impl EventImpl for ScrollEvent with as_any(self) -> @nostd.Any {
  self.as_any()
}

///|
/// MessageEvent is fired when a message is received from another browsing context
/// https://developer.mozilla.org/en-US/docs/Web/API/MessageEvent
pub(all) struct MessageEvent {
  data : @nostd.Any
  origin : String
  lastEventId : String
  ports : Array[@message.MessagePort]
} derive(Show)

///|
pub fn MessageEvent::as_any(self : MessageEvent) -> @nostd.Any = "%identity"

///|

///|
pub impl EventImpl for MessageEvent with as_any(self) -> @nostd.Any {
  self.as_any()
}

///|
/// Returns the source window of the message
/// https://developer.mozilla.org/en-US/docs/Web/API/MessageEvent/source
pub fn MessageEvent::source(self : Self) -> Window? {
  let v : @nostd.Any = self.as_any()._get("source").cast()
  v |> @js.identity_option()
}

///|
/// PopStateEvent represents an event fired when the active history entry changes
/// https://developer.mozilla.org/en-US/docs/Web/API/PopStateEvent
#external
pub type PopStateEvent

///|
pub fn PopStateEvent::as_any(self : PopStateEvent) -> @nostd.Any = "%identity"

///|

///|
pub impl EventImpl for PopStateEvent with as_any(self) -> @nostd.Any {
  self.as_any()
}

///|
/// Returns the state associated with the history entry
/// https://developer.mozilla.org/en-US/docs/Web/API/PopStateEvent/state
pub fn PopStateEvent::state(self : Self) -> @nostd.Any? {
  let v : @nostd.Any = self.as_any()._get("state").cast()
  v |> @js.identity_option()
}

///|
/// HashChangeEvent represents an event fired when the fragment identifier of the URL has changed
/// https://developer.mozilla.org/en-US/docs/Web/API/HashChangeEvent
pub(all) struct HashChangeEvent {
  /// The previous URL from which the window was navigated
  oldURL : String
  /// The new URL to which the window is navigating
  newURL : String
} derive(Show)

///|
pub fn HashChangeEvent::as_any(self : HashChangeEvent) -> @nostd.Any = "%identity"

///|
pub impl EventImpl for HashChangeEvent with as_any(self) -> @nostd.Any {
  self.as_any()
}

///|
/// BeforeUnloadEvent represents an event fired when the window is about to be unloaded
/// https://developer.mozilla.org/en-US/docs/Web/API/BeforeUnloadEvent
#external
pub type BeforeUnloadEvent

///|
pub fn BeforeUnloadEvent::as_any(self : BeforeUnloadEvent) -> @nostd.Any = "%identity"

///|

///|
pub impl EventImpl for BeforeUnloadEvent with as_any(self) -> @nostd.Any {
  self.as_any()
}

///|
/// Sets the return value to show a confirmation dialog
/// https://developer.mozilla.org/en-US/docs/Web/API/BeforeUnloadEvent/returnValue
#alias(set_return_value)
pub fn BeforeUnloadEvent::setReturnValue(self : Self, value : String) -> Unit {
  self.as_any()._set("returnValue", @nostd.any(value)) |> ignore
}

///|
/// Gets the return value
#alias(return_value)
pub fn BeforeUnloadEvent::returnValue(self : Self) -> String {
  self.as_any()._get("returnValue").cast()
}

///|
/// PageTransitionEvent represents an event fired when a document is being loaded or unloaded
/// https://developer.mozilla.org/en-US/docs/Web/API/PageTransitionEvent
pub(all) struct PageTransitionEvent {
  /// Indicates if the page is being loaded from a cache
  persisted : Bool
} derive(Show)

///|
pub fn PageTransitionEvent::as_any(self : PageTransitionEvent) -> @nostd.Any = "%identity"

///|
pub impl EventImpl for PageTransitionEvent with as_any(self) -> @nostd.Any {
  self.as_any()
}
