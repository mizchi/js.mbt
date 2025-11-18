///|
/// Log a value to the console (JavaScript console.log).
///
/// This is a convenience function for debugging.
///
/// # Example
///
/// ```moonbit skip
/// log("Hello, World!")
/// log(42)
/// log([1, 2, 3])
/// ```
pub fn[T] log(v : T) -> Unit {
  ffi_console_log([v |> unsafe_cast]) |> ignore
}

///|
pub fn[T, U] log2(v : T, u : U) -> Unit {
  ffi_console_log([v |> unsafe_cast, u |> unsafe_cast]) |> ignore
}
