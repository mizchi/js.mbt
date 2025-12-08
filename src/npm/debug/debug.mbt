///|
/// debug bindings for MoonBit (nostd)
/// https://github.com/debug-js/debug
///
/// A tiny JavaScript debugging utility.

///| Debug Type

///|
/// Debug logger instance
#external
pub type Debug

///| FFI Functions

///|
/// Create a new debug logger with the given namespace
pub extern "js" fn debug(ns : String) -> Debug =
  #| (ns) => {
  #|   const debug = require('debug');
  #|   return debug(ns);
  #| }

///|
/// Enable debug output for the given namespaces
/// Supports wildcards: "app:*" enables all namespaces starting with "app:"
pub extern "js" fn enable(namespaces : String) -> Unit =
  #| (namespaces) => {
  #|   const debug = require('debug');
  #|   debug.enable(namespaces);
  #| }

///|
/// Disable all debug output and return previously enabled namespaces
pub extern "js" fn disable() -> String =
  #| () => {
  #|   const debug = require('debug');
  #|   return debug.disable();
  #| }

///|
/// Check if a namespace is enabled
pub extern "js" fn enabled(ns : String) -> Bool =
  #| (ns) => {
  #|   const debug = require('debug');
  #|   return debug.enabled(ns);
  #| }

///|
/// Coerce a value (useful for Error objects)
pub extern "js" fn coerce(val : @core.Any) -> @core.Any =
  #| (val) => {
  #|   const debug = require('debug');
  #|   return debug.coerce(val);
  #| }

///|
extern "js" fn ffi_log(
  debug : Debug,
  message : String,
  args : Array[@core.Any],
) -> Unit =
  #| (debug, message, args) => {
  #|   debug(message, ...args);
  #| }

///|
extern "js" fn ffi_extend(debug : Debug, ns : String) -> Debug =
  #| (debug, ns) => {
  #|   return debug.extend(ns);
  #| }

///|
extern "js" fn ffi_get_namespace(debug : Debug) -> String =
  #| (debug) => {
  #|   return debug.namespace;
  #| }

///|
extern "js" fn ffi_get_enabled(debug : Debug) -> Bool =
  #| (debug) => {
  #|   return debug.enabled;
  #| }

///|
extern "js" fn ffi_set_enabled(debug : Debug, enabled : Bool) -> Unit =
  #| (debug, enabled) => {
  #|   debug.enabled = enabled;
  #| }

///| Module Functions

///| Debug Methods

///|
extern "js" fn ffi_log0(debug : Debug, message : String) -> Unit =
  #| (debug, message) => debug(message)

///|
extern "js" fn ffi_log1(
  debug : Debug,
  message : String,
  a1 : @core.Any,
) -> Unit =
  #| (debug, message, a1) => debug(message, a1)

///|
extern "js" fn ffi_log2(
  debug : Debug,
  message : String,
  a1 : @core.Any,
  a2 : @core.Any,
) -> Unit =
  #| (debug, message, a1, a2) => debug(message, a1, a2)

///|
extern "js" fn ffi_log3(
  debug : Debug,
  message : String,
  a1 : @core.Any,
  a2 : @core.Any,
  a3 : @core.Any,
) -> Unit =
  #| (debug, message, a1, a2, a3) => debug(message, a1, a2, a3)

///|
extern "js" fn ffi_log4(
  debug : Debug,
  message : String,
  a1 : @core.Any,
  a2 : @core.Any,
  a3 : @core.Any,
  a4 : @core.Any,
) -> Unit =
  #| (debug, message, a1, a2, a3, a4) => debug(message, a1, a2, a3, a4)

///|
/// Log a debug message
pub fn Debug::log(self : Debug, message : String) -> Unit {
  ffi_log0(self, message)
}

///|
/// Log a debug message with format arguments
pub fn Debug::log_with(
  self : Debug,
  message : String,
  args : Array[@core.Any],
) -> Unit {
  ffi_log(self, message, args)
}

///|
/// Log with a single argument
pub fn Debug::log1(self : Debug, message : String, arg1 : @core.Any) -> Unit {
  ffi_log1(self, message, arg1)
}

///|
/// Log with two arguments
pub fn Debug::log2(
  self : Debug,
  message : String,
  arg1 : @core.Any,
  arg2 : @core.Any,
) -> Unit {
  ffi_log2(self, message, arg1, arg2)
}

///|
/// Log with three arguments
pub fn Debug::log3(
  self : Debug,
  message : String,
  arg1 : @core.Any,
  arg2 : @core.Any,
  arg3 : @core.Any,
) -> Unit {
  ffi_log3(self, message, arg1, arg2, arg3)
}

///|
/// Log with four arguments
pub fn Debug::log4(
  self : Debug,
  message : String,
  arg1 : @core.Any,
  arg2 : @core.Any,
  arg3 : @core.Any,
  arg4 : @core.Any,
) -> Unit {
  ffi_log4(self, message, arg1, arg2, arg3, arg4)
}

///|
/// Create an extended logger with additional namespace
pub fn Debug::extend(self : Debug, ns : String) -> Debug {
  ffi_extend(self, ns)
}

///|
/// Get the namespace of this debug logger
pub fn Debug::get_namespace(self : Debug) -> String {
  ffi_get_namespace(self)
}

///|
/// Check if this debug logger is enabled
pub fn Debug::is_enabled(self : Debug) -> Bool {
  ffi_get_enabled(self)
}

///|
/// Set whether this debug logger is enabled
pub fn Debug::set_enabled(self : Debug, enabled : Bool) -> Unit {
  ffi_set_enabled(self, enabled)
}
