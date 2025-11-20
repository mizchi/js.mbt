///|
/// EventImpl trait - base interface for all DOM events
pub(open) trait EventImpl: JsImpl {
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
  self.get("target") |> unsafe_cast
}

///|
impl EventImpl with currentTarget(self) -> Element {
  self.get("currentTarget") |> unsafe_cast
}

///|
impl EventImpl with eventType(self) -> String {
  self.get("type") |> unsafe_cast
}

///|
impl EventImpl with bubbles(self) -> Bool {
  self.get("bubbles") |> unsafe_cast
}

///|
impl EventImpl with cancelable(self) -> Bool {
  self.get("cancelable") |> unsafe_cast
}

///|
impl EventImpl with defaultPrevented(self) -> Bool {
  self.get("defaultPrevented") |> unsafe_cast
}

///|
/// Event represents a DOM event
/// https://developer.mozilla.org/en-US/docs/Web/API/Event
#external
pub type Event

///|
pub impl JsImpl for Event

///|
pub impl EventImpl for Event

///|
/// PointerEvent represents a pointer event
/// https://developer.mozilla.org/en-US/docs/Web/API/PointerEvent
#external
pub type PointerEvent

///|
pub impl JsImpl for PointerEvent

///|
pub impl EventImpl for PointerEvent

///|
/// Returns the width of the pointer contact
pub fn PointerEvent::width(self : Self) -> Double {
  self.get("width") |> unsafe_cast
}

///|
/// Returns the height of the pointer contact
pub fn PointerEvent::height(self : Self) -> Double {
  self.get("height") |> unsafe_cast
}

///|
/// Returns the pointer ID
pub fn PointerEvent::pointer_id(self : Self) -> Int {
  self.get("pointerId") |> unsafe_cast
}

///|
/// Returns the pointer type (mouse, pen, touch)
pub fn PointerEvent::pointer_type(self : Self) -> String {
  self.get("pointerType") |> unsafe_cast
}

///|
/// Returns whether the pointer is primary
pub fn PointerEvent::is_primary(self : Self) -> Bool {
  self.get("isPrimary") |> unsafe_cast
}

///|
/// MouseEvent represents a mouse event
/// https://developer.mozilla.org/en-US/docs/Web/API/MouseEvent
#external
pub type MouseEvent

///|
pub impl JsImpl for MouseEvent

///|
pub impl EventImpl for MouseEvent

///|
/// Returns the X coordinate relative to the viewport
/// https://developer.mozilla.org/en-US/docs/Web/API/MouseEvent/clientX
pub fn MouseEvent::clientX(self : Self) -> Int {
  self.get("clientX") |> unsafe_cast
}

///|
/// Returns the Y coordinate relative to the viewport
/// https://developer.mozilla.org/en-US/docs/Web/API/MouseEvent/clientY
pub fn MouseEvent::clientY(self : Self) -> Int {
  self.get("clientY") |> unsafe_cast
}

///|
/// Returns the X coordinate relative to the screen
/// https://developer.mozilla.org/en-US/docs/Web/API/MouseEvent/screenX
pub fn MouseEvent::screenX(self : MouseEvent) -> Int {
  self.get("screenX") |> unsafe_cast
}

///|
/// Returns the Y coordinate relative to the screen
/// https://developer.mozilla.org/en-US/docs/Web/API/MouseEvent/screenY
pub fn MouseEvent::screenY(self : MouseEvent) -> Int {
  self.get("screenY") |> unsafe_cast
}

///|
/// Returns the X coordinate relative to the target element
/// https://developer.mozilla.org/en-US/docs/Web/API/MouseEvent/offsetX
pub fn MouseEvent::offsetX(self : Self) -> Int {
  self.get("offsetX") |> unsafe_cast
}

///|
/// Returns the Y coordinate relative to the target element
/// https://developer.mozilla.org/en-US/docs/Web/API/MouseEvent/offsetY
pub fn MouseEvent::offsetY(self : Self) -> Int {
  self.get("offsetY") |> unsafe_cast
}

///|
/// Returns the X coordinate relative to the page
/// https://developer.mozilla.org/en-US/docs/Web/API/MouseEvent/pageX
pub fn MouseEvent::pageX(self : Self) -> Int {
  self.get("pageX") |> unsafe_cast
}

///|
/// Returns the Y coordinate relative to the page
/// https://developer.mozilla.org/en-US/docs/Web/API/MouseEvent/pageY
pub fn MouseEvent::pageY(self : Self) -> Int {
  self.get("pageY") |> unsafe_cast
}

///|
/// Returns which mouse button was pressed
/// https://developer.mozilla.org/en-US/docs/Web/API/MouseEvent/button
pub fn MouseEvent::button(self : Self) -> Int {
  self.get("button") |> unsafe_cast
}

