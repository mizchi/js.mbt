// https://nodejs.org/api/wasi.html
// WebAssembly System Interface (WASI) API

///|
using @js {type Val, trait Js, js}

///|
using @webassembly {type WebAssemblyInstance}

///| WASI Module

///|
/// Get wasi module
fn wasi_module() -> Val {
  @node.require("node:wasi")
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
  return_on_exit : Bool?
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
fn WasiOptions::to_js(self : WasiOptions) -> Val {
  let options = @js.new_empty_object()

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
      let env_obj = @js.new_empty_object()
      env.each(fn(key, value) { env_obj.set(key, value) })
      options.set("env", env_obj)
    }
    None => ()
  }

  // Set optional preopens
  match self.preopens {
    Some(preopens) => {
      let preopens_obj = @js.new_empty_object()
      preopens.each(fn(key, value) { preopens_obj.set(key, value) })
      options.set("preopens", preopens_obj)
    }
    None => ()
  }

  // Set optional return_on_exit
  match self.return_on_exit {
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
  options
}

///| WASI Class

///|
/// WASI class wrapper
pub struct WASI {
  instance : Val
}

///|
extern "js" fn ffi_new_wasi(wasi_class : Val, options : Val) -> Val =
  #| (WasiClass, options) => new WasiClass(options)

///|
/// Create a new WASI instance
pub fn WASI::new(options : WasiOptions) -> WASI {
  let wasi_module = wasi_module()
  let wasi_class = wasi_module.get("WASI")
  let instance = ffi_new_wasi(wasi_class, options.to_js())
  { instance, }
}

///|
/// Get import object for WebAssembly.instantiate()
pub fn WASI::get_import_object(self : WASI) -> Val {
  self.instance.invoke("getImportObject", [])
}

///|
/// Start a WASI command by invoking _start() export
pub fn WASI::start(self : WASI, instance : WebAssemblyInstance) -> Unit {
  self.instance.invoke("start", [instance.to_js()]) |> ignore
}

///|
/// Initialize a WASI reactor by invoking _initialize() export
pub fn WASI::initialize(self : WASI, instance : WebAssemblyInstance) -> Unit {
  self.instance.invoke("initialize", [instance.to_js()]) |> ignore
}

///|
/// Get the wasiImport property
pub fn WASI::wasi_import(self : WASI) -> Val {
  self.instance.get("wasiImport")
}
