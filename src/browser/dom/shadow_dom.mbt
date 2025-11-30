///|
/// Shadow DOM API
/// https://developer.mozilla.org/en-US/docs/Web/API/Web_components/Using_shadow_DOM

///|
/// ShadowRoot represents the root node of a shadow DOM subtree
/// https://developer.mozilla.org/en-US/docs/Web/API/ShadowRoot
#external
pub type ShadowRoot

///|
pub fn ShadowRoot::as_any(self : ShadowRoot) -> @nostd.Any = "%identity"

///|
pub fn ShadowRoot::as_event_target(self : ShadowRoot) -> @event.EventTarget = "%identity"

///|
pub fn ShadowRoot::as_node(self : ShadowRoot) -> Node = "%identity"

///|

///|
/// Returns the mode of the shadow root
/// https://developer.mozilla.org/en-US/docs/Web/API/ShadowRoot/mode
pub fn ShadowRoot::mode(self : Self) -> String {
  self.as_any()._get("mode").cast()
}

///|
/// Returns the host element of the shadow root
/// https://developer.mozilla.org/en-US/docs/Web/API/ShadowRoot/host
pub fn ShadowRoot::host(self : Self) -> Element {
  self.as_any()._get("host").cast()
}

///|
/// Returns whether the shadow root delegates focus
/// https://developer.mozilla.org/en-US/docs/Web/API/ShadowRoot/delegatesFocus
pub fn ShadowRoot::delegatesFocus(self : Self) -> Bool {
  self.as_any()._get("delegatesFocus").cast()
}

///|
/// Returns the shadow root's slot assignment mode
/// https://developer.mozilla.org/en-US/docs/Web/API/ShadowRoot/slotAssignment
pub fn ShadowRoot::slotAssignment(self : Self) -> String {
  self.as_any()._get("slotAssignment").cast()
}

///|
/// Returns the inner HTML of the shadow root
/// https://developer.mozilla.org/en-US/docs/Web/API/ShadowRoot/innerHTML
pub fn ShadowRoot::innerHTML(self : Self) -> String {
  self.as_any()._get("innerHTML").cast()
}

///|
/// Sets the inner HTML of the shadow root
pub fn ShadowRoot::setInnerHTML(self : Self, html : String) -> Unit {
  self.as_any()._set("innerHTML", @nostd.any(html)) |> ignore
}

///|
/// Returns the active element within the shadow root
/// https://developer.mozilla.org/en-US/docs/Web/API/ShadowRoot/activeElement
pub fn ShadowRoot::activeElement(self : Self) -> Element? {
  let v : @js.Any = self.as_any()._get("activeElement").cast()
  v |> @js.identity_option()
}

///|
/// Returns the element from point within the shadow root
/// https://developer.mozilla.org/en-US/docs/Web/API/ShadowRoot/elementFromPoint
pub fn ShadowRoot::elementFromPoint(
  self : Self,
  x : Double,
  y : Double,
) -> Element? {
  let v : @js.Any = self
    .as_any()
    ._call("elementFromPoint", [@nostd.any(x), @nostd.any(y)])
    .cast()
  v |> @js.identity_option()
}

///|
/// Returns elements from point within the shadow root
/// https://developer.mozilla.org/en-US/docs/Web/API/ShadowRoot/elementsFromPoint
///
/// Note: The returned array is a snapshot and should be treated as immutable.
pub fn ShadowRoot::elementsFromPoint(
  self : Self,
  x : Double,
  y : Double,
) -> Array[Element] {
  let arr : @js.Any = self
    .as_any()
    ._call("elementsFromPoint", [@nostd.any(x), @nostd.any(y)])
    .cast()
  @js.array_from(arr).map(_.cast())
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
  let options = @mbtconv.from_map({
    "mode": @nostd.any(init.mode),
    "delegatesFocus": @nostd.any(init.delegatesFocus),
    "slotAssignment": @nostd.any(init.slotAssignment),
  })
  self.as_any()._call("attachShadow", [@nostd.any(options)]).cast()
}

///|
/// Returns the shadow root of the element if it exists
/// https://developer.mozilla.org/en-US/docs/Web/API/Element/shadowRoot
pub fn HTMLElement::shadowRoot(self : Self) -> ShadowRoot? {
  let v : @js.Any = self.as_any()._get("shadowRoot").cast()
  v |> @js.identity_option()
}
