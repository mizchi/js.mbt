///|
extern "js" fn ffi_react_dom_render(
  v : ReactDOMRoot,
  vdom : @react.Element,
) -> Unit =
  #| (root, vdom) => root.render(vdom)

///|
#external
pub type ReactDOMClient

///|
#external
pub type ReactDOMRoot

///|
#alias(createRoot)
pub fn ReactDOMClient::create_root(
  self : Self,
  container : Val,
) -> ReactDOMRoot {
  let v : Val = self |> js
  v.get("createRoot").invoke_self([container]).cast()
}

///|
pub fn ReactDOMRoot::render(self : ReactDOMRoot, vdom : @react.Element) -> Unit {
  ffi_react_dom_render(self, vdom)
}
