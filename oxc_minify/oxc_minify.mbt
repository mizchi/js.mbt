///| npm oxc-minify package FFI bindings (nostd)
/// https://www.npmjs.com/package/oxc-minify
/// https://oxc.rs/docs/guide/usage/minifier.html

///|
/// FFI for minifySync
#module("oxc-minify")
extern "js" fn ffi_minify_sync(filename : String, source : String) -> @core.Any = "minifySync"

///|
/// FFI for minify (async)
#module("oxc-minify")
extern "js" fn ffi_minify_async(
  filename : String,
  source : String,
) -> @core.Promise[@core.Any] = "minify"

///|
/// Minify result
pub(all) struct MinifyResult {
  /// Minified code
  code : String
  /// Errors if any
  errors : Array[String]
}

///|
/// Parse minify result from JS object
fn parse_minify_result(result : @core.Any) -> MinifyResult {
  let code : String = result["code"].cast()
  let errors_js = result["errors"]
  let errors : Array[String] = if @core.is_nullish(errors_js) {
    []
  } else {
    errors_js.cast()
  }
  { code, errors }
}

///|
/// Minify JavaScript code synchronously
/// https://oxc.rs/docs/guide/usage/minifier.html
pub fn minify_sync(filename : String, source : String) -> MinifyResult {
  parse_minify_result(ffi_minify_sync(filename, source))
}

///|
/// Minify JavaScript code synchronously with default filename
pub fn minify(source : String) -> String {
  minify_sync("input.js", source).code
}

///|
/// Async minify JavaScript code
pub async fn minify_async(filename : String, source : String) -> MinifyResult {
  let result = ffi_minify_async(filename, source).wait()
  parse_minify_result(result)
}
