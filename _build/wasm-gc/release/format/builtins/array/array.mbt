// Frequently used JavaScript builtin types

///|
/// JavaScript Array
/// NonGeneric Array only for Array[Any]
/// Use builtin Array[T] for generic array and JsArray::from(array)
#external
pub type JsArray

///|
pub fn JsArray::as_any(self : JsArray) -> @core.Any = "%identity"

///|
extern "js" fn ffi_json_stringify(
  value : @core.Any,
  replacer : @core.Any,
  space : @core.Any,
) -> String =
  #| (value, replacer, space) => JSON.stringify(value, replacer, space)

///|
pub fn JsArray::to_string(self : Self) -> String {
  ffi_json_stringify(
    self.as_any() |> @core.identity,
    @core.undefined(),
    @core.undefined(),
  )
}

///|
/// cast to builtin Array
pub fn[T] JsArray::as_builtin_array(self : Self) -> Array[T] {
  self |> @core.identity
}
