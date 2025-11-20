///|
/// Observer APIs for DOM
/// https://developer.mozilla.org/en-US/docs/Web/API/MutationObserver

///|
/// MutationObserver observes changes to the DOM tree
/// https://developer.mozilla.org/en-US/docs/Web/API/MutationObserver
#external
pub type MutationObserver

///|
pub impl JsImpl for MutationObserver

///|
/// Creates a new MutationObserver
/// https://developer.mozilla.org/en-US/docs/Web/API/MutationObserver/MutationObserver
pub fn new_mutation_observer(
  callback : (Js?, MutationObserver) -> Unit,
) -> MutationObserver {
  let ctor = @js.global_this().get("MutationObserver")
  @js.unsafe_cast(@js.new_(ctor, [callback |> @js.from_fn2]))
}

///|
/// Starts observing a target element
/// https://developer.mozilla.org/en-US/docs/Web/API/MutationObserver/observe
pub fn MutationObserver::observe(
  self : Self,
  target : Element,
  options : Js,
) -> Unit {
  self.call2("observe", target |> js, options) |> ignore
}

///|
/// Stops observing
/// https://developer.mozilla.org/en-US/docs/Web/API/MutationObserver/disconnect
pub fn MutationObserver::disconnect(self : Self) -> Unit {
  self.call0("disconnect") |> ignore
}

///|
/// Returns all pending mutation records
/// https://developer.mozilla.org/en-US/docs/Web/API/MutationObserver/takeRecords
pub fn MutationObserver::take_records(self : Self) -> Js {
  self.call0("takeRecords")
}

///|
/// MutationRecord represents a single DOM mutation
/// https://developer.mozilla.org/en-US/docs/Web/API/MutationRecord
#external
pub type MutationRecord

///|
pub impl JsImpl for MutationRecord

///|
/// Returns the type of mutation
pub fn MutationRecord::mutation_type(self : Self) -> String {
  self.get("type") |> @js.unsafe_cast
}

///|
/// Returns the target node
pub fn MutationRecord::target(self : Self) -> Js {
  self.get("target")
}

///|
/// Returns the added nodes
pub fn MutationRecord::added_nodes(self : Self) -> Js {
  self.get("addedNodes")
}

///|
/// Returns the removed nodes
pub fn MutationRecord::removed_nodes(self : Self) -> Js {
  self.get("removedNodes")
}

///|
/// Returns the previous sibling
pub fn MutationRecord::previous_sibling(self : Self) -> Element? {
  self.get("previousSibling") |> @js.unsafe_cast_option()
}

///|
/// Returns the next sibling
pub fn MutationRecord::next_sibling(self : Self) -> Element? {
  self.get("nextSibling") |> @js.unsafe_cast_option()
}

///|
/// Returns the attribute name
pub fn MutationRecord::attribute_name(self : Self) -> String? {
  self.get("attributeName") |> @js.unsafe_cast_option()
}

///|
/// Returns the old value
pub fn MutationRecord::old_value(self : Self) -> String? {
  self.get("oldValue") |> @js.unsafe_cast_option()
}

///|
/// IntersectionObserver observes intersection changes
/// https://developer.mozilla.org/en-US/docs/Web/API/IntersectionObserver
#external
pub type IntersectionObserver

///|
pub impl JsImpl for IntersectionObserver

///|
/// Creates a new IntersectionObserver
/// https://developer.mozilla.org/en-US/docs/Web/API/IntersectionObserver/IntersectionObserver
pub fn new_intersection_observer(
  callback : (Js?, IntersectionObserver) -> Unit,
) -> IntersectionObserver {
  let ctor = @js.global_this().get("IntersectionObserver")
  @js.unsafe_cast(@js.new_(ctor, [callback |> @js.from_fn2]))
}

///|
/// Creates a new IntersectionObserver with options
pub fn new_intersection_observer_with_options(
  callback : (Js?, IntersectionObserver) -> Unit,
  options : Js,
) -> IntersectionObserver {
  let ctor = @js.global_this().get("IntersectionObserver")
  @js.unsafe_cast(@js.new_(ctor, [callback |> @js.from_fn2, options]))
}

///|
/// Starts observing a target element
/// https://developer.mozilla.org/en-US/docs/Web/API/IntersectionObserver/observe
pub fn IntersectionObserver::observe(self : Self, target : Element) -> Unit {
  self.call("observe", [target]) |> ignore
}

///|
/// Stops observing a target element
/// https://developer.mozilla.org/en-US/docs/Web/API/IntersectionObserver/unobserve
pub fn IntersectionObserver::unobserve(self : Self, target : Element) -> Unit {
  self.call("unobserve", [target]) |> ignore
}

