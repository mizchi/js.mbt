///|
/// Event represents a DOM event
/// https://developer.mozilla.org/en-US/docs/Web/API/Event
#external
pub type Event

///|
pub fn Event::as_any(self : Event) -> @core.Any = "%identity"

///|
pub fn Event::as_event(self : Event) -> @event.Event = "%identity"

///|
pub fn Event::preventDefault(self : Event) -> Unit {
  self.as_any()._call("preventDefault", []) |> ignore
}

///|
pub fn Event::stopPropagation(self : Event) -> Unit {
  self.as_any()._call("stopPropagation", []) |> ignore
}

///|
pub fn Event::stopImmediatePropagation(self : Event) -> Unit {
  self.as_any()._call("stopImmediatePropagation", []) |> ignore
}

///|
pub fn Event::target(self : Event) -> Element {
  self.as_any()._get("target").cast()
}

///|
pub fn Event::currentTarget(self : Event) -> Element {
  self.as_any()._get("currentTarget").cast()
}

///|
pub fn Event::eventType(self : Event) -> String {
  self.as_any()._get("type").cast()
}

///|
pub fn Event::bubbles(self : Event) -> Bool {
  self.as_any()._get("bubbles").cast()
}

///|
pub fn Event::cancelable(self : Event) -> Bool {
  self.as_any()._get("cancelable").cast()
}

