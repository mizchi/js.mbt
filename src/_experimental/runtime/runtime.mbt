///|
/// Runtime utilities for MoonBit JS runtime
/// Provides helpers for finding project structure from compiled JS output

///|
/// MoonBit module info from moon.mod.json
/// Schema: https://github.com/moonbitlang/moon/blob/main/crates/moonbuild/template/mod.schema.json
pub struct MoonMod {
  // -- File location --
  /// Path to moon.mod.json
  path : String
  /// Directory containing moon.mod.json
  root_dir : String
  // -- Required fields --
  /// Module name (required)
  name : String?
  // -- Optional fields --
  /// Module version (SemVer 2.0.0)
  version : String?
  /// Source directory path (defaults to "src")
  source : String
  /// Description of this module
  description : String?
  /// License of this module (SPDX identifier)
  license : String?
  /// Path to module's README file
  readme : String?
  /// URL to module's repository
  repository : String?
  /// Keywords for the module
  keywords : Array[String]
  /// Preferred compilation target (e.g., "js", "wasm")
  preferred_target : String?
  /// Warn list setting of the module
  warn_list : String?
  /// Raw parsed content (for accessing deps, scripts, etc.)
  raw : @nostd.Any
}

///|
/// MoonBit package info from moon.pkg.json
/// Schema: https://github.com/moonbitlang/moon/blob/main/crates/moonbuild/template/pkg.schema.json
pub struct MoonPkg {
  // -- File location --
  /// Path to moon.pkg.json
  path : String
  /// Directory containing moon.pkg.json
  pkg_dir : String
  // -- Derived fields --
  /// Package name (derived from directory path relative to source dir)
  pkg_name : String
  // -- Schema fields --
  /// Whether this is a main package
  is_main : Bool
  /// Whether to import all definitions from the package being tested
  test_import_all : Bool
  /// Supported compilation targets
  supported_targets : Array[String]
  /// Binary name for executable
  bin_name : String?
  /// Binary target specification
  bin_target : String?
  /// Implementation reference for virtual packages
  implement : String?
  /// Warn list setting of the package
  warn_list : String?
  /// Native stub files
  native_stub : Array[String]
  /// Dependency overrides
  overrides : Array[String]
  /// Raw parsed content (for accessing imports, targets, link, pre-build, etc.)
  raw : @nostd.Any
}

///|
/// Read a text file (returns empty string if failed)
fn read_text_file(path : String) -> String {
  ffi_read_text_file(path)
}

///|
extern "js" fn ffi_read_text_file(path : String) -> String =
  #|(path) => {
  #|  try {
  #|    const fs = require('fs');
  #|    return fs.readFileSync(path, 'utf8');
  #|  } catch {
  #|    return '';
  #|  }
  #|}

///|
/// Find moon.mod.json starting from given path, searching upward
/// Returns None if not found
pub fn find_moon_mod(start_path : String) -> MoonMod? {
  let abs_path = @path.resolve([start_path])
  find_moon_mod_from(abs_path)
}

///|
fn find_moon_mod_from(dir : String) -> MoonMod? {
  let moon_mod_path = @path.join([dir, "moon.mod.json"])
  if @fs.exists_sync(moon_mod_path) {
    let content = read_text_file(moon_mod_path)
    if content.length() == 0 {
      return None
    }
    let parsed = ffi_json_parse(content)
    let source_raw : String? = parsed._get("source").cast()
    let source = source_raw.unwrap_or("src")
    let keywords_raw : Array[String]? = parsed._get("keywords").cast()
    let keywords = keywords_raw.unwrap_or([])
    return Some({
      path: moon_mod_path,
      root_dir: dir,
      name: parsed._get("name") |> @nostd.identity,
      version: parsed._get("version") |> @nostd.identity,
      source,
      description: parsed._get("description") |> @nostd.identity,
      license: parsed._get("license") |> @nostd.identity,
      readme: parsed._get("readme") |> @nostd.identity,
      repository: parsed._get("repository") |> @nostd.identity,
      keywords,
      preferred_target: parsed._get("preferred-target") |> @nostd.identity,
      warn_list: parsed._get("warn-list") |> @nostd.identity,
      raw: parsed,
    })
  }
  let parent = @path.dirname(dir)
  // Reached root
  if parent == dir {
    return None
  }
  find_moon_mod_from(parent)
}

