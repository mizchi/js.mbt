///|
/// Initialize the Preact API and store it in globalThis.__PreactApi
/// Node.js: globalThis.__PreactApi = require('preact')
pub fn init_preact_api(
  preact : @js.Any,
  hooks : @js.Any,
  global_key? : String = "__PreactApi",
) -> Unit {
  if @js.is_nullish(@js.global_this().get(global_key)) {
    // Merge preact and hooks into a single API object
    let api = @js.Object::new()
    // Copy preact exports
    for key in @js.Object::keys(preact) {
      api.set(key, preact.get(key))
    }
    // Copy hooks exports
    for key in @js.Object::keys(hooks) {
      api.set(key, hooks.get(key))
    }
    @js.global_this().set(global_key, api)
  }
}

///|
/// Dynamic import for preact modules
extern "js" fn import_preact() -> @js.Promise[@js.Any] =
  #|() => import("preact")

///|
extern "js" fn import_preact_hooks() -> @js.Promise[@js.Any] =
  #|() => import("preact/hooks")

///|
/// Dynamic import and initialize Preact API asynchronously
pub async fn dynamic_import() -> Unit {
  if @js.is_nullish(@js.global_this().get("__PreactApi")) {
    let preact : @js.Any = import_preact().wait()
    let hooks : @js.Any = import_preact_hooks().wait()
    init_preact_api(preact, hooks)
  }
}
