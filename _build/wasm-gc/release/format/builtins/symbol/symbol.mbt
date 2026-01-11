///|
/// JavaScript Symbol
#external
pub type Symbol

///|
/// JS: Symbol(name)
pub extern "js" fn symbol(name : String) -> Symbol =
  #|(name) => Symbol(name)

///|
/// JS: Symbol.for(name)
pub extern "js" fn Symbol::for_(name : String) -> Symbol =
  #| (name) => Symbol.for(name)

///|
/// JS: Symbol.iterator
pub extern "js" fn Symbol::iterator() -> Symbol =
  #| () => Symbol.iterator

///|
/// JS: Symbol.asyncIterator
pub extern "js" fn Symbol::asyncIterator() -> Symbol =
  #| () => Symbol.asyncIterator

///|
/// JS: Symbol.dispose
pub extern "js" fn Symbol::dispose() -> Symbol =
  #| () => Symbol.dispose

///|
/// JS: Symbol.asyncDispose
pub extern "js" fn Symbol::asyncDispose() -> Symbol =
  #| () => Symbol.asyncDispose

///|
/// JS: Symbol.asyncDispose
pub extern "js" fn Symbol::toStringTag() -> Symbol =
  #| () => Symbol.toStringTag
