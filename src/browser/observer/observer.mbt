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
/// Creates a new MutationObserver
/// https://developer.mozilla.org/en-US/docs/Web/API/MutationObserver/MutationObserver
pub fn MutationObserver::new(
  callback : (@nostd.Any?, MutationObserver) -> Unit,
) -> MutationObserver {
  let ctor = @global.global_this()._get("MutationObserver")
  @nostd.new(ctor, [callback |> @js.from_fn2]).cast()
}

///|
/// Starts observing a target element
/// https://developer.mozilla.org/en-US/docs/Web/API/MutationObserver/observe
pub fn MutationObserver::observe(
  self : Self,
  target : @dom.Element,
  options : @nostd.Any,
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
pub fn MutationObserver::take_records(self : Self) -> @nostd.Any {
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
pub fn MutationRecord::as_any(self : MutationRecord) -> @nostd.Any = "%identity"

///|
/// Get the type of mutation
pub fn MutationRecord::mutation_type(self : Self) -> String {
  self.as_any()["type"].cast()
}

///|
/// IntersectionObserver observes intersection changes
/// https://developer.mozilla.org/en-US/docs/Web/API/IntersectionObserver
#external
pub type IntersectionObserver

///|
pub fn IntersectionObserver::as_any(self : IntersectionObserver) -> @nostd.Any = "%identity"

///|
/// Creates a new IntersectionObserver
/// https://developer.mozilla.org/en-US/docs/Web/API/IntersectionObserver/IntersectionObserver
pub fn IntersectionObserver::new(
  callback : (@nostd.Any?, IntersectionObserver) -> Unit,
  options? : @nostd.Any,
) -> IntersectionObserver {
  let ctor = @global.global_this()._get("IntersectionObserver")
  match options {
    Some(opts) => @nostd.new(ctor, [callback |> @js.from_fn2, opts]).cast()
    None => @nostd.new(ctor, [callback |> @js.from_fn2]).cast()
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
pub fn IntersectionObserver::take_records(self : Self) -> @nostd.Any {
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
pub fn IntersectionObserverEntry::as_any(
  self : IntersectionObserverEntry,
) -> @nostd.Any = "%identity"

///|
/// ResizeObserver observes size changes
/// https://developer.mozilla.org/en-US/docs/Web/API/ResizeObserver
#external
pub type ResizeObserver

///|
pub fn ResizeObserver::as_any(self : ResizeObserver) -> @nostd.Any = "%identity"

///|
/// Creates a new ResizeObserver
/// https://developer.mozilla.org/en-US/docs/Web/API/ResizeObserver/ResizeObserver
pub fn ResizeObserver::new(
  callback : (@nostd.Any?, ResizeObserver) -> Unit,
) -> ResizeObserver {
  let ctor = @global.global_this()._get("ResizeObserver")
  @nostd.new(ctor, [callback |> @js.from_fn2]).cast()
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
  options : @nostd.Any,
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
  borderBoxSize : @nostd.Any
  contentBoxSize : @nostd.Any
}

///|
pub fn ResizeObserverEntry::as_any(self : ResizeObserverEntry) -> @nostd.Any = "%identity"
