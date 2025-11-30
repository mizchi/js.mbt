///|
#external
pub type ReactDOM

///|
pub impl @js.JsImpl for ReactDOM

///|
/// Dynamic import for react-dom module (internal)
/// NOTE: This uses dynamic import which doesn't support tree-shaking.
/// When MoonBit adds native ESM support, this should be replaced with static imports.
extern "js" fn import_react_dom_internal() -> @js.Promise[ReactDOM] =
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
  let result : @js.Any = match key {
    Some(key) =>
      self.call("createPortal", [children, dom_node.as_any(), @js.any(key)])
    None => self.call2("createPortal", children, dom_node.as_any())
  }
  result.cast()
}

///|
/// flushSync lets you force React to flush any updates inside the provided callback synchronously.
/// This ensures that the DOM is updated immediately.
#alias(flush_sync)
pub fn[T] ReactDOM::flushSync(self : ReactDOM, callback : () -> T) -> T {
  self.call1("flushSync", @js.from_fn0(callback)).cast()
}
