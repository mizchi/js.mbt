///|
#external
pub type ReactDOMClient

///|
#external
pub type ReactDOMRoot

///|
pub fn ReactDOMClient::create_root(
  self : ReactDOMClient,
  container : @dom.Element,
) -> ReactDOMRoot {
  let v : @js.Value = self |> @js.identity
  v.get("createRoot").call([container.to_js_value()]).cast()
}

///|
extern "js" fn ReactDOMRoot::render_internal(
  self : ReactDOMRoot,
  vdom : Element,
) -> Unit =
  #| (root, vdom) => root.render(vdom)

///|
pub fn ReactDOMRoot::render(self : ReactDOMRoot, vdom : Element) -> Unit {
  self.render_internal(vdom)
}

///|
extern "js" fn import_react() -> @js.Promise[@js.Value] =
  #| () => import("react")

///|
extern "js" fn import_react_dom_client() -> @js.Promise[ReactDOMClient] =
  #| () => import("react-dom/client")

///|
pub async fn init_react_client() -> ReactDOMClient {
  if @js.global_this().get("__ReactApi").is_undefined() {
    let react : @js.Value = import_react().wait()
    @js.global_this().set("__ReactApi", react)
  }
  import_react_dom_client().wait()
}
