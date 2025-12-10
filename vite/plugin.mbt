///|
/// Vite Plugin API support
/// See: https://ja.vite.dev/guide/api-plugin

///|
/// Vite Plugin type
pub type Plugin = @core.Any

///| Hook callback types

///|
/// ResolveId hook callback
/// (source: String, importer: String?, options: @core.Any) -> String? | @core.Any?
pub type ResolveIdHook = (String, String?, @core.Any) -> String?

///|
/// Load hook callback
/// (id: String) -> String? | @core.Any?
pub type LoadHook = (String) -> String?

///|
/// Transform hook callback
/// (code: String, id: String) -> String? | @core.Any?
pub type TransformHook = (String, String) -> String?

///|
/// BuildStart hook callback
/// (options: @core.Any) -> Unit
pub type BuildStartHook = (@core.Any) -> Unit

///|
/// BuildEnd hook callback
/// (error?: @core.Any) -> Unit
pub type BuildEndHook = (@core.Any?) -> Unit

///|
/// ConfigResolved hook callback
/// (config: @core.Any) -> Unit
pub type ConfigResolvedHook = (@core.Any) -> Unit

///|
/// ConfigureServer hook callback
/// (server: @core.Any) -> Unit
pub type ConfigureServerHook = (@core.Any) -> Unit

///|
/// Create a Vite plugin with labeled arguments
/// See: https://ja.vite.dev/guide/api-plugin
pub fn define_plugin(
  name : String,
  enforce? : String,
  apply? : String,
  config? : (@core.Any) -> Unit,
  configResolved? : ConfigResolvedHook,
  configureServer? : ConfigureServerHook,
  configurePreviewServer? : (@core.Any) -> Unit,
  transformIndexHtml? : (@core.Any) -> @core.Any,
  handleHotUpdate? : (@core.Any) -> Unit,
  options? : (@core.Any) -> Unit,
  buildStart? : BuildStartHook,
  resolveId? : ResolveIdHook,
  load? : LoadHook,
  transform? : TransformHook,
  buildEnd? : BuildEndHook,
  closeBundle? : () -> Unit,
) -> Plugin {
  let plugin = @core.new_object()
  plugin["name"] = @core.any(name)
  if enforce is Some(v) {
    plugin["enforce"] = @core.any(v)
  }
  if apply is Some(v) {
    plugin["apply"] = @core.any(v)
  }
  if config is Some(v) {
    plugin["config"] = @core.any(@js.from_fn1(v))
  }
  if configResolved is Some(v) {
    plugin["configResolved"] = @core.any(@js.from_fn1(v))
  }
  if configureServer is Some(v) {
    plugin["configureServer"] = @core.any(@js.from_fn1(v))
  }
  if configurePreviewServer is Some(v) {
    plugin["configurePreviewServer"] = @core.any(@js.from_fn1(v))
  }
  if transformIndexHtml is Some(v) {
    plugin["transformIndexHtml"] = @core.any(@js.from_fn1(v))
  }
  if handleHotUpdate is Some(v) {
    plugin["handleHotUpdate"] = @core.any(@js.from_fn1(v))
  }
  if options is Some(v) {
    plugin["options"] = @core.any(@js.from_fn1(v))
  }
  if buildStart is Some(v) {
    plugin["buildStart"] = @core.any(@js.from_fn1(v))
  }
  if resolveId is Some(v) {
    plugin["resolveId"] = @core.any(@js.from_fn3(v))
  }
  if load is Some(v) {
    plugin["load"] = @core.any(@js.from_fn1(v))
  }
  if transform is Some(v) {
    plugin["transform"] = @core.any(@js.from_fn2(v))
  }
  if buildEnd is Some(v) {
    plugin["buildEnd"] = @core.any(@js.from_fn1(v))
  }
  if closeBundle is Some(v) {
    plugin["closeBundle"] = @core.any(@js.from_fn0(v))
  }
  plugin |> @core.identity
}