///|
extern "js" fn ffi_json_parse(s : String) -> @nostd.Any =
  #|(s) => JSON.parse(s)

///|
/// Find moon.pkg.json starting from given path, searching upward
/// Returns None if not found
pub fn find_moon_pkg(start_path : String) -> MoonPkg? {
  let abs_path = @path.resolve([start_path])
  find_moon_pkg_from(abs_path)
}

///|
fn find_moon_pkg_from(dir : String) -> MoonPkg? {
  let moon_pkg_path = @path.join([dir, "moon.pkg.json"])
  if @fs.exists_sync(moon_pkg_path) {
    let content = read_text_file(moon_pkg_path)
    if content.length() == 0 {
      return None
    }
    let parsed = ffi_json_parse(content)
    // Derive package name from directory structure
    let pkg_name = derive_pkg_name(dir)
    let is_main_raw : Bool? = parsed._get("is-main").cast()
    let is_main = is_main_raw.unwrap_or(false)
    let test_import_all_raw : Bool? = parsed._get("test-import-all").cast()
    let test_import_all = test_import_all_raw.unwrap_or(false)
    let supported_targets = get_string_array(parsed, "supported-targets")
    let native_stub = get_string_array(parsed, "native-stub")
    let overrides = get_string_array(parsed, "overrides")
    return Some({
      path: moon_pkg_path,
      pkg_dir: dir,
      pkg_name,
      is_main,
      test_import_all,
      supported_targets,
      bin_name: parsed._get("bin-name") |> @nostd.identity,
      bin_target: parsed._get("bin-target") |> @nostd.identity,
      implement: parsed._get("implement") |> @nostd.identity,
      warn_list: parsed._get("warn-list") |> @nostd.identity,
      native_stub,
      overrides,
      raw: parsed,
    })
  }
  let parent = @path.dirname(dir)
  // Reached root
  if parent == dir {
    return None
  }
  find_moon_pkg_from(parent)
}

///|
/// Safely extract string array from JSON, returns empty array if not present
fn get_string_array(obj : @nostd.Any, key : String) -> Array[String] {
  let value = obj._get(key)
  if @js.is_nullish(value) || not(@js.is_array(value)) {
    return []
  }
  value |> @nostd.identity
}

///|
/// Derive package name from directory path
/// Finds moon.mod.json first to get module name and source dir
fn derive_pkg_name(pkg_dir : String) -> String {
  let moon_mod = find_moon_mod(pkg_dir)
  match moon_mod {
    Some(m) => {
      let source_dir = @path.join([m.root_dir, m.source])
      if pkg_dir.has_prefix(source_dir) {
        // Extract relative path from source directory
        let start_idx = source_dir.length()
        let relative = safe_substring(pkg_dir, start_idx)
        // Remove leading slash
        let pkg_path = if relative.has_prefix("/") {
          safe_substring(relative, 1)
        } else {
          relative
        }
        // Combine module name with package path
        match m.name {
          Some(mod_name) =>
            if pkg_path.length() > 0 {
              mod_name + "/" + pkg_path
            } else {
              mod_name
            }
          None => pkg_path
        }
      } else {
        // Package is not under source directory (unusual)
        @path.basename(pkg_dir)
      }
    }
    None => @path.basename(pkg_dir)
  }
}

///|
/// Safe substring extraction (returns empty string on error)
fn safe_substring(s : String, start : Int) -> String {
  ffi_safe_substring(s, start)
}