///|
/// Returns which mouse buttons were pressed
/// https://developer.mozilla.org/en-US/docs/Web/API/MouseEvent/buttons
pub fn MouseEvent::buttons(self : Self) -> Int {
  self.get("buttons") |> unsafe_cast
}

///|
/// Returns whether the Ctrl key was pressed
pub fn MouseEvent::ctrlKey(self : Self) -> Bool {
  self.get("ctrlKey") |> unsafe_cast
}

///|
/// Returns whether the Shift key was pressed
pub fn MouseEvent::shiftKey(self : Self) -> Bool {
  self.get("shiftKey") |> unsafe_cast
}

///|
/// Returns whether the Alt key was pressed
pub fn MouseEvent::altKey(self : Self) -> Bool {
  self.get("altKey") |> unsafe_cast
}

///|
/// Returns whether the Meta key was pressed
pub fn MouseEvent::metaKey(self : Self) -> Bool {
  self.get("metaKey") |> unsafe_cast
}

///|
/// KeyboardEvent represents a keyboard event
/// https://developer.mozilla.org/en-US/docs/Web/API/KeyboardEvent
#external
pub type KeyboardEvent

///|
impl JsImpl for KeyboardEvent

///|
pub impl EventImpl for KeyboardEvent

///|
/// Returns the key value
/// https://developer.mozilla.org/en-US/docs/Web/API/KeyboardEvent/key
pub fn KeyboardEvent::key(self : KeyboardEvent) -> String {
  self.get("key") |> unsafe_cast
}

///|
/// Returns the key code (deprecated)
/// https://developer.mozilla.org/en-US/docs/Web/API/KeyboardEvent/keyCode
pub fn KeyboardEvent::keyCode(self : KeyboardEvent) -> Int {
  self.get("keyCode") |> unsafe_cast
}

///|
/// Returns which key was pressed (deprecated)
pub fn KeyboardEvent::which(self : KeyboardEvent) -> Int {
  self.get("which") |> unsafe_cast
}

///|
/// Returns the physical key code
/// https://developer.mozilla.org/en-US/docs/Web/API/KeyboardEvent/code
pub fn KeyboardEvent::code(self : KeyboardEvent) -> String {
  self.get("code") |> unsafe_cast
}

///|
/// Returns whether the Ctrl key was pressed
pub fn KeyboardEvent::ctrl_key(self : KeyboardEvent) -> Bool {
  self.get("ctrlKey") |> unsafe_cast
}

///|
/// Returns whether the Alt key was pressed
pub fn KeyboardEvent::altKey(self : KeyboardEvent) -> Bool {
  self.get("altKey") |> unsafe_cast
}

///|
/// Returns whether the Shift key was pressed
pub fn KeyboardEvent::shiftKey(self : KeyboardEvent) -> Bool {
  self.get("shiftKey") |> unsafe_cast
}

///|
/// Returns whether the Meta key was pressed
pub fn KeyboardEvent::metaKey(self : KeyboardEvent) -> Bool {
  self.get("metaKey") |> unsafe_cast
}

///|
/// Returns whether the key is being held down
pub fn KeyboardEvent::repeat(self : KeyboardEvent) -> Bool {
  self.get("repeat") |> unsafe_cast
}

///|
/// Returns the location of the key on the keyboard
pub fn KeyboardEvent::location(self : KeyboardEvent) -> Int {
  self.get("location") |> unsafe_cast
}

///|
/// ChangeEvent represents a change event
#external
pub type ChangeEvent

///|
pub impl JsImpl for ChangeEvent

///|
pub impl EventImpl for ChangeEvent

///|
/// FocusEvent represents a focus event
/// https://developer.mozilla.org/en-US/docs/Web/API/FocusEvent
#external
pub type FocusEvent

///|
impl JsImpl for FocusEvent

///|
pub impl EventImpl for FocusEvent

///|
/// Returns the related target (element losing/gaining focus)
pub fn FocusEvent::relatedTarget(self : FocusEvent) -> Element? {
  self.get("relatedTarget") |> @js.unsafe_cast_option()
}

///|
/// FormEvent represents a form event
#external
pub type FormEvent

///|
impl JsImpl for FormEvent

///|
pub impl EventImpl for FormEvent

///|
/// Returns the form data
pub fn FormEvent::formData(self : FormEvent) -> Js {
  self.get("formData")
}

///|
/// DragEvent represents a drag and drop event
/// https://developer.mozilla.org/en-US/docs/Web/API/DragEvent
#external
pub type DragEvent

///|
pub impl JsImpl for DragEvent

///|
pub impl EventImpl for DragEvent