///|
/// Stops observing all targets
/// https://developer.mozilla.org/en-US/docs/Web/API/IntersectionObserver/disconnect
pub fn IntersectionObserver::disconnect(self : Self) -> Unit {
  self.call0("disconnect") |> ignore
}

///|
/// Returns all pending intersection records
/// https://developer.mozilla.org/en-US/docs/Web/API/IntersectionObserver/takeRecords
pub fn IntersectionObserver::take_records(self : Self) -> Js {
  self.call0("takeRecords")
}

///|
/// IntersectionObserverEntry represents an intersection change
/// https://developer.mozilla.org/en-US/docs/Web/API/IntersectionObserverEntry
#external
pub type IntersectionObserverEntry

///|
pub impl JsImpl for IntersectionObserverEntry

///|
/// Returns the target element
pub fn IntersectionObserverEntry::target(self : Self) -> Js {
  self.get("target") |> @js.unsafe_cast
}

///|
/// Returns the bounding rect of the target
pub fn IntersectionObserverEntry::bounding_client_rect(self : Self) -> Js {
  self.get("boundingClientRect")
}

///|
/// Returns the intersection rect
pub fn IntersectionObserverEntry::intersection_rect(self : Self) -> Js {
  self.get("intersectionRect")
}

///|
/// Returns the root bounds
pub fn IntersectionObserverEntry::root_bounds(self : Self) -> Element? {
  self.get("rootBounds") |> @js.unsafe_cast_option()
}

///|
/// Returns the intersection ratio
pub fn IntersectionObserverEntry::intersection_ratio(self : Self) -> Double {
  self.get("intersectionRatio") |> @js.unsafe_cast
}

///|
/// Returns whether the target is intersecting
pub fn IntersectionObserverEntry::is_intersecting(self : Self) -> Bool {
  self.get("isIntersecting") |> @js.unsafe_cast
}

///|
/// Returns the time of the intersection
pub fn IntersectionObserverEntry::time(self : Self) -> Double {
  self.get("time") |> @js.unsafe_cast
}

///|
/// ResizeObserver observes size changes
/// https://developer.mozilla.org/en-US/docs/Web/API/ResizeObserver
#external
pub type ResizeObserver

///|
pub impl JsImpl for ResizeObserver

///|
/// Creates a new ResizeObserver
/// https://developer.mozilla.org/en-US/docs/Web/API/ResizeObserver/ResizeObserver
pub fn new_resize_observer(
  callback : (Js?, ResizeObserver) -> Unit,
) -> ResizeObserver {
  let ctor = @js.global_this().get("ResizeObserver")
  @js.unsafe_cast(@js.new_(ctor, [callback |> @js.from_fn2]))
}

///|
/// Starts observing a target element
/// https://developer.mozilla.org/en-US/docs/Web/API/ResizeObserver/observe
pub fn ResizeObserver::observe(self : Self, target : Element) -> Unit {
  self.call("observe", [target |> js]) |> ignore
}

///|
/// Starts observing with options
pub fn ResizeObserver::observe_with_options(
  self : Self,
  target : Element,
  options : Js,
) -> Unit {
  self.call2("observe", target |> js, options) |> ignore
}

///|
/// Stops observing a target element
/// https://developer.mozilla.org/en-US/docs/Web/API/ResizeObserver/unobserve
pub fn ResizeObserver::unobserve(self : Self, target : Element) -> Unit {
  self.call("unobserve", [target |> js]) |> ignore
}

///|
/// Stops observing all targets
/// https://developer.mozilla.org/en-US/docs/Web/API/ResizeObserver/disconnect
pub fn ResizeObserver::disconnect(self : Self) -> Unit {
  self.call0("disconnect") |> ignore
}

///|
/// ResizeObserverEntry represents an entry in a ResizeObserver
/// https://developer.mozilla.org/en-US/docs/Web/API/ResizeObserverEntry
#external
pub type ResizeObserverEntry

///|
pub impl JsImpl for ResizeObserverEntry

///|
/// Returns the target element being observed
pub fn ResizeObserverEntry::target(self : Self) -> Element {
  self.get("target") |> @js.unsafe_cast
}

///|
/// Returns the content rect
pub fn ResizeObserverEntry::contentRect(self : Self) -> @dom.DOMRectReadOnly {
  self.get("contentRect") |> @js.unsafe_cast
}

///|
/// Returns the border box size
pub fn ResizeObserverEntry::borderBoxSize(self : Self) -> Js {
  self.get("borderBoxSize")
}

///|
/// Returns the content box size
pub fn ResizeObserverEntry::contentBoxSize(self : Self) -> Js {
  self.get("contentBoxSize")
}
