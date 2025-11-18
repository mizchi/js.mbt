// https://nodejs.org/api/module.html
// Based on @types/node module definitions

///|
/// Module Functions
extern "js" fn ffi_require_module() -> Js =
  #|() => require("node:module")

///|
/// Get the builtin modules list
#alias(builtin_modules)
pub fn builtinModules() -> Array[String] {
  let mod = ffi_require_module()
  unsafe_cast(mod.get("builtinModules"))
}

///|
/// createRequire(filename)
/// Create a require function from a file URL or path
#alias(create_require)
pub fn createRequire(filename : String) -> Js {
  let mod = ffi_require_module()
  mod.invoke("createRequire", [filename |> js])
}

///|
/// isBuiltin(moduleName)
/// Returns true if the module is a built-in Node.js module
#alias(is_builtin)
pub fn isBuiltin(module_name : String) -> Bool {
  let mod = ffi_require_module()
  unsafe_cast(mod.invoke("isBuiltin", [module_name |> js]))
}

///|
/// syncBuiltinESMExports()
/// Updates the CommonJS exports to match the ES module exports
#alias(sync_builtin_esm_exports)
pub fn syncBuiltinESMExports() -> Unit {
  let mod = ffi_require_module()
  mod.invoke("syncBuiltinESMExports", []) |> ignore
}

///|
/// findSourceMap(path)
/// Returns the source map for the given path if it exists
#alias(find_source_map)
pub fn findSourceMap(path : String) -> SourceMap? {
  let mod = ffi_require_module()
  mod.invoke("findSourceMap", [path |> js]) |> unsafe_option()
}

///|
/// enableCompileCache(options?)
/// Enable compile cache for faster module loading
#alias(enable_compile_cache)
pub fn enableCompileCache(cache_dir? : String) -> Unit {
  let mod = ffi_require_module()
  match cache_dir {
    Some(dir) => {
      let options = @js.Object::new()
      options.set("cacheDir", dir)
      mod.invoke("enableCompileCache", [options]) |> ignore
    }
    None => mod.invoke("enableCompileCache", []) |> ignore
  }
}

///|
/// flushCompileCache()
/// Flush the compile cache to disk
#alias(flush_compile_cache)
pub fn flushCompileCache() -> Unit {
  let mod = ffi_require_module()
  mod.invoke("flushCompileCache", []) |> ignore
}

///|
/// getCompileCacheDir()
/// Get the compile cache directory path
#alias(get_compile_cache_dir)
pub fn getCompileCacheDir() -> String? {
  let mod = ffi_require_module()
  mod.invoke("getCompileCacheDir", []) |> unsafe_option()
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
    (None, None, None) =>
      unsafe_cast(mod.invoke("stripTypeScriptTypes", [code |> js]))
    _ => {
      let options = @js.Object::new()
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
pub impl JsImpl for SourceMap

///|
/// Get the payload (the actual source map data)
pub fn SourceMap::payload(self : Self) -> Js {
  self.get("payload")
}

///|
/// findEntry(lineNumber, columnNumber)
/// Find the original source location for a generated position
#alias(find_entry)
pub fn SourceMap::findEntry(
  self : Self,
  line_number : Int,
  column_number : Int,
) -> SourceMapEntry? {
  self.invoke("findEntry", [line_number |> js, column_number |> js])
  |> unsafe_option()
}

///| SourceMapEntry Type

///|
/// Represents an entry in a source map
#external
pub type SourceMapEntry

///|
pub impl JsImpl for SourceMapEntry

///|
/// Get the original line number
#alias(original_line)
pub fn SourceMapEntry::originalLine(self : Self) -> Int {
  unsafe_cast(self.get("originalLine"))
}

///|
/// Get the original column number
#alias(original_column)
pub fn SourceMapEntry::originalColumn(self : Self) -> Int {
  unsafe_cast(self.get("originalColumn"))
}

///|
/// Get the original source file name
#alias(original_source)
pub fn SourceMapEntry::originalSource(self : Self) -> String {
  unsafe_cast(self.get("originalSource"))
}

///|
/// Get the generated line number
#alias(generated_line)
pub fn SourceMapEntry::generatedLine(self : Self) -> Int {
  unsafe_cast(self.get("generatedLine"))
}

///|
/// Get the generated column number
#alias(generated_column)
pub fn SourceMapEntry::generatedColumn(self : Self) -> Int {
  unsafe_cast(self.get("generatedColumn"))
}

///|
/// Get the name (if available)
pub fn SourceMapEntry::name(self : Self) -> String? {
  self.get("name") |> unsafe_option()
}
