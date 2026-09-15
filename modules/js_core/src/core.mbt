// core.mbt - Common interface (all targets)
// Target-specific implementations in core_js.mbt / core_wasm.mbt
// Functions using target-specific bindings are in core_interop.mbt

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

///|
/// Convert TypeOf[T] to Any for use with generic functions
pub fn[T] TypeOf::as_any(self : TypeOf[T]) -> Any = "%identity"
