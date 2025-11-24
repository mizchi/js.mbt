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
  server : @js.Any?
  build : @js.Any?
  preview : @js.Any?
  optimizeDeps : @js.Any?
  plugins : @js.Any?
  publicDir : String?
  cacheDir : String?
  resolve : @js.Any?
  css : @js.Any?
  json : @js.Any?
  esbuild : @js.Any?
  assetsInclude : @js.Any?
  envDir : String?
  envPrefix : String?
} derive(Show)

///|
/// FFI: defineConfig
extern "js" fn ffi_defineConfig(config : @js.Any) -> @js.Any =
  #| (config) => {
  #|   const vite = require('vite');
  #|   return vite.defineConfig(config);
  #| }

///|
/// Define Vite configuration with type support
/// JS: defineConfig(config)
/// See: https://ja.vite.dev/config/#config-intellisense
/// Returns a @js.Any object with defineConfig applied
pub fn defineConfig(
  root? : String,
  base? : String,
  mode? : String,
  logLevel? : String,
  clearScreen? : Bool,
  server? : @js.Any,
  build? : @js.Any,
  preview? : @js.Any,
  optimizeDeps? : @js.Any,
  plugins? : @js.Any,
  publicDir? : String,
  cacheDir? : String,
  resolve? : @js.Any,
  css? : @js.Any,
  json? : @js.Any,
  esbuild? : @js.Any,
  assetsInclude? : @js.Any,
  envDir? : String,
  envPrefix? : String,
) -> @js.Any {
  let obj = @js.Object::new()
  match root {
    Some(v) => obj.set("root", @js.any(v))
    None => ()
  }
  match base {
    Some(v) => obj.set("base", @js.any(v))
    None => ()
  }
  match mode {
    Some(v) => obj.set("mode", @js.any(v))
    None => ()
  }
  match logLevel {
    Some(v) => obj.set("logLevel", @js.any(v))
    None => ()
  }
  match clearScreen {
    Some(v) => obj.set("clearScreen", @js.any(v))
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
    Some(v) => obj.set("publicDir", @js.any(v))
    None => ()
  }
  match cacheDir {
    Some(v) => obj.set("cacheDir", @js.any(v))
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
    Some(v) => obj.set("envDir", @js.any(v))
    None => ()
  }
  match envPrefix {
    Some(v) => obj.set("envPrefix", @js.any(v))
    None => ()
  }
  ffi_defineConfig(obj.to_any())
}
