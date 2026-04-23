// core_interop.mbt - Functions that use target-specific bindings (js + wasm-gc only)
// These depend on functions defined in core_js.mbt / core_wasm.mbt

// ============================================
// Trait implementations
// ============================================

///|
pub impl Eq for Any with equal(self, other) -> Bool {
  equal(self, other)
}

///|
pub impl Show for Any with output(self, logger) {
  logger.write_string(self.to_string())
}

// ============================================
// Option conversions (use target-specific functions)
// ============================================

///|
/// Safely convert a JavaScript value to an Option type.
/// Converts JavaScript `null` or `undefined` to `None`, otherwise returns `Some(value)`.
pub fn[T] identity_option(v : Any) -> T? {
  if is_nullish(v) {
    None
  } else {
    Some(identity(v))
  }
}

///|
/// Convert an Option to Any, mapping None to null and Some(v) to v.
pub fn[A] from_option(opt : A?) -> Any {
  match opt {
    Some(v) => identity(v)
    None => null()
  }
}

// ============================================
// TypeOf utilities (common logic, uses target-specific functions)
// ============================================

///|
/// Type-safe instanceof check: TypeOf[T].is_instanceof(value)
pub fn[T] TypeOf::is_instanceof(self : TypeOf[T], v : Any) -> Bool {
  instanceof_(v, identity(self))
}

///|
/// Type-safe constructor call: new cls(...args) -> T
pub fn[T] new_instance(cls : TypeOf[T], args : Array[Any]) -> T {
  identity(new(identity(cls), args))
}
