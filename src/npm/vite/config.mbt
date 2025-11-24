///|
/// Vite Configuration support

///|
/// Vite configuration
pub(all) struct Config {
  root : String?
  base : String?
  mode : String?
  logLevel : String?
  clearScreen : Bool?
  server : @js.Js?
  build : @js.Js?
  preview : @js.Js?
  optimizeDeps : @js.Js?
  plugins : @js.Js?
  publicDir : String?
  cacheDir : String?
  resolve : @js.Js?
  css : @js.Js?
  json : @js.Js?
  esbuild : @js.Js?
  assetsInclude : @js.Js?
  envDir : String?
  envPrefix : String?
} derive(Show)

///|
/// FFI: defineConfig
extern "js" fn ffi_defineConfig(config : @js.Js) -> @js.Js =
  #| (config) => {
  #|   const vite = require('vite');
  #|   return vite.defineConfig(config);
  #| }

///|
/// Define Vite configuration with type support
/// JS: defineConfig(config)
/// See: https://ja.vite.dev/config/#config-intellisense
/// Returns a @js.Js object with defineConfig applied
pub fn defineConfig(
  root? : String,
  base? : String,
  mode? : String,
  logLevel? : String,
  clearScreen? : Bool,
  server? : @js.Js,
  build? : @js.Js,
  preview? : @js.Js,
  optimizeDeps? : @js.Js,
  plugins? : @js.Js,
  publicDir? : String,
  cacheDir? : String,
  resolve? : @js.Js,
  css? : @js.Js,
  json? : @js.Js,
  esbuild? : @js.Js,
  assetsInclude? : @js.Js,
  envDir? : String,
  envPrefix? : String,
) -> @js.Js {
  let obj = @js.Object::new()
  match root {
    Some(v) => obj.set("root", @js.js(v))
    None => ()
  }
  match base {
    Some(v) => obj.set("base", @js.js(v))
    None => ()
  }
  match mode {
    Some(v) => obj.set("mode", @js.js(v))
    None => ()
  }
  match logLevel {
    Some(v) => obj.set("logLevel", @js.js(v))
    None => ()
  }
  match clearScreen {
    Some(v) => obj.set("clearScreen", @js.js(v))
    None => ()
  }
  match server {
    Some(v) => obj.set("server", v)
    None => ()
  }
  match build {
    Some(v) => obj.set("build", v)
    None => ()
  }
  match preview {
    Some(v) => obj.set("preview", v)
    None => ()
  }
  match optimizeDeps {
    Some(v) => obj.set("optimizeDeps", v)
    None => ()
  }
  match plugins {
    Some(v) => obj.set("plugins", v)
    None => ()
  }
  match publicDir {
    Some(v) => obj.set("publicDir", @js.js(v))
    None => ()
  }
  match cacheDir {
    Some(v) => obj.set("cacheDir", @js.js(v))
    None => ()
  }
  match resolve {
    Some(v) => obj.set("resolve", v)
    None => ()
  }
  match css {
    Some(v) => obj.set("css", v)
    None => ()
  }
  match json {
    Some(v) => obj.set("json", v)
    None => ()
  }
  match esbuild {
    Some(v) => obj.set("esbuild", v)
    None => ()
  }
  match assetsInclude {
    Some(v) => obj.set("assetsInclude", v)
    None => ()
  }
  match envDir {
    Some(v) => obj.set("envDir", @js.js(v))
    None => ()
  }
  match envPrefix {
    Some(v) => obj.set("envPrefix", @js.js(v))
    None => ()
  }
  ffi_defineConfig(obj.to_js())
}
