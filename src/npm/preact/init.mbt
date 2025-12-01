///|
/// Initialize the Preact API and store it in globalThis.__PreactApi
/// Node.js: globalThis.__PreactApi = require('preact')
pub fn init_preact_api(
  preact : @nostd.Any,
  hooks : @nostd.Any,
  global_key? : String = "__PreactApi",
) -> Unit {
  if @js.is_nullish(@global.global_this()._get(global_key)) {
    // Merge preact and hooks into a single API object
    let api = @nostd.Object::new()
    // Copy preact exports
    for key in @js.Object::keys(preact) {
      api.set(key, preact._get(key))
    }
    // Copy hooks exports
    for key in @js.Object::keys(hooks) {
      api.set(key, hooks._get(key))
    }
    @global.global_this().set(global_key, api)
  }
}

///|
/// Dynamic import for preact modules
extern "js" fn import_preact() -> @js.Promise[@nostd.Any] =
  #|() => import("preact")

///|
extern "js" fn import_preact_hooks() -> @js.Promise[@nostd.Any] =
  #|() => import("preact/hooks")

///|
/// Dynamic import and initialize Preact API asynchronously
pub async fn dynamic_import() -> Unit {
  if @js.is_nullish(@global.global_this()._get("__PreactApi")) {
    let preact : @nostd.Any = import_preact().wait()
    let hooks : @nostd.Any = import_preact_hooks().wait()
    init_preact_api(preact, hooks)
  }
}
