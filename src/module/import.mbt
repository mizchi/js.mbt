///|
using @val {type Val}

///|
using @promise {type Promise, suspend}

///|
extern "js" fn ffi_require(module_name : String) -> Val =
  #| (moduleName) => require(moduleName)

///|
extern "js" fn ffi_dynamic_import(
  module_name : String) -> Promise[Val] =
  #| (moduleName) => import(moduleName)

///|
pub fn dynamic_import(module_name : String) -> Promise[Val] {
  ffi_dynamic_import(module_name)
}

///|
pub fn require(module_name : String) -> Val {
  ffi_require(module_name)
}
