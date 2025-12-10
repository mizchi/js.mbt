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
  server : @core.Any?
  build : @core.Any?
  preview : @core.Any?
  optimizeDeps : @core.Any?
  plugins : @core.Any?
  publicDir : String?
  cacheDir : String?
  resolve : @core.Any?
  css : @core.Any?
  json : @core.Any?
  esbuild : @core.Any?
  assetsInclude : @core.Any?
  envDir : String?
  envPrefix : String?
} derive(Show)

///|
#module("vite")
extern "js" fn ffi_defineConfig(config : @core.Any) -> @core.Any = "defineConfig"

///|
/// Define Vite configuration with type support
/// JS: defineConfig(config)
/// See: https://ja.vite.dev/config/#config-intellisense
/// Returns a @core.Any object with defineConfig applied
pub fn defineConfig(
  root? : String,
  base? : String,
  mode? : String,
  logLevel? : String,
  clearScreen? : Bool,
  server? : @core.Any,
  build? : @core.Any,
  preview? : @core.Any,
  optimizeDeps? : @core.Any,
  plugins? : @core.Any,
  publicDir? : String,
  cacheDir? : String,
  resolve? : @core.Any,
  css? : @core.Any,
  json? : @core.Any,
  esbuild? : @core.Any,
  assetsInclude? : @core.Any,
  envDir? : String,
  envPrefix? : String,
) -> @core.Any {
  let obj = @core.new_object()
  if root is Some(v) {
    obj["root"] = @core.any(v)
  }
  if base is Some(v) {
    obj["base"] = @core.any(v)
  }
  if mode is Some(v) {
    obj["mode"] = @core.any(v)
  }
  if logLevel is Some(v) {
    obj["logLevel"] = @core.any(v)
  }
  if clearScreen is Some(v) {
    obj["clearScreen"] = @core.any(v)
  }
  if server is Some(v) {
    obj["server"] = @core.any(v)
  }
  if build is Some(v) {
    obj["build"] = @core.any(v)
  }
  if preview is Some(v) {
    obj["preview"] = @core.any(v)
  }
  if optimizeDeps is Some(v) {
    obj["optimizeDeps"] = @core.any(v)
  }
  if plugins is Some(v) {
    obj["plugins"] = @core.any(v)
  }
  if publicDir is Some(v) {
    obj["publicDir"] = @core.any(v)
  }
  if cacheDir is Some(v) {
    obj["cacheDir"] = @core.any(v)
  }
  if resolve is Some(v) {
    obj["resolve"] = @core.any(v)
  }
  if css is Some(v) {
    obj["css"] = @core.any(v)
  }
  if json is Some(v) {
    obj["json"] = @core.any(v)
  }
  if esbuild is Some(v) {
    obj["esbuild"] = @core.any(v)
  }
  if assetsInclude is Some(v) {
    obj["assetsInclude"] = @core.any(v)
  }
  if envDir is Some(v) {
    obj["envDir"] = @core.any(v)
  }
  if envPrefix is Some(v) {
    obj["envPrefix"] = @core.any(v)
  }
  ffi_defineConfig(obj)
}
