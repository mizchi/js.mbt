///|
/// Observer APIs for DOM
/// https://developer.mozilla.org/en-US/docs/Web/API/MutationObserver

///|
/// MutationObserver observes changes to the DOM tree
/// https://developer.mozilla.org/en-US/docs/Web/API/MutationObserver
#external
pub type MutationObserver

///|
pub impl Js for MutationObserver with to_js(self) -> Val {
  self |> js
}

///|
/// Creates a new MutationObserver
/// https://developer.mozilla.org/en-US/docs/Web/API/MutationObserver/MutationObserver
pub fn new_mutation_observer(
  callback : (Val, MutationObserver) -> Unit,
) -> MutationObserver {
  let ctor = @js.global_this().get("MutationObserver")
  unsafe_cast(@js.new_(ctor, [callback |> js]))
}

///|
/// Starts observing a target element
/// https://developer.mozilla.org/en-US/docs/Web/API/MutationObserver/observe
pub fn MutationObserver::observe(
  self : Self,
  target : Element,
  options : Val,
) -> Unit {
  self.to_js().invoke("observe", [target |> js, options]) |> ignore
}

///|
/// Stops observing
/// https://developer.mozilla.org/en-US/docs/Web/API/MutationObserver/disconnect
pub fn MutationObserver::disconnect(self : Self) -> Unit {
  self.to_js().invoke("disconnect", []) |> ignore
}

///|
/// Returns all pending mutation records
/// https://developer.mozilla.org/en-US/docs/Web/API/MutationObserver/takeRecords
pub fn MutationObserver::take_records(self : Self) -> Val {
  self.to_js().invoke("takeRecords", [])
}

///|
/// MutationRecord represents a single DOM mutation
/// https://developer.mozilla.org/en-US/docs/Web/API/MutationRecord
#external
pub type MutationRecord

///|
pub impl Js for MutationRecord with to_js(self) -> Val {
  self |> js
}

///|
/// Returns the type of mutation
pub fn MutationRecord::mutation_type(self : Self) -> String {
  unsafe_cast(self.to_js().get("type"))
}

///|
/// Returns the target node
pub fn MutationRecord::target(self : Self) -> Val {
  unsafe_cast(self.to_js().get("target"))
}

///|
/// Returns the added nodes
pub fn MutationRecord::added_nodes(self : Self) -> Val {
  self.to_js().get("addedNodes")
}

///|
/// Returns the removed nodes
pub fn MutationRecord::removed_nodes(self : Self) -> Val {
  self.to_js().get("removedNodes")
}

///|
/// Returns the previous sibling
pub fn MutationRecord::previous_sibling(self : Self) -> Element? {
  self.to_js().get("previousSibling") |> unsafe_cast_option()
}

///|
/// Returns the next sibling
pub fn MutationRecord::next_sibling(self : Self) -> Element? {
  self.to_js().get("nextSibling") |> unsafe_cast_option()
}

///|
/// Returns the attribute name
pub fn MutationRecord::attribute_name(self : Self) -> String? {
  self.to_js().get("attributeName") |> unsafe_cast_option()
}

///|
/// Returns the old value
pub fn MutationRecord::old_value(self : Self) -> String? {
  self.to_js().get("oldValue") |> unsafe_cast_option()
}

///|
/// IntersectionObserver observes intersection changes
/// https://developer.mozilla.org/en-US/docs/Web/API/IntersectionObserver
#external
pub type IntersectionObserver

///|
pub impl Js for IntersectionObserver with to_js(self) -> Val {
  self |> js
}

///|
/// Creates a new IntersectionObserver
/// https://developer.mozilla.org/en-US/docs/Web/API/IntersectionObserver/IntersectionObserver
pub fn new_intersection_observer(
  callback : (Val, IntersectionObserver) -> Unit,
) -> IntersectionObserver {
  let ctor = @js.global_this().get("IntersectionObserver")
  unsafe_cast(@js.new_(ctor, [callback |> js]))
}

///|
/// Creates a new IntersectionObserver with options
pub fn new_intersection_observer_with_options(
  callback : (Val, IntersectionObserver) -> Unit,
  options : Val,
) -> IntersectionObserver {
  let ctor = @js.global_this().get("IntersectionObserver")
  unsafe_cast(@js.new_(ctor, [callback |> js, options]))
}

