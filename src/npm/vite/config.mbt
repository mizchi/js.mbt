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
  server : @nostd.Any?
  build : @nostd.Any?
  preview : @nostd.Any?
  optimizeDeps : @nostd.Any?
  plugins : @nostd.Any?
  publicDir : String?
  cacheDir : String?
  resolve : @nostd.Any?
  css : @nostd.Any?
  json : @nostd.Any?
  esbuild : @nostd.Any?
  assetsInclude : @nostd.Any?
  envDir : String?
  envPrefix : String?
} derive(Show)

///|
/// FFI: defineConfig
extern "js" fn ffi_defineConfig(config : @nostd.Any) -> @nostd.Any =
  #| (config) => {
  #|   const vite = require('vite');
  #|   return vite.defineConfig(config);
  #| }

///|
/// Define Vite configuration with type support
/// JS: defineConfig(config)
/// See: https://ja.vite.dev/config/#config-intellisense
/// Returns a @nostd.Any object with defineConfig applied
pub fn defineConfig(
  root? : String,
  base? : String,
  mode? : String,
  logLevel? : String,
  clearScreen? : Bool,
  server? : @nostd.Any,
  build? : @nostd.Any,
  preview? : @nostd.Any,
  optimizeDeps? : @nostd.Any,
  plugins? : @nostd.Any,
  publicDir? : String,
  cacheDir? : String,
  resolve? : @nostd.Any,
  css? : @nostd.Any,
  json? : @nostd.Any,
  esbuild? : @nostd.Any,
  assetsInclude? : @nostd.Any,
  envDir? : String,
  envPrefix? : String,
) -> @nostd.Any {
  let obj = @nostd.Object::new()
  if root is Some(v) {
    obj["root"] = @nostd.any(v)
  }
  if base is Some(v) {
    obj["base"] = @nostd.any(v)
  }
  if mode is Some(v) {
    obj["mode"] = @nostd.any(v)
  }
  if logLevel is Some(v) {
    obj["logLevel"] = @nostd.any(v)
  }
  if clearScreen is Some(v) {
    obj["clearScreen"] = @nostd.any(v)
  }
  if server is Some(v) {
    obj["server"] = @nostd.any(v)
  }
  if build is Some(v) {
    obj["build"] = @nostd.any(v)
  }
  if preview is Some(v) {
    obj["preview"] = @nostd.any(v)
  }
  if optimizeDeps is Some(v) {
    obj["optimizeDeps"] = @nostd.any(v)
  }
  if plugins is Some(v) {
    obj["plugins"] = @nostd.any(v)
  }
  if publicDir is Some(v) {
    obj["publicDir"] = @nostd.any(v)
  }
  if cacheDir is Some(v) {
    obj["cacheDir"] = @nostd.any(v)
  }
  if resolve is Some(v) {
    obj["resolve"] = @nostd.any(v)
  }
  if css is Some(v) {
    obj["css"] = @nostd.any(v)
  }
  if json is Some(v) {
    obj["json"] = @nostd.any(v)
  }
  if esbuild is Some(v) {
    obj["esbuild"] = @nostd.any(v)
  }
  if assetsInclude is Some(v) {
    obj["assetsInclude"] = @nostd.any(v)
  }
  if envDir is Some(v) {
    obj["envDir"] = @nostd.any(v)
  }
  if envPrefix is Some(v) {
    obj["envPrefix"] = @nostd.any(v)
  }
  ffi_defineConfig(obj)
}
