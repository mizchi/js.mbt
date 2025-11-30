///|
/// Initialize the Vue API and store it in globalThis.__VueApi
/// Node.js: globalThis.__VueApi = require('vue')
pub fn init_vue_api(vue : @js.Any, global_key? : String = "__VueApi") -> Unit {
  if @js.is_nullish(@global.global_this().get(global_key)) {
    @global.global_this().set(global_key, vue)
  }
}

///|
/// Dynamic import for Vue module
extern "js" fn import_vue() -> @js.Promise[@js.Any] =
  #|() => import("vue")

///|
/// Dynamic import and initialize Vue API asynchronously
pub async fn dynamic_import() -> Unit {
  if @js.is_nullish(@global.global_this().get("__VueApi")) {
    let vue : @js.Any = import_vue().wait()
    init_vue_api(vue)
  }
}
