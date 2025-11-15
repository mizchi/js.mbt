///|
/// EventImpl trait - base interface for all DOM events
pub(open) trait EventImpl: Js {
  prevent_default(Self) -> Unit = _
  stop_propagation(Self) -> Unit = _
  stop_immediate_propagation(Self) -> Unit = _
  target(Self) -> Element = _
  current_target(Self) -> Element = _
  event_type(Self) -> String = _
  bubbles(Self) -> Bool = _
  cancelable(Self) -> Bool = _
  default_prevented(Self) -> Bool = _
}

///|
impl EventImpl with prevent_default(self) -> Unit {
  ignore(self.to_js().invoke("preventDefault", []))
}

///|
impl EventImpl with stop_propagation(self) -> Unit {
  ignore(self.to_js().invoke("stopPropagation", []))
}

///|
impl EventImpl with stop_immediate_propagation(self) -> Unit {
  ignore(self.to_js().invoke("stopImmediatePropagation", []))
}

///|
impl EventImpl with target(self) -> Element {
  self.to_js().get("target").cast()
}

///|
impl EventImpl with current_target(self) -> Element {
  self.to_js().get("currentTarget").cast()
}

///|
impl EventImpl with event_type(self) -> String {
  self.to_js().get("type").cast()
}

///|
impl EventImpl with bubbles(self) -> Bool {
  self.to_js().get("bubbles").cast()
}

///|
impl EventImpl with cancelable(self) -> Bool {
  self.to_js().get("cancelable").cast()
}

///|
impl EventImpl with default_prevented(self) -> Bool {
  self.to_js().get("defaultPrevented").cast()
}

///|
/// Event represents a DOM event
/// https://developer.mozilla.org/en-US/docs/Web/API/Event
#external
pub type Event

///|
pub impl Js for Event with to_js(self) -> Val {
  self |> js
}

///|
pub impl EventImpl for Event

///|
/// PointerEvent represents a pointer event
/// https://developer.mozilla.org/en-US/docs/Web/API/PointerEvent
#external
pub type PointerEvent

///|
pub impl Js for PointerEvent with to_js(self) {
  self |> js
}

///|
pub impl EventImpl for PointerEvent

///|
/// Returns the width of the pointer contact
pub fn PointerEvent::width(self : Self) -> Double {
  self.to_js().get("width").cast()
}

///|
/// Returns the height of the pointer contact
pub fn PointerEvent::height(self : Self) -> Double {
  self.to_js().get("height").cast()
}

///|
/// Returns the pointer ID
pub fn PointerEvent::pointer_id(self : Self) -> Int {
  self.to_js().get("pointerId").cast()
}

///|
/// Returns the pointer type (mouse, pen, touch)
pub fn PointerEvent::pointer_type(self : Self) -> String {
  self.to_js().get("pointerType").cast()
}

///|
/// Returns whether the pointer is primary
pub fn PointerEvent::is_primary(self : Self) -> Bool {
  self.to_js().get("isPrimary").cast()
}

///|
/// MouseEvent represents a mouse event
/// https://developer.mozilla.org/en-US/docs/Web/API/MouseEvent
#external
pub type MouseEvent

///|
pub impl Js for MouseEvent with to_js(self) -> Val {
  self |> js
}

///|
pub impl EventImpl for MouseEvent

///|
/// Returns the X coordinate relative to the viewport
/// https://developer.mozilla.org/en-US/docs/Web/API/MouseEvent/clientX
pub fn MouseEvent::client_x(self : Self) -> Int {
  self.to_js().get("clientX").cast()
}

///|
/// Returns the Y coordinate relative to the viewport
/// https://developer.mozilla.org/en-US/docs/Web/API/MouseEvent/clientY
pub fn MouseEvent::client_y(self : Self) -> Int {
  self.to_js().get("clientY").cast()
}

///|
/// Returns the X coordinate relative to the screen
/// https://developer.mozilla.org/en-US/docs/Web/API/MouseEvent/screenX
pub fn MouseEvent::screen_x(self : MouseEvent) -> Int {
  self.to_js().get("screenX").cast()
}

///|
/// Returns the Y coordinate relative to the screen
/// https://developer.mozilla.org/en-US/docs/Web/API/MouseEvent/screenY
pub fn MouseEvent::screen_y(self : MouseEvent) -> Int {
  self.to_js().get("screenY").cast()
}

