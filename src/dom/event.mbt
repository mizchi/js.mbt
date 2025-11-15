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
  ignore(self.invoke("preventDefault", []))
}

///|
impl EventImpl with stop_propagation(self) -> Unit {
  ignore(self.invoke("stopPropagation", []))
}

///|
impl EventImpl with stop_immediate_propagation(self) -> Unit {
  ignore(self.invoke("stopImmediatePropagation", []))
}

///|
impl EventImpl with target(self) -> Element {
  unsafe_cast(self.get("target"))
}

///|
impl EventImpl with current_target(self) -> Element {
  unsafe_cast(self.get("currentTarget"))
}

///|
impl EventImpl with event_type(self) -> String {
  unsafe_cast(self.get("type"))
}

///|
impl EventImpl with bubbles(self) -> Bool {
  unsafe_cast(self.get("bubbles"))
}

///|
impl EventImpl with cancelable(self) -> Bool {
  unsafe_cast(self.get("cancelable"))
}

///|
impl EventImpl with default_prevented(self) -> Bool {
  unsafe_cast(self.get("defaultPrevented"))
}

///|
/// Event represents a DOM event
/// https://developer.mozilla.org/en-US/docs/Web/API/Event
#external
pub type Event

///|
pub impl Js for Event

///|
pub impl EventImpl for Event

///|
/// PointerEvent represents a pointer event
/// https://developer.mozilla.org/en-US/docs/Web/API/PointerEvent
#external
pub type PointerEvent

///|
pub impl Js for PointerEvent

///|
pub impl EventImpl for PointerEvent

///|
/// Returns the width of the pointer contact
pub fn PointerEvent::width(self : Self) -> Double {
  unsafe_cast(self.get("width"))
}

///|
/// Returns the height of the pointer contact
pub fn PointerEvent::height(self : Self) -> Double {
  unsafe_cast(self.get("height"))
}

///|
/// Returns the pointer ID
pub fn PointerEvent::pointer_id(self : Self) -> Int {
  unsafe_cast(self.get("pointerId"))
}

///|
/// Returns the pointer type (mouse, pen, touch)
pub fn PointerEvent::pointer_type(self : Self) -> String {
  unsafe_cast(self.get("pointerType"))
}

///|
/// Returns whether the pointer is primary
pub fn PointerEvent::is_primary(self : Self) -> Bool {
  unsafe_cast(self.get("isPrimary"))
}

///|
/// MouseEvent represents a mouse event
/// https://developer.mozilla.org/en-US/docs/Web/API/MouseEvent
#external
pub type MouseEvent

///|
pub impl Js for MouseEvent

///|
pub impl EventImpl for MouseEvent

///|
/// Returns the X coordinate relative to the viewport
/// https://developer.mozilla.org/en-US/docs/Web/API/MouseEvent/clientX
pub fn MouseEvent::client_x(self : Self) -> Int {
  unsafe_cast(self.get("clientX"))
}

///|
/// Returns the Y coordinate relative to the viewport
/// https://developer.mozilla.org/en-US/docs/Web/API/MouseEvent/clientY
pub fn MouseEvent::client_y(self : Self) -> Int {
  unsafe_cast(self.get("clientY"))
}

///|
/// Returns the X coordinate relative to the screen
/// https://developer.mozilla.org/en-US/docs/Web/API/MouseEvent/screenX
pub fn MouseEvent::screen_x(self : MouseEvent) -> Int {
  unsafe_cast(self.get("screenX"))
}

///|
/// Returns the Y coordinate relative to the screen
/// https://developer.mozilla.org/en-US/docs/Web/API/MouseEvent/screenY
pub fn MouseEvent::screen_y(self : MouseEvent) -> Int {
  unsafe_cast(self.get("screenY"))
}

///|
/// Returns the X coordinate relative to the target element
/// https://developer.mozilla.org/en-US/docs/Web/API/MouseEvent/offsetX
pub fn MouseEvent::offset_x(self : Self) -> Int {
  unsafe_cast(self.get("offsetX"))
}

