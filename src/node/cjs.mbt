///|
/// Node.js: require(moduleName)
pub extern "js" fn require(module_name : String) -> @js.Js =
  #| (moduleName) => require(moduleName)

///|
/// Node.js: require.cache
pub extern "js" fn require_cache() -> @js.Object =
  #| (moduleName) => require.cache

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
