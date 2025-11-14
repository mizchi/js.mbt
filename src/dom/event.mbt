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
/// Prevents the default action of the event
/// https://developer.mozilla.org/en-US/docs/Web/API/Event/preventDefault
#alias(preventDefault)
pub fn Event::prevent_default(self : Event) -> Unit {
  self.to_js().call_method("preventDefault", []) |> ignore
}

///|
/// Stops the propagation of the event
/// https://developer.mozilla.org/en-US/docs/Web/API/Event/stopPropagation
#alias(stopPropagation)
pub fn Event::stop_propagation(self : Event) -> Unit {
  self.to_js().call_method("stopPropagation", []) |> ignore
}

///|
/// Stops immediate propagation of the event
/// https://developer.mozilla.org/en-US/docs/Web/API/Event/stopImmediatePropagation
pub fn Event::stop_immediate_propagation(self : Event) -> Unit {
  self.to_js().call_method("stopImmediatePropagation", []) |> ignore
}

///|
/// Returns the event target
/// https://developer.mozilla.org/en-US/docs/Web/API/Event/target
pub fn Event::target(self : Self) -> Element {
  self.to_js().get("target").cast()
}

///|
/// Returns the current event target
/// https://developer.mozilla.org/en-US/docs/Web/API/Event/currentTarget
pub fn Event::current_target(self : Self) -> Element {
  self.to_js().get("currentTarget").cast()
}

///|
/// Returns the event type
/// https://developer.mozilla.org/en-US/docs/Web/API/Event/type
pub fn Event::event_type(self : Self) -> String {
  self.to_js().get("type").cast()
}

///|
/// Returns whether the event bubbles
/// https://developer.mozilla.org/en-US/docs/Web/API/Event/bubbles
pub fn Event::bubbles(self : Self) -> Bool {
  self.to_js().get("bubbles").cast()
}

///|
/// Returns whether the event is cancelable
/// https://developer.mozilla.org/en-US/docs/Web/API/Event/cancelable
pub fn Event::cancelable(self : Self) -> Bool {
  self.to_js().get("cancelable").cast()
}

///|
/// Returns whether preventDefault was called
/// https://developer.mozilla.org/en-US/docs/Web/API/Event/defaultPrevented
pub fn Event::default_prevented(self : Self) -> Bool {
  self.to_js().get("defaultPrevented").cast()
}

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
/// Returns the event target
pub fn KeyboardEvent::target(self : KeyboardEvent) -> Element {
  self.to_js().get("target").cast()
}

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
pub fn ChangeEvent::target(self : ChangeEvent) -> Element {
  let value : Val = self |> js
  value.get("target").cast()
}

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
/// Returns the event target
pub fn FocusEvent::target(self : FocusEvent) -> Element {
  self.to_js().get("target").cast()
}

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
/// Returns the event target
pub fn FormEvent::target(self : FormEvent) -> Element {
  self.to_js().get("target").cast()
}

///|
/// Returns the current event target
pub fn FormEvent::current_target(self : FormEvent) -> Element {
  self.to_js().get("currentTarget").cast()
}

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
/// Returns the event target
pub fn DragEvent::target(self : Self) -> Element {
  self.to_js().get("target").cast()
}

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
/// Returns the event target
pub fn InputEvent::target(self : Self) -> Element {
  self.to_js().get("target").cast()
}

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
impl Js for ScrollEvent with to_js(self) -> Val {
  self |> js
}

///|
/// ResizeObserverEntry represents an entry in a ResizeObserver
/// https://developer.mozilla.org/en-US/docs/Web/API/ResizeObserverEntry
#external
pub type ResizeObserverEntry

///|
impl Js for ResizeObserverEntry with to_js(self) -> Val {
  self |> js
}

///|
/// Returns the target element being observed
pub fn ResizeObserverEntry::target(self : Self) -> Element {
  self.to_js().get("target").cast()
}

///|
/// Returns the content rect
pub fn ResizeObserverEntry::content_rect(self : Self) -> Val {
  self.to_js().get("contentRect")
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
