///|
extern "js" fn require_react() -> Val =
  #|() => require("react")

///|
pub fn init_react() -> Unit {
  if global_this().get("__ReactApi").is_none() {
    let react : Val = require_react()
    global_this().set("__ReactApi", react)
  }
}

///|
extern "js" fn import_react() -> Promise[Val] =
  #|() => import("react")

///|
pub async fn init_react_async() -> Unit {
  if global_this().get("__ReactApi").is_none() {
    let react : Val = import_react().unwrap()
    global_this().set("__ReactApi", react)
  }
}
