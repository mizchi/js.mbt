using @val {type Val}
///|
async fn[T, E : Error] suspend(
  f : ((T) -> Unit, (E) -> Unit) -> Unit,
) -> T raise E = "%async.suspend"

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
