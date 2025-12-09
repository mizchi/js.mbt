///|
/// Initialize the Preact API and store it in globalThis.__PreactApi
/// @deprecated No longer needed with ESM imports
pub fn init_preact_api(
  preact : @core.Any,
  hooks : @core.Any,
  global_key? : String = "__PreactApi",
) -> Unit {
  ignore(preact)
  ignore(hooks)
  ignore(global_key)
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
