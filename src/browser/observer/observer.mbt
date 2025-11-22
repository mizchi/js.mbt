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
pub fn MutationObserver::new(
  callback : (Js?, MutationObserver) -> Unit,
) -> MutationObserver {
  let ctor = @js.global_this().get("MutationObserver")
  @js.new_(ctor, [callback |> @js.from_fn2]) |> @js.unsafe_cast
}

///|
/// Starts observing a target element
/// https://developer.mozilla.org/en-US/docs/Web/API/MutationObserver/observe
pub fn MutationObserver::observe(
  self : Self,
  target : Element,
  options : Js,
) -> Unit {
  self.to_js().call2("observe", target |> js, options) |> ignore
}

///|
/// Stops observing
/// https://developer.mozilla.org/en-US/docs/Web/API/MutationObserver/disconnect
pub fn MutationObserver::disconnect(self : Self) -> Unit {
  self.to_js().call0("disconnect") |> ignore
}

///|
/// Returns all pending mutation records
/// https://developer.mozilla.org/en-US/docs/Web/API/MutationObserver/takeRecords
pub fn MutationObserver::take_records(self : Self) -> Js {
  self.to_js().call0("takeRecords")
}

///|
/// MutationRecord represents a single DOM mutation
/// https://developer.mozilla.org/en-US/docs/Web/API/MutationRecord
pub(all) struct MutationRecord {
  mutationType : String
  target : Node
  addedNodes : Array[Node]
  removedNodes : Array[Node]
  previousSibling : Nullable[Node]
  nextSibling : Nullable[Node]
  attributeName : Nullable[String]
  oldValue : Nullable[String]
}

///|
/// Get the type of mutation
pub fn MutationRecord::mutation_type(self : Self) -> String {
  self.to_js().get("type") |> @js.unsafe_cast
}

///|
pub impl JsImpl for MutationRecord

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
pub fn IntersectionObserver::new(
  callback : (Js?, IntersectionObserver) -> Unit,
  options? : Js,
) -> IntersectionObserver {
  let ctor = @js.global_this().get("IntersectionObserver")
  match options {
    Some(opts) =>
      @js.new_(ctor, [callback |> @js.from_fn2, opts]) |> @js.unsafe_cast
    None => @js.new_(ctor, [callback |> @js.from_fn2]) |> @js.unsafe_cast
  }
}

///|
/// Starts observing a target element
/// https://developer.mozilla.org/en-US/docs/Web/API/IntersectionObserver/observe
pub fn IntersectionObserver::observe(self : Self, target : Element) -> Unit {
  self.to_js().call("observe", [target]) |> ignore
}

///|
/// Stops observing a target element
/// https://developer.mozilla.org/en-US/docs/Web/API/IntersectionObserver/unobserve
pub fn IntersectionObserver::unobserve(self : Self, target : Element) -> Unit {
  self.to_js().call("unobserve", [target]) |> ignore
}

///|
/// Stops observing all targets
/// https://developer.mozilla.org/en-US/docs/Web/API/IntersectionObserver/disconnect
pub fn IntersectionObserver::disconnect(self : Self) -> Unit {
  self.to_js().call0("disconnect") |> ignore
}

///|
/// Returns all pending intersection records
/// https://developer.mozilla.org/en-US/docs/Web/API/IntersectionObserver/takeRecords
pub fn IntersectionObserver::take_records(self : Self) -> Js {
  self.to_js().call0("takeRecords")
}

///|
/// IntersectionObserverEntry represents an intersection change
/// https://developer.mozilla.org/en-US/docs/Web/API/IntersectionObserverEntry
pub(all) struct IntersectionObserverEntry {
  target : Element
  boundingClientRect : DOMRectReadOnly
  intersectionRect : DOMRectReadOnly
  rootBounds : Element?
  intersectionRatio : Double
  isIntersecting : Bool
  time : Double
}

///|
pub impl JsImpl for IntersectionObserverEntry

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
pub fn ResizeObserver::new(
  callback : (Js?, ResizeObserver) -> Unit,
) -> ResizeObserver {
  let ctor = @js.global_this().get("ResizeObserver")
  @js.new_(ctor, [callback |> @js.from_fn2]) |> @js.unsafe_cast
}

///|
/// Starts observing a target element
/// https://developer.mozilla.org/en-US/docs/Web/API/ResizeObserver/observe
pub fn ResizeObserver::observe(self : Self, target : Element) -> Unit {
  self.to_js().call("observe", [target |> js]) |> ignore
}

///|
/// Starts observing with options
pub fn ResizeObserver::observe_with_options(
  self : Self,
  target : Element,
  options : Js,
) -> Unit {
  self.to_js().call2("observe", target |> js, options) |> ignore
}

///|
/// Stops observing a target element
/// https://developer.mozilla.org/en-US/docs/Web/API/ResizeObserver/unobserve
pub fn ResizeObserver::unobserve(self : Self, target : Element) -> Unit {
  self.to_js().call("unobserve", [target |> js]) |> ignore
}

///|
/// Stops observing all targets
/// https://developer.mozilla.org/en-US/docs/Web/API/ResizeObserver/disconnect
pub fn ResizeObserver::disconnect(self : Self) -> Unit {
  self.to_js().call0("disconnect") |> ignore
}

///|
/// ResizeObserverEntry represents an entry in a ResizeObserver
/// https://developer.mozilla.org/en-US/docs/Web/API/ResizeObserverEntry
pub(all) struct ResizeObserverEntry {
  target : Element
  contentRect : @dom.DOMRectReadOnly
  borderBoxSize : Js
  contentBoxSize : Js
}

///|
pub impl JsImpl for ResizeObserverEntry
