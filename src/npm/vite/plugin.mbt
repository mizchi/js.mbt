///|
/// Vite Plugin API support
/// See: https://ja.vite.dev/guide/api-plugin

///|
/// Vite Plugin type
pub type Plugin = @js.Any

///| Hook callback types

///|
/// ResolveId hook callback
/// (source: String, importer: String?, options: @js.Any) -> String? | @js.Any?
pub type ResolveIdHook = (String, String?, @js.Any) -> String?

///|
/// Load hook callback
/// (id: String) -> String? | @js.Any?
pub type LoadHook = (String) -> String?

///|
/// Transform hook callback
/// (code: String, id: String) -> String? | @js.Any?
pub type TransformHook = (String, String) -> String?

///|
/// BuildStart hook callback
/// (options: @js.Any) -> Unit
pub type BuildStartHook = (@js.Any) -> Unit

///|
/// BuildEnd hook callback
/// (error?: @js.Any) -> Unit
pub type BuildEndHook = (@js.Any?) -> Unit

///|
/// ConfigResolved hook callback
/// (config: @js.Any) -> Unit
pub type ConfigResolvedHook = (@js.Any) -> Unit

///|
/// ConfigureServer hook callback
/// (server: @js.Any) -> Unit
pub type ConfigureServerHook = (@js.Any) -> Unit

///|
/// Create a Vite plugin with labeled arguments
/// See: https://ja.vite.dev/guide/api-plugin
pub fn define_plugin(
  name : String,
  enforce? : String,
  apply? : String,
  config? : (@js.Any) -> Unit,
  configResolved? : ConfigResolvedHook,
  configureServer? : ConfigureServerHook,
  configurePreviewServer? : (@js.Any) -> Unit,
  transformIndexHtml? : (@js.Any) -> @js.Any,
  handleHotUpdate? : (@js.Any) -> Unit,
  options? : (@js.Any) -> Unit,
  buildStart? : BuildStartHook,
  resolveId? : ResolveIdHook,
  load? : LoadHook,
  transform? : TransformHook,
  buildEnd? : BuildEndHook,
  closeBundle? : () -> Unit,
) -> Plugin {
  let plugin = @js.Object::new()
  plugin.set("name", @js.js(name))
  match enforce {
    Some(v) => plugin.set("enforce", @js.js(v))
    None => ()
  }
  match apply {
    Some(v) => plugin.set("apply", @js.js(v))
    None => ()
  }
  match config {
    Some(v) => plugin.set("config", @js.identity(v))
    None => ()
  }
  match configResolved {
    Some(v) => plugin.set("configResolved", @js.identity(v))
    None => ()
  }
  match configureServer {
    Some(v) => plugin.set("configureServer", @js.identity(v))
    None => ()
  }
  match configurePreviewServer {
    Some(v) => plugin.set("configurePreviewServer", @js.identity(v))
    None => ()
  }
  match transformIndexHtml {
    Some(v) => plugin.set("transformIndexHtml", @js.identity(v))
    None => ()
  }
  match handleHotUpdate {
    Some(v) => plugin.set("handleHotUpdate", @js.identity(v))
    None => ()
  }
  match options {
    Some(v) => plugin.set("options", @js.identity(v))
    None => ()
  }
  match buildStart {
    Some(v) => plugin.set("buildStart", @js.identity(v))
    None => ()
  }
  match resolveId {
    Some(v) => plugin.set("resolveId", @js.identity(v))
    None => ()
  }
  match load {
    Some(v) => plugin.set("load", @js.identity(v))
    None => ()
  }
  match transform {
    Some(v) => plugin.set("transform", @js.identity(v))
    None => ()
  }
  match buildEnd {
    Some(v) => plugin.set("buildEnd", @js.identity(v))
    None => ()
  }
  match closeBundle {
    Some(v) => plugin.set("closeBundle", @js.identity(v))
    None => ()
  }
  plugin.to_js()
}
