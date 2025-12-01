///|
/// Vite Plugin API support
/// See: https://ja.vite.dev/guide/api-plugin

///|
/// Vite Plugin type
pub type Plugin = @nostd.Any

///| Hook callback types

///|
/// ResolveId hook callback
/// (source: String, importer: String?, options: @nostd.Any) -> String? | @nostd.Any?
pub type ResolveIdHook = (String, String?, @nostd.Any) -> String?

///|
/// Load hook callback
/// (id: String) -> String? | @nostd.Any?
pub type LoadHook = (String) -> String?

///|
/// Transform hook callback
/// (code: String, id: String) -> String? | @nostd.Any?
pub type TransformHook = (String, String) -> String?

///|
/// BuildStart hook callback
/// (options: @nostd.Any) -> Unit
pub type BuildStartHook = (@nostd.Any) -> Unit

///|
/// BuildEnd hook callback
/// (error?: @nostd.Any) -> Unit
pub type BuildEndHook = (@nostd.Any?) -> Unit

///|
/// ConfigResolved hook callback
/// (config: @nostd.Any) -> Unit
pub type ConfigResolvedHook = (@nostd.Any) -> Unit

///|
/// ConfigureServer hook callback
/// (server: @nostd.Any) -> Unit
pub type ConfigureServerHook = (@nostd.Any) -> Unit

///|
/// Create a Vite plugin with labeled arguments
/// See: https://ja.vite.dev/guide/api-plugin
pub fn define_plugin(
  name : String,
  enforce? : String,
  apply? : String,
  config? : (@nostd.Any) -> Unit,
  configResolved? : ConfigResolvedHook,
  configureServer? : ConfigureServerHook,
  configurePreviewServer? : (@nostd.Any) -> Unit,
  transformIndexHtml? : (@nostd.Any) -> @nostd.Any,
  handleHotUpdate? : (@nostd.Any) -> Unit,
  options? : (@nostd.Any) -> Unit,
  buildStart? : BuildStartHook,
  resolveId? : ResolveIdHook,
  load? : LoadHook,
  transform? : TransformHook,
  buildEnd? : BuildEndHook,
  closeBundle? : () -> Unit,
) -> Plugin {
  let plugin = @nostd.Object::new()
  plugin["name"] = @nostd.any(name)
  if enforce is Some(v) {
    plugin["enforce"] = @nostd.any(v)
  }
  if apply is Some(v) {
    plugin["apply"] = @nostd.any(v)
  }
  if config is Some(v) {
    plugin["config"] = @nostd.any(@js.from_fn1(v))
  }
  if configResolved is Some(v) {
    plugin["configResolved"] = @nostd.any(@js.from_fn1(v))
  }
  if configureServer is Some(v) {
    plugin["configureServer"] = @nostd.any(@js.from_fn1(v))
  }
  if configurePreviewServer is Some(v) {
    plugin["configurePreviewServer"] = @nostd.any(@js.from_fn1(v))
  }
  if transformIndexHtml is Some(v) {
    plugin["transformIndexHtml"] = @nostd.any(@js.from_fn1(v))
  }
  if handleHotUpdate is Some(v) {
    plugin["handleHotUpdate"] = @nostd.any(@js.from_fn1(v))
  }
  if options is Some(v) {
    plugin["options"] = @nostd.any(@js.from_fn1(v))
  }
  if buildStart is Some(v) {
    plugin["buildStart"] = @nostd.any(@js.from_fn1(v))
  }
  if resolveId is Some(v) {
    plugin["resolveId"] = @nostd.any(@js.from_fn3(v))
  }
  if load is Some(v) {
    plugin["load"] = @nostd.any(@js.from_fn1(v))
  }
  if transform is Some(v) {
    plugin["transform"] = @nostd.any(@js.from_fn2(v))
  }
  if buildEnd is Some(v) {
    plugin["buildEnd"] = @nostd.any(@js.from_fn1(v))
  }
  if closeBundle is Some(v) {
    plugin["closeBundle"] = @nostd.any(@js.from_fn0(v))
  }
  plugin |> @js.identity
}
