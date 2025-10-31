///|
extern "js" fn ffi_react_dom_render(v : ReactDOMRoot, vdom : Element) -> Unit =
  #| (root, vdom) => root.render(vdom)

///|
#external
pub type ReactDOMClient

///|
#external
pub type ReactDOMRoot

///|
pub fn ReactDOMClient::create_root(
  self : Self,
  container : @dom.Element,
) -> ReactDOMRoot {
  let v : Val = self |> js
  v.get("createRoot").call([container]).cast()
}

///|
pub fn ReactDOMRoot::render(self : ReactDOMRoot, vdom : Element) -> Unit {
  ffi_react_dom_render(self, vdom)
}

///|
extern "js" fn import_react() -> Promise[Val] =
  #| () => import("react")

///|
extern "js" fn import_react_dom_client() -> Promise[ReactDOMClient] =
  #| () => import("react-dom/client")

///|
pub async fn init_react_client() -> ReactDOMClient {
  if global_this().get("__ReactApi").is_undefined() {
    let react : Val = import_react().unwrap()
    global_this().set("__ReactApi", react)
  }
  import_react_dom_client().unwrap()
}