///|
/// Returns the Y coordinate relative to the target element
/// https://developer.mozilla.org/en-US/docs/Web/API/MouseEvent/offsetY
pub fn MouseEvent::offset_y(self : Self) -> Int {
  unsafe_cast(self.get("offsetY"))
}

///|
/// Returns the X coordinate relative to the page
/// https://developer.mozilla.org/en-US/docs/Web/API/MouseEvent/pageX
pub fn MouseEvent::page_x(self : Self) -> Int {
  unsafe_cast(self.get("pageX"))
}

///|
/// Returns the Y coordinate relative to the page
/// https://developer.mozilla.org/en-US/docs/Web/API/MouseEvent/pageY
pub fn MouseEvent::page_y(self : Self) -> Int {
  unsafe_cast(self.get("pageY"))
}

///|
/// Returns which mouse button was pressed
/// https://developer.mozilla.org/en-US/docs/Web/API/MouseEvent/button
pub fn MouseEvent::button(self : Self) -> Int {
  unsafe_cast(self.get("button"))
}

///|
/// Returns which mouse buttons were pressed
/// https://developer.mozilla.org/en-US/docs/Web/API/MouseEvent/buttons
pub fn MouseEvent::buttons(self : Self) -> Int {
  unsafe_cast(self.get("buttons"))
}

///|
/// Returns whether the Ctrl key was pressed
pub fn MouseEvent::ctrl_key(self : Self) -> Bool {
  unsafe_cast(self.get("ctrlKey"))
}

///|
/// Returns whether the Shift key was pressed
pub fn MouseEvent::shift_key(self : Self) -> Bool {
  unsafe_cast(self.get("shiftKey"))
}

///|
/// Returns whether the Alt key was pressed
pub fn MouseEvent::alt_key(self : Self) -> Bool {
  unsafe_cast(self.get("altKey"))
}

///|
/// Returns whether the Meta key was pressed
pub fn MouseEvent::meta_key(self : Self) -> Bool {
  unsafe_cast(self.get("metaKey"))
}

///|
/// KeyboardEvent represents a keyboard event
/// https://developer.mozilla.org/en-US/docs/Web/API/KeyboardEvent
#external
pub type KeyboardEvent

///|
impl Js for KeyboardEvent

///|
pub impl EventImpl for KeyboardEvent

///|
/// Returns the key value
/// https://developer.mozilla.org/en-US/docs/Web/API/KeyboardEvent/key
pub fn KeyboardEvent::key(self : KeyboardEvent) -> String {
  unsafe_cast(self.get("key"))
}

///|
/// Returns the key code (deprecated)
/// https://developer.mozilla.org/en-US/docs/Web/API/KeyboardEvent/keyCode
pub fn KeyboardEvent::key_code(self : KeyboardEvent) -> Int {
  unsafe_cast(self.get("keyCode"))
}

///|
/// Returns which key was pressed (deprecated)
pub fn KeyboardEvent::which(self : KeyboardEvent) -> Int {
  unsafe_cast(self.get("which"))
}

///|
/// Returns the physical key code
/// https://developer.mozilla.org/en-US/docs/Web/API/KeyboardEvent/code
pub fn KeyboardEvent::code(self : KeyboardEvent) -> String {
  unsafe_cast(self.get("code"))
}

///|
/// Returns whether the Ctrl key was pressed
pub fn KeyboardEvent::ctrl_key(self : KeyboardEvent) -> Bool {
  unsafe_cast(self.get("ctrlKey"))
}

///|
/// Returns whether the Alt key was pressed
pub fn KeyboardEvent::alt_key(self : KeyboardEvent) -> Bool {
  unsafe_cast(self.get("altKey"))
}

///|
/// Returns whether the Shift key was pressed
pub fn KeyboardEvent::shift_key(self : KeyboardEvent) -> Bool {
  unsafe_cast(self.get("shiftKey"))
}

///|
/// Returns whether the Meta key was pressed
pub fn KeyboardEvent::meta_key(self : KeyboardEvent) -> Bool {
  unsafe_cast(self.get("metaKey"))
}

