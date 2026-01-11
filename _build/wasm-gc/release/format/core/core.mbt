// core.mbt - Common interface (all targets)
// Target-specific implementations in core_js.mbt / core_wasm.mbt

///|
/// Opaque type for JavaScript values
#external
pub type Any

///|
/// Represents a JavaScript constructor/class type.
/// Similar to TypeScript's `typeof ClassName`.
#external
pub type TypeOf[T]

// ============================================
// Zero-cost type conversions using %identity
// ============================================

///|
pub fn[A, B] identity(value : A) -> B = "%identity"

///|
pub fn[T] any(value : T) -> Any = "%identity"

///|
pub fn[T] Any::cast(self : Any) -> T = "%identity"

///|
/// Convert Option[T] to Any (None becomes undefined)
/// Zero-cost: concrete Option[T] compiles to T | undefined in JS
pub fn[T] nullable(opt : T?) -> Any = "%identity"

// ============================================
// Function wrappers (zero-cost)
// ============================================

///|
/// Wrap MoonBit function as JS function (0 args)
pub fn[A] from_fn0(f : () -> A) -> Any = "%identity"

///|
/// Wrap MoonBit function as JS function (1 arg)
pub fn[A, B] from_fn1(f : (A) -> B) -> Any = "%identity"

///|
/// Wrap MoonBit function as JS function (2 args)
pub fn[A, B, C] from_fn2(f : (A, B) -> C) -> Any = "%identity"

///|
/// Wrap MoonBit function as JS function (3 args)
pub fn[A, B, C, D] from_fn3(f : (A, B, C) -> D) -> Any = "%identity"

// ============================================
// Trait implementations (common)
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
/// Convert TypeOf[T] to Any for use with generic functions
pub fn[T] TypeOf::as_any(self : TypeOf[T]) -> Any = "%identity"

///|
/// Type-safe constructor call: new cls(...args) -> T
pub fn[T] new_instance(cls : TypeOf[T], args : Array[Any]) -> T {
  identity(new(identity(cls), args))
}
