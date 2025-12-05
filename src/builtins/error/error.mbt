///| JavaScript Error types
///|
///| MDN Reference: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Error

///| TypeError
///| @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/TypeError
///|
pub(all) struct TypeError {
  message : String
  stack : String
}

///| RangeError
///| @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/RangeError
///|
pub(all) struct RangeError {
  message : String
  stack : String
}

///| ReferenceError
///| @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/ReferenceError
///|
pub(all) struct ReferenceError {
  message : String
  stack : String
}

///| SyntaxError
///| @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/SyntaxError
///|
pub(all) struct SyntaxError {
  message : String
  stack : String
}

///| URIError
///| @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/URIError
///|
pub(all) struct URIError {
  message : String
  stack : String
}

///| EvalError
///| @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/EvalError
///|
pub(all) struct EvalError {
  message : String
  stack : String
}

///| AggregateError
///| @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/AggregateError
///|
pub(all) struct AggregateError {
  message : String
  stack : String
}

///| JsError struct
///|
///| This represents the JavaScript Error type.
///| Named JsError to avoid namespace conflict with MoonBit's reserved Error type.
///| @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Error
///|
pub(all) struct JsError {
  message : String
  stack : String
}

///|
pub extern "js" fn JsError::isError(value : @core.Any) -> Bool =
  #| (value) => Error.isError(value)

///|
pub fn JsError::new(message : String, cause? : JsError) -> JsError {
  let args : Array[@core.Any] = if cause is Some(cause) {
    [
      @core.any(message).cast(),
      @core.from_entries([("cause", cause |> @core.any)]).cast(),
    ]
  } else {
    [@core.any(message).cast()]
  }
  ffi_new_error(args)
}

///|
extern "js" fn ffi_new_error(args : Array[@core.Any]) -> JsError =
  #| (args) => new Error(...args)

///| Error type conversion and utility functions

///|
pub fn JsError::as_any(self : JsError) -> @core.Any = "%identity"

///|
pub extern "js" fn throw_(error : @core.Any) -> Unit =
  #| (error) => { throw error; }

///| TypeError helpers

///|
pub fn TypeError::as_any(self : TypeError) -> @core.Any = "%identity"

///|
pub extern "js" fn TypeError::instanceof(value : @core.Any) -> Bool =
  #| (value) => value instanceof TypeError

///|
pub extern "js" fn TypeError::new(message : String) -> TypeError =
  #| (message) => new TypeError(message)

///| RangeError helpers

///|
pub fn RangeError::as_any(self : RangeError) -> @core.Any = "%identity"

///|
pub extern "js" fn RangeError::instanceof(value : @core.Any) -> Bool =
  #| (value) => value instanceof RangeError

///|
pub extern "js" fn RangeError::new(message : String) -> RangeError =
  #| (message) => new RangeError(message)

///| ReferenceError helpers

///|
pub fn ReferenceError::as_any(self : ReferenceError) -> @core.Any = "%identity"

///|
pub extern "js" fn ReferenceError::instanceof(value : @core.Any) -> Bool =
  #| (value) => value instanceof ReferenceError

///|
pub extern "js" fn ReferenceError::new(message : String) -> ReferenceError =
  #| (message) => new ReferenceError(message)

///| SyntaxError helpers

///|
pub fn SyntaxError::as_any(self : SyntaxError) -> @core.Any = "%identity"

///|
pub extern "js" fn SyntaxError::instanceof(value : @core.Any) -> Bool =
  #| (value) => value instanceof SyntaxError

///|
pub extern "js" fn SyntaxError::new(message : String) -> SyntaxError =
  #| (message) => new SyntaxError(message)

///| URIError helpers

///|
pub fn URIError::as_any(self : URIError) -> @core.Any = "%identity"

///|
pub extern "js" fn URIError::instanceof(value : @core.Any) -> Bool =
  #| (value) => value instanceof URIError

///|
pub extern "js" fn URIError::new(message : String) -> URIError =
  #| (message) => new URIError(message)

///| EvalError helpers

///|
pub fn EvalError::as_any(self : EvalError) -> @core.Any = "%identity"

///|
pub extern "js" fn EvalError::instanceof(value : @core.Any) -> Bool =
  #| (value) => value instanceof EvalError

///|
pub extern "js" fn EvalError::new(message : String) -> EvalError =
  #| (message) => new EvalError(message)

///| AggregateError helpers

///|
pub fn AggregateError::as_any(self : AggregateError) -> @core.Any = "%identity"

///|
pub extern "js" fn AggregateError::instanceof(value : @core.Any) -> Bool =
  #| (value) => value instanceof AggregateError

///|
pub extern "js" fn AggregateError::new(
  errors : @core.Any,
  message : String
) -> AggregateError =
  #| (errors, message) => new AggregateError(errors, message)
