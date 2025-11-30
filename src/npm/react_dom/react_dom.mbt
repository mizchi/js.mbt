///|
#external
pub type ReactDOM

///|
pub fn ReactDOM::as_any(self : ReactDOM) -> @nostd.Any = "%identity"

///|
/// Dynamic import for react-dom module (internal)
/// NOTE: This uses dynamic import which doesn't support tree-shaking.
/// When MoonBit adds native ESM support, this should be replaced with static imports.
extern "js" fn import_react_dom_internal() -> @nostd.Promise[ReactDOM] =
  #| () => import("react-dom")

///|
/// Dynamic import for react-dom module
/// NOTE: This uses dynamic import which doesn't support tree-shaking.
/// When MoonBit adds native ESM support, this should be replaced with static imports.
pub async fn dynamic_import() -> ReactDOM {
  import_react_dom_internal().wait()
}

///|
/// createPortal lets you render some children into a different part of the DOM.
/// Portals let your children "escape" the DOM hierarchy of the parent component
/// while still maintaining their position in the React tree.
#alias(create_portal)
pub fn ReactDOM::createPortal(
  self : ReactDOM,
  children : @react.Element,
  dom_node : &@dom.ElementImpl,
  key? : String,
) -> @react.Element {
  let result : @nostd.Any = match key {
    Some(key) =>
      self
      .as_any()
      ._call(
        "createPortal",
        [children.as_any(), dom_node.as_any(), @nostd.any(key)],
      )
    None =>
      self
      .as_any()
      ._call("createPortal", [children.as_any(), dom_node.as_any()])
  }
  result.cast()
}

///|
/// flushSync lets you force React to flush any updates inside the provided callback synchronously.
/// This ensures that the DOM is updated immediately.
#alias(flush_sync)
pub fn[T] ReactDOM::flushSync(self : ReactDOM, callback : () -> T) -> T {
  self.as_any()._call("flushSync", [@nostd.any(callback)]).cast()
}
