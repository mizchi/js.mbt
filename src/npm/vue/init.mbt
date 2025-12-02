///|
/// Initialize the Vue API and store it in globalThis.__VueApi
/// Node.js: globalThis.__VueApi = require('vue')
pub fn init_vue_api(
  vue : @nostd.Any,
  global_key? : String = "__VueApi",
) -> Unit {
  if @nostd.is_nullish(@global.global_this()._get(global_key)) {
    @global.global_this().set(global_key, vue)
  }
}

///|
/// Dynamic import for Vue module
extern "js" fn import_vue() -> @js.Promise[@nostd.Any] =
  #|() => import("vue")

///|
/// Dynamic import and initialize Vue API asynchronously
pub async fn dynamic_import() -> Unit {
  if @nostd.is_nullish(@global.global_this()._get("__VueApi")) {
    let vue : @nostd.Any = import_vue().wait()
    init_vue_api(vue)
  }
}