///|
/// Returns the X coordinate relative to the target element
/// https://developer.mozilla.org/en-US/docs/Web/API/MouseEvent/offsetX
pub fn MouseEvent::offset_x(self : Self) -> Int {
  self.to_js().get("offsetX").cast()
}

///|
/// Returns the Y coordinate relative to the target element
/// https://developer.mozilla.org/en-US/docs/Web/API/MouseEvent/offsetY
pub fn MouseEvent::offset_y(self : Self) -> Int {
  self.to_js().get("offsetY").cast()
}

///|
/// Returns the X coordinate relative to the page
/// https://developer.mozilla.org/en-US/docs/Web/API/MouseEvent/pageX
pub fn MouseEvent::page_x(self : Self) -> Int {
  self.to_js().get("pageX").cast()
}

///|
/// Returns the Y coordinate relative to the page
/// https://developer.mozilla.org/en-US/docs/Web/API/MouseEvent/pageY
pub fn MouseEvent::page_y(self : Self) -> Int {
  self.to_js().get("pageY").cast()
}

///|
/// Returns which mouse button was pressed
/// https://developer.mozilla.org/en-US/docs/Web/API/MouseEvent/button
pub fn MouseEvent::button(self : Self) -> Int {
  self.to_js().get("button").cast()
}

///|
/// Returns which mouse buttons were pressed
/// https://developer.mozilla.org/en-US/docs/Web/API/MouseEvent/buttons
pub fn MouseEvent::buttons(self : Self) -> Int {
  self.to_js().get("buttons").cast()
}

///|
/// Returns whether the Ctrl key was pressed
pub fn MouseEvent::ctrl_key(self : Self) -> Bool {
  self.to_js().get("ctrlKey").cast()
}

///|
/// Returns whether the Shift key was pressed
pub fn MouseEvent::shift_key(self : Self) -> Bool {
  self.to_js().get("shiftKey").cast()
}

///|
/// Returns whether the Alt key was pressed
pub fn MouseEvent::alt_key(self : Self) -> Bool {
  self.to_js().get("altKey").cast()
}

///|
/// Returns whether the Meta key was pressed
pub fn MouseEvent::meta_key(self : Self) -> Bool {
  self.to_js().get("metaKey").cast()
}

///|
/// KeyboardEvent represents a keyboard event
/// https://developer.mozilla.org/en-US/docs/Web/API/KeyboardEvent
#external
pub type KeyboardEvent

///|
impl Js for KeyboardEvent with to_js(self) -> Val {
  self |> js
}

///|
pub impl EventImpl for KeyboardEvent

///|
/// Returns the key value
/// https://developer.mozilla.org/en-US/docs/Web/API/KeyboardEvent/key
pub fn KeyboardEvent::key(self : KeyboardEvent) -> String {
  self.to_js().get("key").cast()
}

///|
/// Returns the key code (deprecated)
/// https://developer.mozilla.org/en-US/docs/Web/API/KeyboardEvent/keyCode
pub fn KeyboardEvent::key_code(self : KeyboardEvent) -> Int {
  self.to_js().get("keyCode").cast()
}

///|
/// Returns which key was pressed (deprecated)
pub fn KeyboardEvent::which(self : KeyboardEvent) -> Int {
  self.to_js().get("which").cast()
}

///|
/// Returns the physical key code
/// https://developer.mozilla.org/en-US/docs/Web/API/KeyboardEvent/code
pub fn KeyboardEvent::code(self : KeyboardEvent) -> String {
  self.to_js().get("code").cast()
}

///|
/// Returns whether the Ctrl key was pressed
pub fn KeyboardEvent::ctrl_key(self : KeyboardEvent) -> Bool {
  self.to_js().get("ctrlKey").cast()
}

///|
/// Returns whether the Alt key was pressed
pub fn KeyboardEvent::alt_key(self : KeyboardEvent) -> Bool {
  self.to_js().get("altKey").cast()
}

///|
/// Returns whether the Shift key was pressed
pub fn KeyboardEvent::shift_key(self : KeyboardEvent) -> Bool {
  self.to_js().get("shiftKey").cast()
}

///|
/// Returns whether the Meta key was pressed
pub fn KeyboardEvent::meta_key(self : KeyboardEvent) -> Bool {
  self.to_js().get("metaKey").cast()
}

///|
/// Returns whether the key is being held down
pub fn KeyboardEvent::repeat(self : KeyboardEvent) -> Bool {
  self.to_js().get("repeat").cast()
}

