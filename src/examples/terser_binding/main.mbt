// Minimal terser binding using nostd
// terser.minify(code, options) -> Promise<{code: string}>

///|
/// Create options object: { compress: { passes: n }, mangle: { toplevel: true } }
fn create_options(passes : Int) -> @nostd.JsValue {
  let global = @nostd.global_this()
  let object = global["Object"]
  let args = @nostd.JsArray::new()
  args._push(@nostd.null())
  let options = object._call("create", args)

  // compress: { passes: n }
  let compress_args = @nostd.JsArray::new()
  compress_args._push(@nostd.null())
  let compress = object._call("create", compress_args)
  compress["passes"] = @nostd.JsValue::from(passes)
  options["compress"] = compress

  // mangle: { toplevel: true }
  let mangle_args = @nostd.JsArray::new()
  mangle_args._push(@nostd.null())
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
  let args = @nostd.JsArray::new()
  args._push(@nostd.JsValue::from(code))
  args._push(options)
  terser._call("minify", args)
}

///|
fn main {
  // Get terser module (assumed to be injected via globalThis.terser)
  let global = @nostd.global_this()
  let console = global["console"]
  let terser = global["terser"]
  if @nostd.is_nullish(terser) {
    let args = @nostd.JsArray::new()
    args._push(
      @nostd.JsValue::from(
        "Error: terser not found. Run with: node -e \"globalThis.terser = require('terser')\" -r ./terser_binding.js",
      ),
    )
    let _ = console._call("log", args)
    return
  }

  // Sample code to minify
  let code = "function hello(name) { console.log('Hello, ' + name); } hello('World');"

  // Create options
  let options = create_options(3)

  // Call terser.minify - returns Promise
  let promise = terser_minify(terser, code, options)

  // promise.then(result => console.log(result.code))
  let args = @nostd.JsArray::new()

  // Create callback: result => console.log(result.code)
  let callback = create_then_callback()
  args._push(callback)
  let _ = promise._call("then", args)
  let log_args = @nostd.JsArray::new()
  log_args._push(@nostd.JsValue::from("[terser_binding] Promise started"))
  let _ = console._call("log", log_args)

}

///|
extern "js" fn create_then_callback() -> @nostd.JsValue =
  #| () => (result) => console.log("Minified:", result.code)