///|
/// Returns the data transfer object
/// https://developer.mozilla.org/en-US/docs/Web/API/DragEvent/dataTransfer
pub fn DragEvent::dataTransfer(self : Self) -> Js {
  self.get("dataTransfer")
}

///|
/// InputEvent represents an input event
/// https://developer.mozilla.org/en-US/docs/Web/API/InputEvent
#external
pub type InputEvent

///|
impl JsImpl for InputEvent

///|
pub impl EventImpl for InputEvent

///|
/// Returns the input data
pub fn InputEvent::data(self : Self) -> String? {
  self.get("data") |> @js.unsafe_cast_option()
}

///|
/// Returns the input type
pub fn InputEvent::inputType(self : Self) -> String {
  self.get("inputType") |> unsafe_cast
}

///|
/// WheelEvent represents a wheel event
/// https://developer.mozilla.org/en-US/docs/Web/API/WheelEvent
#external
pub type WheelEvent

///|
impl JsImpl for WheelEvent

///|
pub impl EventImpl for WheelEvent

///|
/// Returns the horizontal scroll amount
pub fn WheelEvent::delta_x(self : Self) -> Double {
  self.get("deltaX") |> unsafe_cast
}

///|
/// Returns the vertical scroll amount
pub fn WheelEvent::delta_y(self : Self) -> Double {
  self.get("deltaY") |> unsafe_cast
}

///|
/// Returns the Z-axis scroll amount
pub fn WheelEvent::delta_z(self : Self) -> Double {
  self.get("deltaZ") |> unsafe_cast
}

///|
/// Returns the delta mode (pixel, line, or page)
pub fn WheelEvent::delta_mode(self : Self) -> Int {
  self.get("deltaMode") |> unsafe_cast
}

///|
/// TouchEvent represents a touch event
/// https://developer.mozilla.org/en-US/docs/Web/API/TouchEvent
#external
pub type TouchEvent

///|
impl JsImpl for TouchEvent

///|
pub impl EventImpl for TouchEvent

///|
/// Returns the list of all touches
/// https://developer.mozilla.org/en-US/docs/Web/API/TouchEvent/touches
pub fn TouchEvent::touches(self : Self) -> Js {
  self.get("touches")
}

///|
/// Returns the list of touches that are currently in contact with the surface
/// https://developer.mozilla.org/en-US/docs/Web/API/TouchEvent/targetTouches
pub fn TouchEvent::targetTouches(self : Self) -> Js {
  self.get("targetTouches")
}

///|
/// Returns the list of touches that changed since the last event
/// https://developer.mozilla.org/en-US/docs/Web/API/TouchEvent/changedTouches
pub fn TouchEvent::changedTouches(self : Self) -> Js {
  self.get("changedTouches")
}

///|
/// Returns whether the Alt key was pressed
pub fn TouchEvent::altKey(self : Self) -> Bool {
  self.get("altKey") |> unsafe_cast
}

///|
/// Returns whether the Ctrl key was pressed
pub fn TouchEvent::ctrlKey(self : Self) -> Bool {
  self.get("ctrlKey") |> unsafe_cast
}

///|
/// Returns whether the Shift key was pressed
pub fn TouchEvent::shiftKey(self : Self) -> Bool {
  self.get("shiftKey") |> unsafe_cast
}

///|
/// Returns whether the Meta key was pressed
pub fn TouchEvent::metaKey(self : Self) -> Bool {
  self.get("metaKey") |> unsafe_cast
}

///|
/// Touch represents a single touch point
/// https://developer.mozilla.org/en-US/docs/Web/API/Touch
#external
pub type Touch

///|
impl JsImpl for Touch

///|
/// Returns the unique identifier for this touch
pub fn Touch::identifier(self : Self) -> Int {
  self.get("identifier") |> unsafe_cast
}

///|
/// Returns the X coordinate relative to the viewport
pub fn Touch::clientX(self : Self) -> Double {
  self.get("clientX") |> unsafe_cast
}

///|
/// Returns the Y coordinate relative to the viewport
pub fn Touch::clientY(self : Self) -> Double {
  self.get("clientY") |> unsafe_cast
}

///|
/// Returns the X coordinate relative to the screen
pub fn Touch::screenX(self : Self) -> Double {
  self.get("screenX") |> unsafe_cast
}

///|
/// Returns the Y coordinate relative to the screen
pub fn Touch::screenY(self : Self) -> Double {
  self.get("screenY") |> unsafe_cast
}

///|
/// Returns the X coordinate relative to the page
pub fn Touch::pageX(self : Self) -> Double {
  self.get("pageX") |> unsafe_cast
}

