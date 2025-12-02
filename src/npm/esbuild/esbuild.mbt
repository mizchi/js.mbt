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
pub fn Esbuild::as_any(self : Esbuild) -> @nostd.Any = "%identity"

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
pub fn BuildResult::as_any(self : BuildResult) -> @nostd.Any = "%identity"

///|
/// Get output files from build result
pub fn BuildResult::output_files(self : BuildResult) -> Array[OutputFile] {
  let files_arr = self.as_any()._get("outputFiles")
  if @nostd.is_undefined(files_arr) || @nostd.is_null(files_arr) {
    return []
  }
  let len : Int = @nostd.identity(files_arr._get("length"))
  let result : Array[OutputFile] = []
  for i = 0; i < len; i = i + 1 {
    result.push(files_arr._get(i.to_string()).cast())
  }
  result
}

///|
/// Get errors from build result
pub fn BuildResult::errors(self : BuildResult) -> Array[Message] {
  let errors_arr = self.as_any()._get("errors")
  if @nostd.is_undefined(errors_arr) || @nostd.is_null(errors_arr) {
    return []
  }
  let len : Int = @nostd.identity(errors_arr._get("length"))
  let result : Array[Message] = []
  for i = 0; i < len; i = i + 1 {
    result.push(errors_arr._get(i.to_string()).cast())
  }
  result
}

///|
/// Get warnings from build result
pub fn BuildResult::warnings(self : BuildResult) -> Array[Message] {
  let warnings_arr = self.as_any()._get("warnings")
  if @nostd.is_undefined(warnings_arr) || @nostd.is_null(warnings_arr) {
    return []
  }
  let len : Int = @nostd.identity(warnings_arr._get("length"))
  let result : Array[Message] = []
  for i = 0; i < len; i = i + 1 {
    result.push(warnings_arr._get(i.to_string()).cast())
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
pub fn OutputFile::as_any(self : OutputFile) -> @nostd.Any = "%identity"

///|
/// Get the file path
pub fn OutputFile::path(self : OutputFile) -> String {
  @nostd.identity(self.as_any()._get("path"))
}

///|
/// Get the file contents as text
pub fn OutputFile::text(self : OutputFile) -> String {
  @nostd.identity(self.as_any()._get("text"))
}

///|
/// Get the file contents as Uint8Array
pub fn OutputFile::contents(self : OutputFile) -> @nostd.Any {
  self.as_any()._get("contents")
}

// ============================================================
// Message (Error/Warning)
// ============================================================

///|
/// Error or warning message
#external
pub(all) type Message

///|
pub fn Message::as_any(self : Message) -> @nostd.Any = "%identity"

///|
/// Get the message text
pub fn Message::text(self : Message) -> String {
  @nostd.identity(self.as_any()._get("text"))
}

// ============================================================
// TransformResult
// ============================================================

///|
/// Result from transform()
#external
pub(all) type TransformResult

///|
pub fn TransformResult::as_any(self : TransformResult) -> @nostd.Any = "%identity"

///|
/// Get the transformed code
pub fn TransformResult::code(self : TransformResult) -> String {
  @nostd.identity(self.as_any()._get("code"))
}

///|
/// Get the source map
pub fn TransformResult::map(self : TransformResult) -> String {
  let m = self.as_any()._get("map")
  if @nostd.is_undefined(m) || @nostd.is_null(m) {
    ""
  } else {
    @nostd.identity(m)
  }
}

///|
/// Get warnings from transform result
pub fn TransformResult::warnings(self : TransformResult) -> Array[Message] {
  let warnings_arr = self.as_any()._get("warnings")
  if @nostd.is_undefined(warnings_arr) || @nostd.is_null(warnings_arr) {
    return []
  }
  let len : Int = @nostd.identity(warnings_arr._get("length"))
  let result : Array[Message] = []
  for i = 0; i < len; i = i + 1 {
    result.push(warnings_arr._get(i.to_string()).cast())
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
  let opts = @nostd.Object::new()
  if entry_points.length() > 0 {
    opts._set("entryPoints", entry_points |> @nostd.any)
  }
  if outdir != "" {
    opts._set("outdir", outdir |> @nostd.any)
  }
  if outfile != "" {
    opts._set("outfile", outfile |> @nostd.any)
  }
  opts._set("bundle", bundle |> @nostd.any)
  opts._set("minify", minify |> @nostd.any)
  opts._set("format", format.to_string() |> @nostd.any)
  if target != "" {
    opts._set("target", target |> @nostd.any)
  }
  opts._set("platform", platform.to_string() |> @nostd.any)
  opts._set("sourcemap", sourcemap |> @nostd.any)
  opts._set("write", write |> @nostd.any)
  if external.length() > 0 {
    opts._set("external", external |> @nostd.any)
  }
  if definitions.length() > 0 {
    let defs = @nostd.Object::new()
    for pair in definitions {
      let (key, value) = pair
      defs._set(key, value |> @nostd.any)
    }
    opts._set("define", defs)
  }
  let promise : @js.Promise[BuildResult] = self
    .as_any()
    ._call("build", [opts])
    .cast()
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
  let opts = @nostd.Object::new()
  opts._set("loader", loader.to_string() |> @nostd.any)
  opts._set("minify", minify |> @nostd.any)
  opts._set("format", format.to_string() |> @nostd.any)
  if target != "" {
    opts._set("target", target |> @nostd.any)
  }
  opts._set("sourcemap", sourcemap |> @nostd.any)
  let promise : @js.Promise[TransformResult] = self
    .as_any()
    ._call("transform", [code |> @nostd.any, opts])
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
  let opts = @nostd.Object::new()
  if entry_points.length() > 0 {
    opts._set("entryPoints", entry_points |> @nostd.any)
  }
  if outdir != "" {
    opts._set("outdir", outdir |> @nostd.any)
  }
  if outfile != "" {
    opts._set("outfile", outfile |> @nostd.any)
  }
  opts._set("bundle", bundle |> @nostd.any)
  opts._set("minify", minify |> @nostd.any)
  opts._set("format", format.to_string() |> @nostd.any)
  if target != "" {
    opts._set("target", target |> @nostd.any)
  }
  opts._set("platform", platform.to_string() |> @nostd.any)
  opts._set("sourcemap", sourcemap |> @nostd.any)
  opts._set("write", write |> @nostd.any)
  if external.length() > 0 {
    opts._set("external", external |> @nostd.any)
  }
  if definitions.length() > 0 {
    let defs = @nostd.Object::new()
    for pair in definitions {
      let (key, value) = pair
      defs._set(key, value |> @nostd.any)
    }
    opts._set("define", defs)
  }
  self.as_any()._call("buildSync", [opts]).cast()
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
  let opts = @nostd.Object::new()
  opts._set("loader", loader.to_string() |> @nostd.any)
  opts._set("minify", minify |> @nostd.any)
  opts._set("format", format.to_string() |> @nostd.any)
  if target != "" {
    opts._set("target", target |> @nostd.any)
  }
  opts._set("sourcemap", sourcemap |> @nostd.any)
  self.as_any()._call("transformSync", [code |> @nostd.identity, opts]).cast()
}
