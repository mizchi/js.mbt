// =============================================================================
// The GPUError hierarchy, GPUPipelineError and uncaptured errors
// https://developer.mozilla.org/en-US/docs/Web/API/GPUError
//
// `GPUDevice::popErrorScope` and the uncaptured-error handler both hand back a
// `GPUError`, whose concrete type says what went wrong. JS discriminates with
// `instanceof`, so `GPUError::kind` does that in one FFI hop and the three
// `as_*` helpers narrow once you know.
// =============================================================================

///|
/// What kind of error a `GPUError` actually is.
pub(all) enum GPUErrorKind {
  /// The call broke a WebGPU validation rule -- a bug in the calling code.
  Validation
  /// An allocation failed.
  OutOfMemory
  /// The implementation hit a limit it could not describe further, e.g. a
  /// shader too complex for the driver.
  Internal
  /// Not one of the three standard subtypes.
  Unknown
} derive(Eq, Debug)

///|
extern "js" fn ffi_gpu_error_kind(err : @core.Any) -> String =
  #| (e) => (typeof GPUValidationError !== "undefined" && e instanceof GPUValidationError) ? "validation"
  #|      : (typeof GPUOutOfMemoryError !== "undefined" && e instanceof GPUOutOfMemoryError) ? "out-of-memory"
  #|      : (typeof GPUInternalError !== "undefined" && e instanceof GPUInternalError) ? "internal"
  #|      : "unknown"

///|
/// Which concrete subtype this error is.
pub fn GPUError::kind(self : GPUError) -> GPUErrorKind {
  match ffi_gpu_error_kind(self.as_any()) {
    "validation" => Validation
    "out-of-memory" => OutOfMemory
    "internal" => Internal
    _ => Unknown
  }
}

///|
/// Narrow to a `GPUValidationError`, or `None` if it is not one.
pub fn GPUError::as_validation_error(self : GPUError) -> GPUValidationError? {
  if self.kind() is Validation {
    Some(self.as_any().cast())
  } else {
    None
  }
}

///|
/// Narrow to a `GPUOutOfMemoryError`, or `None` if it is not one.
pub fn GPUError::as_out_of_memory_error(
  self : GPUError,
) -> GPUOutOfMemoryError? {
  if self.kind() is OutOfMemory {
    Some(self.as_any().cast())
  } else {
    None
  }
}

///|
/// Narrow to a `GPUInternalError`, or `None` if it is not one.
pub fn GPUError::as_internal_error(self : GPUError) -> GPUInternalError? {
  if self.kind() is Internal {
    Some(self.as_any().cast())
  } else {
    None
  }
}

// ---- the three subtypes ----------------------------------------------------

///|
/// A WebGPU validation rule was broken.
/// https://developer.mozilla.org/en-US/docs/Web/API/GPUValidationError
#external
pub type GPUValidationError

///|
pub fn GPUValidationError::as_any(self : GPUValidationError) -> @core.Any = "%identity"

///|
/// Widen back to the base error type.
pub fn GPUValidationError::as_gpu_error(self : GPUValidationError) -> GPUError = "%identity"

///|
/// A human-readable description of the failure.
pub fn GPUValidationError::message(self : GPUValidationError) -> String {
  self.as_any()["message"].cast()
}

///|
/// An allocation failed.
/// https://developer.mozilla.org/en-US/docs/Web/API/GPUOutOfMemoryError
#external
pub type GPUOutOfMemoryError

///|
pub fn GPUOutOfMemoryError::as_any(self : GPUOutOfMemoryError) -> @core.Any = "%identity"

///|
/// Widen back to the base error type.
pub fn GPUOutOfMemoryError::as_gpu_error(
  self : GPUOutOfMemoryError,
) -> GPUError = "%identity"

///|
/// A human-readable description of the failure.
pub fn GPUOutOfMemoryError::message(self : GPUOutOfMemoryError) -> String {
  self.as_any()["message"].cast()
}

///|
/// The implementation hit a limit it cannot describe more precisely.
/// https://developer.mozilla.org/en-US/docs/Web/API/GPUInternalError
#external
pub type GPUInternalError

///|
pub fn GPUInternalError::as_any(self : GPUInternalError) -> @core.Any = "%identity"

///|
/// Widen back to the base error type.
pub fn GPUInternalError::as_gpu_error(self : GPUInternalError) -> GPUError = "%identity"

///|
/// A human-readable description of the failure.
pub fn GPUInternalError::message(self : GPUInternalError) -> String {
  self.as_any()["message"].cast()
}

// ---- GPUPipelineError ------------------------------------------------------

///|
/// Why `createRenderPipelineAsync` / `createComputePipelineAsync` rejected.
/// https://developer.mozilla.org/en-US/docs/Web/API/GPUPipelineError
#external
pub type GPUPipelineError

///|
pub fn GPUPipelineError::as_any(self : GPUPipelineError) -> @core.Any = "%identity"

///|
/// Wrap a rejection value as a `GPUPipelineError`.
pub fn GPUPipelineError::from_any(value : @core.Any) -> GPUPipelineError? {
  if @core.is_nullish(value) {
    None
  } else {
    Some(value.cast())
  }
}

///|
/// A human-readable description of the failure.
pub fn GPUPipelineError::message(self : GPUPipelineError) -> String {
  self.as_any()["message"].cast()
}

///|
/// Either "validation" or "internal".
pub fn GPUPipelineError::reason(self : GPUPipelineError) -> String {
  self.as_any()["reason"].cast()
}

// ---- uncaptured errors -----------------------------------------------------

///|
/// The event delivered to `GPUDevice::set_onuncapturederror`.
/// https://developer.mozilla.org/en-US/docs/Web/API/GPUUncapturedErrorEvent
#external
pub type GPUUncapturedErrorEvent

///|
pub fn GPUUncapturedErrorEvent::as_any(
  self : GPUUncapturedErrorEvent,
) -> @core.Any = "%identity"

///|
/// The error that was not caught by any error scope.
pub fn GPUUncapturedErrorEvent::error(
  self : GPUUncapturedErrorEvent,
) -> GPUError {
  self.as_any()["error"].cast()
}

///|
/// Handle errors that no `pushErrorScope` caught. This is the practical way to
/// find out about validation failures, since most WebGPU calls report
/// asynchronously and do not raise.
/// https://developer.mozilla.org/en-US/docs/Web/API/GPUDevice/uncapturederror_event
pub fn GPUDevice::set_onuncapturederror(
  self : GPUDevice,
  handler : (GPUUncapturedErrorEvent) -> Unit,
) -> Unit {
  self
  .as_any()
  ._set(
    "onuncapturederror",
    @core.any(fn(ev : @core.Any) { handler(ev.cast()) }),
  )
}
