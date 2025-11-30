///|
// Initialize the React API and store it in globalThis.__ReactApi
// Node.js: globalThis.__ReactApi = require('react')
pub fn init_react_api(
  val : @js.Any,
  global_key? : String = "__ReactApi",
) -> Unit {
  if @js.is_nullish(@global.global_this().get(global_key)) {
    @global.global_this().set(global_key, val)
  }
}

///|
/// Dynamic import for react module
/// NOTE: This uses dynamic import which doesn't support tree-shaking.
/// When MoonBit adds native ESM support, this should be replaced with static imports.
extern "js" fn import_react() -> @js.Promise[@js.Any] =
  #|() => import("react")

///|
/// Dynamic import and initialize React API asynchronously
/// NOTE: This uses dynamic import which doesn't support tree-shaking.
/// When MoonBit adds native ESM support, this should be replaced with static imports.
///
/// Implementation detail: Stores the module in globalThis for internal use.
pub async fn dynamic_import() -> Unit {
  if @js.is_nullish(@global.global_this().get("__ReactApi")) {
    let react : @js.Any = import_react().wait()
    @global.global_this().set("__ReactApi", react)
  }
}

///|
/// @deprecated Use dynamic_import() instead
#alias(initReactAsync)
pub async fn init_react_async() -> Unit {
  dynamic_import()
}
