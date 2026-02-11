// ToAny Trait - Optional Type-Safe Any Conversion
//
// This trait is NOT used internally by this library. It is provided as an
// optional convenience for users building JS bindings where bundle size is
// not a primary concern.
//
// Why not use this internally?
// - Generic functions with trait bounds (`fn[T : ToAny]`) cause monomorphization,
//   duplicating code for each concrete type used.
// - For bundle-sensitive applications, use `|> @core.any` directly which is
//   zero-cost and does not cause code duplication.
//
// When to use this trait:
// - Building high-level APIs where ergonomics matter more than bundle size
// - Desktop/server applications where code size is not critical
// - Prototyping and development where convenience is prioritized

///|
/// Trait for converting values to JavaScript Any type.
///
/// Provides a type-safe alternative to the `@core.any()` function.
/// All implementations use zero-cost `%identity` conversion.
///
/// Usage:
/// ```moonbit nocheck
/// fn[T : ToAny] set_value(obj : Any, key : String, value : T) -> Unit {
///   obj._set(key, ToAny::to_any(value))
/// }
/// ```
///
/// Trade-off: Using `fn[T : ToAny]` causes monomorphization (code duplication
/// per type). For smaller bundle size, either:
/// - Use `|> @core.any` directly (no trait overhead)
/// - Use `&ToAny` trait objects (dynamic dispatch, single function)
pub trait ToAny {
  to_any(Self) -> Any
}

// Primitive type implementations - all zero-cost via %identity

///|
pub impl ToAny for Int with to_any(self) -> Any = "%identity"

///|
pub impl ToAny for UInt with to_any(self) -> Any = "%identity"

///|
pub impl ToAny for Int64 with to_any(self) -> Any = "%identity"

///|
pub impl ToAny for UInt64 with to_any(self) -> Any = "%identity"

///|
pub impl ToAny for Float with to_any(self) -> Any = "%identity"

///|
pub impl ToAny for Double with to_any(self) -> Any = "%identity"

///|
pub impl ToAny for String with to_any(self) -> Any = "%identity"

///|
pub impl ToAny for Bool with to_any(self) -> Any = "%identity"

///|
pub impl ToAny for BigInt with to_any(self) -> Any = "%identity"

///|
pub impl ToAny for Bytes with to_any(self) -> Any = "%identity"

///|
pub impl ToAny for Any with to_any(self) -> Any {
  self
}

///|
pub impl[T] ToAny for Array[T] with to_any(self) -> Any = "%identity"

///|
pub impl ToAny for Unit with to_any(_self) -> Any {
  undefined()
}
