///|
#external
pub type Symbol

///|
pub impl Js for Symbol

///|
/// Create a new JavaScript Symbol with a description.
///
/// # Parameters
///
/// - `name`: The description for the symbol
///
/// # Returns
///
/// A new Symbol
///
/// # Example
///
/// ```moonbit
/// let sym = symbol("mySymbol")
/// let obj = new_empty_object()
/// obj.set(sym, "value")
/// ```
pub fn symbol(name : String) -> Symbol {
  ffi_symbol(name)
}

///|
pub fn Symbol::for_(name : String) -> Symbol {
  ffi_symbol_for(name)
}

///|
/// Get the well-known Symbol.iterator symbol.
///
/// Used to make objects iterable in JavaScript.
///
/// # Returns
///
/// The Symbol.iterator symbol
///
/// # Example
///
/// ```moonbit
/// let iter_sym = Symbol::iterator()
/// // Use to implement custom iterators
/// ```
pub fn Symbol::iterator() -> Symbol {
  ffi_symbol_iterator()
}

///|
pub fn Symbol::asyncIterator() -> Symbol {
  ffi_symbol_async_iterator()
}

///|
/// Get the well-known Symbol.dispose symbol.
///
/// Used for explicit resource management (using statement).
///
/// # Returns
///
/// The Symbol.dispose symbol
pub fn Symbol::dispose() -> Symbol {
  ffi_symbol_dispose()
}

///|
/// Get the well-known Symbol.asyncDispose symbol.
///
/// Used for asynchronous resource management.
///
/// # Returns
///
/// The Symbol.asyncDispose symbol
pub fn Symbol::asyncDispose() -> Symbol {
  ffi_symbol_async_dispose()
}
