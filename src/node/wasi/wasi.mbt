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
  @node.require("node:wasi").cast()
}

///|
extern "js" fn ffi_new_wasi(wasi_class : @js.Any, options : @js.Any) -> @js.Any =
  #| (WasiClass, options) => new WasiClass(options)

///|
#external
pub type WASI

///|
pub impl @js.JsImpl for WASI

///|
/// Create a new WASI instance
///
/// @param version WASI version - either "unstable" or "preview1" (required)
/// @param args Command-line arguments visible to the WebAssembly application
/// @param env Environment variables accessible to the WebAssembly application
/// @param preopens Maps virtual directories to real host paths
/// @param returnOnExit When true, start() returns the exit code instead of terminating the process
/// @param stdin File descriptor for standard input
/// @param stdout File descriptor for standard output
/// @param stderr File descriptor for standard error
pub fn WASI::new(
  version : String,
  args? : Array[String],
  env? : Map[String, String],
  preopens? : Map[String, String],
  returnOnExit? : Bool,
  stdin? : Int,
  stdout? : Int,
  stderr? : Int,
) -> WASI {
  let env_obj = match env {
    Some(env) => {
      let obj = @js.Object::new()
      env.each(fn(key, value) { obj.set(key, value) })
      Some(obj)
    }
    None => None
  }
  let preopens_obj = match preopens {
    Some(preopens) => {
      let obj = @js.Object::new()
      preopens.each(fn(key, value) { obj.set(key, value) })
      Some(obj)
    }
    None => None
  }
  let options = @js.from_entries_option([
    ("version", Some(version)),
    ("args", args.map(x => x |> @js.from_array)),
    ("env", env_obj.map(x => x)),
    ("preopens", preopens_obj.map(x => x)),
    ("returnOnExit", returnOnExit.map(x => x)),
    ("stdin", stdin.map(x => x)),
    ("stdout", stdout.map(x => x)),
    ("stderr", stderr.map(x => x)),
  ])
  let wasi_module = wasi_module()
  let wasi_class = wasi_module.get("WASI")
  let instance = ffi_new_wasi(wasi_class, options)
  instance.cast()
}

///|
/// Get import object for WebAssembly.instantiate()
pub fn WASI::getImportObject(self : Self) -> @js.Any {
  self.call0("getImportObject")
}

///|
/// Start a WASI command by invoking _start() export
pub fn WASI::start(
  self : Self,
  instance : @webassembly.WebAssemblyInstance,
) -> Unit {
  self.call1("start", instance.to_any()) |> ignore
}

///|
/// Initialize a WASI reactor by invoking _initialize() export
pub fn WASI::initialize(
  self : WASI,
  instance : @webassembly.WebAssemblyInstance,
) -> Unit {
  self.call1("initialize", instance.to_any()) |> ignore
}

///|
/// Get the wasiImport property
pub fn WASI::wasiImport(self : Self) -> @js.Any {
  self.get("wasiImport")
}
