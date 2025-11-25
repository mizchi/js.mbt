// https://nodejs.org/api/module.html
// Based on @types/node module definitions

///|
/// Module Functions
extern "js" fn ffi_require_module() -> @js.Any =
  #|() => require("node:module")

///|
/// Get the builtin modules list
///
/// Note: The returned array is a snapshot and should be treated as immutable.
#alias(builtin_modules)
pub fn builtinModules() -> Array[String] {
  let mod = ffi_require_module()
  mod.get("builtinModules").cast()
}

///|
/// createRequire(filename)
/// Create a require function from a file URL or path
#alias(create_require)
pub fn createRequire(filename : String) -> @js.Any {
  let mod = ffi_require_module()
  mod.call("createRequire", [filename])
}

///|
/// isBuiltin(moduleName)
/// Returns true if the module is a built-in Node.js module
#alias(is_builtin)
pub fn isBuiltin(module_name : String) -> Bool {
  let mod = ffi_require_module()
  @js.identity(mod.call("isBuiltin", [module_name]))
}

///|
/// syncBuiltinESMExports()
/// Updates the CommonJS exports to match the ES module exports
#alias(sync_builtin_esm_exports)
pub fn syncBuiltinESMExports() -> Unit {
  let mod = ffi_require_module()
  mod.call0("syncBuiltinESMExports") |> ignore
}

///|
/// findSourceMap(path)
/// Returns the source map for the given path if it exists
#alias(find_source_map)
pub fn findSourceMap(path : String) -> SourceMap? {
  let mod = ffi_require_module()
  mod.call("findSourceMap", [path]) |> @js.identity_option()
}

///|
/// enableCompileCache(options?)
/// Enable compile cache for faster module loading
#alias(enable_compile_cache)
pub fn enableCompileCache(cache_dir? : String) -> Unit {
  let mod = ffi_require_module()
  match cache_dir {
    Some(dir) =>
      mod.call("enableCompileCache", [
        @js.from_entries_option_cast([("cacheDir", Some(dir))]),
      ])
      |> ignore
    None => mod.call0("enableCompileCache") |> ignore
  }
}

///|
/// flushCompileCache()
/// Flush the compile cache to disk
#alias(flush_compile_cache)
pub fn flushCompileCache() -> Unit {
  let mod = ffi_require_module()
  mod.call0("flushCompileCache") |> ignore
}

///|
/// getCompileCacheDir()
/// Get the compile cache directory path
#alias(get_compile_cache_dir)
pub fn getCompileCacheDir() -> String? {
  let mod = ffi_require_module()
  mod.call0("getCompileCacheDir") |> @js.identity_option()
}

///|
/// stripTypeScriptTypes(code, options?)
/// Remove TypeScript type annotations from code
/// mode: 'strip' (default) or 'transform'
/// source_map: true to generate source map (only with mode='transform')
/// source_url: URL to include in source map
#alias(strip_typescript_types)
pub fn stripTypeScriptTypes(
  code : String,
  mode? : String,
  source_map? : Bool,
  source_url? : String,
) -> String {
  let mod = ffi_require_module()
  match (mode, source_map, source_url) {
    (None, None, None) => @js.identity(mod.call("stripTypeScriptTypes", [code]))
    _ =>
      @js.identity(
        mod.call("stripTypeScriptTypes", [
          code,
          @js.from_entries_option([
            ("mode", mode.map(x => x)),
            ("sourceMap", source_map.map(x => x)),
            ("sourceUrl", source_url.map(x => x)),
          ]),
        ]),
      )
  }
}

///| SourceMap Type

///|
/// Represents a source map for debugging
pub(all) struct SourceMap {
  payload : @js.Any
}

///|
pub impl @js.JsImpl for SourceMap

///|
/// findEntry(lineNumber, columnNumber)
/// Find the original source location for a generated position
#alias(find_entry)
pub fn SourceMap::findEntry(
  self : Self,
  line_number : Int,
  column_number : Int,
) -> SourceMapEntry? {
  self.call2("findEntry", line_number, column_number) |> @js.identity_option()
}

///| SourceMapEntry Type

///|
/// Represents an entry in a source map
pub(all) struct SourceMapEntry {
  originalLine : Int
  originalColumn : Int
  originalSource : String
  generatedLine : Int
  generatedColumn : Int
  name : String?
}

///|
pub impl @js.JsImpl for SourceMapEntry
