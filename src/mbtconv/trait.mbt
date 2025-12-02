///|
pub fn[T] is_builtin_trait(v : T) -> Bool {
  let v = @core.any(v)
  @core.object_has_own(v.cast(), "self") &&
  @core.object_has_own(v.cast(), "method_0")
}
