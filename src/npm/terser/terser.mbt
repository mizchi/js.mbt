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
fn build_options(options : MinifyOptions) -> @core.Any {
  let js_options = @core.new_object()
  js_options["compress"] = @core.any(options.compress)
  js_options["mangle"] = @core.any(options.mangle)
  if options.sourceMap {
    js_options["sourceMap"] = @core.any(true)
  }
  if options.toplevel {
    js_options["toplevel"] = @core.any(true)
  }
  if options.keep_fnames {
    let mangle_opts = @core.new_object()
    mangle_opts["keep_fnames"] = @core.any(true)
    js_options["mangle"] = mangle_opts
  }
  if options.keep_classnames {
    let mangle_opts = @core.new_object()
    mangle_opts["keep_classnames"] = @core.any(true)
    js_options["mangle"] = mangle_opts
  }
  js_options
}

///|
fn parse_result(result : @core.Any) -> MinifyResult {
  let code : String = result["code"].cast()
  let map_val = result["map"]
  let map : String? = if @core.is_nullish(map_val) {
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
#module("terser")
extern "js" fn ffi_minify(
  code : String,
  options : @core.Any,
) -> @core.Promise[@core.Any] = "minify"

///|
// extern "js" fn ffi_minify(
//   code : String,
//   options : @core.Any,
// ) -> @core.Promise[@core.Any] =
//   #|async (code, options) => {
//   #|  const { minify } = require('terser');
//   #|  return minify(code, options);
//   #|}

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
extern "js" fn ffi_minify_sync(code : String, options : @core.Any) -> @core.Any =
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