///|
extern "js" fn ffi_safe_substring(s : String, start : Int) -> String =
  #|(s, start) => {
  #|  try {
  #|    return s.slice(start);
  #|  } catch {
  #|    return '';
  #|  }
  #|}

///|
/// Result of source directory resolution
pub struct SourceDirInfo {
  /// The computed source directory path
  source_dir : String
  /// The target directory (e.g., target/js/release/build)
  target_dir : String
  /// The relative package path within source (e.g., "npm/hono")
  pkg_path : String
  /// Build mode (debug or release)
  build_mode : String
  /// Build type (build or test)
  build_type : String
}

///|
/// Get source directory from a path inside target/js/*
///
/// Given a path like:
///   /project/target/js/release/build/npm/hono/hono.js
///
/// Returns:
///   source_dir: /project/src/npm/hono (considering moon.mod.json source field)
///   target_dir: /project/target/js/release/build/npm/hono
///   pkg_path: npm/hono
///   build_mode: release
///   build_type: build
pub fn get_source_dir(runtime_path : String) -> SourceDirInfo? {
  let abs_path = @path.resolve([runtime_path])
  // Find moon module first to get project root
  let moon_mod = find_moon_mod(abs_path)
  let moon = match moon_mod {
    Some(m) => m
    None => return None
  }
  // Check if path is inside target/js/
  let target_js_dir = @path.join([moon.root_dir, "target", "js"])
  if not(abs_path.has_prefix(target_js_dir)) {
    return None
  }
  // Extract relative path from target/js/
  let start_idx = target_js_dir.length() + 1
  let relative_to_target = safe_substring(abs_path, start_idx)
  if relative_to_target.length() == 0 {
    return None
  }
  // Parse: {mode}/build/{package_path}/...
  // or: {mode}/test/{package_path}/...
  let parts = relative_to_target.split("/").collect()
  if parts.length() < 3 {
    return None
  }
  let build_mode = parts[0].to_string()
  let build_type = parts[1].to_string() // "build" or "test"
  // Find package path by looking for .js file or just using directory
  let package_parts : Array[String] = []
  for i = 2; i < parts.length(); i = i + 1 {
    let part = parts[i].to_string()
    // Skip if it's a file
    if part.has_suffix(".js") || part.has_suffix(".mjs") {
      break
    }
    package_parts.push(part)
  }
  let pkg_path = package_parts.join("/")
  // Use source field from moon.mod.json
  let source_dir = @path.join([moon.root_dir, moon.source, pkg_path])
  let target_dir = @path.join([target_js_dir, build_mode, build_type, pkg_path])
  Some({ source_dir, target_dir, pkg_path, build_mode, build_type })
}

///|
/// Module type (ESM or CommonJS)
pub enum ModuleType {
  ESM
  CommonJS
  Unknown
}

///|
pub impl Show for ModuleType with output(self, logger) {
  match self {
    ESM => logger.write_string("ESM")
    CommonJS => logger.write_string("CommonJS")
    Unknown => logger.write_string("Unknown")
  }
}

///|
/// Get the current module type
pub fn get_module_type() -> ModuleType {
  let type_str = ffi_get_module_type()
  match type_str {
    "esm" => ESM
    "cjs" => CommonJS
    _ => Unknown
  }
}

///|
extern "js" fn ffi_get_module_type() -> String =
  #|() => {
  #|  // Check for CommonJS first (safer check)
  #|  if (typeof module !== 'undefined' && typeof __filename !== 'undefined') {
  #|    return 'cjs';
  #|  }
  #|  // ESM detection via indirect check
  #|  try {
  #|    // This will be true in ESM environment
  #|    if (typeof globalThis !== 'undefined' && !globalThis.module) {
  #|      return 'esm';
  #|    }
  #|  } catch {}
  #|  return 'unknown';
  #|}

///|
/// Get the current file path
/// ESM: uses import.meta.filename (Node.js 20.11+) or falls back to import.meta.url
/// CommonJS: uses __filename
pub fn get_current_file() -> String {
  ffi_get_current_file()
}

