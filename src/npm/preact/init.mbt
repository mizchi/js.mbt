///|
/// Initialize the Preact API and store it in globalThis.__PreactApi
/// Node.js: globalThis.__PreactApi = require('preact')
pub fn init_preact_api(
  preact : @core.Any,
  hooks : @core.Any,
  global_key? : String = "__PreactApi",
) -> Unit {
  if @core.is_nullish(@global.global_this()._get(global_key)) {
    // Merge preact and hooks into a single API object
    let api = @core.new_object()
    // Copy preact exports
    for key in @core.object_keys(preact) {
      api._set(key, preact._get(key))
    }
    // Copy hooks exports
    for key in @core.object_keys(hooks) {
      api._set(key, hooks._get(key))
    }
    @global.global_this()._set(global_key, api)
  }
}

///|
/// Dynamic import for preact modules
extern "js" fn import_preact() -> @js.Promise[@core.Any] =
  #|() => import("preact")

///|
extern "js" fn import_preact_hooks() -> @js.Promise[@core.Any] =
  #|() => import("preact/hooks")

///|
/// Dynamic import and initialize Preact API asynchronously
pub async fn dynamic_import() -> Unit {
  if @core.is_nullish(@global.global_this()._get("__PreactApi")) {
    let preact : @core.Any = import_preact().wait()
    let hooks : @core.Any = import_preact_hooks().wait()
    init_preact_api(preact, hooks)
  }
}
