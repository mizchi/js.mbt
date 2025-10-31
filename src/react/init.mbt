///|
pub fn init_react() -> Unit {
  if global_this().get("__ReactApi").is_none() {
    let react : Val = @module.require("react")
    global_this().set("__ReactApi", react)
  }
}

///|
pub async fn init_react_client() -> ReactDOMClient {
  if global_this().get("__ReactApi").is_undefined() {
    let react : Val = import_react().unwrap()
    global_this().set("__ReactApi", react)
  }
  import_react_dom_client().unwrap()
}