///|
/// Returns the location of the key on the keyboard
pub fn KeyboardEvent::location(self : KeyboardEvent) -> Int {
  self.to_js().get("location").cast()
}

///|
/// ChangeEvent represents a change event
#external
pub type ChangeEvent

///|
pub impl Js for ChangeEvent with to_js(self) -> Val {
  self |> js
}

///|
pub impl EventImpl for ChangeEvent

///|
/// FocusEvent represents a focus event
/// https://developer.mozilla.org/en-US/docs/Web/API/FocusEvent
#external
pub type FocusEvent

///|
impl Js for FocusEvent with to_js(self) -> Val {
  self |> js
}

///|
pub impl EventImpl for FocusEvent

///|
/// Returns the related target (element losing/gaining focus)
pub fn FocusEvent::related_target(self : FocusEvent) -> Element? {
  self.to_js().get("relatedTarget").cast_option()
}

///|
/// FormEvent represents a form event
#external
pub type FormEvent

///|
impl Js for FormEvent with to_js(self) -> Val {
  self |> js
}

///|
pub impl EventImpl for FormEvent

///|
/// Returns the form data
pub fn FormEvent::form_data(self : FormEvent) -> Val {
  self.to_js().get("formData")
}

///|
/// DragEvent represents a drag and drop event
/// https://developer.mozilla.org/en-US/docs/Web/API/DragEvent
#external
pub type DragEvent

///|
pub impl Js for DragEvent with to_js(self) -> Val {
  self |> js
}

///|
pub impl EventImpl for DragEvent

///|
/// Returns the data transfer object
/// https://developer.mozilla.org/en-US/docs/Web/API/DragEvent/dataTransfer
pub fn DragEvent::data_transfer(self : Self) -> Val {
  self.to_js().get("dataTransfer")
}

///|
/// InputEvent represents an input event
/// https://developer.mozilla.org/en-US/docs/Web/API/InputEvent
#external
pub type InputEvent

///|
impl Js for InputEvent with to_js(self) -> Val {
  self |> js
}

///|
pub impl EventImpl for InputEvent

///|
/// Returns the input data
pub fn InputEvent::data(self : Self) -> String? {
  self.to_js().get("data").cast_option()
}

///|
/// Returns the input type
pub fn InputEvent::input_type(self : Self) -> String {
  self.to_js().get("inputType").cast()
}

///|
/// WheelEvent represents a wheel event
/// https://developer.mozilla.org/en-US/docs/Web/API/WheelEvent
#external
pub type WheelEvent

///|
impl Js for WheelEvent with to_js(self) -> Val {
  self |> js
}

///|
pub impl EventImpl for WheelEvent

///|
/// Returns the horizontal scroll amount
pub fn WheelEvent::delta_x(self : Self) -> Double {
  self.to_js().get("deltaX").cast()
}

///|
/// Returns the vertical scroll amount
pub fn WheelEvent::delta_y(self : Self) -> Double {
  self.to_js().get("deltaY").cast()
}

///|
/// Returns the Z-axis scroll amount
pub fn WheelEvent::delta_z(self : Self) -> Double {
  self.to_js().get("deltaZ").cast()
}

///|
/// Returns the delta mode (pixel, line, or page)
pub fn WheelEvent::delta_mode(self : Self) -> Int {
  self.to_js().get("deltaMode").cast()
}

///|
/// TouchEvent represents a touch event
/// https://developer.mozilla.org/en-US/docs/Web/API/TouchEvent
#external
pub type TouchEvent

///|
impl Js for TouchEvent with to_js(self) -> Val {
  self |> js
}

///|
pub impl EventImpl for TouchEvent

///|
/// Returns the list of all touches
/// https://developer.mozilla.org/en-US/docs/Web/API/TouchEvent/touches
pub fn TouchEvent::touches(self : Self) -> Val {
  self.to_js().get("touches")
}

///|
/// Returns the list of touches that are currently in contact with the surface
/// https://developer.mozilla.org/en-US/docs/Web/API/TouchEvent/targetTouches
pub fn TouchEvent::target_touches(self : Self) -> Val {
  self.to_js().get("targetTouches")
}

///|
/// Returns the list of touches that changed since the last event
/// https://developer.mozilla.org/en-US/docs/Web/API/TouchEvent/changedTouches
pub fn TouchEvent::changed_touches(self : Self) -> Val {
  self.to_js().get("changedTouches")
}

