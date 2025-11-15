// https://nodejs.org/api/module.html
// Based on @types/node module definitions

///|
/// Module Functions
extern "js" fn ffi_require_module() -> Val =
  #|() => require("node:module")

///|
/// Get the builtin modules list
pub fn builtin_modules() -> Array[String] {
  let mod = ffi_require_module()
  unsafe_cast(mod.get("builtinModules"))
}

///|
/// createRequire(filename)
/// Create a require function from a file URL or path
pub fn create_require(filename : String) -> Val {
  let mod = ffi_require_module()
  mod.invoke("createRequire", [filename |> js])
}

///|
/// isBuiltin(moduleName)
/// Returns true if the module is a built-in Node.js module
pub fn is_builtin(module_name : String) -> Bool {
  let mod = ffi_require_module()
  unsafe_cast(mod.invoke("isBuiltin", [module_name |> js]))
}

///|
/// syncBuiltinESMExports()
/// Updates the CommonJS exports to match the ES module exports
pub fn sync_builtin_esm_exports() -> Unit {
  let mod = ffi_require_module()
  mod.invoke("syncBuiltinESMExports", []) |> ignore
}

///|
/// findSourceMap(path)
/// Returns the source map for the given path if it exists
pub fn find_source_map(path : String) -> SourceMap? {
  let mod = ffi_require_module()
  mod.invoke("findSourceMap", [path |> js]) |> to_option()
}

///|
/// enableCompileCache(options?)
/// Enable compile cache for faster module loading
pub fn enable_compile_cache(cache_dir? : String) -> Unit {
  let mod = ffi_require_module()
  match cache_dir {
    Some(dir) => {
      let options = @js.new_empty_object()
      options.set("cacheDir", dir)
      mod.invoke("enableCompileCache", [options]) |> ignore
    }
    None => mod.invoke("enableCompileCache", []) |> ignore
  }
}

///|
/// flushCompileCache()
/// Flush the compile cache to disk
pub fn flush_compile_cache() -> Unit {
  let mod = ffi_require_module()
  mod.invoke("flushCompileCache", []) |> ignore
}

///|
/// getCompileCacheDir()
/// Get the compile cache directory path
pub fn get_compile_cache_dir() -> String? {
  let mod = ffi_require_module()
  mod.invoke("getCompileCacheDir", []) |> to_option()
}

///|
/// stripTypeScriptTypes(code, options?)
/// Remove TypeScript type annotations from code
/// mode: 'strip' (default) or 'transform'
/// source_map: true to generate source map (only with mode='transform')
/// source_url: URL to include in source map
pub fn strip_typescript_types(
  code : String,
  mode? : String,
  source_map? : Bool,
  source_url? : String,
) -> String {
  let mod = ffi_require_module()
  match (mode, source_map, source_url) {
    (None, None, None) =>
      unsafe_cast(mod.invoke("stripTypeScriptTypes", [code |> js]))
    _ => {
      let options = @js.new_empty_object()
      match mode {
        Some(m) => options.set("mode", m)
        None => ()
      }
      match source_map {
        Some(sm) => options.set("sourceMap", sm)
        None => ()
      }
      match source_url {
        Some(url) => options.set("sourceUrl", url)
        None => ()
      }
      unsafe_cast(mod.invoke("stripTypeScriptTypes", [code |> js, options]))
    }
  }
}

///| SourceMap Type

///|
/// Represents a source map for debugging
#external
pub type SourceMap

///|
pub impl Js for SourceMap

///|
/// Get the payload (the actual source map data)
pub fn SourceMap::payload(self : Self) -> Val {
  self.get("payload")
}

///|
/// findEntry(lineNumber, columnNumber)
/// Find the original source location for a generated position
pub fn SourceMap::find_entry(
  self : Self,
  line_number : Int,
  column_number : Int,
) -> SourceMapEntry? {
  self.invoke("findEntry", [line_number |> js, column_number |> js])
  |> to_option()
}

///| SourceMapEntry Type

///|
/// Represents an entry in a source map
#external
pub type SourceMapEntry

///|
pub impl Js for SourceMapEntry

///|
/// Get the original line number
pub fn SourceMapEntry::original_line(self : Self) -> Int {
  unsafe_cast(self.get("originalLine"))
}

///|
/// Get the original column number
pub fn SourceMapEntry::original_column(self : Self) -> Int {
  unsafe_cast(self.get("originalColumn"))
}

///|
/// Get the original source file name
pub fn SourceMapEntry::original_source(self : Self) -> String {
  unsafe_cast(self.get("originalSource"))
}

///|
/// Get the generated line number
pub fn SourceMapEntry::generated_line(self : Self) -> Int {
  unsafe_cast(self.get("generatedLine"))
}

///|
/// Get the generated column number
pub fn SourceMapEntry::generated_column(self : Self) -> Int {
  unsafe_cast(self.get("generatedColumn"))
}

///|
/// Get the name (if available)
pub fn SourceMapEntry::name(self : Self) -> String? {
  self.get("name") |> to_option()
}