///|
/// Returns whether the key is being held down
pub fn KeyboardEvent::repeat(self : KeyboardEvent) -> Bool {
  unsafe_cast(self.get("repeat"))
}

///|
/// Returns the location of the key on the keyboard
pub fn KeyboardEvent::location(self : KeyboardEvent) -> Int {
  unsafe_cast(self.get("location"))
}

///|
/// ChangeEvent represents a change event
#external
pub type ChangeEvent

///|
pub impl Js for ChangeEvent

///|
pub impl EventImpl for ChangeEvent

///|
/// FocusEvent represents a focus event
/// https://developer.mozilla.org/en-US/docs/Web/API/FocusEvent
#external
pub type FocusEvent

///|
impl Js for FocusEvent

///|
pub impl EventImpl for FocusEvent

///|
/// Returns the related target (element losing/gaining focus)
pub fn FocusEvent::related_target(self : FocusEvent) -> Element? {
  self.get("relatedTarget") |> to_option()
}

///|
/// FormEvent represents a form event
#external
pub type FormEvent

///|
impl Js for FormEvent

///|
pub impl EventImpl for FormEvent

///|
/// Returns the form data
pub fn FormEvent::form_data(self : FormEvent) -> Val {
  self.get("formData")
}

///|
/// DragEvent represents a drag and drop event
/// https://developer.mozilla.org/en-US/docs/Web/API/DragEvent
#external
pub type DragEvent

///|
pub impl Js for DragEvent

///|
pub impl EventImpl for DragEvent

///|
/// Returns the data transfer object
/// https://developer.mozilla.org/en-US/docs/Web/API/DragEvent/dataTransfer
pub fn DragEvent::data_transfer(self : Self) -> Val {
  self.get("dataTransfer")
}

///|
/// InputEvent represents an input event
/// https://developer.mozilla.org/en-US/docs/Web/API/InputEvent
#external
pub type InputEvent

///|
impl Js for InputEvent

///|
pub impl EventImpl for InputEvent

///|
/// Returns the input data
pub fn InputEvent::data(self : Self) -> String? {
  self.get("data") |> to_option()
}

///|
/// Returns the input type
pub fn InputEvent::input_type(self : Self) -> String {
  unsafe_cast(self.get("inputType"))
}

///|
/// WheelEvent represents a wheel event
/// https://developer.mozilla.org/en-US/docs/Web/API/WheelEvent
#external
pub type WheelEvent

///|
impl Js for WheelEvent

///|
pub impl EventImpl for WheelEvent

///|
/// Returns the horizontal scroll amount
pub fn WheelEvent::delta_x(self : Self) -> Double {
  unsafe_cast(self.get("deltaX"))
}

///|
/// Returns the vertical scroll amount
pub fn WheelEvent::delta_y(self : Self) -> Double {
  unsafe_cast(self.get("deltaY"))
}

///|
/// Returns the Z-axis scroll amount
pub fn WheelEvent::delta_z(self : Self) -> Double {
  unsafe_cast(self.get("deltaZ"))
}

///|
/// Returns the delta mode (pixel, line, or page)
pub fn WheelEvent::delta_mode(self : Self) -> Int {
  unsafe_cast(self.get("deltaMode"))
}

///|
/// TouchEvent represents a touch event
/// https://developer.mozilla.org/en-US/docs/Web/API/TouchEvent
#external
pub type TouchEvent

///|
impl Js for TouchEvent

///|
pub impl EventImpl for TouchEvent

///|
/// Returns the list of all touches
/// https://developer.mozilla.org/en-US/docs/Web/API/TouchEvent/touches
pub fn TouchEvent::touches(self : Self) -> Val {
  self.get("touches")
}

///|
/// Returns the list of touches that are currently in contact with the surface
/// https://developer.mozilla.org/en-US/docs/Web/API/TouchEvent/targetTouches
pub fn TouchEvent::target_touches(self : Self) -> Val {
  self.get("targetTouches")
}

