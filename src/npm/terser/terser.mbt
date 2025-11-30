///|
/// Terser - JavaScript minifier/compressor (nostd)
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
fn build_options(options : MinifyOptions) -> @nostd.Any {
  let js_options = @nostd.Object::new()
  js_options["compress"] = @nostd.any(options.compress)
  js_options["mangle"] = @nostd.any(options.mangle)
  if options.sourceMap {
    js_options["sourceMap"] = @nostd.any(true)
  }
  if options.toplevel {
    js_options["toplevel"] = @nostd.any(true)
  }
  if options.keep_fnames {
    let mangle_opts = @nostd.Object::new()
    mangle_opts["keep_fnames"] = @nostd.any(true)
    js_options["mangle"] = mangle_opts
  }
  if options.keep_classnames {
    let mangle_opts = @nostd.Object::new()
    mangle_opts["keep_classnames"] = @nostd.any(true)
    js_options["mangle"] = mangle_opts
  }
  js_options
}

///|
fn parse_result(result : @nostd.Any) -> MinifyResult {
  let code : String = result["code"].cast()
  let map_val = result["map"]
  let map : String? = if @nostd.is_nullish(map_val) {
    None
  } else {
    Some(map_val.cast())
  }
  { code, map }
}

///|
/// Minify JavaScript code (async)
pub async fn minify(
  code : String,
  options? : MinifyOptions = MinifyOptions::default(),
) -> MinifyResult {
  let result = ffi_minify(code, build_options(options)).wait()
  parse_result(result)
}

///|
extern "js" fn ffi_minify(
  code : String,
  options : @nostd.Any,
) -> @nostd.Promise[@nostd.Any] =
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
  let result = ffi_minify_sync(code, build_options(options))
  parse_result(result)
}

///|
extern "js" fn ffi_minify_sync(
  code : String,
  options : @nostd.Any,
) -> @nostd.Any =
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
