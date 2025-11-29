// Minimal terser binding using nostd
// terser.minify(code, options) -> Promise<{code: string}>

///|
/// Create options object: { compress: { passes: n }, mangle: { toplevel: true } }
fn create_options(passes : Int) -> @nostd.Any {
  let global = @nostd.global_this()
  let object = global["Object"]
  let options = object._call("create", [@nostd.null()])

  // compress: { passes: n }
  let compress = object._call("create", [@nostd.null()])
  compress["passes"] = @nostd.any(passes)
  options["compress"] = compress

  // mangle: { toplevel: true }
  let mangle = object._call("create", [@nostd.null()])
  mangle["toplevel"] = @nostd.any(true)
  options["mangle"] = mangle
  options
}

///|
/// Call terser.minify(code, options) and return Promise
fn terser_minify(
  terser : @nostd.Any,
  code : String,
  options : @nostd.Any,
) -> @nostd.Any {
  terser._call("minify", [@nostd.any(code), options])
}

///|
fn main {
  // Get terser module (assumed to be injected via globalThis.terser)
  let global = @nostd.global_this()
  let console = global["console"]
  let terser = global["terser"]
  if @nostd.is_nullish(terser) {
    console._call("log", [
      @nostd.any(
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
  console._call("log", [@nostd.any("[terser_binding] Promise started")])
  |> ignore
}

///|
extern "js" fn create_then_callback() -> @nostd.Any =
  #| () => (result) => console.log("Minified:", result.code)
