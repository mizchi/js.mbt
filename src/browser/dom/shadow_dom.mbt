///|
/// Shadow DOM API
/// https://developer.mozilla.org/en-US/docs/Web/API/Web_components/Using_shadow_DOM

///|
/// ShadowRoot represents the root node of a shadow DOM subtree
/// https://developer.mozilla.org/en-US/docs/Web/API/ShadowRoot
#external
pub type ShadowRoot

///|
pub fn ShadowRoot::as_any(self : ShadowRoot) -> @core.Any = "%identity"

///|
pub fn ShadowRoot::as_event_target(self : ShadowRoot) -> @event.EventTarget = "%identity"

///|
pub fn ShadowRoot::as_node(self : ShadowRoot) -> Node = "%identity"

///|

///|
/// Returns the mode of the shadow root
/// https://developer.mozilla.org/en-US/docs/Web/API/ShadowRoot/mode
pub extern "js" fn ShadowRoot::mode(self : Self) -> String =
  #| (self) => self.mode

///|
/// Returns the host element of the shadow root
/// https://developer.mozilla.org/en-US/docs/Web/API/ShadowRoot/host
pub extern "js" fn ShadowRoot::host(self : Self) -> Element =
  #| (self) => self.host

///|
/// Returns whether the shadow root delegates focus
/// https://developer.mozilla.org/en-US/docs/Web/API/ShadowRoot/delegatesFocus
pub extern "js" fn ShadowRoot::delegatesFocus(self : Self) -> Bool =
  #| (self) => self.delegatesFocus

///|
/// Returns the shadow root's slot assignment mode
/// https://developer.mozilla.org/en-US/docs/Web/API/ShadowRoot/slotAssignment
pub extern "js" fn ShadowRoot::slotAssignment(self : Self) -> String =
  #| (self) => self.slotAssignment

///|
/// Returns the inner HTML of the shadow root
/// https://developer.mozilla.org/en-US/docs/Web/API/ShadowRoot/innerHTML
pub extern "js" fn ShadowRoot::innerHTML(self : Self) -> String =
  #| (self) => self.innerHTML

///|
/// Sets the inner HTML of the shadow root
pub fn ShadowRoot::setInnerHTML(self : Self, html : String) -> Unit {
  self.as_any()._set("innerHTML", @core.any(html)) |> ignore
}

///|
/// Returns the active element within the shadow root
/// https://developer.mozilla.org/en-US/docs/Web/API/ShadowRoot/activeElement
pub fn ShadowRoot::activeElement(self : Self) -> Element? {
  let v : @core.Any = self.as_any()._get("activeElement").cast()
  v |> @core.identity_option()
}

///|
/// Returns the element from point within the shadow root
/// https://developer.mozilla.org/en-US/docs/Web/API/ShadowRoot/elementFromPoint
pub fn ShadowRoot::elementFromPoint(
  self : Self,
  x : Double,
  y : Double,
) -> Element? {
  let v : @core.Any = self
    .as_any()
    ._call("elementFromPoint", [@core.any(x), @core.any(y)])
    .cast()
  v |> @core.identity_option()
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
  let arr : @core.Any = self
    .as_any()
    ._call("elementsFromPoint", [@core.any(x), @core.any(y)])
    .cast()
  @core.array_from(arr).map(x => x.cast())
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
  let options = @core.from_entries([
    ("mode", @core.any(init.mode)),
    ("delegatesFocus", @core.any(init.delegatesFocus)),
    ("slotAssignment", @core.any(init.slotAssignment)),
  ])
  self.as_any()._call("attachShadow", [@core.any(options)]).cast()
}

///|
/// Returns the shadow root of the element if it exists
/// https://developer.mozilla.org/en-US/docs/Web/API/Element/shadowRoot
pub fn HTMLElement::shadowRoot(self : Self) -> ShadowRoot? {
  let v : @core.Any = self.as_any()._get("shadowRoot").cast()
  v |> @core.identity_option()
}
