///| esbuild bindings
/// Bindings for https://esbuild.github.io/

// ============================================================
// Module Handle
// ============================================================

///|
/// Esbuild module handle
#external
pub type Esbuild

///|
pub impl @js.JsImpl for Esbuild

///|
/// Get the esbuild module
pub fn esbuild() -> Esbuild {
  @node.require("esbuild").cast()
}

// ============================================================
// Format enum
// ============================================================

///|
/// Output format for bundled code
pub(all) enum Format {
  Iife
  Cjs
  Esm
}

///|
pub fn Format::to_string(self : Format) -> String {
  match self {
    Iife => "iife"
    Cjs => "cjs"
    Esm => "esm"
  }
}

// ============================================================
// Platform enum
// ============================================================

///|
/// Target platform
pub(all) enum Platform {
  Browser
  Node
  Neutral
}

///|
pub fn Platform::to_string(self : Platform) -> String {
  match self {
    Browser => "browser"
    Node => "node"
    Neutral => "neutral"
  }
}

// ============================================================
// Loader enum
// ============================================================

///|
/// Loader type for different file types
pub(all) enum Loader {
  Js
  Jsx
  Ts
  Tsx
  Css
  Json
  Text
  Base64
  Binary
  Dataurl
  File
  Copy
}

///|
pub fn Loader::to_string(self : Loader) -> String {
  match self {
    Js => "js"
    Jsx => "jsx"
    Ts => "ts"
    Tsx => "tsx"
    Css => "css"
    Json => "json"
    Text => "text"
    Base64 => "base64"
    Binary => "binary"
    Dataurl => "dataurl"
    File => "file"
    Copy => "copy"
  }
}

// ============================================================
// BuildResult
// ============================================================

///|
/// Result from build()
#external
pub(all) type BuildResult

///|
pub impl @js.JsImpl for BuildResult

///|
/// Get output files from build result
pub fn BuildResult::output_files(self : BuildResult) -> Array[OutputFile] {
  let files_arr = self.get("outputFiles")
  if @js.is_undefined(files_arr) || @js.is_null(files_arr) {
    return []
  }
  let len : Int = @js.identity(files_arr.get("length"))
  let result : Array[OutputFile] = []
  for i = 0; i < len; i = i + 1 {
    result.push(files_arr.get(i.to_string()).cast())
  }
  result
}

///|
/// Get errors from build result
pub fn BuildResult::errors(self : BuildResult) -> Array[Message] {
  let errors_arr = self.get("errors")
  if @js.is_undefined(errors_arr) || @js.is_null(errors_arr) {
    return []
  }
  let len : Int = @js.identity(errors_arr.get("length"))
  let result : Array[Message] = []
  for i = 0; i < len; i = i + 1 {
    result.push(errors_arr.get(i.to_string()).cast())
  }
  result
}

///|
/// Get warnings from build result
pub fn BuildResult::warnings(self : BuildResult) -> Array[Message] {
  let warnings_arr = self.get("warnings")
  if @js.is_undefined(warnings_arr) || @js.is_null(warnings_arr) {
    return []
  }
  let len : Int = @js.identity(warnings_arr.get("length"))
  let result : Array[Message] = []
  for i = 0; i < len; i = i + 1 {
    result.push(warnings_arr.get(i.to_string()).cast())
  }
  result
}

// ============================================================
// OutputFile
// ============================================================

///|
/// Output file from build
#external
pub(all) type OutputFile

///|
pub impl @js.JsImpl for OutputFile

///|
/// Get the file path
pub fn OutputFile::path(self : OutputFile) -> String {
  @js.identity(self.get("path"))
}

///|
/// Get the file contents as text
pub fn OutputFile::text(self : OutputFile) -> String {
  @js.identity(self.get("text"))
}

///|
/// Get the file contents as Uint8Array
pub fn OutputFile::contents(self : OutputFile) -> @js.Any {
  self.get("contents")
}

// ============================================================
// Message (Error/Warning)
// ============================================================

///|
/// Error or warning message
#external
pub(all) type Message

///|
pub impl @js.JsImpl for Message

///|
/// Get the message text
pub fn Message::text(self : Message) -> String {
  @js.identity(self.get("text"))
}

// ============================================================
// TransformResult
// ============================================================

///|
/// Result from transform()
#external
pub(all) type TransformResult

///|
pub impl @js.JsImpl for TransformResult

///|
/// Get the transformed code
pub fn TransformResult::code(self : TransformResult) -> String {
  @js.identity(self.get("code"))
}

///|
/// Get the source map
pub fn TransformResult::map(self : TransformResult) -> String {
  let m = self.get("map")
  if @js.is_undefined(m) || @js.is_null(m) {
    ""
  } else {
    @js.identity(m)
  }
}

