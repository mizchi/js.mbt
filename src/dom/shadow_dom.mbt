///|
/// Shadow DOM API
/// https://developer.mozilla.org/en-US/docs/Web/API/Web_components/Using_shadow_DOM

///|
/// ShadowRoot represents the root node of a shadow DOM subtree
/// https://developer.mozilla.org/en-US/docs/Web/API/ShadowRoot
#external
pub type ShadowRoot

///|
pub impl JsImpl for ShadowRoot

///|
pub impl EventTargetImpl for ShadowRoot

///|
pub impl NodeImpl for ShadowRoot

///|
/// Returns the mode of the shadow root
/// https://developer.mozilla.org/en-US/docs/Web/API/ShadowRoot/mode
pub fn ShadowRoot::mode(self : Self) -> String {
  unsafe_cast(self.get("mode"))
}

///|
/// Returns the host element of the shadow root
/// https://developer.mozilla.org/en-US/docs/Web/API/ShadowRoot/host
pub fn ShadowRoot::host(self : Self) -> Element {
  unsafe_cast(self.get("host"))
}

///|
/// Returns whether the shadow root delegates focus
/// https://developer.mozilla.org/en-US/docs/Web/API/ShadowRoot/delegatesFocus
pub fn ShadowRoot::delegatesFocus(self : Self) -> Bool {
  unsafe_cast(self.get("delegatesFocus"))
}

///|
/// Returns the shadow root's slot assignment mode
/// https://developer.mozilla.org/en-US/docs/Web/API/ShadowRoot/slotAssignment
pub fn ShadowRoot::slotAssignment(self : Self) -> String {
  unsafe_cast(self.get("slotAssignment"))
}

///|
/// Returns the inner HTML of the shadow root
/// https://developer.mozilla.org/en-US/docs/Web/API/ShadowRoot/innerHTML
pub fn ShadowRoot::innerHTML(self : Self) -> String {
  unsafe_cast(self.get("innerHTML"))
}

///|
/// Sets the inner HTML of the shadow root
pub fn ShadowRoot::setInnerHTML(self : Self, html : String) -> Unit {
  self.set("innerHTML", html)
}

///|
/// Returns the active element within the shadow root
/// https://developer.mozilla.org/en-US/docs/Web/API/ShadowRoot/activeElement
pub fn ShadowRoot::activeElement(self : Self) -> Element? {
  self.get("activeElement") |> @js.unsafe_cast_option()
}

///|
/// Returns the element from point within the shadow root
/// https://developer.mozilla.org/en-US/docs/Web/API/ShadowRoot/elementFromPoint
pub fn ShadowRoot::elementFromPoint(
  self : Self,
  x : Double,
  y : Double,
) -> Element? {
  self.invoke("elementFromPoint", [x, y]) |> @js.unsafe_cast_option()
}

///|
/// Returns elements from point within the shadow root
/// https://developer.mozilla.org/en-US/docs/Web/API/ShadowRoot/elementsFromPoint
pub fn ShadowRoot::elementsFromPoint(
  self : Self,
  x : Double,
  y : Double,
) -> Array[Element] {
  @js.array_from(self.invoke("elementsFromPoint", [x, y])).map(fn(v) {
    unsafe_cast(v)
  })
}

///|
/// ShadowRootInit options for attachShadow
pub struct ShadowRootInit {
  mode : String
  delegatesFocus : Bool
  slotAssignment : String
}

///|
/// Creates a new ShadowRootInit with default values
pub fn ShadowRootInit::new(
  mode : String,
  delegatesFocus? : Bool = false,
  slotAssignment? : String = "named",
) -> ShadowRootInit {
  { mode, delegatesFocus, slotAssignment }
}

///|
/// Attaches a shadow root to the element
/// https://developer.mozilla.org/en-US/docs/Web/API/Element/attachShadow
pub fn HTMLElement::attachShadow(
  self : Self,
  init : ShadowRootInit,
) -> ShadowRoot {
  let options = @js.from_map({
    "mode": js(init.mode),
    "delegatesFocus": js(init.delegatesFocus),
    "slotAssignment": js(init.slotAssignment),
  })
  self.invoke("attachShadow", [options]) |> unsafe_cast
}

///|
/// Returns the shadow root of the element if it exists
/// https://developer.mozilla.org/en-US/docs/Web/API/Element/shadowRoot
pub fn HTMLElement::shadowRoot(self : Self) -> ShadowRoot? {
  self.get("shadowRoot") |> @js.unsafe_cast_option()
}
