///|
extern "js" fn import_react_dom_client() -> Promise[ReactDOMClient] =
  #| () => import("react-dom/client")

///|
pub async fn init_react_client() -> ReactDOMClient {
  @react.init_react_async() |> ignore
  import_react_dom_client().unwrap()
}
