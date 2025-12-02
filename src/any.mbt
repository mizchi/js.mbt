///|
/// Represents an unsafe JavaScript value like TypeScript's `any`
/// It can hold any JavaScript value including primitives, objects, arrays, functions, etc.
///
/// ## Example
///
/// ```moonbit
/// let num : @nostd.Any = @nostd.any(42) // MoonBit Int -> @nostd.Any
///
/// let _val : Int = num.cast() // Any -> MoonBit Int (unsafe)
/// ```
// #deprecated("Use @nostd.Any instead for better performance and usability")
// pub type Any = @nostd.Any

pub using @nostd {type Any}

///|
/// Nullable type for explicit null handling in FFI struct fields.
pub type Nullable[T] = @nostd.Nullable[T]

///|
/// Null or undefined wrapper type.
pub type Nullish[T] = @nostd.Nullish[T]
