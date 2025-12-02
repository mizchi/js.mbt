// https://nodejs.org/api/wasi.html
// WebAssembly System Interface (WASI) API

///|
extern "js" fn wasi_module_ffi() -> @core.Any =
  #| () => require("node:wasi")

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
  let options = @mbtconv.from_option_map({
    "version": Some(@core.any(version)),
    "args": args.map(fn(x) { @core.any(x) }),
    "env": env_obj.map(x => @core.any(x)),
    "preopens": preopens_obj.map(x => @core.any(x)),
    "returnOnExit": returnOnExit.map(x => @core.any(x)),
    "stdin": stdin.map(x => @core.any(x)),
    "stdout": stdout.map(x => @core.any(x)),
    "stderr": stderr.map(x => @core.any(x)),
  }).cast()
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
