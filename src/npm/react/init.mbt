///|
// Initialize the React API and store it in globalThis.__ReactApi
// Node.js: globalThis.__ReactApi = require('react')
pub fn init_react_api(val : Js, global_key? : String = "__ReactApi") -> Unit {
  if @js.is_nullish(global_this().get(global_key)) {
    global_this().set(global_key, val)
  }
}

///|
extern "js" fn import_react() -> Promise[Js] =
  #|() => import("react")

///|
/// For vite build env
/// Initialize the React API asynchronously and store it in globalThis.__ReactApi
#alias(initReactAsync)
pub async fn init_react_async() -> Unit {
  if @js.is_nullish(global_this().get("__ReactApi")) {
    let react : Js = import_react().wait()
    global_this().set("__ReactApi", react)
  }
}
