// https://nodejs.org/api/wasi.html
// WebAssembly System Interface (WASI) API

///|
extern "js" fn wasi_module_ffi() -> @js.Any =
  #| () => require("node:wasi")

///|
/// WASI Module
#external
pub type WasiModule

///|
pub impl @js.JsImpl for WasiModule

///|
/// Get wasi module
fn wasi_module() -> WasiModule {
  wasi_module_ffi().cast()
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
  let options = @js.from_option_map({
    "version": Some(@js.any(version)),
    "args": args.map(fn(x) { @js.from_array(x) }),
    "env": env_obj.map(fn(x) { x.as_any() }),
    "preopens": preopens_obj.map(fn(x) { x.as_any() }),
    "returnOnExit": returnOnExit.map(fn(x) { @js.any(x) }),
    "stdin": stdin.map(fn(x) { @js.any(x) }),
    "stdout": stdout.map(fn(x) { @js.any(x) }),
    "stderr": stderr.map(fn(x) { @js.any(x) }),
  })
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
  self.call1("start", instance.as_any()) |> ignore
}

///|
/// Initialize a WASI reactor by invoking _initialize() export
pub fn WASI::initialize(
  self : WASI,
  instance : @webassembly.WebAssemblyInstance,
) -> Unit {
  self.call1("initialize", instance.as_any()) |> ignore
}

///|
/// Get the wasiImport property
pub fn WASI::wasiImport(self : Self) -> @js.Any {
  self.get("wasiImport")
}
