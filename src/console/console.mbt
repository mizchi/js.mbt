///|
using @js {type Val, js, unsafe_cast}

///|
pub extern "js" fn console_log(value : Val) -> Unit =
  #| (value) => console.log(value)

///|
pub extern "js" fn console_warn(value : Val) -> Unit =
  #| (value) => console.warn(value)

///|
pub extern "js" fn console_error(value : Val) -> Unit =
  #| (value) => console.error(value)

///|
pub extern "js" fn console_info(value : Val) -> Unit =
  #| (value) => console.info(value)

///|
pub extern "js" fn console_debug(value : Val) -> Unit =
  #| (value) => console.debug(value)

///|
pub extern "js" fn console_trace(value : Val) -> Unit =
  #| (value) => console.trace(value)

///|
pub extern "js" fn console_dir(value : Val) -> Unit =
  #| (value) => console.dir(value)

///|
pub extern "js" fn console_table(value : Val, keys : Array[String]) -> Unit =
  #| (value, keys) => console.table(value, keys)

///|
pub extern "js" fn console_assert(condition : Bool, value : Val) -> Unit =
  #| (condition, value) => console.assert(condition, value)

///|
pub extern "js" fn console_clear() -> Unit =
  #| () => console.clear()

///|
pub extern "js" fn console_count(label : String) -> Unit =
  #| (label) => console.count(label)

///|
pub extern "js" fn console_count_reset(label : String) -> Unit =
  #| (label) => console.countReset(label)

///|
pub extern "js" fn console_group(label : String) -> Unit =
  #| (label) => console.group(label)

///|
pub extern "js" fn console_group_end() -> Unit =
  #| () => console.groupEnd()

///|
pub extern "js" fn console_time(label : String) -> Unit =
  #| (label) => console.time(label)

///|
pub extern "js" fn console_time_end(label : String) -> Unit =
  #| (label) => console.timeEnd(label)
