///|
/// JavaScript Symbol
#external
pub type Symbol

///|
pub impl Js for Symbol

///|
/// JS: Symbol(name)
pub fn symbol(name : String) -> Symbol {
  ffi_symbol(name)
}

///|
/// JS: Symbol.for(name)
pub fn Symbol::for_(name : String) -> Symbol {
  ffi_symbol_for(name)
}

///|
/// JS: Symbol.iterator
pub fn Symbol::iterator() -> Symbol {
  ffi_symbol_iterator()
}

///|
/// JS: Symbol.asyncIterator
pub fn Symbol::asyncIterator() -> Symbol {
  ffi_symbol_async_iterator()
}

///|
/// JS: Symbol.dispose
pub fn Symbol::dispose() -> Symbol {
  ffi_symbol_dispose()
}

///|
/// JS: Symbol.asyncDispose
pub fn Symbol::asyncDispose() -> Symbol {
  ffi_symbol_async_dispose()
}
