///| esbuild bindings
/// Bindings for https://esbuild.github.io/

// ============================================================
// FFI Functions
// ============================================================

///|
#module("esbuild")
extern "js" fn ffi_build(opts : @core.Any) -> @js.Promise[BuildResult] = "build"

///|
#module("esbuild")
extern "js" fn ffi_build_sync(opts : @core.Any) -> BuildResult = "buildSync"

///|
#module("esbuild")
extern "js" fn ffi_transform(
  code : String,
  opts : @core.Any,
) -> @js.Promise[TransformResult] = "transform"

///|
#module("esbuild")
extern "js" fn ffi_transform_sync(
  code : String,
  opts : @core.Any,
) -> TransformResult = "transformSync"

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
pub fn BuildResult::as_any(self : BuildResult) -> @core.Any = "%identity"

///|
/// Get output files from build result
pub fn BuildResult::output_files(self : BuildResult) -> Array[OutputFile] {
  let files_arr = self.as_any()._get("outputFiles")
  if @core.is_undefined(files_arr) || @core.is_null(files_arr) {
    return []
  }
  let len : Int = @core.identity(files_arr._get("length"))
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
  if @core.is_undefined(errors_arr) || @core.is_null(errors_arr) {
    return []
  }
  let len : Int = @core.identity(errors_arr._get("length"))
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
  if @core.is_undefined(warnings_arr) || @core.is_null(warnings_arr) {
    return []
  }
  let len : Int = @core.identity(warnings_arr._get("length"))
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
pub fn OutputFile::as_any(self : OutputFile) -> @core.Any = "%identity"

///|
/// Get the file path
pub fn OutputFile::path(self : OutputFile) -> String {
  @core.identity(self.as_any()._get("path"))
}

///|
/// Get the file contents as text
pub fn OutputFile::text(self : OutputFile) -> String {
  @core.identity(self.as_any()._get("text"))
}

///|
/// Get the file contents as Uint8Array
pub fn OutputFile::contents(self : OutputFile) -> @core.Any {
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
pub fn Message::as_any(self : Message) -> @core.Any = "%identity"

///|
/// Get the message text
pub fn Message::text(self : Message) -> String {
  @core.identity(self.as_any()._get("text"))
}

// ============================================================
// TransformResult
// ============================================================

///|
/// Result from transform()
#external
pub(all) type TransformResult

///|
pub fn TransformResult::as_any(self : TransformResult) -> @core.Any = "%identity"

///|
/// Get the transformed code
pub fn TransformResult::code(self : TransformResult) -> String {
  @core.identity(self.as_any()._get("code"))
}

///|
/// Get the source map
pub fn TransformResult::map(self : TransformResult) -> String {
  let m = self.as_any()._get("map")
  if @core.is_undefined(m) || @core.is_null(m) {
    ""
  } else {
    @core.identity(m)
  }
}

///|
/// Get warnings from transform result
pub fn TransformResult::warnings(self : TransformResult) -> Array[Message] {
  let warnings_arr = self.as_any()._get("warnings")
  if @core.is_undefined(warnings_arr) || @core.is_null(warnings_arr) {
    return []
  }
  let len : Int = @core.identity(warnings_arr._get("length"))
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
fn make_build_opts(
  entry_points : Array[String],
  outdir : String,
  outfile : String,
  bundle : Bool,
  minify : Bool,
  format : Format,
  target : String,
  platform : Platform,
  sourcemap : Bool,
  write : Bool,
  external : Array[String],
  definitions : Array[(String, String)],
) -> @core.Any {
  let opts = @core.new_object()
  if entry_points.length() > 0 {
    opts._set("entryPoints", entry_points |> @core.any)
  }
  if outdir != "" {
    opts._set("outdir", outdir |> @core.any)
  }
  if outfile != "" {
    opts._set("outfile", outfile |> @core.any)
  }
  opts._set("bundle", bundle |> @core.any)
  opts._set("minify", minify |> @core.any)
  opts._set("format", format.to_string() |> @core.any)
  if target != "" {
    opts._set("target", target |> @core.any)
  }
  opts._set("platform", platform.to_string() |> @core.any)
  opts._set("sourcemap", sourcemap |> @core.any)
  opts._set("write", write |> @core.any)
  if external.length() > 0 {
    opts._set("external", external |> @core.any)
  }
  if definitions.length() > 0 {
    let defs = @core.new_object()
    for pair in definitions {
      let (key, value) = pair
      defs._set(key, value |> @core.any)
    }
    opts._set("define", defs)
  }
  opts
}

///|
/// Build with options (async)
pub async fn build(
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
  let opts = make_build_opts(
    entry_points, outdir, outfile, bundle, minify, format, target, platform, sourcemap,
    write, external, definitions,
  )
  ffi_build(opts).wait()
}

///|
fn make_transform_opts(
  loader : Loader,
  minify : Bool,
  format : Format,
  target : String,
  sourcemap : Bool,
) -> @core.Any {
  let opts = @core.new_object()
  opts._set("loader", loader.to_string() |> @core.any)
  opts._set("minify", minify |> @core.any)
  opts._set("format", format.to_string() |> @core.any)
  if target != "" {
    opts._set("target", target |> @core.any)
  }
  opts._set("sourcemap", sourcemap |> @core.any)
  opts
}

///|
/// Transform code (async)
pub async fn transform(
  code : String,
  loader? : Loader = Js,
  minify? : Bool = false,
  format? : Format = Esm,
  target? : String = "",
  sourcemap? : Bool = false,
) -> TransformResult {
  let opts = make_transform_opts(loader, minify, format, target, sourcemap)
  ffi_transform(code, opts).wait()
}

///|
/// Build synchronously
pub fn build_sync(
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
  let opts = make_build_opts(
    entry_points, outdir, outfile, bundle, minify, format, target, platform, sourcemap,
    write, external, definitions,
  )
  ffi_build_sync(opts)
}

///|
/// Transform code synchronously
pub fn transform_sync(
  code : String,
  loader? : Loader = Js,
  minify? : Bool = false,
  format? : Format = Esm,
  target? : String = "",
  sourcemap? : Bool = false,
) -> TransformResult {
  let opts = make_transform_opts(loader, minify, format, target, sourcemap)
  ffi_transform_sync(code, opts)
}