///|
extern "js" fn ffi_get_current_file() -> String =
  #|() => {
  #|  // CommonJS: use __filename directly
  #|  if (typeof __filename !== 'undefined') {
  #|    return __filename;
  #|  }
  #|  return '';
  #|}

///|
/// Get the current file's source directory
/// Uses import.meta.filename or __filename to determine current path
pub fn get_current_source_dir() -> SourceDirInfo? {
  let current_path = get_current_file()
  if current_path.is_empty() {
    return None
  }
  get_source_dir(current_path)
}

///|
/// Check if the current file is running from a target build directory
/// Returns true if running from target/js/*
pub fn is_target_build() -> Bool {
  let current_path = get_current_file()
  if current_path.is_empty() {
    return false
  }
  is_target_build_path(current_path)
}

///|
/// Check if a given path is inside a target build directory
pub fn is_target_build_path(file_path : String) -> Bool {
  let abs_path = @path.resolve([file_path])
  let moon_mod = find_moon_mod(abs_path)
  match moon_mod {
    Some(m) => {
      let target_js_dir = @path.join([m.root_dir, "target", "js"])
      abs_path.has_prefix(target_js_dir)
    }
    None => false
  }
}

///|
/// Find source map file for a compiled JS file
/// Looks for .js.map or inline sourceMappingURL
pub fn find_source_map(js_file_path : String) -> String? {
  // First try .js.map file
  let map_path = js_file_path + ".map"
  if @fs.exists_sync(map_path) {
    return Some(map_path)
  }
  // Try reading the file to find sourceMappingURL
  if @fs.exists_sync(js_file_path) {
    let content = read_text_file(js_file_path)
    let url = extract_source_map_url(content)
    if url.length() > 0 {
      // If it's a relative path, resolve it
      if not(url.has_prefix("data:")) {
        let dir = @path.dirname(js_file_path)
        return Some(@path.join([dir, url]))
      }
      return Some(url)
    }
  }
  None
}

///|
fn extract_source_map_url(content : String) -> String {
  ffi_extract_source_map_url(content)
}

///|
extern "js" fn ffi_extract_source_map_url(content : String) -> String =
  #|(content) => {
  #|  const match = content.match(/\/\/[#@]\s*sourceMappingURL=(.+?)(?:\s|$)/);
  #|  return match ? match[1].trim() : '';
  #|}

///|
/// Load and parse source map for a JS file
pub fn load_source_map(js_file_path : String) -> @nostd.Any? {
  let map_path = find_source_map(js_file_path)
  let path = match map_path {
    Some(p) => p
    None => return None
  }
  // Handle data URL
  if path.has_prefix("data:") {
    let parsed = ffi_parse_data_url_source_map(path)
    return Some(parsed)
  }
  // Load from file
  if @fs.exists_sync(path) {
    let content = read_text_file(path)
    if content.length() > 0 {
      return Some(ffi_json_parse(content))
    }
  }
  None
}

///|
extern "js" fn ffi_parse_data_url_source_map(data_url : String) -> @nostd.Any =
  #|(dataUrl) => {
  #|  const base64 = dataUrl.split(',')[1];
  #|  const json = Buffer.from(base64, 'base64').toString('utf-8');
  #|  return JSON.parse(json);
  #|}

///|
/// Resolve full package name from a path inside target/js/*
/// Combines module name from moon.mod.json with package path
pub fn resolve_pkg_name(runtime_path : String) -> String? {
  let source_info = get_source_dir(runtime_path)
  match source_info {
    Some(info) => {
      let moon_mod = find_moon_mod(runtime_path)
      match moon_mod {
        Some(m) =>
          match m.name {
            Some(mod_name) =>
              if info.pkg_path.length() > 0 {
                Some(mod_name + "/" + info.pkg_path)
              } else {
                Some(mod_name)
              }
            None => Some(info.pkg_path)
          }
        None => Some(info.pkg_path)
      }
    }
    None => None
  }
}
