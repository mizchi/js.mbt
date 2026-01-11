///|
/// JS: console.log(value)
/// https://developer.mozilla.org/ja/docs/Web/API/console/log_static
pub extern "js" fn log(value : @core.Any) -> Unit =
  #| (value) => console.log(value)

///|
/// JS: console.warn(value)
/// https://developer.mozilla.org/ja/docs/Web/API/console/warn_static
pub extern "js" fn warn(value : @core.Any) -> Unit =
  #| (value) => console.warn(value)

///|
/// JS: console.error(value)
/// https://developer.mozilla.org/ja/docs/Web/API/console/error_static
pub extern "js" fn error(value : @core.Any) -> Unit =
  #| (value) => console.error(value)

///|
/// JS: console.info(value)
/// https://developer.mozilla.org/ja/docs/Web/API/console/info_static
pub extern "js" fn info(value : @core.Any) -> Unit =
  #| (value) => console.info(value)

///|
/// JS: console.debug(value)
/// https://developer.mozilla.org/ja/docs/Web/API/console/debug_static
pub extern "js" fn debug(value : @core.Any) -> Unit =
  #| (value) => console.debug(value)

///|
/// JS: console.trace(value)
pub extern "js" fn trace(value : @core.Any) -> Unit =
  #| (value) => console.trace(value)

///|
/// JS: console.dir(value)
pub extern "js" fn dir(value : @core.Any) -> Unit =
  #| (value) => console.dir(value)

///|
/// JS: console.table(value, keys)
pub extern "js" fn table(value : @core.Any, keys : Array[String]) -> Unit =
  #| (value, keys) => console.table(value, keys)

///|
/// JS: console.assert(condition, value)
pub extern "js" fn assert_(condition : Bool, value : @core.Any) -> Unit =
  #| (condition, value) => console.assert(condition, value)

///|
/// JS: console.clear()
pub extern "js" fn clear() -> Unit =
  #| () => console.clear()

///|
/// JS: console.count(label)
pub extern "js" fn count(label : String) -> Unit =
  #| (label) => console.count(label)

///|
/// JS: console.countReset(label)
pub extern "js" fn countReset(label : String) -> Unit =
  #| (label) => console.countReset(label)

///|
/// JS: console.group(label)
pub extern "js" fn group(label : String) -> Unit =
  #| (label) => console.group(label)

///|
/// JS: console.groupEnd()
pub extern "js" fn groupEnd() -> Unit =
  #| () => console.groupEnd()

///|
/// JS: console.time(label)
pub extern "js" fn time(label : String) -> Unit =
  #| (label) => console.time(label)

///|
/// JS: console.timeEnd(label)
pub extern "js" fn timeEnd(label : String) -> Unit =
  #| (label) => console.timeEnd(label)
