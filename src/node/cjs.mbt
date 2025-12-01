///|
/// Node.js: require(moduleName)
pub extern "js" fn require(module_name : String) -> @nostd.Any =
  #| (moduleName) => require(moduleName)

///|
/// Node.js: require.cache
pub extern "js" fn require_cache() -> @nostd.Any =
  #| (moduleName) => require.cache

///|
/// Node.js: module
pub extern "js" fn module_() -> @nostd.Any =
  #| () => module

///|
/// Node.js: require.resolve(moduleName)
/// only cjs
pub extern "js" fn require_resolve(module_name : String) =
  #| (moduleName) => require.resolve(moduleName)

///|
/// Node.js: __dirname
/// only cjs
extern "js" fn __dirname() -> String =
  #| () => __dirname

///|
/// Node.js: __filename
/// only cjs
extern "js" fn __filename() -> String =
  #| () => __filename

///|
/// Node.js: require.main
/// only esm
pub extern "js" fn require_main() -> String =
  #| () => require.main
