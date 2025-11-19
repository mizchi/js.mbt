///|
#external
pub type ReactDOMClient

///|
#external
pub type ReactDOMRoot

///|
pub impl JsImpl for ReactDOMRoot

///|
pub impl JsImpl for ReactDOMClient

///|
pub extern "js" fn import_react_dom_client() -> Promise[ReactDOMClient] =
  #| () => import("react-dom/client")

///|
#alias(create_root)
pub fn ReactDOMClient::createRoot(
  self : Self,
  container : &@dom.ElementImpl,
) -> ReactDOMRoot {
  self.call("createRoot", [container.to_js()]) |> unsafe_cast
}

///|
pub fn ReactDOMRoot::render(self : ReactDOMRoot, vdom : @react.Element) -> Unit {
  self.call("render", [vdom]) |> ignore
}
