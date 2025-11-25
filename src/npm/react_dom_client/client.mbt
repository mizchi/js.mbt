///|
#external
pub type ReactDOMClient

///|
#external
pub type ReactDOMRoot

///|
pub impl @js.JsImpl for ReactDOMRoot

///|
pub impl @js.JsImpl for ReactDOMClient

///|
/// Dynamic import for react-dom/client module (internal)
/// NOTE: This uses dynamic import which doesn't support tree-shaking.
/// When MoonBit adds native ESM support, this should be replaced with static imports.
extern "js" fn import_react_dom_client_internal() -> @js.Promise[ReactDOMClient] =
  #| () => import("react-dom/client")

///|
/// Dynamic import for react-dom/client module
/// NOTE: This uses dynamic import which doesn't support tree-shaking.
/// When MoonBit adds native ESM support, this should be replaced with static imports.
pub async fn dynamic_import() -> ReactDOMClient {
  import_react_dom_client_internal().wait()
}

///|
#alias(create_root)
pub fn ReactDOMClient::createRoot(
  self : Self,
  container : &@dom.ElementImpl,
) -> ReactDOMRoot {
  self.call1("createRoot", container.to_any()).cast()
}

///|
pub fn ReactDOMRoot::render(self : ReactDOMRoot, vdom : @react.Element) -> Unit {
  self.call1("render", vdom) |> ignore
}