///|
/// Returns the list of touches that changed since the last event
/// https://developer.mozilla.org/en-US/docs/Web/API/TouchEvent/changedTouches
pub fn TouchEvent::changed_touches(self : Self) -> Val {
  self.get("changedTouches")
}

///|
/// Returns whether the Alt key was pressed
pub fn TouchEvent::alt_key(self : Self) -> Bool {
  unsafe_cast(self.get("altKey"))
}

///|
/// Returns whether the Ctrl key was pressed
pub fn TouchEvent::ctrl_key(self : Self) -> Bool {
  unsafe_cast(self.get("ctrlKey"))
}

///|
/// Returns whether the Shift key was pressed
pub fn TouchEvent::shift_key(self : Self) -> Bool {
  unsafe_cast(self.get("shiftKey"))
}

///|
/// Returns whether the Meta key was pressed
pub fn TouchEvent::meta_key(self : Self) -> Bool {
  unsafe_cast(self.get("metaKey"))
}

///|
/// Touch represents a single touch point
/// https://developer.mozilla.org/en-US/docs/Web/API/Touch
#external
pub type Touch

///|
impl Js for Touch

///|
/// Returns the unique identifier for this touch
pub fn Touch::identifier(self : Self) -> Int {
  unsafe_cast(self.get("identifier"))
}

///|
/// Returns the X coordinate relative to the viewport
pub fn Touch::client_x(self : Self) -> Double {
  unsafe_cast(self.get("clientX"))
}

///|
/// Returns the Y coordinate relative to the viewport
pub fn Touch::client_y(self : Self) -> Double {
  unsafe_cast(self.get("clientY"))
}

///|
/// Returns the X coordinate relative to the screen
pub fn Touch::screen_x(self : Self) -> Double {
  unsafe_cast(self.get("screenX"))
}

///|
/// Returns the Y coordinate relative to the screen
pub fn Touch::screen_y(self : Self) -> Double {
  unsafe_cast(self.get("screenY"))
}

///|
/// Returns the X coordinate relative to the page
pub fn Touch::page_x(self : Self) -> Double {
  unsafe_cast(self.get("pageX"))
}

///|
/// Returns the Y coordinate relative to the page
pub fn Touch::page_y(self : Self) -> Double {
  unsafe_cast(self.get("pageY"))
}

///|
/// Returns the X radius of the ellipse that approximates the touch area
pub fn Touch::radius_x(self : Self) -> Double {
  unsafe_cast(self.get("radiusX"))
}

///|
/// Returns the Y radius of the ellipse that approximates the touch area
pub fn Touch::radius_y(self : Self) -> Double {
  unsafe_cast(self.get("radiusY"))
}

///|
/// Returns the rotation angle of the touch area ellipse
pub fn Touch::rotation_angle(self : Self) -> Double {
  unsafe_cast(self.get("rotationAngle"))
}

///|
/// Returns the amount of pressure applied
pub fn Touch::force(self : Self) -> Double {
  unsafe_cast(self.get("force"))
}

///|
/// Returns the target element
pub fn Touch::target(self : Self) -> Element {
  unsafe_cast(self.get("target"))
}

///|
/// ClipboardEvent represents a clipboard event
/// https://developer.mozilla.org/en-US/docs/Web/API/ClipboardEvent
#external
pub type ClipboardEvent

///|
impl Js for ClipboardEvent

///|
pub impl EventImpl for ClipboardEvent

///|
/// Returns the clipboard data
/// https://developer.mozilla.org/en-US/docs/Web/API/ClipboardEvent/clipboardData
pub fn ClipboardEvent::clipboard_data(self : Self) -> Val? {
  self.get("clipboardData") |> to_option()
}

///|
/// TransitionEvent represents a CSS transition event
/// https://developer.mozilla.org/en-US/docs/Web/API/TransitionEvent
#external
pub type TransitionEvent

///|
impl Js for TransitionEvent

///|
pub impl EventImpl for TransitionEvent

///|
/// Returns the name of the CSS property associated with the transition
pub fn TransitionEvent::property_name(self : Self) -> String {
  unsafe_cast(self.get("propertyName"))
}