///|
/// Get warnings from transform result
pub fn TransformResult::warnings(self : TransformResult) -> Array[Message] {
  let warnings_arr = self.get("warnings")
  if @js.is_undefined(warnings_arr) || @js.is_null(warnings_arr) {
    return []
  }
  let len : Int = @js.identity(warnings_arr.get("length"))
  let result : Array[Message] = []
  for i = 0; i < len; i = i + 1 {
    result.push(warnings_arr.get(i.to_string()).cast())
  }
  result
}

// ============================================================
// Build API
// ============================================================

///|
/// Build with options (async)
pub async fn Esbuild::build(
  self : Esbuild,
  entry_points? : Array[String] = [],
  outdir? : String = "",
  outfile? : String = "",
  bundle? : Bool = false,
  minify? : Bool = false,
  format? : Format = Esm,
  target? : String = "",
  platform? : Platform = Browser,
  sourcemap? : Bool = false,
  write? : Bool = true,
  external? : Array[String] = [],
  definitions? : Array[(String, String)] = [],
) -> BuildResult {
  let opts = @js.Object::new()
  if entry_points.length() > 0 {
    opts.set("entryPoints", entry_points |> @js.from_array)
  }
  if outdir != "" {
    opts.set("outdir", outdir)
  }
  if outfile != "" {
    opts.set("outfile", outfile)
  }
  opts.set("bundle", bundle)
  opts.set("minify", minify)
  opts.set("format", format.to_string())
  if target != "" {
    opts.set("target", target)
  }
  opts.set("platform", platform.to_string())
  opts.set("sourcemap", sourcemap)
  opts.set("write", write)
  if external.length() > 0 {
    opts.set("external", external |> @js.from_array)
  }
  if definitions.length() > 0 {
    let defs = @js.Object::new()
    for pair in definitions {
      let (key, value) = pair
      defs.set(key, value)
    }
    opts.set("define", defs.to_any())
  }
  let promise : @js.Promise[BuildResult] = self.call1("build", opts).cast()
  promise.wait()
}

///|
/// Transform code (async)
pub async fn Esbuild::transform(
  self : Esbuild,
  code : String,
  loader? : Loader = Js,
  minify? : Bool = false,
  format? : Format = Esm,
  target? : String = "",
  sourcemap? : Bool = false,
) -> TransformResult {
  let opts = @js.Object::new()
  opts.set("loader", loader.to_string())
  opts.set("minify", minify)
  opts.set("format", format.to_string())
  if target != "" {
    opts.set("target", target)
  }
  opts.set("sourcemap", sourcemap)
  let promise : @js.Promise[TransformResult] = self
    .call2("transform", code, opts)
    .cast()
  promise.wait()
}

///|
/// Build synchronously
pub fn Esbuild::build_sync(
  self : Esbuild,
  entry_points? : Array[String] = [],
  outdir? : String = "",
  outfile? : String = "",
  bundle? : Bool = false,
  minify? : Bool = false,
  format? : Format = Esm,
  target? : String = "",
  platform? : Platform = Browser,
  sourcemap? : Bool = false,
  write? : Bool = true,
  external? : Array[String] = [],
  definitions? : Array[(String, String)] = [],
) -> BuildResult {
  let opts = @js.Object::new()
  if entry_points.length() > 0 {
    opts.set("entryPoints", entry_points |> @js.from_array)
  }
  if outdir != "" {
    opts.set("outdir", outdir)
  }
  if outfile != "" {
    opts.set("outfile", outfile)
  }
  opts.set("bundle", bundle)
  opts.set("minify", minify)
  opts.set("format", format.to_string())
  if target != "" {
    opts.set("target", target)
  }
  opts.set("platform", platform.to_string())
  opts.set("sourcemap", sourcemap)
  opts.set("write", write)
  if external.length() > 0 {
    opts.set("external", external |> @js.from_array)
  }
  if definitions.length() > 0 {
    let defs = @js.Object::new()
    for pair in definitions {
      let (key, value) = pair
      defs.set(key, value)
    }
    opts.set("define", defs.to_any())
  }
  self.call1("buildSync", opts).cast()
}

///|
/// Transform code synchronously
pub fn Esbuild::transform_sync(
  self : Esbuild,
  code : String,
  loader? : Loader = Js,
  minify? : Bool = false,
  format? : Format = Esm,
  target? : String = "",
  sourcemap? : Bool = false,
) -> TransformResult {
  let opts = @js.Object::new()
  opts.set("loader", loader.to_string())
  opts.set("minify", minify)
  opts.set("format", format.to_string())
  if target != "" {
    opts.set("target", target)
  }
  opts.set("sourcemap", sourcemap)
  self.call2("transformSync", code, opts).cast()
}
