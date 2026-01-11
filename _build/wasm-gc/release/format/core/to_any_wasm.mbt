// to_any_wasm.mbt - WASM-GC compatible ToAny implementations
//
// In WASM-GC, %identity cannot convert MoonBit primitives to externref.
// Instead, we use wasm_from_* imports that call JavaScript functions
// to perform the type conversion at the JS/WASM boundary.

///|
/// Trait for converting values to JavaScript Any type.
/// WASM-GC implementation uses jscore imports for type-safe conversion.
pub trait ToAny {
  to_any(Self) -> Any
}

// Primitive type implementations using wasm_from_* imports

///|
pub impl ToAny for Int with to_any(self) -> Any {
  wasm_from_int(self)
}

///|
pub impl ToAny for UInt with to_any(self) -> Any {
  wasm_from_uint(self)
}

///|
pub impl ToAny for Int64 with to_any(self) -> Any {
  wasm_from_int64(self)
}

///|
pub impl ToAny for UInt64 with to_any(self) -> Any {
  wasm_from_uint64(self)
}

///|
pub impl ToAny for Float with to_any(self) -> Any {
  wasm_from_float(self)
}

///|
pub impl ToAny for Double with to_any(self) -> Any {
  wasm_from_double(self)
}

///|
pub impl ToAny for String with to_any(self) -> Any {
  wasm_from_string(self)
}

///|
pub impl ToAny for Bool with to_any(self) -> Any {
  wasm_from_bool(self)
}

///|
/// BigInt is converted to Int64, then to JS BigInt
/// Note: Values outside Int64 range will overflow
pub impl ToAny for BigInt with to_any(self) -> Any {
  int64_to_bigint(self.to_int64())
}

// Note: Generic Array[T] cannot be used in WASM FFI
// Use Array[Any] instead, which converts via array_to_js

///|
pub impl ToAny for Any with to_any(self) -> Any {
  self
}

///|
/// Array[Any] is converted to JS array by iterating and pushing elements
pub impl ToAny for Array[Any] with to_any(self) -> Any {
  array_to_js(self)
}

///|
/// Bytes are converted to JS Uint8Array
pub impl ToAny for Bytes with to_any(self) -> Any {
  bytes_to_js(self)
}

// Note: BigInt requires special handling - use wasm_from_int64 for Int64 instead

///|
pub impl ToAny for Unit with to_any(_self) -> Any {
  undefined()
}