///|
/// Returns whether the Alt key was pressed
pub fn TouchEvent::alt_key(self : Self) -> Bool {
  self.to_js().get("altKey").cast()
}

///|
/// Returns whether the Ctrl key was pressed
pub fn TouchEvent::ctrl_key(self : Self) -> Bool {
  self.to_js().get("ctrlKey").cast()
}

///|
/// Returns whether the Shift key was pressed
pub fn TouchEvent::shift_key(self : Self) -> Bool {
  self.to_js().get("shiftKey").cast()
}

///|
/// Returns whether the Meta key was pressed
pub fn TouchEvent::meta_key(self : Self) -> Bool {
  self.to_js().get("metaKey").cast()
}

///|
/// Touch represents a single touch point
/// https://developer.mozilla.org/en-US/docs/Web/API/Touch
#external
pub type Touch

///|
impl Js for Touch with to_js(self) -> Val {
  self |> js
}

///|
/// Returns the unique identifier for this touch
pub fn Touch::identifier(self : Self) -> Int {
  self.to_js().get("identifier").cast()
}

///|
/// Returns the X coordinate relative to the viewport
pub fn Touch::client_x(self : Self) -> Double {
  self.to_js().get("clientX").cast()
}

///|
/// Returns the Y coordinate relative to the viewport
pub fn Touch::client_y(self : Self) -> Double {
  self.to_js().get("clientY").cast()
}

///|
/// Returns the X coordinate relative to the screen
pub fn Touch::screen_x(self : Self) -> Double {
  self.to_js().get("screenX").cast()
}

///|
/// Returns the Y coordinate relative to the screen
pub fn Touch::screen_y(self : Self) -> Double {
  self.to_js().get("screenY").cast()
}

///|
/// Returns the X coordinate relative to the page
pub fn Touch::page_x(self : Self) -> Double {
  self.to_js().get("pageX").cast()
}

///|
/// Returns the Y coordinate relative to the page
pub fn Touch::page_y(self : Self) -> Double {
  self.to_js().get("pageY").cast()
}

///|
/// Returns the X radius of the ellipse that approximates the touch area
pub fn Touch::radius_x(self : Self) -> Double {
  self.to_js().get("radiusX").cast()
}

///|
/// Returns the Y radius of the ellipse that approximates the touch area
pub fn Touch::radius_y(self : Self) -> Double {
  self.to_js().get("radiusY").cast()
}

///|
/// Returns the rotation angle of the touch area ellipse
pub fn Touch::rotation_angle(self : Self) -> Double {
  self.to_js().get("rotationAngle").cast()
}

///|
/// Returns the amount of pressure applied
pub fn Touch::force(self : Self) -> Double {
  self.to_js().get("force").cast()
}

///|
/// Returns the target element
pub fn Touch::target(self : Self) -> Element {
  self.to_js().get("target").cast()
}

///|
/// ClipboardEvent represents a clipboard event
/// https://developer.mozilla.org/en-US/docs/Web/API/ClipboardEvent
#external
pub type ClipboardEvent

///|
impl Js for ClipboardEvent with to_js(self) -> Val {
  self |> js
}

///|
pub impl EventImpl for ClipboardEvent

///|
/// Returns the clipboard data
/// https://developer.mozilla.org/en-US/docs/Web/API/ClipboardEvent/clipboardData
pub fn ClipboardEvent::clipboard_data(self : Self) -> Val? {
  self.to_js().get("clipboardData").cast_option()
}

///|
/// TransitionEvent represents a CSS transition event
/// https://developer.mozilla.org/en-US/docs/Web/API/TransitionEvent
#external
pub type TransitionEvent

///|
impl Js for TransitionEvent with to_js(self) -> Val {
  self |> js
}

///|
pub impl EventImpl for TransitionEvent

///|
/// Returns the name of the CSS property associated with the transition
pub fn TransitionEvent::property_name(self : Self) -> String {
  self.to_js().get("propertyName").cast()
}

///|
/// Returns the elapsed time of the transition in seconds
pub fn TransitionEvent::elapsed_time(self : Self) -> Double {
  self.to_js().get("elapsedTime").cast()
}

///|
/// Returns the pseudo-element name
pub fn TransitionEvent::pseudo_element(self : Self) -> String {
  self.to_js().get("pseudoElement").cast()
}

///|
/// AnimationEvent represents a CSS animation event
/// https://developer.mozilla.org/en-US/docs/Web/API/AnimationEvent
#external
pub type AnimationEvent

