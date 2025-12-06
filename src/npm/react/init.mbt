///|
// Initialize the React API and store it in globalThis.__ReactApi
// Node.js: globalThis.__ReactApi = require('react')
pub fn init_react_api(
  val : @core.Any,
  global_key? : String = "__ReactApi",
) -> Unit {
  if @core.is_nullish(@global.global_this()._get(global_key)) {
    @global.global_this()._set(global_key, val)
  }
}

///|
/// Dynamic import for react module
/// NOTE: This uses dynamic import which doesn't support tree-shaking.
/// When MoonBit adds native ESM support, this should be replaced with static imports.
extern "js" fn import_react() -> @js.Promise[@core.Any] =
  #|() => import("react")

///|
/// Dynamic import and initialize React API asynchronously
/// NOTE: This uses dynamic import which doesn't support tree-shaking.
/// When MoonBit adds native ESM support, this should be replaced with static imports.
///
/// Implementation detail: Stores the module in globalThis for internal use.
pub async fn dynamic_import() -> Unit {
  let g = @global.global_this()
  if @core.is_nullish(g._get("__ReactApi")) {
    let react : @core.Any = import_react().wait()
    g._set("__ReactApi", react)
  }
}

///|
/// @deprecated Use dynamic_import() instead
#alias(initReactAsync)
pub async fn init_react_async() -> Unit {
  dynamic_import()
}
