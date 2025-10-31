using @val {type Val}
using @promise {suspend}

///|
extern "js" fn ffi_require(module_name : String) -> Val =
  #| (moduleName) => require(moduleName)

///|
extern "js" fn ffi_import(module_name : String, ok: (Val) -> Unit, err: (Error) -> Unit) -> Val =
  #| (moduleName, ok, err) => import(moduleName).then(ok).catch(err)

///|
pub async fn[T] import_module(module_name : String) -> T {
  suspend((resolve, reject) => ffi_import(module_name, resolve, reject).cast()).cast()
}

pub fn[T] require(module_name : String) -> T {
  ffi_require(module_name).cast()
}