///|
/// Returns the elapsed time of the transition in seconds
pub fn TransitionEvent::elapsed_time(self : Self) -> Double {
  unsafe_cast(self.get("elapsedTime"))
}

///|
/// Returns the pseudo-element name
pub fn TransitionEvent::pseudo_element(self : Self) -> String {
  unsafe_cast(self.get("pseudoElement"))
}

///|
/// AnimationEvent represents a CSS animation event
/// https://developer.mozilla.org/en-US/docs/Web/API/AnimationEvent
#external
pub type AnimationEvent

///|
impl Js for AnimationEvent

///|
pub impl EventImpl for AnimationEvent

///|
/// Returns the name of the CSS animation
pub fn AnimationEvent::animation_name(self : Self) -> String {
  unsafe_cast(self.get("animationName"))
}

///|
/// Returns the elapsed time of the animation in seconds
pub fn AnimationEvent::elapsed_time(self : Self) -> Double {
  unsafe_cast(self.get("elapsedTime"))
}

///|
/// Returns the pseudo-element name
pub fn AnimationEvent::pseudo_element(self : Self) -> String {
  unsafe_cast(self.get("pseudoElement"))
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
pub impl Js for MessageEvent

///|
pub impl EventImpl for MessageEvent

///|
/// Returns the data sent by the message emitter
/// https://developer.mozilla.org/en-US/docs/Web/API/MessageEvent/data
pub fn MessageEvent::data(self : Self) -> Val {
  unsafe_cast(self.get("data"))
}

///|
/// Returns the origin of the message emitter
/// https://developer.mozilla.org/en-US/docs/Web/API/MessageEvent/origin
pub fn MessageEvent::origin(self : Self) -> String {
  unsafe_cast(self.get("origin"))
}

///|
/// Returns the source window of the message
/// https://developer.mozilla.org/en-US/docs/Web/API/MessageEvent/source
pub fn MessageEvent::source(self : Self) -> Window? {
  self.get("source") |> to_option()
}

///|
/// Returns the array of MessagePort objects
/// https://developer.mozilla.org/en-US/docs/Web/API/MessageEvent/ports
pub fn MessageEvent::ports(self : Self) -> Array[Val] {
  @js.array_from(self.get("ports")).map(fn(v) { unsafe_cast(v) })
}

///|
/// DOMRectReadOnly represents a read-only rectangle
/// https://developer.mozilla.org/en-US/docs/Web/API/DOMRectReadOnly
#external
pub type DOMRectReadOnly

///|
pub impl Js for DOMRectReadOnly

///|
pub fn DOMRectReadOnly::x(self : Self) -> Double {
  unsafe_cast(self.get("x"))
}

///|
pub fn DOMRectReadOnly::y(self : Self) -> Double {
  unsafe_cast(self.get("y"))
}

///|
pub fn DOMRectReadOnly::width(self : Self) -> Double {
  unsafe_cast(self.get("width"))
}

///|
pub fn DOMRectReadOnly::height(self : Self) -> Double {
  unsafe_cast(self.get("height"))
}

///|
pub fn DOMRectReadOnly::top(self : Self) -> Double {
  unsafe_cast(self.get("top"))
}

///|
pub fn DOMRectReadOnly::right(self : Self) -> Double {
  unsafe_cast(self.get("right"))
}

///|
pub fn DOMRectReadOnly::bottom(self : Self) -> Double {
  unsafe_cast(self.get("bottom"))
}

///|
pub fn DOMRectReadOnly::left(self : Self) -> Double {
  unsafe_cast(self.get("left"))
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
  unsafe_cast(self.get("target"))
}

///|
/// Returns the content rect
pub fn ResizeObserverEntry::content_rect(self : Self) -> DOMRectReadOnly {
  unsafe_cast(self.get("contentRect"))
}

///|
/// Returns the border box size
pub fn ResizeObserverEntry::border_box_size(self : Self) -> Val {
  self.get("borderBoxSize")
}

///|
/// Returns the content box size
pub fn ResizeObserverEntry::content_box_size(self : Self) -> Val {
  self.get("contentBoxSize")
}
