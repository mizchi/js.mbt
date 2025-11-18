// https://nodejs.org/api/wasi.html
// WebAssembly System Interface (WASI) API

///|
/// WASI Module
#external
pub type WasiModule

///|
pub impl JsImpl for WasiModule

///|
/// Get wasi module
fn wasi_module() -> WasiModule {
  @node.require("node:wasi") |> unsafe_cast
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
fn WasiOptions::to_js(self : WasiOptions) -> Js {
  let options = @js.Object::new()

  // Set version (required)
  options.set("version", self.version)

  // Set optional args
  match self.args {
    Some(args) => options.set("args", args |> js)
    None => ()
  }

  // Set optional env
  match self.env {
    Some(env) => {
      let env_obj = @js.Object::new()
      env.each(fn(key, value) { env_obj.set(key, value) })
      options.set("env", env_obj)
    }
    None => ()
  }

  // Set optional preopens
  match self.preopens {
    Some(preopens) => {
      let preopens_obj = @js.Object::new()
      preopens.each(fn(key, value) { preopens_obj.set(key, value) })
      options.set("preopens", preopens_obj)
    }
    None => ()
  }

  // Set optional return_on_exit
  match self.returnOnExit {
    Some(value) => options.set("returnOnExit", value)
    None => ()
  }

  // Set optional stdin
  match self.stdin {
    Some(value) => options.set("stdin", value)
    None => ()
  }

  // Set optional stdout
  match self.stdout {
    Some(value) => options.set("stdout", value)
    None => ()
  }

  // Set optional stderr
  match self.stderr {
    Some(value) => options.set("stderr", value)
    None => ()
  }
  options.to_js()
}

///|
extern "js" fn ffi_new_wasi(wasi_class : Js, options : Js) -> Js =
  #| (WasiClass, options) => new WasiClass(options)

///|
#external
pub type WASI

///|
pub impl JsImpl for WASI

///|
/// Create a new WASI instance
pub fn WASI::new(options : WasiOptions) -> WASI {
  let wasi_module = wasi_module()
  let wasi_class = wasi_module.get("WASI")
  let instance = ffi_new_wasi(wasi_class, options.to_js())
  instance |> unsafe_cast
}

///|
/// Get import object for WebAssembly.instantiate()
pub fn WASI::getImportObject(self : Self) -> Js {
  self.invoke("getImportObject", [])
}

///|
/// Start a WASI command by invoking _start() export
pub fn WASI::start(self : Self, instance : WebAssemblyInstance) -> Unit {
  self.invoke("start", [instance.to_js()]) |> ignore
}

///|
/// Initialize a WASI reactor by invoking _initialize() export
pub fn WASI::initialize(self : WASI, instance : WebAssemblyInstance) -> Unit {
  self.invoke("initialize", [instance.to_js()]) |> ignore
}

///|
/// Get the wasiImport property
pub fn WASI::wasiImport(self : Self) -> Js {
  self.get("wasiImport")
}
