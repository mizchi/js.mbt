///|
/// Node.js: import.meta.resolve(moduleName)
/// only esm
pub extern "js" fn import_meta_resolve(module_name : String) =
  #| (moduleName) => import.meta.resolve(moduleName)

///|
/// Node.js: import.meta.url
/// only esm
pub extern "js" fn import_meta_url() -> String =
  #| () => import.meta.url

///|
/// Node.js: import.meta.filename
/// only esm
pub extern "js" fn import_meta_filename() -> String =
  #| () => import.meta.filename

///|
/// Node.js: import.meta.dirname
/// only esm
pub extern "js" fn import_meta_dirname() -> String =
  #| () => import.meta.dirname