///|
impl Js for AnimationEvent with to_js(self) -> Val {
  self |> js
}

///|
pub impl EventImpl for AnimationEvent

///|
/// Returns the name of the CSS animation
pub fn AnimationEvent::animation_name(self : Self) -> String {
  self.to_js().get("animationName").cast()
}

///|
/// Returns the elapsed time of the animation in seconds
pub fn AnimationEvent::elapsed_time(self : Self) -> Double {
  self.to_js().get("elapsedTime").cast()
}

///|
/// Returns the pseudo-element name
pub fn AnimationEvent::pseudo_element(self : Self) -> String {
  self.to_js().get("pseudoElement").cast()
}

///|
/// ScrollEvent represents a scroll event
#external
pub type ScrollEvent

///|
pub impl Js for ScrollEvent

///|
pub impl EventImpl for ScrollEvent

///|
/// MessageEvent is fired when a message is received from another browsing context
/// https://developer.mozilla.org/en-US/docs/Web/API/MessageEvent
#external
pub type MessageEvent

///|
pub impl Js for MessageEvent with to_js(self) -> Val {
  self |> js
}

///|
pub impl EventImpl for MessageEvent

///|
/// Returns the data sent by the message emitter
/// https://developer.mozilla.org/en-US/docs/Web/API/MessageEvent/data
pub fn MessageEvent::data(self : Self) -> Val {
  self.to_js().get("data").cast()
}

///|
/// Returns the origin of the message emitter
/// https://developer.mozilla.org/en-US/docs/Web/API/MessageEvent/origin
pub fn MessageEvent::origin(self : Self) -> String {
  self.to_js().get("origin").cast()
}

///|
/// Returns the source window of the message
/// https://developer.mozilla.org/en-US/docs/Web/API/MessageEvent/source
pub fn MessageEvent::source(self : Self) -> Window? {
  self.to_js().get("source").cast_option()
}

///|
/// Returns the array of MessagePort objects
/// https://developer.mozilla.org/en-US/docs/Web/API/MessageEvent/ports
pub fn MessageEvent::ports(self : Self) -> Array[Val] {
  @js.array_from(self.to_js().get("ports")).map(fn(v) { v.cast() })
}

///|
/// DOMRectReadOnly represents a read-only rectangle
/// https://developer.mozilla.org/en-US/docs/Web/API/DOMRectReadOnly
#external
pub type DOMRectReadOnly

///|
pub impl Js for DOMRectReadOnly with to_js(self) -> Val {
  self |> js
}

///|
pub fn DOMRectReadOnly::x(self : Self) -> Double {
  self.to_js().get("x").cast()
}

///|
pub fn DOMRectReadOnly::y(self : Self) -> Double {
  self.to_js().get("y").cast()
}

///|
pub fn DOMRectReadOnly::width(self : Self) -> Double {
  self.to_js().get("width").cast()
}

///|
pub fn DOMRectReadOnly::height(self : Self) -> Double {
  self.to_js().get("height").cast()
}

///|
pub fn DOMRectReadOnly::top(self : Self) -> Double {
  self.to_js().get("top").cast()
}

///|
pub fn DOMRectReadOnly::right(self : Self) -> Double {
  self.to_js().get("right").cast()
}

///|
pub fn DOMRectReadOnly::bottom(self : Self) -> Double {
  self.to_js().get("bottom").cast()
}

///|
pub fn DOMRectReadOnly::left(self : Self) -> Double {
  self.to_js().get("left").cast()
}

///|
/// ResizeObserverEntry represents an entry in a ResizeObserver
/// https://developer.mozilla.org/en-US/docs/Web/API/ResizeObserverEntry
#external
pub type ResizeObserverEntry

///|
pub impl Js for ResizeObserverEntry

///|
/// Returns the target element being observed
pub fn ResizeObserverEntry::target(self : Self) -> Element {
  self.to_js().get("target").cast()
}

///|
/// Returns the content rect
pub fn ResizeObserverEntry::content_rect(self : Self) -> DOMRectReadOnly {
  self.to_js().get("contentRect").cast()
}

///|
/// Returns the border box size
pub fn ResizeObserverEntry::border_box_size(self : Self) -> Val {
  self.to_js().get("borderBoxSize")
}

///|
/// Returns the content box size
pub fn ResizeObserverEntry::content_box_size(self : Self) -> Val {
  self.to_js().get("contentBoxSize")
}
