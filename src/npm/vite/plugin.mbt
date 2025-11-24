///|
/// Vite Plugin API support
/// See: https://ja.vite.dev/guide/api-plugin

///|
/// Vite Plugin type
pub type Plugin = @js.Js

///| Hook callback types

///|
/// ResolveId hook callback
/// (source: String, importer: String?, options: @js.Js) -> String? | @js.Js?
pub type ResolveIdHook = (String, String?, @js.Js) -> String?

///|
/// Load hook callback
/// (id: String) -> String? | @js.Js?
pub type LoadHook = (String) -> String?

///|
/// Transform hook callback
/// (code: String, id: String) -> String? | @js.Js?
pub type TransformHook = (String, String) -> String?

///|
/// BuildStart hook callback
/// (options: @js.Js) -> Unit
pub type BuildStartHook = (@js.Js) -> Unit

///|
/// BuildEnd hook callback
/// (error?: @js.Js) -> Unit
pub type BuildEndHook = (@js.Js?) -> Unit

///|
/// ConfigResolved hook callback
/// (config: @js.Js) -> Unit
pub type ConfigResolvedHook = (@js.Js) -> Unit

///|
/// ConfigureServer hook callback
/// (server: @js.Js) -> Unit
pub type ConfigureServerHook = (@js.Js) -> Unit

///|
/// Create a Vite plugin with labeled arguments
/// See: https://ja.vite.dev/guide/api-plugin
pub fn define_plugin(
  name : String,
  enforce? : String,
  apply? : String,
  config? : (@js.Js) -> Unit,
  configResolved? : ConfigResolvedHook,
  configureServer? : ConfigureServerHook,
  configurePreviewServer? : (@js.Js) -> Unit,
  transformIndexHtml? : (@js.Js) -> @js.Js,
  handleHotUpdate? : (@js.Js) -> Unit,
  options? : (@js.Js) -> Unit,
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
    Some(v) => plugin.set("config", @js.unsafe_cast(v))
    None => ()
  }
  match configResolved {
    Some(v) => plugin.set("configResolved", @js.unsafe_cast(v))
    None => ()
  }
  match configureServer {
    Some(v) => plugin.set("configureServer", @js.unsafe_cast(v))
    None => ()
  }
  match configurePreviewServer {
    Some(v) => plugin.set("configurePreviewServer", @js.unsafe_cast(v))
    None => ()
  }
  match transformIndexHtml {
    Some(v) => plugin.set("transformIndexHtml", @js.unsafe_cast(v))
    None => ()
  }
  match handleHotUpdate {
    Some(v) => plugin.set("handleHotUpdate", @js.unsafe_cast(v))
    None => ()
  }
  match options {
    Some(v) => plugin.set("options", @js.unsafe_cast(v))
    None => ()
  }
  match buildStart {
    Some(v) => plugin.set("buildStart", @js.unsafe_cast(v))
    None => ()
  }
  match resolveId {
    Some(v) => plugin.set("resolveId", @js.unsafe_cast(v))
    None => ()
  }
  match load {
    Some(v) => plugin.set("load", @js.unsafe_cast(v))
    None => ()
  }
  match transform {
    Some(v) => plugin.set("transform", @js.unsafe_cast(v))
    None => ()
  }
  match buildEnd {
    Some(v) => plugin.set("buildEnd", @js.unsafe_cast(v))
    None => ()
  }
  match closeBundle {
    Some(v) => plugin.set("closeBundle", @js.unsafe_cast(v))
    None => ()
  }
  plugin.to_js()
}
