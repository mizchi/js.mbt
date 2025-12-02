// ///|
// extern "js" fn ffi_is_error(value : @core.Any) -> Bool =
//   #| (value) => Error.isError(value)

// ///|
// extern "js" fn ffi_new_error(args : Array[@core.Any]) -> JsError =
//   #| (args) => new Error(...args)

// ///|
// extern "js" fn ffi_get(obj : @core.Any, key : String) -> @core.Any =
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
// pub fn JsError::to_any(self : JsError) -> @core.Any = "%identity"

// ///|
// pub fn JsError::as_any(self : JsError) -> @core.Any = "%identity"

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
// pub fn JsError::isError(val : @core.Any) -> Bool {
//   ffi_is_error(val |> @core.identity)
// }

// ///|
// /// Create a new JavaScript Error object.
// pub fn JsError::new(message : String, cause? : JsError) -> JsError {
//   let args : Array[@core.Any] = if cause is Some(cause) {
//     [
//       @core.any(message).cast(),
//       @core.from_entries([("cause", cause.to_any())]).cast(),
//     ]
//   } else {
//     [@core.any(message).cast()]
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
//   Value(@core.Any)
// }

// ///|
// pub fn ThrowError::to_any(self : ThrowError) -> @core.Any = "%identity"

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
// pub fn ThrowError::from(value : @core.Any) -> ThrowError {
//   let global = @core.global_this()

//   // Check specific error types first (most specific to least specific)
//   if @core.instanceof_(value, ffi_get(global, "TypeError")) {
//     ThrowError::TypeError(@core.identity(value))
//   } else if @core.instanceof_(value, ffi_get(global, "RangeError")) {
//     ThrowError::RangeError(@core.identity(value))
//   } else if @core.instanceof_(value, ffi_get(global, "ReferenceError")) {
//     ThrowError::ReferenceError(@core.identity(value))
//   } else if @core.instanceof_(value, ffi_get(global, "SyntaxError")) {
//     ThrowError::SyntaxError(@core.identity(value))
//   } else if @core.instanceof_(value, ffi_get(global, "URIError")) {
//     ThrowError::URIError(@core.identity(value))
//   } else if @core.instanceof_(value, ffi_get(global, "EvalError")) {
//     ThrowError::EvalError(@core.identity(value))
//   } else if @core.instanceof_(value, ffi_get(global, "AggregateError")) {
//     ThrowError::AggregateError(@core.identity(value))
//   } else if @core.instanceof_(value, ffi_get(global, "SuppressedError")) {
//     ThrowError::SuppressedError(@core.identity(value))
//   } else if JsError::isError(@core.any(value)) {
//     // Generic Error or custom error types
//     ThrowError::Error(@core.identity(value))
//   } else {
//     // Non-error value thrown
//     ThrowError::Value(value)
//   }
// }
