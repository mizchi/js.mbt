// Minimal terser binding using nostd
// terser.minify(code, options) -> Promise<{code: string}>

///|
/// Create options object: { compress: { passes: n }, mangle: { toplevel: true } }
fn create_options(passes : Int) -> @core.Any {
  let global = @core.global_this()
  let object = global["Object"]
  let options = object._call("create", [@core.null()])

  // compress: { passes: n }
  let compress = object._call("create", [@core.null()])
  compress["passes"] = @core.any(passes)
  options["compress"] = compress

  // mangle: { toplevel: true }
  let mangle = object._call("create", [@core.null()])
  mangle["toplevel"] = @core.any(true)
  options["mangle"] = mangle
  options
}

///|
/// Call terser.minify(code, options) and return Promise
fn terser_minify(
  terser : @core.Any,
  code : String,
  options : @core.Any,
) -> @core.Any {
  terser._call("minify", [@core.any(code), options])
}

///|
fn main {
  // Get terser module (assumed to be injected via globalThis.terser)
  let global = @core.global_this()
  let console = global["console"]
  let terser = global["terser"]
  if @core.is_nullish(terser) {
    console._call("log", [
      @core.any(
        "Error: terser not found. Run with: node -e \"globalThis.terser = require('terser')\" -r ./terser_binding.js",
      ),
    ])
    |> ignore
    return
  }

  // Sample code to minify
  let code = "function hello(name) { console.log('Hello, ' + name); } hello('World');"

  // Create options
  let options = create_options(3)

  // Call terser.minify - returns Promise
  let promise = terser_minify(terser, code, options)

  // promise.then(result => console.log(result.code))
  // Create callback: result => console.log(result.code)
  let callback = create_then_callback()
  promise._call("then", [callback]) |> ignore
  console._call("log", [@core.any("[terser_binding] Promise started")])
  |> ignore
}

///|
extern "js" fn create_then_callback() -> @core.Any =
  #| () => (result) => console.log("Minified:", result.code)
