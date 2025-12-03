///| Types

///| Global Functions

///|
extern "js" fn ffi_console_log(values : Array[Any]) -> Unit =
  #| (values) => console.log(...values)

///| String and Encoding

///| JSON

///|
extern "js" fn ffi_json_stringify(
  value : @core.Any,
  replacer : @core.Any,
  space : @core.Any,
) -> String =
  #| (value, replacer, space) => JSON.stringify(value, replacer, space)

///|
extern "js" fn ffi_json_parse(json : String, reviver? : @core.Any) -> @core.Any =
  #| (json, reviver) => JSON.parse(json, reviver)

///| Timers
