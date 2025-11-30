///|
/// Observer APIs for DOM
/// https://developer.mozilla.org/en-US/docs/Web/API/MutationObserver

///|
/// MutationObserver observes changes to the DOM tree
/// https://developer.mozilla.org/en-US/docs/Web/API/MutationObserver
#external
pub type MutationObserver

///|
pub fn MutationObserver::as_any(self : MutationObserver) -> @nostd.Any = "%identity"

///|
pub impl @js.JsImpl for MutationObserver

///|
/// Creates a new MutationObserver
/// https://developer.mozilla.org/en-US/docs/Web/API/MutationObserver/MutationObserver
pub fn MutationObserver::new(
  callback : (@js.Any?, MutationObserver) -> Unit,
) -> MutationObserver {
  let ctor = @global.global_this().get("MutationObserver")
  @js.new_(ctor, [callback |> @js.from_fn2]).cast()
}

///|
/// Starts observing a target element
/// https://developer.mozilla.org/en-US/docs/Web/API/MutationObserver/observe
pub fn MutationObserver::observe(
  self : Self,
  target : @dom.Element,
  options : @js.Any,
) -> Unit {
  self.as_any()._call("observe", [@nostd.any(target), @nostd.any(options)])
  |> ignore
}

///|
/// Stops observing
/// https://developer.mozilla.org/en-US/docs/Web/API/MutationObserver/disconnect
pub fn MutationObserver::disconnect(self : Self) -> Unit {
  self.as_any()._call("disconnect", []) |> ignore
}

///|
/// Returns all pending mutation records
/// https://developer.mozilla.org/en-US/docs/Web/API/MutationObserver/takeRecords
pub fn MutationObserver::take_records(self : Self) -> @js.Any {
  self.as_any()._call("takeRecords", []).cast()
}

///|
/// MutationRecord represents a single DOM mutation
/// https://developer.mozilla.org/en-US/docs/Web/API/MutationRecord
pub(all) struct MutationRecord {
  mutationType : String
  target : @dom.Node
  addedNodes : Array[@dom.Node]
  removedNodes : Array[@dom.Node]
  previousSibling : @js.Nullable[@dom.Node]
  nextSibling : @js.Nullable[@dom.Node]
  attributeName : @js.Nullable[String]
  oldValue : @js.Nullable[String]
}

///|
/// Get the type of mutation
pub fn MutationRecord::mutation_type(self : Self) -> String {
  self.as_any().get("type").cast()
}

///|
pub impl @js.JsImpl for MutationRecord

///|
/// IntersectionObserver observes intersection changes
/// https://developer.mozilla.org/en-US/docs/Web/API/IntersectionObserver
#external
pub type IntersectionObserver

///|
pub fn IntersectionObserver::as_any(self : IntersectionObserver) -> @nostd.Any = "%identity"

///|
pub impl @js.JsImpl for IntersectionObserver

///|
/// Creates a new IntersectionObserver
/// https://developer.mozilla.org/en-US/docs/Web/API/IntersectionObserver/IntersectionObserver
pub fn IntersectionObserver::new(
  callback : (@js.Any?, IntersectionObserver) -> Unit,
  options? : @js.Any,
) -> IntersectionObserver {
  let ctor = @global.global_this().get("IntersectionObserver")
  match options {
    Some(opts) => @js.new_(ctor, [callback |> @js.from_fn2, opts]).cast()
    None => @js.new_(ctor, [callback |> @js.from_fn2]).cast()
  }
}

///|
/// Starts observing a target element
/// https://developer.mozilla.org/en-US/docs/Web/API/IntersectionObserver/observe
pub fn IntersectionObserver::observe(
  self : Self,
  target : @dom.Element,
) -> Unit {
  self.as_any()._call("observe", [@nostd.any(target)]) |> ignore
}

///|
/// Stops observing a target element
/// https://developer.mozilla.org/en-US/docs/Web/API/IntersectionObserver/unobserve
pub fn IntersectionObserver::unobserve(
  self : Self,
  target : @dom.Element,
) -> Unit {
  self.as_any()._call("unobserve", [@nostd.any(target)]) |> ignore
}

///|
/// Stops observing all targets
/// https://developer.mozilla.org/en-US/docs/Web/API/IntersectionObserver/disconnect
pub fn IntersectionObserver::disconnect(self : Self) -> Unit {
  self.as_any()._call("disconnect", []) |> ignore
}

///|
/// Returns all pending intersection records
/// https://developer.mozilla.org/en-US/docs/Web/API/IntersectionObserver/takeRecords
pub fn IntersectionObserver::take_records(self : Self) -> @js.Any {
  self.as_any()._call("takeRecords", []).cast()
}

///|
/// IntersectionObserverEntry represents an intersection change
/// https://developer.mozilla.org/en-US/docs/Web/API/IntersectionObserverEntry
pub(all) struct IntersectionObserverEntry {
  target : @dom.Element
  boundingClientRect : @dom.DOMRectReadOnly
  intersectionRect : @dom.DOMRectReadOnly
  rootBounds : @dom.Element?
  intersectionRatio : Double
  isIntersecting : Bool
  time : Double
}

///|
pub impl @js.JsImpl for IntersectionObserverEntry

///|
/// ResizeObserver observes size changes
/// https://developer.mozilla.org/en-US/docs/Web/API/ResizeObserver
#external
pub type ResizeObserver

///|
pub fn ResizeObserver::as_any(self : ResizeObserver) -> @nostd.Any = "%identity"

///|
pub impl @js.JsImpl for ResizeObserver

///|
/// Creates a new ResizeObserver
/// https://developer.mozilla.org/en-US/docs/Web/API/ResizeObserver/ResizeObserver
pub fn ResizeObserver::new(
  callback : (@js.Any?, ResizeObserver) -> Unit,
) -> ResizeObserver {
  let ctor = @global.global_this().get("ResizeObserver")
  @js.new_(ctor, [callback |> @js.from_fn2]).cast()
}

///|
/// Starts observing a target element
/// https://developer.mozilla.org/en-US/docs/Web/API/ResizeObserver/observe
pub fn ResizeObserver::observe(self : Self, target : @dom.Element) -> Unit {
  self.as_any()._call("observe", [@nostd.any(target)]) |> ignore
}

///|
/// Starts observing with options
pub fn ResizeObserver::observe_with_options(
  self : Self,
  target : @dom.Element,
  options : @js.Any,
) -> Unit {
  self.as_any()._call("observe", [@nostd.any(target), @nostd.any(options)])
  |> ignore
}

///|
/// Stops observing a target element
/// https://developer.mozilla.org/en-US/docs/Web/API/ResizeObserver/unobserve
pub fn ResizeObserver::unobserve(self : Self, target : @dom.Element) -> Unit {
  self.as_any()._call("unobserve", [@nostd.any(target)]) |> ignore
}

///|
/// Stops observing all targets
/// https://developer.mozilla.org/en-US/docs/Web/API/ResizeObserver/disconnect
pub fn ResizeObserver::disconnect(self : Self) -> Unit {
  self.as_any()._call("disconnect", []) |> ignore
}

///|
/// ResizeObserverEntry represents an entry in a ResizeObserver
/// https://developer.mozilla.org/en-US/docs/Web/API/ResizeObserverEntry
pub(all) struct ResizeObserverEntry {
  target : @dom.Element
  contentRect : @dom.DOMRectReadOnly
  borderBoxSize : @js.Any
  contentBoxSize : @js.Any
}

///|
pub impl @js.JsImpl for ResizeObserverEntry
