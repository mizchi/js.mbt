// ///|
// extern "js" fn ffi_is_error(value : @nostd.Any) -> Bool =
//   #| (value) => Error.isError(value)

// ///|
// extern "js" fn ffi_new_error(args : Array[@nostd.Any]) -> JsError =
//   #| (args) => new Error(...args)

// ///|
// extern "js" fn ffi_get(obj : @nostd.Any, key : String) -> @nostd.Any =
//   #| (obj, key) => obj[key]

// ///|
// /// JavaScript Error
// // pub type JsError
// // #external
// pub(all) struct JsError {
//   message : String
//   stack : String
// }

// ///|
// pub fn JsError::to_any(self : JsError) -> @nostd.Any = "%identity"

// ///|
// pub fn JsError::as_any(self : JsError) -> @nostd.Any = "%identity"

// ///|
// pub impl Show for JsError with output(self, logger) {
//   logger.write_string(self.to_string())
// }

// ///|
// pub impl Show for JsError with to_string(self) {
//   self.message
// }

// ///|
// /// JS: Error.isError(value)
// pub fn JsError::isError(val : @nostd.Any) -> Bool {
//   ffi_is_error(val |> @nostd.identity)
// }

// ///|
// /// Create a new JavaScript Error object.
// pub fn JsError::new(message : String, cause? : JsError) -> JsError {
//   let args : Array[@nostd.Any] = if cause is Some(cause) {
//     [
//       @nostd.any(message).cast(),
//       @nostd.from_entries([("cause", cause.to_any())]).cast(),
//     ]
//   } else {
//     [@nostd.any(message).cast()]
//   }
//   ffi_new_error(args)
// }

// ///|
// /// Wraps JavaScript errors thrown during runtime.
// /// This type represents errors that can be raised when calling JavaScript functions
// /// that may throw exceptions.
// pub(all) struct ThrowError {
//   /// TypeError - Type-related errors
//   TypeError(JsError)
//   /// RangeError - Value out of range errors
//   RangeError(JsError)
//   /// ReferenceError - Invalid reference errors
//   ReferenceError(JsError)
//   /// SyntaxError - Syntax parsing errors
//   SyntaxError(JsError)
//   /// URIError - URI handling errors
//   URIError(JsError)
//   /// EvalError - eval() related errors
//   EvalError(JsError)
//   /// AggregateError - Multiple errors wrapped together
//   AggregateError(JsError)
//   /// SuppressedError - Error suppressed during disposal
//   SuppressedError(JsError)
//   /// Generic JavaScript Error including custom errors
//   Error(JsError)
//   /// Non-error value thrown
//   Value(@nostd.Any)
// }

// ///|
// pub fn ThrowError::to_any(self : ThrowError) -> @nostd.Any = "%identity"

// ///|
// pub impl Show for ThrowError with output(self, logger) {
//   logger.write_string(self.to_string())
// }

// ///|
// pub impl Show for ThrowError with to_string(self) {
//   match self {
//     Error(err)
//     | TypeError(err)
//     | RangeError(err)
//     | ReferenceError(err)
//     | SyntaxError(err)
//     | URIError(err)
//     | EvalError(err)
//     | AggregateError(err)
//     | SuppressedError(err) => err.message
//     Value(val) => val.to_string()
//   }
// }

// ///|
// /// Convert a JavaScript value to ThrowError by checking its type with instanceof
// ///
// /// This function inspects the error type and returns the appropriate ThrowError variant.
// /// If the value is not an Error object, it returns ThrowError::Value.
// ///
// /// # Example
// ///
// /// ```moonbit no-check
// /// let js_error = globalThis()._get("TypeError")
// ///
// /// let throw_error = ThrowError::from(js_error)
// /// // Returns ThrowError::TypeError(...)
// /// ```
// pub fn ThrowError::from(value : @nostd.Any) -> ThrowError {
//   let global = @nostd.global_this()

//   // Check specific error types first (most specific to least specific)
//   if @nostd.instanceof_(value, ffi_get(global, "TypeError")) {
//     ThrowError::TypeError(@nostd.identity(value))
//   } else if @nostd.instanceof_(value, ffi_get(global, "RangeError")) {
//     ThrowError::RangeError(@nostd.identity(value))
//   } else if @nostd.instanceof_(value, ffi_get(global, "ReferenceError")) {
//     ThrowError::ReferenceError(@nostd.identity(value))
//   } else if @nostd.instanceof_(value, ffi_get(global, "SyntaxError")) {
//     ThrowError::SyntaxError(@nostd.identity(value))
//   } else if @nostd.instanceof_(value, ffi_get(global, "URIError")) {
//     ThrowError::URIError(@nostd.identity(value))
//   } else if @nostd.instanceof_(value, ffi_get(global, "EvalError")) {
//     ThrowError::EvalError(@nostd.identity(value))
//   } else if @nostd.instanceof_(value, ffi_get(global, "AggregateError")) {
//     ThrowError::AggregateError(@nostd.identity(value))
//   } else if @nostd.instanceof_(value, ffi_get(global, "SuppressedError")) {
//     ThrowError::SuppressedError(@nostd.identity(value))
//   } else if JsError::isError(@nostd.any(value)) {
//     // Generic Error or custom error types
//     ThrowError::Error(@nostd.identity(value))
//   } else {
//     // Non-error value thrown
//     ThrowError::Value(value)
//   }
// }
