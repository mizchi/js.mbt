///|
/// JS: v instanceof cls
// pub fn[T, U] instanceof_(v : T, cls : U) -> Bool {
//   ffi_instance_of(identity(v), identity(cls))
// }

///|
/// JS: typeof v
pub fn[T] typeof_(v : T) -> String {
  ffi_type_of(identity(v))
}

///|
/// JS: new cls(...args)
// pub fn new_(cls : @nostd.Any, args : Array[@nostd.Any]) -> @nostd.Any {
//   ffi_new(cls, args)
// }
