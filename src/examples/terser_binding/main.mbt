// Minimal terser binding using nostd
// terser.minify(code, options) -> Promise<{code: string}>

///|
/// Create options object: { compress: { passes: n }, mangle: { toplevel: true } }
fn create_options(passes : Int) -> @nostd.JsValue {
  let global = @nostd.global_this()
  let object = global["Object"]
  let args = @nostd.array_new()
  @nostd.array_push(args, @nostd.null())
  let options = object._call("create", args)

  // compress: { passes: n }
  let compress_args = @nostd.array_new()
  @nostd.array_push(compress_args, @nostd.null())
  let compress = object._call("create", compress_args)
  compress["passes"] = @nostd.JsValue::from(passes)
  options["compress"] = compress

  // mangle: { toplevel: true }
  let mangle_args = @nostd.array_new()
  @nostd.array_push(mangle_args, @nostd.null())
  let mangle = object._call("create", mangle_args)
  mangle["toplevel"] = @nostd.JsValue::from(true)
  options["mangle"] = mangle
  options
}

///|
/// Call terser.minify(code, options) and return Promise
fn terser_minify(
  terser : @nostd.JsValue,
  code : String,
  options : @nostd.JsValue,
) -> @nostd.JsValue {
  let args = @nostd.array_new()
  @nostd.array_push(args, @nostd.JsValue::from(code))
  @nostd.array_push(args, options)
  terser._call("minify", args)
}

///|
fn main {
  @nostd.console_log("[terser_binding] Demo")

  // Get terser module (assumed to be injected via globalThis.terser)
  let global = @nostd.global_this()
  let terser = global["terser"]
  if @nostd.is_nullish(terser) {
    @nostd.console_log(
      "Error: terser not found. Run with: node -e \"globalThis.terser = require('terser')\" -r ./terser_binding.js",
    )
    return
  }

  // Sample code to minify
  let code = "function hello(name) { console.log('Hello, ' + name); } hello('World');"

  // Create options
  let options = create_options(3)

  // Call terser.minify - returns Promise
  let promise = terser_minify(terser, code, options)

  // promise.then(result => console.log(result.code))
  let args = @nostd.array_new()

  // Create callback: result => console.log(result.code)
  let callback = create_then_callback()
  @nostd.array_push(args, callback)
  let _ = promise._call("then", args)
  @nostd.console_log("[terser_binding] Promise started")
}

///|
extern "js" fn create_then_callback() -> @nostd.JsValue =
  #| () => (result) => console.log("Minified:", result.code)
