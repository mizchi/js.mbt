///|
/// Shadow DOM and Custom Elements API
/// https://developer.mozilla.org/en-US/docs/Web/API/Web_components

///|
/// ShadowRoot represents a shadow root
/// https://developer.mozilla.org/en-US/docs/Web/API/ShadowRoot
#external
pub type ShadowRoot

///|
pub impl Js for ShadowRoot with to_js(self) -> Val {
  self |> js
}

///|
/// Attaches a shadow root to an element
/// https://developer.mozilla.org/en-US/docs/Web/API/Element/attachShadow
pub fn Element::attach_shadow(self : Self, options : Val) -> ShadowRoot {
  self.to_js().call_method("attachShadow", [options]).cast()
}

///|
/// Attaches a shadow root with mode
pub fn Element::attach_shadow_mode(self : Self, mode : String) -> ShadowRoot {
  let options = @js.new_empty_object()
  options.set("mode", mode)
  self.attach_shadow(options)
}

///|
/// Returns the element's shadow root
/// https://developer.mozilla.org/en-US/docs/Web/API/Element/shadowRoot
pub fn Element::shadow_root(self : Self) -> ShadowRoot? {
  self.to_js().get("shadowRoot").cast_option()
}

///|
/// Returns the shadow root's mode
pub fn ShadowRoot::mode(self : Self) -> String {
  self.to_js().get("mode").cast()
}

///|
/// Returns the shadow root's host element
/// https://developer.mozilla.org/en-US/docs/Web/API/ShadowRoot/host
pub fn ShadowRoot::host(self : Self) -> Element {
  self.to_js().get("host").cast()
}

///|
/// Returns whether the shadow root delegates focus
pub fn ShadowRoot::delegates_focus(self : Self) -> Bool {
  self.to_js().get("delegatesFocus").cast()
}

///|
/// Returns the shadow root's slot assignment mode
pub fn ShadowRoot::slot_assignment(self : Self) -> String {
  self.to_js().get("slotAssignment").cast()
}

///|
/// Converts ShadowRoot to Element for DOM operations
pub fn ShadowRoot::as_element(self : Self) -> Element {
  self |> @js.unsafe_cast
}

///|
/// Query selector on shadow root
pub fn ShadowRoot::query_selector(self : Self, selector : String) -> Element? {
  self.to_js().call_method("querySelector", [selector |> js]).cast_option()
}

///|
/// Query selector all on shadow root
pub fn ShadowRoot::query_selector_all(self : Self, selector : String) -> Val {
  self.to_js().call_method("querySelectorAll", [selector |> js])
}

///|
/// Get element by ID on shadow root
pub fn ShadowRoot::get_element_by_id(self : Self, id : String) -> Element? {
  self.to_js().call_method("getElementById", [id |> js]).cast_option()
}

///|
/// Returns the active element in the shadow root
pub fn ShadowRoot::active_element(self : Self) -> Element? {
  self.to_js().get("activeElement").cast_option()
}

///|
/// Returns the shadow root's inner HTML
pub fn ShadowRoot::inner_html(self : Self) -> String {
  self.to_js().get("innerHTML").cast()
}

///|
/// Sets the shadow root's inner HTML
pub fn ShadowRoot::set_inner_html(self : Self, html : String) -> Unit {
  self.to_js().set("innerHTML", html |> js) |> ignore
}

///|
/// HTMLSlotElement represents a <slot> element
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLSlotElement
#external
pub type HTMLSlotElement

///|
pub impl Js for HTMLSlotElement with to_js(self) -> Val {
  self |> js
}

///|
/// Returns the slot's name
pub fn HTMLSlotElement::name(self : Self) -> String {
  self.to_js().get("name").cast()
}

///|
/// Sets the slot's name
pub fn HTMLSlotElement::set_name(self : Self, name : String) -> Unit {
  self.to_js().set("name", name |> js) |> ignore
}

///|
/// Returns the assigned nodes
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLSlotElement/assignedNodes
pub fn HTMLSlotElement::assigned_nodes(self : Self) -> Val {
  self.to_js().call_method("assignedNodes", [])
}

///|
/// Returns the assigned nodes with options
pub fn HTMLSlotElement::assigned_nodes_with_options(
  self : Self,
  options : Val,
) -> Val {
  self.to_js().call_method("assignedNodes", [options])
}

///|
/// Returns the assigned elements
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLSlotElement/assignedElements
pub fn HTMLSlotElement::assigned_elements(self : Self) -> Val {
  self.to_js().call_method("assignedElements", [])
}

///|
/// Returns the assigned elements with options
pub fn HTMLSlotElement::assigned_elements_with_options(
  self : Self,
  options : Val,
) -> Val {
  self.to_js().call_method("assignedElements", [options])
}

///|
/// Assigns nodes to the slot
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLSlotElement/assign
pub fn HTMLSlotElement::assign(self : Self, nodes : Val) -> Unit {
  self.to_js().call_method("assign", [nodes]) |> ignore
}

///|
/// Custom Elements Registry
/// https://developer.mozilla.org/en-US/docs/Web/API/CustomElementRegistry

///|
/// Returns the custom elements registry
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/customElements
pub fn custom_elements() -> Val {
  @js.global_this().get("customElements")
}

///|
/// Defines a new custom element
/// https://developer.mozilla.org/en-US/docs/Web/API/CustomElementRegistry/define
pub fn define_custom_element(name : String, ctor : Val) -> Unit {
  custom_elements().call_method("define", [name |> js, ctor]) |> ignore
}

///|
/// Defines a custom element with options
pub fn define_custom_element_with_options(
  name : String,
  ctor : Val,
  options : Val,
) -> Unit {
  custom_elements().call_method("define", [name |> js, ctor, options]) |> ignore
}

///|
/// Returns the constructor for a custom element
/// https://developer.mozilla.org/en-US/docs/Web/API/CustomElementRegistry/get
pub fn get_custom_element(name : String) -> Val? {
  custom_elements().call_method("get", [name |> js]).cast_option()
}

///|
/// Returns a promise that resolves when the custom element is defined
/// https://developer.mozilla.org/en-US/docs/Web/API/CustomElementRegistry/whenDefined
pub fn when_custom_element_defined(name : String) -> @async.Promise[Unit] {
  custom_elements().call_method("whenDefined", [name |> js]).cast()
}

///|
/// Upgrades an element
/// https://developer.mozilla.org/en-US/docs/Web/API/CustomElementRegistry/upgrade
pub fn upgrade_element(element : Element) -> Unit {
  custom_elements().call_method("upgrade", [element |> js]) |> ignore
}

///|
/// Returns the slot assigned to an element
/// https://developer.mozilla.org/en-US/docs/Web/API/Element/assignedSlot
pub fn Element::assigned_slot(self : Self) -> HTMLSlotElement? {
  self.to_js().get("assignedSlot").cast_option()
}

///|
/// Returns the element's slot attribute
pub fn Element::slot(self : Self) -> String {
  self.to_js().get("slot").cast()
}

///|
/// Sets the element's slot attribute
pub fn Element::set_slot(self : Self, slot : String) -> Unit {
  self.to_js().set("slot", slot |> js) |> ignore
}
