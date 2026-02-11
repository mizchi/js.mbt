// https://nodejs.org/api/module.html
// Based on @types/node module definitions

///|
/// Module Functions (kept for property access and functions with optional args)
extern "js" fn ffi_require_module() -> @core.Any =
  #|() => require("node:module")

///|
#module("node:module")
extern "js" fn internal_create_require(filename : String) -> @core.Any = "createRequire"

///|
#module("node:module")
extern "js" fn internal_is_builtin(module_name : String) -> Bool = "isBuiltin"

///|
#module("node:module")
extern "js" fn internal_sync_builtin_esm_exports() -> Unit = "syncBuiltinESMExports"

///|
#module("node:module")
extern "js" fn internal_find_source_map(path : String) -> @core.Any = "findSourceMap"

///|
#module("node:module")
extern "js" fn internal_flush_compile_cache() -> Unit = "flushCompileCache"

///|
#module("node:module")
extern "js" fn internal_get_compile_cache_dir() -> @core.Any = "getCompileCacheDir"

///|
/// Get the builtin modules list
///
/// Note: The returned array is a snapshot and should be treated as immutable.
#alias(builtin_modules)
pub fn builtinModules() -> Array[String] {
  let mod : @core.Any = ffi_require_module() |> @core.any
  mod["builtinModules"] |> @core.identity
}

///|
/// createRequire(filename)
/// Create a require function from a file URL or path
#alias(create_require)
pub fn createRequire(filename : String) -> @core.Any {
  internal_create_require(filename)
}

///|
/// isBuiltin(moduleName)
/// Returns true if the module is a built-in Node.js module
#alias(is_builtin)
pub fn isBuiltin(module_name : String) -> Bool {
  internal_is_builtin(module_name)
}

///|
/// syncBuiltinESMExports()
/// Updates the CommonJS exports to match the ES module exports
#alias(sync_builtin_esm_exports)
pub fn syncBuiltinESMExports() -> Unit {
  internal_sync_builtin_esm_exports()
}

///|
/// findSourceMap(path)
/// Returns the source map for the given path if it exists
#alias(find_source_map)
pub fn findSourceMap(path : String) -> SourceMap? {
  let result = internal_find_source_map(path)
  if @core.is_nullish(result) {
    None
  } else {
    Some({ payload: result |> @core.identity })
  }
}

///|
/// enableCompileCache(options?)
/// Enable compile cache for faster module loading
#alias(enable_compile_cache)
pub fn enableCompileCache(cache_dir? : String) -> Unit {
  let mod : @core.Any = ffi_require_module() |> @core.any
  match cache_dir {
    Some(dir) => {
      let opts = @core.from_entries([("cacheDir", @core.any(dir))])
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
  internal_flush_compile_cache()
}

///|
/// getCompileCacheDir()
/// Get the compile cache directory path
#alias(get_compile_cache_dir)
pub fn getCompileCacheDir() -> String? {
  let result = internal_get_compile_cache_dir()
  if @core.is_nullish(result) {
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
extern "js" fn internal_strip_typescript_types(
  mod : @core.Any,
  code : String,
) -> String =
  #| (mod, code) => {
  #|   const originalEmitWarning = process.emitWarning
  #|   process.emitWarning = function (warning, type, codeArg, ctor) {
  #|     if (type === "ExperimentalWarning" || codeArg === "ExperimentalWarning") {
  #|       return
  #|     }
  #|     return originalEmitWarning.call(this, warning, type, codeArg, ctor)
  #|   }
  #|   try {
  #|     return mod.stripTypeScriptTypes(code)
  #|   } finally {
  #|     process.emitWarning = originalEmitWarning
  #|   }
  #| }

///|
extern "js" fn internal_strip_typescript_types_opts(
  mod : @core.Any,
  code : String,
  opts : @core.Any,
) -> String =
  #| (mod, code, opts) => {
  #|   const originalEmitWarning = process.emitWarning
  #|   process.emitWarning = function (warning, type, codeArg, ctor) {
  #|     if (type === "ExperimentalWarning" || codeArg === "ExperimentalWarning") {
  #|       return
  #|     }
  #|     return originalEmitWarning.call(this, warning, type, codeArg, ctor)
  #|   }
  #|   try {
  #|     return mod.stripTypeScriptTypes(code, opts)
  #|   } finally {
  #|     process.emitWarning = originalEmitWarning
  #|   }
  #| }

///|
#alias(strip_typescript_types)
pub fn stripTypeScriptTypes(
  code : String,
  mode? : String,
  source_map? : Bool,
  source_url? : String,
) -> String {
  let mod : @core.Any = ffi_require_module() |> @core.any
  match (mode, source_map, source_url) {
    (None, None, None) => internal_strip_typescript_types(mod, code)
    _ => {
      let opts = @core.new_object()
      if mode is Some(m) {
        opts["mode"] = @core.any(m)
      }
      if source_map is Some(sm) {
        opts["sourceMap"] = @core.any(sm)
      }
      if source_url is Some(su) {
        opts["sourceUrl"] = @core.any(su)
      }
      internal_strip_typescript_types_opts(mod, code, opts)
    }
  }
}

///| SourceMap Type

///|
/// Represents a source map for debugging
pub(all) struct SourceMap {
  payload : @core.Any
}

///|
pub fn SourceMap::as_any(self : SourceMap) -> @core.Any {
  self.to_any()
}

///|
pub fn SourceMap::to_any(self : SourceMap) -> @core.Any {
  self.payload |> @core.any
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
  let result = s._call("findEntry", [
    @core.any(line_number),
    @core.any(column_number),
  ])
  if @core.is_nullish(result) {
    None
  } else {
    Some({
      originalLine: result["originalLine"].cast(),
      originalColumn: result["originalColumn"].cast(),
      originalSource: result["originalSource"].cast(),
      generatedLine: result["generatedLine"].cast(),
      generatedColumn: result["generatedColumn"].cast(),
      name: @core.identity_option(result["name"]),
    })
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
pub fn SourceMapEntry::as_any(self : SourceMapEntry) -> @core.Any = "%identity"

///|
pub fn SourceMapEntry::to_any(self : SourceMapEntry) -> @core.Any = "%identity"