///|
/// Returns the Y coordinate relative to the page
pub fn Touch::pageY(self : Self) -> Double {
  self.get("pageY") |> unsafe_cast
}

///|
/// Returns the X radius of the ellipse that approximates the touch area
pub fn Touch::radiusX(self : Self) -> Double {
  self.get("radiusX") |> unsafe_cast
}

///|
/// Returns the Y radius of the ellipse that approximates the touch area
pub fn Touch::radiusY(self : Self) -> Double {
  self.get("radiusY") |> unsafe_cast
}

///|
/// Returns the rotation angle of the touch area ellipse
pub fn Touch::rotationAngle(self : Self) -> Double {
  self.get("rotationAngle") |> unsafe_cast
}

///|
/// Returns the amount of pressure applied
pub fn Touch::force(self : Self) -> Double {
  self.get("force") |> unsafe_cast
}

///|
/// Returns the target element
pub fn Touch::target(self : Self) -> Element {
  self.get("target") |> unsafe_cast
}

///|
/// ClipboardEvent represents a clipboard event
/// https://developer.mozilla.org/en-US/docs/Web/API/ClipboardEvent
#external
pub type ClipboardEvent

///|
impl JsImpl for ClipboardEvent

///|
pub impl EventImpl for ClipboardEvent

///|
/// Returns the clipboard data
/// https://developer.mozilla.org/en-US/docs/Web/API/ClipboardEvent/clipboardData
pub fn ClipboardEvent::clipboardData(self : Self) -> Js? {
  self.get("clipboardData") |> @js.unsafe_cast_option()
}

///|
/// TransitionEvent represents a CSS transition event
/// https://developer.mozilla.org/en-US/docs/Web/API/TransitionEvent
#external
pub type TransitionEvent

///|
impl JsImpl for TransitionEvent

///|
pub impl EventImpl for TransitionEvent

///|
/// Returns the name of the CSS property associated with the transition
pub fn TransitionEvent::propertyName(self : Self) -> String {
  self.get("propertyName") |> unsafe_cast
}

///|
/// Returns the elapsed time of the transition in seconds
pub fn TransitionEvent::elapsedTime(self : Self) -> Double {
  self.get("elapsedTime") |> unsafe_cast
}

///|
/// Returns the pseudo-element name
pub fn TransitionEvent::pseudoElement(self : Self) -> String {
  self.get("pseudoElement") |> unsafe_cast
}

///|
/// AnimationEvent represents a CSS animation event
/// https://developer.mozilla.org/en-US/docs/Web/API/AnimationEvent
#external
pub type AnimationEvent

///|
impl JsImpl for AnimationEvent

///|
pub impl EventImpl for AnimationEvent

///|
/// Returns the name of the CSS animation
pub fn AnimationEvent::animationName(self : Self) -> String {
  self.get("animationName") |> unsafe_cast
}

///|
/// Returns the elapsed time of the animation in seconds
pub fn AnimationEvent::elapsedTime(self : Self) -> Double {
  self.get("elapsedTime") |> unsafe_cast
}

///|
/// Returns the pseudo-element name
pub fn AnimationEvent::pseudoElement(self : Self) -> String {
  self.get("pseudoElement") |> unsafe_cast
}

///|
/// ScrollEvent represents a scroll event
#external
pub type ScrollEvent

///|
pub impl JsImpl for ScrollEvent

///|
pub impl EventImpl for ScrollEvent

///|
/// MessageEvent is fired when a message is received from another browsing context
/// https://developer.mozilla.org/en-US/docs/Web/API/MessageEvent
#external
pub type MessageEvent

///|
pub impl JsImpl for MessageEvent

///|
pub impl EventImpl for MessageEvent

///|
/// Returns the data sent by the message emitter
/// https://developer.mozilla.org/en-US/docs/Web/API/MessageEvent/data
pub fn MessageEvent::data(self : Self) -> Js {
  self.get("data") |> unsafe_cast
}

///|
/// Returns the origin of the message emitter
/// https://developer.mozilla.org/en-US/docs/Web/API/MessageEvent/origin
pub fn MessageEvent::origin(self : Self) -> String {
  self.get("origin") |> unsafe_cast
}

///|
/// Returns the source window of the message
/// https://developer.mozilla.org/en-US/docs/Web/API/MessageEvent/source
pub fn MessageEvent::source(self : Self) -> Window? {
  self.get("source") |> @js.unsafe_cast_option()
}

///|
/// Returns the array of MessagePort objects
/// https://developer.mozilla.org/en-US/docs/Web/API/MessageEvent/ports
pub fn MessageEvent::ports(self : Self) -> Array[Js] {
  @js.array_from(self.get("ports")).map(fn(v) { unsafe_cast(v) })
}
