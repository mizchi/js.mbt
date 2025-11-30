///|
/// JS Symbol type wrapper
#external
pub type Symbol

///|
pub extern "js" fn Symbol::as_any(self : Symbol) -> @nostd.Any =
  #| (x) => x

///|
/// Get Symbol.iterator
pub extern "js" fn symbol_iterator() -> Symbol =
  #| () => Symbol.iterator

///|
/// Get Symbol.asyncIterator
pub extern "js" fn symbol_async_iterator() -> Symbol =
  #| () => Symbol.asyncIterator

///|
/// Get Symbol.toStringTag
pub extern "js" fn symbol_to_string_tag() -> Symbol =
  #| () => Symbol.toStringTag

///|
/// Create a new Symbol with optional description
pub extern "js" fn symbol_create(description : String) -> Symbol =
  #| (desc) => Symbol(desc)

///|
/// Call a method using a Symbol as key: obj[symbol]()
pub extern "js" fn call_symbol_method(
  obj : @nostd.Any,
  symbol : Symbol,
  args : Array[@nostd.Any],
) -> @nostd.Any =
  #| (obj, symbol, args) => obj[symbol](...args)

///|
extern "js" fn console_log(v : @nostd.Any) -> Unit =
  #| (v) => console.log(v)

///|
extern "js" fn get_iterable_array() -> @nostd.Any =
  #| () => [1, 2, 3]

///|
fn main {
  // Test symbol_iterator
  let iter_sym = symbol_iterator()
  console_log(@nostd.any("iterator symbol:"))
  console_log(iter_sym.as_any())

  // Test symbol_async_iterator
  let async_iter_sym = symbol_async_iterator()
  console_log(@nostd.any("async iterator symbol:"))
  console_log(async_iter_sym.as_any())

  // Test symbol_to_string_tag
  let tag_sym = symbol_to_string_tag()
  console_log(@nostd.any("toStringTag symbol:"))
  console_log(tag_sym.as_any())

  // Test custom symbol
  let custom = symbol_create("mySymbol")
  console_log(@nostd.any("custom symbol:"))
  console_log(custom.as_any())

  // Test calling Symbol.iterator on an array
  let arr = get_iterable_array()
  let iterator = call_symbol_method(arr, iter_sym, [])
  console_log(@nostd.any("iterator from array:"))
  console_log(iterator)

  // Get first value from iterator
  let result = iterator._call("next", [])
  console_log(@nostd.any("first iteration result:"))
  console_log(result)
  console_log(result["value"])
}
