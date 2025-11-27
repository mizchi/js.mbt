///|
/// Terser - JavaScript minifier/compressor
/// npm: terser

///|
/// Minify result containing the minified code and optional source map
pub struct MinifyResult {
  code : String
  map : String?
}

///|
/// Minify options
pub(all) struct MinifyOptions {
  /// Enable compression (default: true)
  compress : Bool
  /// Enable name mangling (default: true)
  mangle : Bool
  /// Generate source map
  sourceMap : Bool
  /// Compress/mangle top-level scope variables
  toplevel : Bool
  /// Keep function names
  keep_fnames : Bool
  /// Keep class names
  keep_classnames : Bool
}

///|
/// Create default minify options
pub fn MinifyOptions::default() -> MinifyOptions {
  {
    compress: true,
    mangle: true,
    sourceMap: false,
    toplevel: false,
    keep_fnames: false,
    keep_classnames: false,
  }
}

///|
/// Minify JavaScript code (async)
pub async fn minify(
  code : String,
  options? : MinifyOptions = MinifyOptions::default(),
) -> MinifyResult {
  let js_options = @js.Object::new()
  js_options.set("compress", options.compress)
  js_options.set("mangle", options.mangle)
  if options.sourceMap {
    js_options.set("sourceMap", true)
  }
  if options.toplevel {
    js_options.set("toplevel", true)
  }
  if options.keep_fnames {
    let mangle_opts = @js.Object::new()
    mangle_opts.set("keep_fnames", true)
    js_options.set("mangle", mangle_opts.to_any())
  }
  if options.keep_classnames {
    let mangle_opts = @js.Object::new()
    mangle_opts.set("keep_classnames", true)
    js_options.set("mangle", mangle_opts.to_any())
  }
  let result = ffi_minify(code, js_options.to_any()).wait()
  {
    code: result.get("code") |> @js.identity,
    map: result.get("map") |> @js.identity,
  }
}

///|
extern "js" fn ffi_minify(
  code : String,
  options : @js.Any,
) -> @js.Promise[@js.Any] =
  #|async (code, options) => {
  #|  const { minify } = require('terser');
  #|  return minify(code, options);
  #|}

///|
/// Minify JavaScript code (sync)
pub fn minify_sync(
  code : String,
  options? : MinifyOptions = MinifyOptions::default(),
) -> MinifyResult {
  let js_options = @js.Object::new()
  js_options.set("compress", options.compress)
  js_options.set("mangle", options.mangle)
  if options.sourceMap {
    js_options.set("sourceMap", true)
  }
  if options.toplevel {
    js_options.set("toplevel", true)
  }
  if options.keep_fnames {
    let mangle_opts = @js.Object::new()
    mangle_opts.set("keep_fnames", true)
    js_options.set("mangle", mangle_opts.to_any())
  }
  if options.keep_classnames {
    let mangle_opts = @js.Object::new()
    mangle_opts.set("keep_classnames", true)
    js_options.set("mangle", mangle_opts.to_any())
  }
  let result = ffi_minify_sync(code, js_options.to_any())
  {
    code: result.get("code") |> @js.identity,
    map: result.get("map") |> @js.identity,
  }
}

///|
extern "js" fn ffi_minify_sync(code : String, options : @js.Any) -> @js.Any =
  #|(code, options) => {
  #|  const { minify_sync } = require('terser');
  #|  return minify_sync(code, options);
  #|}

///|
/// Simple minify with default options (async)
pub async fn minify_simple(code : String) -> String {
  let result = minify(code)
  result.code
}

///|
/// Simple minify with default options (sync)
pub fn minify_simple_sync(code : String) -> String {
  let result = minify_sync(code)
  result.code
}
