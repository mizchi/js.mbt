///|
pub extern "js" fn global_this() -> Value =
  #| () => globalThis

///|
pub extern "js" fn import_meta() -> Value =
  #| () => import.meta