///|
pub fn Event::defaultPrevented(self : Event) -> Bool {
  self.as_any()._get("defaultPrevented").cast()
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
pub fn PointerEvent::as_any(self : PointerEvent) -> @core.Any = "%identity"

///|
pub fn PointerEvent::preventDefault(self : PointerEvent) -> Unit {
  self.as_any()._call("preventDefault", []) |> ignore
}

///|
pub fn PointerEvent::stopPropagation(self : PointerEvent) -> Unit {
  self.as_any()._call("stopPropagation", []) |> ignore
}

///|
pub fn PointerEvent::stopImmediatePropagation(self : PointerEvent) -> Unit {
  self.as_any()._call("stopImmediatePropagation", []) |> ignore
}

///|
pub fn PointerEvent::target(self : PointerEvent) -> Element {
  self.as_any()._get("target").cast()
}

///|
pub fn PointerEvent::currentTarget(self : PointerEvent) -> Element {
  self.as_any()._get("currentTarget").cast()
}

///|
pub fn PointerEvent::eventType(self : PointerEvent) -> String {
  self.as_any()._get("type").cast()
}

///|
pub fn PointerEvent::bubbles(self : PointerEvent) -> Bool {
  self.as_any()._get("bubbles").cast()
}

///|
pub fn PointerEvent::cancelable(self : PointerEvent) -> Bool {
  self.as_any()._get("cancelable").cast()
}

///|
pub fn PointerEvent::defaultPrevented(self : PointerEvent) -> Bool {
  self.as_any()._get("defaultPrevented").cast()
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
pub fn MouseEvent::as_any(self : MouseEvent) -> @core.Any = "%identity"

///|
pub fn MouseEvent::preventDefault(self : MouseEvent) -> Unit {
  self.as_any()._call("preventDefault", []) |> ignore
}

///|
pub fn MouseEvent::stopPropagation(self : MouseEvent) -> Unit {
  self.as_any()._call("stopPropagation", []) |> ignore
}

///|
pub fn MouseEvent::stopImmediatePropagation(self : MouseEvent) -> Unit {
  self.as_any()._call("stopImmediatePropagation", []) |> ignore
}

///|
pub fn MouseEvent::target(self : MouseEvent) -> Element {
  self.as_any()._get("target").cast()
}

///|
pub fn MouseEvent::currentTarget(self : MouseEvent) -> Element {
  self.as_any()._get("currentTarget").cast()
}

///|
pub fn MouseEvent::eventType(self : MouseEvent) -> String {
  self.as_any()._get("type").cast()
}

///|
pub fn MouseEvent::bubbles(self : MouseEvent) -> Bool {
  self.as_any()._get("bubbles").cast()
}

///|
pub fn MouseEvent::cancelable(self : MouseEvent) -> Bool {
  self.as_any()._get("cancelable").cast()
}

///|
pub fn MouseEvent::defaultPrevented(self : MouseEvent) -> Bool {
  self.as_any()._get("defaultPrevented").cast()
}

///|
/// Returns the secondary target for the mouse event
/// https://developer.mozilla.org/en-US/docs/Web/API/MouseEvent/relatedTarget
pub fn MouseEvent::relatedTarget(self : Self) -> Element? {
  let v : @core.Any = self.as_any()._get("relatedTarget").cast()
  v |> @core.identity_option
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
pub fn KeyboardEvent::as_any(self : KeyboardEvent) -> @core.Any = "%identity"

///|
pub fn KeyboardEvent::preventDefault(self : KeyboardEvent) -> Unit {
  self.as_any()._call("preventDefault", []) |> ignore
}

///|
pub fn KeyboardEvent::stopPropagation(self : KeyboardEvent) -> Unit {
  self.as_any()._call("stopPropagation", []) |> ignore
}

///|
pub fn KeyboardEvent::stopImmediatePropagation(self : KeyboardEvent) -> Unit {
  self.as_any()._call("stopImmediatePropagation", []) |> ignore
}

///|
pub fn KeyboardEvent::target(self : KeyboardEvent) -> Element {
  self.as_any()._get("target").cast()
}

///|
pub fn KeyboardEvent::currentTarget(self : KeyboardEvent) -> Element {
  self.as_any()._get("currentTarget").cast()
}

///|
pub fn KeyboardEvent::eventType(self : KeyboardEvent) -> String {
  self.as_any()._get("type").cast()
}

///|
pub fn KeyboardEvent::bubbles(self : KeyboardEvent) -> Bool {
  self.as_any()._get("bubbles").cast()
}

///|
pub fn KeyboardEvent::cancelable(self : KeyboardEvent) -> Bool {
  self.as_any()._get("cancelable").cast()
}

///|
pub fn KeyboardEvent::defaultPrevented(self : KeyboardEvent) -> Bool {
  self.as_any()._get("defaultPrevented").cast()
}

///|
/// ChangeEvent represents a change event
pub(all) struct ChangeEvent {} derive(Show)

///|
pub fn ChangeEvent::as_any(self : ChangeEvent) -> @core.Any = "%identity"

///|
pub fn ChangeEvent::preventDefault(self : ChangeEvent) -> Unit {
  self.as_any()._call("preventDefault", []) |> ignore
}

///|
pub fn ChangeEvent::stopPropagation(self : ChangeEvent) -> Unit {
  self.as_any()._call("stopPropagation", []) |> ignore
}

///|
pub fn ChangeEvent::stopImmediatePropagation(self : ChangeEvent) -> Unit {
  self.as_any()._call("stopImmediatePropagation", []) |> ignore
}

///|
pub fn ChangeEvent::target(self : ChangeEvent) -> Element {
  self.as_any()._get("target").cast()
}

///|
pub fn ChangeEvent::currentTarget(self : ChangeEvent) -> Element {
  self.as_any()._get("currentTarget").cast()
}

///|
pub fn ChangeEvent::eventType(self : ChangeEvent) -> String {
  self.as_any()._get("type").cast()
}

///|
pub fn ChangeEvent::bubbles(self : ChangeEvent) -> Bool {
  self.as_any()._get("bubbles").cast()
}

///|
pub fn ChangeEvent::cancelable(self : ChangeEvent) -> Bool {
  self.as_any()._get("cancelable").cast()
}

///|
pub fn ChangeEvent::defaultPrevented(self : ChangeEvent) -> Bool {
  self.as_any()._get("defaultPrevented").cast()
}

///|
/// FocusEvent represents a focus event
/// https://developer.mozilla.org/en-US/docs/Web/API/FocusEvent
#external
pub type FocusEvent

///|
pub fn FocusEvent::as_any(self : FocusEvent) -> @core.Any = "%identity"

///|
pub fn FocusEvent::preventDefault(self : FocusEvent) -> Unit {
  self.as_any()._call("preventDefault", []) |> ignore
}

///|
pub fn FocusEvent::stopPropagation(self : FocusEvent) -> Unit {
  self.as_any()._call("stopPropagation", []) |> ignore
}

///|
pub fn FocusEvent::stopImmediatePropagation(self : FocusEvent) -> Unit {
  self.as_any()._call("stopImmediatePropagation", []) |> ignore
}

///|
pub fn FocusEvent::target(self : FocusEvent) -> Element {
  self.as_any()._get("target").cast()
}

///|
pub fn FocusEvent::currentTarget(self : FocusEvent) -> Element {
  self.as_any()._get("currentTarget").cast()
}

///|
pub fn FocusEvent::eventType(self : FocusEvent) -> String {
  self.as_any()._get("type").cast()
}

///|
pub fn FocusEvent::bubbles(self : FocusEvent) -> Bool {
  self.as_any()._get("bubbles").cast()
}

///|
pub fn FocusEvent::cancelable(self : FocusEvent) -> Bool {
  self.as_any()._get("cancelable").cast()
}

///|
pub fn FocusEvent::defaultPrevented(self : FocusEvent) -> Bool {
  self.as_any()._get("defaultPrevented").cast()
}

///|
/// Returns the related target (element losing/gaining focus)
pub fn FocusEvent::relatedTarget(self : FocusEvent) -> Element? {
  let v : @core.Any = self.as_any()._get("relatedTarget").cast()
  v |> @core.identity_option
}

///|
/// FormEvent represents a form event
pub(all) struct FormEvent {
  formData : @http.FormData?
}

///|
pub fn FormEvent::as_any(self : FormEvent) -> @core.Any = "%identity"

///|
pub fn FormEvent::preventDefault(self : FormEvent) -> Unit {
  self.as_any()._call("preventDefault", []) |> ignore
}

///|
pub fn FormEvent::stopPropagation(self : FormEvent) -> Unit {
  self.as_any()._call("stopPropagation", []) |> ignore
}

///|
pub fn FormEvent::stopImmediatePropagation(self : FormEvent) -> Unit {
  self.as_any()._call("stopImmediatePropagation", []) |> ignore
}

///|
pub fn FormEvent::target(self : FormEvent) -> Element {
  self.as_any()._get("target").cast()
}

///|
pub fn FormEvent::currentTarget(self : FormEvent) -> Element {
  self.as_any()._get("currentTarget").cast()
}

///|
pub fn FormEvent::eventType(self : FormEvent) -> String {
  self.as_any()._get("type").cast()
}

///|
pub fn FormEvent::bubbles(self : FormEvent) -> Bool {
  self.as_any()._get("bubbles").cast()
}

///|
pub fn FormEvent::cancelable(self : FormEvent) -> Bool {
  self.as_any()._get("cancelable").cast()
}

///|
pub fn FormEvent::defaultPrevented(self : FormEvent) -> Bool {
  self.as_any()._get("defaultPrevented").cast()
}

///|
/// DragEvent represents a drag and drop event
/// https://developer.mozilla.org/en-US/docs/Web/API/DragEvent
pub(all) struct DragEvent {
  dataTransfer : @js.Nullable[DataTransfer]
}

///|
pub fn DragEvent::as_any(self : DragEvent) -> @core.Any = "%identity"

///|
pub fn DragEvent::preventDefault(self : DragEvent) -> Unit {
  self.as_any()._call("preventDefault", []) |> ignore
}

///|
pub fn DragEvent::stopPropagation(self : DragEvent) -> Unit {
  self.as_any()._call("stopPropagation", []) |> ignore
}

///|
pub fn DragEvent::stopImmediatePropagation(self : DragEvent) -> Unit {
  self.as_any()._call("stopImmediatePropagation", []) |> ignore
}

///|
pub fn DragEvent::target(self : DragEvent) -> Element {
  self.as_any()._get("target").cast()
}

///|
pub fn DragEvent::currentTarget(self : DragEvent) -> Element {
  self.as_any()._get("currentTarget").cast()
}

///|
pub fn DragEvent::eventType(self : DragEvent) -> String {
  self.as_any()._get("type").cast()
}

///|
pub fn DragEvent::bubbles(self : DragEvent) -> Bool {
  self.as_any()._get("bubbles").cast()
}

///|
pub fn DragEvent::cancelable(self : DragEvent) -> Bool {
  self.as_any()._get("cancelable").cast()
}

///|
pub fn DragEvent::defaultPrevented(self : DragEvent) -> Bool {
  self.as_any()._get("defaultPrevented").cast()
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
pub fn InputEvent::as_any(self : InputEvent) -> @core.Any = "%identity"

///|
pub fn InputEvent::preventDefault(self : InputEvent) -> Unit {
  self.as_any()._call("preventDefault", []) |> ignore
}

///|
pub fn InputEvent::stopPropagation(self : InputEvent) -> Unit {
  self.as_any()._call("stopPropagation", []) |> ignore
}

///|
pub fn InputEvent::stopImmediatePropagation(self : InputEvent) -> Unit {
  self.as_any()._call("stopImmediatePropagation", []) |> ignore
}

///|
pub fn InputEvent::target(self : InputEvent) -> Element {
  self.as_any()._get("target").cast()
}

///|
pub fn InputEvent::currentTarget(self : InputEvent) -> Element {
  self.as_any()._get("currentTarget").cast()
}

///|
pub fn InputEvent::eventType(self : InputEvent) -> String {
  self.as_any()._get("type").cast()
}

///|
pub fn InputEvent::bubbles(self : InputEvent) -> Bool {
  self.as_any()._get("bubbles").cast()
}

///|
pub fn InputEvent::cancelable(self : InputEvent) -> Bool {
  self.as_any()._get("cancelable").cast()
}

///|
pub fn InputEvent::defaultPrevented(self : InputEvent) -> Bool {
  self.as_any()._get("defaultPrevented").cast()
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
pub fn WheelEvent::as_any(self : WheelEvent) -> @core.Any = "%identity"

///|
pub fn WheelEvent::preventDefault(self : WheelEvent) -> Unit {
  self.as_any()._call("preventDefault", []) |> ignore
}

///|
pub fn WheelEvent::stopPropagation(self : WheelEvent) -> Unit {
  self.as_any()._call("stopPropagation", []) |> ignore
}

///|
pub fn WheelEvent::stopImmediatePropagation(self : WheelEvent) -> Unit {
  self.as_any()._call("stopImmediatePropagation", []) |> ignore
}

///|
pub fn WheelEvent::target(self : WheelEvent) -> Element {
  self.as_any()._get("target").cast()
}

///|
pub fn WheelEvent::currentTarget(self : WheelEvent) -> Element {
  self.as_any()._get("currentTarget").cast()
}

///|
pub fn WheelEvent::eventType(self : WheelEvent) -> String {
  self.as_any()._get("type").cast()
}

///|
pub fn WheelEvent::bubbles(self : WheelEvent) -> Bool {
  self.as_any()._get("bubbles").cast()
}

///|
pub fn WheelEvent::cancelable(self : WheelEvent) -> Bool {
  self.as_any()._get("cancelable").cast()
}

///|
pub fn WheelEvent::defaultPrevented(self : WheelEvent) -> Bool {
  self.as_any()._get("defaultPrevented").cast()
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
pub fn TouchEvent::as_any(self : TouchEvent) -> @core.Any = "%identity"

///|
pub fn TouchEvent::preventDefault(self : TouchEvent) -> Unit {
  self.as_any()._call("preventDefault", []) |> ignore
}

///|
pub fn TouchEvent::stopPropagation(self : TouchEvent) -> Unit {
  self.as_any()._call("stopPropagation", []) |> ignore
}

///|
pub fn TouchEvent::stopImmediatePropagation(self : TouchEvent) -> Unit {
  self.as_any()._call("stopImmediatePropagation", []) |> ignore
}

///|
pub fn TouchEvent::target(self : TouchEvent) -> Element {
  self.as_any()._get("target").cast()
}

///|
pub fn TouchEvent::currentTarget(self : TouchEvent) -> Element {
  self.as_any()._get("currentTarget").cast()
}

///|
pub fn TouchEvent::eventType(self : TouchEvent) -> String {
  self.as_any()._get("type").cast()
}

///|
pub fn TouchEvent::bubbles(self : TouchEvent) -> Bool {
  self.as_any()._get("bubbles").cast()
}

///|
pub fn TouchEvent::cancelable(self : TouchEvent) -> Bool {
  self.as_any()._get("cancelable").cast()
}

///|
pub fn TouchEvent::defaultPrevented(self : TouchEvent) -> Bool {
  self.as_any()._get("defaultPrevented").cast()
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
pub fn Touch::as_any(self : Touch) -> @core.Any = "%identity"

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
pub fn ClipboardEvent::as_any(self : ClipboardEvent) -> @core.Any = "%identity"

///|
pub fn ClipboardEvent::preventDefault(self : ClipboardEvent) -> Unit {
  self.as_any()._call("preventDefault", []) |> ignore
}

///|
pub fn ClipboardEvent::stopPropagation(self : ClipboardEvent) -> Unit {
  self.as_any()._call("stopPropagation", []) |> ignore
}

///|
pub fn ClipboardEvent::stopImmediatePropagation(self : ClipboardEvent) -> Unit {
  self.as_any()._call("stopImmediatePropagation", []) |> ignore
}

///|
pub fn ClipboardEvent::target(self : ClipboardEvent) -> Element {
  self.as_any()._get("target").cast()
}

///|
pub fn ClipboardEvent::currentTarget(self : ClipboardEvent) -> Element {
  self.as_any()._get("currentTarget").cast()
}

///|
pub fn ClipboardEvent::eventType(self : ClipboardEvent) -> String {
  self.as_any()._get("type").cast()
}

///|
pub fn ClipboardEvent::bubbles(self : ClipboardEvent) -> Bool {
  self.as_any()._get("bubbles").cast()
}

///|
pub fn ClipboardEvent::cancelable(self : ClipboardEvent) -> Bool {
  self.as_any()._get("cancelable").cast()
}

///|
pub fn ClipboardEvent::defaultPrevented(self : ClipboardEvent) -> Bool {
  self.as_any()._get("defaultPrevented").cast()
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
pub fn TransitionEvent::as_any(self : TransitionEvent) -> @core.Any = "%identity"

///|
pub fn TransitionEvent::preventDefault(self : TransitionEvent) -> Unit {
  self.as_any()._call("preventDefault", []) |> ignore
}

///|
pub fn TransitionEvent::stopPropagation(self : TransitionEvent) -> Unit {
  self.as_any()._call("stopPropagation", []) |> ignore
}

///|
pub fn TransitionEvent::stopImmediatePropagation(
  self : TransitionEvent,
) -> Unit {
  self.as_any()._call("stopImmediatePropagation", []) |> ignore
}

///|
pub fn TransitionEvent::target(self : TransitionEvent) -> Element {
  self.as_any()._get("target").cast()
}

///|
pub fn TransitionEvent::currentTarget(self : TransitionEvent) -> Element {
  self.as_any()._get("currentTarget").cast()
}

///|
pub fn TransitionEvent::eventType(self : TransitionEvent) -> String {
  self.as_any()._get("type").cast()
}

///|
pub fn TransitionEvent::bubbles(self : TransitionEvent) -> Bool {
  self.as_any()._get("bubbles").cast()
}

///|
pub fn TransitionEvent::cancelable(self : TransitionEvent) -> Bool {
  self.as_any()._get("cancelable").cast()
}

///|
pub fn TransitionEvent::defaultPrevented(self : TransitionEvent) -> Bool {
  self.as_any()._get("defaultPrevented").cast()
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
pub fn AnimationEvent::as_any(self : AnimationEvent) -> @core.Any = "%identity"

///|
pub fn AnimationEvent::preventDefault(self : AnimationEvent) -> Unit {
  self.as_any()._call("preventDefault", []) |> ignore
}

///|
pub fn AnimationEvent::stopPropagation(self : AnimationEvent) -> Unit {
  self.as_any()._call("stopPropagation", []) |> ignore
}

///|
pub fn AnimationEvent::stopImmediatePropagation(self : AnimationEvent) -> Unit {
  self.as_any()._call("stopImmediatePropagation", []) |> ignore
}

///|
pub fn AnimationEvent::target(self : AnimationEvent) -> Element {
  self.as_any()._get("target").cast()
}

///|
pub fn AnimationEvent::currentTarget(self : AnimationEvent) -> Element {
  self.as_any()._get("currentTarget").cast()
}

///|
pub fn AnimationEvent::eventType(self : AnimationEvent) -> String {
  self.as_any()._get("type").cast()
}

///|
pub fn AnimationEvent::bubbles(self : AnimationEvent) -> Bool {
  self.as_any()._get("bubbles").cast()
}

///|
pub fn AnimationEvent::cancelable(self : AnimationEvent) -> Bool {
  self.as_any()._get("cancelable").cast()
}

///|
pub fn AnimationEvent::defaultPrevented(self : AnimationEvent) -> Bool {
  self.as_any()._get("defaultPrevented").cast()
}

///|
/// ScrollEvent represents a scroll event
pub(all) struct ScrollEvent {} derive(Show)

///|
pub fn ScrollEvent::as_any(self : ScrollEvent) -> @core.Any = "%identity"

///|
pub fn ScrollEvent::preventDefault(self : ScrollEvent) -> Unit {
  self.as_any()._call("preventDefault", []) |> ignore
}

///|
pub fn ScrollEvent::stopPropagation(self : ScrollEvent) -> Unit {
  self.as_any()._call("stopPropagation", []) |> ignore
}

///|
pub fn ScrollEvent::stopImmediatePropagation(self : ScrollEvent) -> Unit {
  self.as_any()._call("stopImmediatePropagation", []) |> ignore
}

///|
pub fn ScrollEvent::target(self : ScrollEvent) -> Element {
  self.as_any()._get("target").cast()
}

///|
pub fn ScrollEvent::currentTarget(self : ScrollEvent) -> Element {
  self.as_any()._get("currentTarget").cast()
}

///|
pub fn ScrollEvent::eventType(self : ScrollEvent) -> String {
  self.as_any()._get("type").cast()
}

///|
pub fn ScrollEvent::bubbles(self : ScrollEvent) -> Bool {
  self.as_any()._get("bubbles").cast()
}

///|
pub fn ScrollEvent::cancelable(self : ScrollEvent) -> Bool {
  self.as_any()._get("cancelable").cast()
}

///|
pub fn ScrollEvent::defaultPrevented(self : ScrollEvent) -> Bool {
  self.as_any()._get("defaultPrevented").cast()
}

///|
/// MessageEvent is fired when a message is received from another browsing context
/// https://developer.mozilla.org/en-US/docs/Web/API/MessageEvent
pub(all) struct MessageEvent {
  data : @core.Any
  origin : String
  lastEventId : String
  ports : Array[@message.MessagePort]
} derive(Show)

///|
pub fn MessageEvent::as_any(self : MessageEvent) -> @core.Any = "%identity"

///|
pub fn MessageEvent::preventDefault(self : MessageEvent) -> Unit {
  self.as_any()._call("preventDefault", []) |> ignore
}

///|
pub fn MessageEvent::stopPropagation(self : MessageEvent) -> Unit {
  self.as_any()._call("stopPropagation", []) |> ignore
}

///|
pub fn MessageEvent::stopImmediatePropagation(self : MessageEvent) -> Unit {
  self.as_any()._call("stopImmediatePropagation", []) |> ignore
}

///|
pub fn MessageEvent::target(self : MessageEvent) -> Element {
  self.as_any()._get("target").cast()
}

///|
pub fn MessageEvent::currentTarget(self : MessageEvent) -> Element {
  self.as_any()._get("currentTarget").cast()
}

///|
pub fn MessageEvent::eventType(self : MessageEvent) -> String {
  self.as_any()._get("type").cast()
}

///|
pub fn MessageEvent::bubbles(self : MessageEvent) -> Bool {
  self.as_any()._get("bubbles").cast()
}

///|
pub fn MessageEvent::cancelable(self : MessageEvent) -> Bool {
  self.as_any()._get("cancelable").cast()
}

///|
pub fn MessageEvent::defaultPrevented(self : MessageEvent) -> Bool {
  self.as_any()._get("defaultPrevented").cast()
}

///|
/// Returns the source window of the message
/// https://developer.mozilla.org/en-US/docs/Web/API/MessageEvent/source
pub fn MessageEvent::source(self : Self) -> Window? {
  let v : @core.Any = self.as_any()._get("source").cast()
  v |> @core.identity_option()
}

///|
/// PopStateEvent represents an event fired when the active history entry changes
/// https://developer.mozilla.org/en-US/docs/Web/API/PopStateEvent
#external
pub type PopStateEvent

///|
pub fn PopStateEvent::as_any(self : PopStateEvent) -> @core.Any = "%identity"

///|
pub fn PopStateEvent::preventDefault(self : PopStateEvent) -> Unit {
  self.as_any()._call("preventDefault", []) |> ignore
}

///|
pub fn PopStateEvent::stopPropagation(self : PopStateEvent) -> Unit {
  self.as_any()._call("stopPropagation", []) |> ignore
}

///|
pub fn PopStateEvent::stopImmediatePropagation(self : PopStateEvent) -> Unit {
  self.as_any()._call("stopImmediatePropagation", []) |> ignore
}

///|
pub fn PopStateEvent::target(self : PopStateEvent) -> Element {
  self.as_any()._get("target").cast()
}

///|
pub fn PopStateEvent::currentTarget(self : PopStateEvent) -> Element {
  self.as_any()._get("currentTarget").cast()
}

///|
pub fn PopStateEvent::eventType(self : PopStateEvent) -> String {
  self.as_any()._get("type").cast()
}

///|
pub fn PopStateEvent::bubbles(self : PopStateEvent) -> Bool {
  self.as_any()._get("bubbles").cast()
}

///|
pub fn PopStateEvent::cancelable(self : PopStateEvent) -> Bool {
  self.as_any()._get("cancelable").cast()
}

///|
pub fn PopStateEvent::defaultPrevented(self : PopStateEvent) -> Bool {
  self.as_any()._get("defaultPrevented").cast()
}

///|
/// Returns the state associated with the history entry
/// https://developer.mozilla.org/en-US/docs/Web/API/PopStateEvent/state
pub fn PopStateEvent::state(self : Self) -> @core.Any? {
  let v : @core.Any = self.as_any()._get("state").cast()
  v |> @core.identity_option()
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
pub fn HashChangeEvent::as_any(self : HashChangeEvent) -> @core.Any = "%identity"

///|
pub fn HashChangeEvent::preventDefault(self : HashChangeEvent) -> Unit {
  self.as_any()._call("preventDefault", []) |> ignore
}

///|
pub fn HashChangeEvent::stopPropagation(self : HashChangeEvent) -> Unit {
  self.as_any()._call("stopPropagation", []) |> ignore
}

///|
pub fn HashChangeEvent::stopImmediatePropagation(
  self : HashChangeEvent,
) -> Unit {
  self.as_any()._call("stopImmediatePropagation", []) |> ignore
}

///|
pub fn HashChangeEvent::target(self : HashChangeEvent) -> Element {
  self.as_any()._get("target").cast()
}

///|
pub fn HashChangeEvent::currentTarget(self : HashChangeEvent) -> Element {
  self.as_any()._get("currentTarget").cast()
}

///|
pub fn HashChangeEvent::eventType(self : HashChangeEvent) -> String {
  self.as_any()._get("type").cast()
}

///|
pub fn HashChangeEvent::bubbles(self : HashChangeEvent) -> Bool {
  self.as_any()._get("bubbles").cast()
}

///|
pub fn HashChangeEvent::cancelable(self : HashChangeEvent) -> Bool {
  self.as_any()._get("cancelable").cast()
}

///|
pub fn HashChangeEvent::defaultPrevented(self : HashChangeEvent) -> Bool {
  self.as_any()._get("defaultPrevented").cast()
}

///|
/// BeforeUnloadEvent represents an event fired when the window is about to be unloaded
/// https://developer.mozilla.org/en-US/docs/Web/API/BeforeUnloadEvent
#external
pub type BeforeUnloadEvent

///|
pub fn BeforeUnloadEvent::as_any(self : BeforeUnloadEvent) -> @core.Any = "%identity"

///|
pub fn BeforeUnloadEvent::preventDefault(self : BeforeUnloadEvent) -> Unit {
  self.as_any()._call("preventDefault", []) |> ignore
}

///|
pub fn BeforeUnloadEvent::stopPropagation(self : BeforeUnloadEvent) -> Unit {
  self.as_any()._call("stopPropagation", []) |> ignore
}

///|
pub fn BeforeUnloadEvent::stopImmediatePropagation(
  self : BeforeUnloadEvent,
) -> Unit {
  self.as_any()._call("stopImmediatePropagation", []) |> ignore
}

///|
pub fn BeforeUnloadEvent::target(self : BeforeUnloadEvent) -> Element {
  self.as_any()._get("target").cast()
}

///|
pub fn BeforeUnloadEvent::currentTarget(self : BeforeUnloadEvent) -> Element {
  self.as_any()._get("currentTarget").cast()
}

///|
pub fn BeforeUnloadEvent::eventType(self : BeforeUnloadEvent) -> String {
  self.as_any()._get("type").cast()
}

///|
pub fn BeforeUnloadEvent::bubbles(self : BeforeUnloadEvent) -> Bool {
  self.as_any()._get("bubbles").cast()
}

///|
pub fn BeforeUnloadEvent::cancelable(self : BeforeUnloadEvent) -> Bool {
  self.as_any()._get("cancelable").cast()
}

///|
pub fn BeforeUnloadEvent::defaultPrevented(self : BeforeUnloadEvent) -> Bool {
  self.as_any()._get("defaultPrevented").cast()
}

///|
/// Sets the return value to show a confirmation dialog
/// https://developer.mozilla.org/en-US/docs/Web/API/BeforeUnloadEvent/returnValue
#alias(set_return_value)
pub fn BeforeUnloadEvent::setReturnValue(self : Self, value : String) -> Unit {
  self.as_any()._set("returnValue", @core.any(value)) |> ignore
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
pub fn PageTransitionEvent::as_any(self : PageTransitionEvent) -> @core.Any = "%identity"

///|
pub fn PageTransitionEvent::preventDefault(self : PageTransitionEvent) -> Unit {
  self.as_any()._call("preventDefault", []) |> ignore
}

///|
pub fn PageTransitionEvent::stopPropagation(self : PageTransitionEvent) -> Unit {
  self.as_any()._call("stopPropagation", []) |> ignore
}

///|
pub fn PageTransitionEvent::stopImmediatePropagation(
  self : PageTransitionEvent,
) -> Unit {
  self.as_any()._call("stopImmediatePropagation", []) |> ignore
}

///|
pub fn PageTransitionEvent::target(self : PageTransitionEvent) -> Element {
  self.as_any()._get("target").cast()
}

///|
pub fn PageTransitionEvent::currentTarget(
  self : PageTransitionEvent,
) -> Element {
  self.as_any()._get("currentTarget").cast()
}

///|
pub fn PageTransitionEvent::eventType(self : PageTransitionEvent) -> String {
  self.as_any()._get("type").cast()
}

///|
pub fn PageTransitionEvent::bubbles(self : PageTransitionEvent) -> Bool {
  self.as_any()._get("bubbles").cast()
}

///|
pub fn PageTransitionEvent::cancelable(self : PageTransitionEvent) -> Bool {
  self.as_any()._get("cancelable").cast()
}

///|
pub fn PageTransitionEvent::defaultPrevented(
  self : PageTransitionEvent,
) -> Bool {
  self.as_any()._get("defaultPrevented").cast()
}
