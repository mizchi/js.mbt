// Deprecated aliases kept for source compatibility with 0.13.x.
// MoonBit's canonical constructor is `Type::Type(..)`, called as `Type(..)`;
// these `::new` forms will be removed in a future release.

///|
/// Deprecated alias for the `JsError(..)` constructor.
#deprecated("use `JsError(..)` instead")
pub fn JsError::new(message : String, cause? : JsError) -> JsError {
  JsError(message, cause?)
}

///|
/// Deprecated alias for the `TypeError(..)` constructor.
#deprecated("use `TypeError(..)` instead")
pub fn TypeError::new(message : String) -> TypeError {
  TypeError(message)
}

///|
/// Deprecated alias for the `RangeError(..)` constructor.
#deprecated("use `RangeError(..)` instead")
pub fn RangeError::new(message : String) -> RangeError {
  RangeError(message)
}

///|
/// Deprecated alias for the `ReferenceError(..)` constructor.
#deprecated("use `ReferenceError(..)` instead")
pub fn ReferenceError::new(message : String) -> ReferenceError {
  ReferenceError(message)
}

///|
/// Deprecated alias for the `SyntaxError(..)` constructor.
#deprecated("use `SyntaxError(..)` instead")
pub fn SyntaxError::new(message : String) -> SyntaxError {
  SyntaxError(message)
}

///|
/// Deprecated alias for the `URIError(..)` constructor.
#deprecated("use `URIError(..)` instead")
pub fn URIError::new(message : String) -> URIError {
  URIError(message)
}

///|
/// Deprecated alias for the `EvalError(..)` constructor.
#deprecated("use `EvalError(..)` instead")
pub fn EvalError::new(message : String) -> EvalError {
  EvalError(message)
}

///|
/// Deprecated alias for the `AggregateError(..)` constructor.
#deprecated("use `AggregateError(..)` instead")
pub fn AggregateError::new(
  errors : @core.Any,
  message : String,
) -> AggregateError {
  AggregateError(errors, message)
}
