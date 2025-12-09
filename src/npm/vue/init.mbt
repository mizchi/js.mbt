///|
/// Initialize the Vue Fragment symbol
/// Required for fragment() function since #module cannot import symbols
pub fn init_fragment(vue_module : @core.Any) -> Unit {
  if @core.is_nullish(@global.global_this()._get("__VueFragment")) {
    @global.global_this()._set("__VueFragment", vue_module._get("Fragment"))
  }
}

///|
/// Dynamic import for Vue module
extern "js" fn import_vue() -> @js.Promise[@core.Any] =
  #|() => import("vue")

///|
/// Dynamic import and initialize Vue Fragment asynchronously
pub async fn init_global() -> Unit {
  if @core.is_nullish(@global.global_this()._get("__VueFragment")) {
    let vue : @core.Any = import_vue().wait()
    init_fragment(vue)
  }
}

///|
/// Deprecated - use init_fragment instead
#deprecated("Use init_fragment instead")
pub fn init_vue_api(vue : @core.Any, global_key? : String = "__VueApi") -> Unit {
  ignore(global_key)
  init_fragment(vue)
}
