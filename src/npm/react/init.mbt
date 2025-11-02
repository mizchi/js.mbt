///|
pub fn init_react() -> Unit {
  if global_this().get("__ReactApi").is_none() {
    let react : Val = @node.require("react")
    global_this().set("__ReactApi", react)
  }
}

///|
// pub async fn init_react_client() -> ReactDOMClient {
//   init_react()
//   import_react_dom_client().unwrap()
// }