///|
/// Starts observing a target element
/// https://developer.mozilla.org/en-US/docs/Web/API/IntersectionObserver/observe
pub fn IntersectionObserver::observe(self : Self, target : Element) -> Unit {
  self.to_js().invoke("observe", [target |> js]) |> ignore
}

///|
/// Stops observing a target element
/// https://developer.mozilla.org/en-US/docs/Web/API/IntersectionObserver/unobserve
pub fn IntersectionObserver::unobserve(self : Self, target : Element) -> Unit {
  self.to_js().invoke("unobserve", [target |> js]) |> ignore
}

///|
/// Stops observing all targets
/// https://developer.mozilla.org/en-US/docs/Web/API/IntersectionObserver/disconnect
pub fn IntersectionObserver::disconnect(self : Self) -> Unit {
  self.to_js().invoke("disconnect", []) |> ignore
}

///|
/// Returns all pending intersection records
/// https://developer.mozilla.org/en-US/docs/Web/API/IntersectionObserver/takeRecords
pub fn IntersectionObserver::take_records(self : Self) -> Val {
  self.to_js().invoke("takeRecords", [])
}

///|
/// IntersectionObserverEntry represents an intersection change
/// https://developer.mozilla.org/en-US/docs/Web/API/IntersectionObserverEntry
#external
pub type IntersectionObserverEntry

///|
pub impl Js for IntersectionObserverEntry with to_js(self) -> Val {
  self |> js
}

///|
/// Returns the target element
pub fn IntersectionObserverEntry::target(self : Self) -> Val {
  unsafe_cast(self.to_js().get("target"))
}

///|
/// Returns the bounding rect of the target
pub fn IntersectionObserverEntry::bounding_client_rect(self : Self) -> Val {
  self.to_js().get("boundingClientRect")
}

///|
/// Returns the intersection rect
pub fn IntersectionObserverEntry::intersection_rect(self : Self) -> Val {
  self.to_js().get("intersectionRect")
}

///|
/// Returns the root bounds
pub fn IntersectionObserverEntry::root_bounds(self : Self) -> Element? {
  self.to_js().get("rootBounds") |> unsafe_cast_option()
}

///|
/// Returns the intersection ratio
pub fn IntersectionObserverEntry::intersection_ratio(self : Self) -> Double {
  unsafe_cast(self.to_js().get("intersectionRatio"))
}

///|
/// Returns whether the target is intersecting
pub fn IntersectionObserverEntry::is_intersecting(self : Self) -> Bool {
  unsafe_cast(self.to_js().get("isIntersecting"))
}

///|
/// Returns the time of the intersection
pub fn IntersectionObserverEntry::time(self : Self) -> Double {
  unsafe_cast(self.to_js().get("time"))
}

///|
/// ResizeObserver observes size changes
/// https://developer.mozilla.org/en-US/docs/Web/API/ResizeObserver
#external
pub type ResizeObserver

///|
pub impl Js for ResizeObserver with to_js(self) -> Val {
  self |> js
}

///|
/// Creates a new ResizeObserver
/// https://developer.mozilla.org/en-US/docs/Web/API/ResizeObserver/ResizeObserver
pub fn new_resize_observer(
  callback : (Val, ResizeObserver) -> Unit,
) -> ResizeObserver {
  let ctor = @js.global_this().get("ResizeObserver")
  unsafe_cast(@js.new_(ctor, [callback |> js]))
}

///|
/// Starts observing a target element
/// https://developer.mozilla.org/en-US/docs/Web/API/ResizeObserver/observe
pub fn ResizeObserver::observe(self : Self, target : Element) -> Unit {
  self.to_js().invoke("observe", [target |> js]) |> ignore
}

///|
/// Starts observing with options
pub fn ResizeObserver::observe_with_options(
  self : Self,
  target : Element,
  options : Val,
) -> Unit {
  self.to_js().invoke("observe", [target |> js, options]) |> ignore
}

///|
/// Stops observing a target element
/// https://developer.mozilla.org/en-US/docs/Web/API/ResizeObserver/unobserve
pub fn ResizeObserver::unobserve(self : Self, target : Element) -> Unit {
  self.to_js().invoke("unobserve", [target |> js]) |> ignore
}

///|
/// Stops observing all targets
/// https://developer.mozilla.org/en-US/docs/Web/API/ResizeObserver/disconnect
pub fn ResizeObserver::disconnect(self : Self) -> Unit {
  self.to_js().invoke("disconnect", []) |> ignore
}
