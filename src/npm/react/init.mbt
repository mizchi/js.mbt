///|
// Initialize the React API and store it in globalThis.__ReactApi
// Node.js: init_react_api(@node.require('react'))
pub fn init_react_api(val : Js, global_key? : String = "__ReactApi") -> Unit {
  if global_this().get(global_key).is_none() {
    global_this().set(global_key, val)
  }
}

///|
extern "js" fn import_react() -> Promise[Js] =
  #|() => import("react")

///|
/// For vite build env
/// Initialize the React API asynchronously and store it in globalThis.__ReactApi
pub async fn init_react_async() -> Unit {
  if global_this().get("__ReactApi").is_none() {
    let react : Js = import_react().unwrap()
    global_this().set("__ReactApi", react)
  }
}
