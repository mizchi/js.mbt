///|
using @js {type Val}

///|
extern "js" fn ffi_require(module_name : String) -> Val =
  #| (moduleName) => require(moduleName)

///|
pub fn require(module_name : String) -> Val {
  ffi_require(module_name)
}
