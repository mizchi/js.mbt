///|
/// Shadow DOM API
/// https://developer.mozilla.org/en-US/docs/Web/API/Web_components/Using_shadow_DOM

///|
/// ShadowRoot represents the root node of a shadow DOM subtree
/// https://developer.mozilla.org/en-US/docs/Web/API/ShadowRoot
#external
pub type ShadowRoot

///|
pub impl Js for ShadowRoot with to_js(self) {
  self |> js
}

///|
pub impl EventTargetImpl for ShadowRoot

///|
pub impl NodeImpl for ShadowRoot

///|
/// Returns the mode of the shadow root
/// https://developer.mozilla.org/en-US/docs/Web/API/ShadowRoot/mode
pub fn ShadowRoot::mode(self : Self) -> String {
  unsafe_cast(self.to_js().get("mode"))
}

///|
/// Returns the host element of the shadow root
/// https://developer.mozilla.org/en-US/docs/Web/API/ShadowRoot/host
pub fn ShadowRoot::host(self : Self) -> Element {
  unsafe_cast(self.to_js().get("host"))
}

///|
/// Returns whether the shadow root delegates focus
/// https://developer.mozilla.org/en-US/docs/Web/API/ShadowRoot/delegatesFocus
pub fn ShadowRoot::delegates_focus(self : Self) -> Bool {
  unsafe_cast(self.to_js().get("delegatesFocus"))
}

///|
/// Returns the shadow root's slot assignment mode
/// https://developer.mozilla.org/en-US/docs/Web/API/ShadowRoot/slotAssignment
pub fn ShadowRoot::slot_assignment(self : Self) -> String {
  unsafe_cast(self.to_js().get("slotAssignment"))
}

///|
/// Returns the inner HTML of the shadow root
/// https://developer.mozilla.org/en-US/docs/Web/API/ShadowRoot/innerHTML
pub fn ShadowRoot::inner_html(self : Self) -> String {
  unsafe_cast(self.to_js().get("innerHTML"))
}

///|
/// Sets the inner HTML of the shadow root
pub fn ShadowRoot::set_inner_html(self : Self, html : String) -> Unit {
  self.to_js().set("innerHTML", html)
}

///|
/// Returns the active element within the shadow root
/// https://developer.mozilla.org/en-US/docs/Web/API/ShadowRoot/activeElement
pub fn ShadowRoot::active_element(self : Self) -> Element? {
  self.to_js().get("activeElement").cast_option()
}

///|
/// Returns the element from point within the shadow root
/// https://developer.mozilla.org/en-US/docs/Web/API/ShadowRoot/elementFromPoint
pub fn ShadowRoot::element_from_point(
  self : Self,
  x : Double,
  y : Double,
) -> Element? {
  self.to_js().invoke("elementFromPoint", [x, y]).cast_option()
}

///|
/// Returns elements from point within the shadow root
/// https://developer.mozilla.org/en-US/docs/Web/API/ShadowRoot/elementsFromPoint
pub fn ShadowRoot::elements_from_point(
  self : Self,
  x : Double,
  y : Double,
) -> Array[Element] {
  @js.array_from(self.to_js().invoke("elementsFromPoint", [x, y])).map(fn(v) {
    unsafe_cast(v)
  })
}

///|
/// ShadowRootInit options for attachShadow
pub struct ShadowRootInit {
  mode : String
  delegates_focus : Bool
  slot_assignment : String
}

///|
/// Creates a new ShadowRootInit with default values
pub fn ShadowRootInit::new(
  mode : String,
  delegates_focus? : Bool = false,
  slot_assignment? : String = "named",
) -> ShadowRootInit {
  { mode, delegates_focus, slot_assignment }
}

///|
/// Attaches a shadow root to the element
/// https://developer.mozilla.org/en-US/docs/Web/API/Element/attachShadow
pub fn HTMLElement::attach_shadow(
  self : Self,
  init : ShadowRootInit,
) -> ShadowRoot {
  let options = @js.from_builtin_map({
    "mode": js(init.mode),
    "delegatesFocus": js(init.delegates_focus),
    "slotAssignment": js(init.slot_assignment),
  })
  self.invoke("attachShadow", [options]) |> unsafe_cast
}

///|
/// Returns the shadow root of the element if it exists
/// https://developer.mozilla.org/en-US/docs/Web/API/Element/shadowRoot
pub fn HTMLElement::shadow_root(self : Self) -> ShadowRoot? {
  self.to_js().get("shadowRoot").cast_option()
}
