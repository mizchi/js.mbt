///|
#external
pub type ReactDOMClient

///|
#external
pub type ReactDOMRoot

///|
pub impl Js for ReactDOMRoot

///|
pub impl Js for ReactDOMClient

///|
#alias(create_root)
pub fn ReactDOMClient::createRoot(
  self : Self,
  container : &@dom.ElementImpl,
) -> ReactDOMRoot {
  self.invoke("createRoot", [container.to_js()]) |> unsafe_cast
}

///|
pub fn ReactDOMRoot::render(self : ReactDOMRoot, vdom : @react.Element) -> Unit {
  self.invoke("render", [vdom]) |> ignore
}
