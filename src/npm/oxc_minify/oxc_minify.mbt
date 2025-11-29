///| npm oxc-minify package FFI bindings (nostd)
/// https://www.npmjs.com/package/oxc-minify
/// https://oxc.rs/docs/guide/usage/minifier.html

///|
/// Get the oxc-minify module instance
extern "js" fn oxc_minify() -> @nostd.Any =
  #| () => require("oxc-minify")

///|
/// Minify result
pub(all) struct MinifyResult {
  /// Minified code
  code : String
  /// Errors if any
  errors : Array[String]
}

///|
/// Minify JavaScript code synchronously
/// https://oxc.rs/docs/guide/usage/minifier.html
pub fn minify_sync(filename : String, source : String) -> MinifyResult {
  let oxc = oxc_minify()
  let result = oxc._call("minifySync", [
    @nostd.any(filename),
    @nostd.any(source),
  ])
  let code : String = result["code"].cast()
  let errors_js = result["errors"]
  let errors : Array[String] = if @nostd.is_nullish(errors_js) {
    []
  } else {
    errors_js.cast()
  }
  { code, errors }
}

///|
/// Minify JavaScript code synchronously with default filename
pub fn minify(source : String) -> String {
  minify_sync("input.js", source).code
}

///|
/// Async minify JavaScript code
pub async fn minify_async(filename : String, source : String) -> MinifyResult {
  let oxc = oxc_minify()
  let promise : @nostd.Promise[@nostd.Any] = oxc._call("minify", [
      @nostd.any(filename),
      @nostd.any(source),
    ])
    |> @nostd.identity
  let result = promise.wait()
  let code : String = result["code"].cast()
  let errors_js = result["errors"]
  let errors : Array[String] = if @nostd.is_nullish(errors_js) {
    []
  } else {
    errors_js.cast()
  }
  { code, errors }
}
