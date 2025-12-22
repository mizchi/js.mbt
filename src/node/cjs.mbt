///|
/// Node.js: require(moduleName)
pub extern "js" fn require(module_name : String) -> @core.Any =
  #| (moduleName) => require(moduleName)

///|
/// Node.js: require.cache
pub extern "js" fn require_cache() -> @core.Any =
  #| (moduleName) => require.cache

///|
/// Node.js: module
pub extern "js" fn module_() -> @core.Any =
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

///|
/// Initialize ESM-compatible require function.
/// Must be called once before using esm_require in pure ESM environments.
/// Returns a Promise that resolves when initialization is complete.
/// In CJS environments, this is a no-op (require is already available).
pub extern "js" fn init_esm_require() -> @core.Any =
  #| async () => {
  #|   if (typeof require !== 'undefined') {
  #|     globalThis.__esm_require__ = require;
  #|     return;
  #|   }
  #|   const { createRequire } = await import('node:module');
  #|   globalThis.__esm_require__ = createRequire(import.meta.url);
  #| }

///|
/// Universal require that works in both ESM and CJS environments.
/// In CJS mode, uses native require directly.
/// In ESM mode, requires init_esm_require() to be called first.
/// Throws an error if used in ESM without initialization.
pub extern "js" fn esm_require(module_name : String) -> @core.Any =
  #| (moduleName) => {
  #|   if (typeof require !== 'undefined') {
  #|     return require(moduleName);
  #|   }
  #|   if (!globalThis.__esm_require__) {
  #|     throw new Error('esm_require not initialized. Call init_esm_require() first in ESM environments.');
  #|   }
  #|   return globalThis.__esm_require__(moduleName);
  #| }
