// https://nodejs.org/api/wasi.html
// WebAssembly System Interface (WASI) API

///|
/// WASI Module
#external
pub type WasiModule

///|
pub impl @js.JsImpl for WasiModule

///|
/// Get wasi module
fn wasi_module() -> WasiModule {
  @node.require("node:wasi") |> @js.identity
}

///| WASI Options

///|
/// WASI options for constructor
pub(all) struct WasiOptions {
  /// Command-line arguments visible to the WebAssembly application
  args : Array[String]?
  /// Environment variables accessible to the WebAssembly application
  env : Map[String, String]?
  /// Maps virtual directories to real host paths
  preopens : Map[String, String]?
  /// When true, start() returns the exit code instead of terminating the process
  returnOnExit : Bool?
  /// File descriptor for standard input
  stdin : Int?
  /// File descriptor for standard output
  stdout : Int?
  /// File descriptor for standard error
  stderr : Int?
  /// WASI version - either "unstable" or "preview1" (required)
  version : String
}

///|
/// Convert WasiOptions to JS object
fn WasiOptions::to_js(self : WasiOptions) -> @js.Js {
  let env_obj = match self.env {
    Some(env) => {
      let obj = @js.Object::new()
      env.each(fn(key, value) { obj.set(key, value) })
      Some(obj)
    }
    None => None
  }
  let preopens_obj = match self.preopens {
    Some(preopens) => {
      let obj = @js.Object::new()
      preopens.each(fn(key, value) { obj.set(key, value) })
      Some(obj)
    }
    None => None
  }
  @js.from_entries_option([
    ("version", Some(self.version)),
    ("args", self.args.map(x => x |> @js.from_array)),
    ("env", env_obj.map(x => x)),
    ("preopens", preopens_obj.map(x => x)),
    ("returnOnExit", self.returnOnExit.map(x => x)),
    ("stdin", self.stdin.map(x => x)),
    ("stdout", self.stdout.map(x => x)),
    ("stderr", self.stderr.map(x => x)),
  ])
}

///|
extern "js" fn ffi_new_wasi(wasi_class : @js.Js, options : @js.Js) -> @js.Js =
  #| (WasiClass, options) => new WasiClass(options)

///|
#external
pub type WASI

///|
pub impl @js.JsImpl for WASI

///|
/// Create a new WASI instance
pub fn WASI::new(options : WasiOptions) -> WASI {
  let wasi_module = wasi_module()
  let wasi_class = wasi_module.get("WASI")
  let instance = ffi_new_wasi(wasi_class, options.to_js())
  instance |> @js.identity
}

///|
/// Get import object for WebAssembly.instantiate()
pub fn WASI::getImportObject(self : Self) -> @js.Js {
  self.call0("getImportObject")
}

///|
/// Start a WASI command by invoking _start() export
pub fn WASI::start(
  self : Self,
  instance : @webassembly.WebAssemblyInstance,
) -> Unit {
  self.call1("start", instance.to_js()) |> ignore
}

///|
/// Initialize a WASI reactor by invoking _initialize() export
pub fn WASI::initialize(
  self : WASI,
  instance : @webassembly.WebAssemblyInstance,
) -> Unit {
  self.call1("initialize", instance.to_js()) |> ignore
}

///|
/// Get the wasiImport property
pub fn WASI::wasiImport(self : Self) -> @js.Js {
  self.get("wasiImport")
}
