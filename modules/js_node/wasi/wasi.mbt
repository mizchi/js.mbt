// https://nodejs.org/api/wasi.html
// WebAssembly System Interface (WASI) API

///|
extern "js" fn wasi_module_ffi() -> @core.Any =
  #| () => {
  #|   const originalEmitWarning = process.emitWarning
  #|   process.emitWarning = function (warning, type, code, ctor) {
  #|     if (type === "ExperimentalWarning" || code === "ExperimentalWarning") {
  #|       return
  #|     }
  #|     return originalEmitWarning.call(this, warning, type, code, ctor)
  #|   }
  #|   try {
  #|     return require("node:wasi")
  #|   } finally {
  #|     process.emitWarning = originalEmitWarning
  #|   }
  #| }

///|
/// WASI Module
#external
pub type WasiModule

///|
pub fn WasiModule::as_any(self : WasiModule) -> @core.Any = "%identity"

///|
/// Get wasi module
fn wasi_module() -> WasiModule {
  wasi_module_ffi().cast()
}

///|
extern "js" fn ffi_new_wasi(
  wasi_class : @core.Any,
  options : @core.Any,
) -> @core.Any =
  #| (WasiClass, options) => new WasiClass(options)

///|
#external
pub type WASI

///|
pub fn WASI::as_any(self : WASI) -> @core.Any = "%identity"

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
      let obj = @core.new_object()
      env.each(fn(key, value) { obj._set(key, value |> @core.any) })
      Some(obj)
    }
    None => None
  }
  let preopens_obj = match preopens {
    Some(preopens) => {
      let obj = @core.new_object()
      preopens.each(fn(key, value) { obj._set(key, value |> @core.any) })
      Some(obj)
    }
    None => None
  }
  let entries : Array[(String, @core.Any)] = []
  entries.push(("version", @core.any(version)))
  if args is Some(v) {
    entries.push(("args", @core.any(v)))
  }
  if env_obj is Some(v) {
    entries.push(("env", @core.any(v)))
  }
  if preopens_obj is Some(v) {
    entries.push(("preopens", @core.any(v)))
  }
  if returnOnExit is Some(v) {
    entries.push(("returnOnExit", @core.any(v)))
  }
  if stdin is Some(v) {
    entries.push(("stdin", @core.any(v)))
  }
  if stdout is Some(v) {
    entries.push(("stdout", @core.any(v)))
  }
  if stderr is Some(v) {
    entries.push(("stderr", @core.any(v)))
  }
  let options = @core.from_entries(entries)
  let wasi_module = wasi_module()
  let wasi_class = wasi_module.as_any()._get("WASI")
  let instance = ffi_new_wasi(wasi_class, options)
  instance.cast()
}

///|
/// Get import object for WebAssembly.instantiate()
pub fn WASI::getImportObject(self : Self) -> @core.Any {
  self.as_any()._call("getImportObject", [])
}

///|
/// Start a WASI command by invoking _start() export
pub fn WASI::start(
  self : Self,
  instance : @webassembly.WebAssemblyInstance,
) -> Unit {
  self.as_any()._call("start", [@core.any(instance)]) |> ignore
}

///|
/// Initialize a WASI reactor by invoking _initialize() export
pub fn WASI::initialize(
  self : WASI,
  instance : @webassembly.WebAssemblyInstance,
) -> Unit {
  self.as_any()._call("initialize", [@core.any(instance)]) |> ignore
}

///|
/// Get the wasiImport property
pub fn WASI::wasiImport(self : Self) -> @core.Any {
  self.as_any()._get("wasiImport")
}
