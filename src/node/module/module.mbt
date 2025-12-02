// https://nodejs.org/api/module.html
// Based on @types/node module definitions

///|
/// Module Functions
extern "js" fn ffi_require_module() -> @nostd.Any =
  #|() => require("node:module")

///|
/// Get the builtin modules list
///
/// Note: The returned array is a snapshot and should be treated as immutable.
#alias(builtin_modules)
pub fn builtinModules() -> Array[String] {
  let mod : @nostd.Any = ffi_require_module() |> @nostd.any
  mod["builtinModules"] |> @nostd.identity
}

///|
/// createRequire(filename)
/// Create a require function from a file URL or path
#alias(create_require)
pub fn createRequire(filename : String) -> @nostd.Any {
  let mod : @nostd.Any = ffi_require_module() |> @nostd.any
  mod._call("createRequire", [@nostd.any(filename)]) |> @nostd.identity
}

///|
/// isBuiltin(moduleName)
/// Returns true if the module is a built-in Node.js module
#alias(is_builtin)
pub fn isBuiltin(module_name : String) -> Bool {
  let mod : @nostd.Any = ffi_require_module() |> @nostd.any
  mod._call("isBuiltin", [@nostd.any(module_name)]).cast()
}

///|
/// syncBuiltinESMExports()
/// Updates the CommonJS exports to match the ES module exports
#alias(sync_builtin_esm_exports)
pub fn syncBuiltinESMExports() -> Unit {
  let mod : @nostd.Any = ffi_require_module() |> @nostd.any
  mod._call("syncBuiltinESMExports", []) |> ignore
}

///|
/// findSourceMap(path)
/// Returns the source map for the given path if it exists
#alias(find_source_map)
pub fn findSourceMap(path : String) -> SourceMap? {
  let mod : @nostd.Any = ffi_require_module() |> @nostd.any
  let result = mod._call("findSourceMap", [@nostd.any(path)])
  if @nostd.is_nullish(result) {
    None
  } else {
    Some({ payload: result |> @nostd.identity })
  }
}

///|
/// enableCompileCache(options?)
/// Enable compile cache for faster module loading
#alias(enable_compile_cache)
pub fn enableCompileCache(cache_dir? : String) -> Unit {
  let mod : @nostd.Any = ffi_require_module() |> @nostd.any
  match cache_dir {
    Some(dir) => {
      let opts = @nostd.from_entries([("cacheDir", @nostd.any(dir))])
      mod._call("enableCompileCache", [opts]) |> ignore
    }
    None => mod._call("enableCompileCache", []) |> ignore
  }
}

///|
/// flushCompileCache()
/// Flush the compile cache to disk
#alias(flush_compile_cache)
pub fn flushCompileCache() -> Unit {
  let mod : @nostd.Any = ffi_require_module() |> @nostd.any
  mod._call("flushCompileCache", []) |> ignore
}

///|
/// getCompileCacheDir()
/// Get the compile cache directory path
#alias(get_compile_cache_dir)
pub fn getCompileCacheDir() -> String? {
  let mod : @nostd.Any = ffi_require_module() |> @nostd.any
  let result = mod._call("getCompileCacheDir", [])
  if @nostd.is_nullish(result) {
    None
  } else {
    Some(result.cast())
  }
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
  let mod : @nostd.Any = ffi_require_module() |> @nostd.any
  match (mode, source_map, source_url) {
    (None, None, None) =>
      mod._call("stripTypeScriptTypes", [@nostd.any(code)]).cast()
    _ => {
      let opts = @nostd.Object::new()
      if mode is Some(m) {
        opts["mode"] = @nostd.any(m)
      }
      if source_map is Some(sm) {
        opts["sourceMap"] = @nostd.any(sm)
      }
      if source_url is Some(su) {
        opts["sourceUrl"] = @nostd.any(su)
      }
      mod._call("stripTypeScriptTypes", [@nostd.any(code), opts]).cast()
    }
  }
}

///| SourceMap Type

///|
/// Represents a source map for debugging
pub(all) struct SourceMap {
  payload : @nostd.Any
}

///|
pub fn SourceMap::as_any(self : SourceMap) -> @nostd.Any {
  self.to_any()
}

///|
pub fn SourceMap::to_any(self : SourceMap) -> @nostd.Any {
  self.payload |> @nostd.any
}

///|
/// findEntry(lineNumber, columnNumber)
/// Find the original source location for a generated position
#alias(find_entry)
pub fn SourceMap::findEntry(
  self : SourceMap,
  line_number : Int,
  column_number : Int,
) -> SourceMapEntry? {
  let s = self.to_any()
  let result = s._call(
    "findEntry",
    [@nostd.any(line_number), @nostd.any(column_number)],
  )
  if @nostd.is_nullish(result) {
    None
  } else {
    Some(
      {
        originalLine: result["originalLine"].cast(),
        originalColumn: result["originalColumn"].cast(),
        originalSource: result["originalSource"].cast(),
        generatedLine: result["generatedLine"].cast(),
        generatedColumn: result["generatedColumn"].cast(),
        name: @nostd.identity_option(result["name"]),
      },
    )
  }
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
pub fn SourceMapEntry::as_any(self : SourceMapEntry) -> @nostd.Any = "%identity"

///|
pub fn SourceMapEntry::to_any(self : SourceMapEntry) -> @nostd.Any = "%identity"
