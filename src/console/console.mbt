///|
/// JS: console.log(value)
/// https://developer.mozilla.org/ja/docs/Web/API/console/log_static
pub fn log(value : &@js.JsImpl) -> Unit {
  log_impl(value.to_js())
}

///|
extern "js" fn log_impl(value : @js.Js) -> Unit =
  #| (value) => console.log(value)

///|
/// JS: console.warn(value)
/// https://developer.mozilla.org/ja/docs/Web/API/console/warn_static
pub fn warn(value : &@js.JsImpl) -> Unit {
  warn_impl(value.to_js())
}

///|
extern "js" fn warn_impl(value : @js.Js) -> Unit =
  #| (value) => console.warn(value)

///|
/// JS: console.error(value)
/// https://developer.mozilla.org/ja/docs/Web/API/console/error_static
pub fn error(value : &@js.JsImpl) -> Unit {
  error_impl(value.to_js())
}

///|
extern "js" fn error_impl(value : @js.Js) -> Unit =
  #| (value) => console.error(value)

///|
/// JS: console.info(value)
/// https://developer.mozilla.org/ja/docs/Web/API/console/info_static
pub fn info(value : &@js.JsImpl) -> Unit {
  info_impl(value.to_js())
}

///|
extern "js" fn info_impl(value : @js.Js) -> Unit =
  #| (value) => console.info(value)

///|
/// JS: console.debug(value)
/// https://developer.mozilla.org/ja/docs/Web/API/console/debug_static
pub fn debug(value : &@js.JsImpl) -> Unit {
  debug_impl(value.to_js())
}

///|
extern "js" fn debug_impl(value : @js.Js) -> Unit =
  #| (value) => console.debug(value)

///|
/// JS: console.trace(value)
pub fn trace(value : &@js.JsImpl) -> Unit {
  trace_impl(value.to_js())
}

///|
extern "js" fn trace_impl(value : @js.Js) -> Unit =
  #| (value) => console.trace(value)

///|
/// JS: console.dir(value)
pub fn dir(value : &@js.JsImpl) -> Unit {
  dir_impl(value.to_js())
}

///|
extern "js" fn dir_impl(value : @js.Js) -> Unit =
  #| (value) => console.dir(value)

///|
/// JS: console.table(value, keys)
pub fn table(value : &@js.JsImpl, keys : Array[String]) -> Unit {
  table_impl(value.to_js(), keys)
}

///|
extern "js" fn table_impl(value : @js.Js, keys : Array[String]) -> Unit =
  #| (value, keys) => console.table(value, keys)

///|
/// JS: console.assert(condition, value)
pub fn assert_(condition : Bool, value : &@js.JsImpl) -> Unit {
  assert_impl(condition, value.to_js())
}

///|
extern "js" fn assert_impl(condition : Bool, value : @js.Js) -> Unit =
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
