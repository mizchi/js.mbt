///|
extern "js" fn console_log(v : String) -> Unit =
  #| (v) => console.log(v)

///|
extern "js" fn get_test_values() -> @core.Any =
  #| () => ({ str: "hello", num: 42, bool: true, nil: null, undef: undefined, arr: [1, 2, 3], obj: { a: 1 } })

///|
fn main {
  let obj = get_test_values()
  // Test to_string on various values
  console_log("str: " + obj["str"].to_string())
  console_log("num: " + obj["num"].to_string())
  console_log("bool: " + obj["bool"].to_string())
  console_log("nil: " + obj["nil"].to_string())
  console_log("undef: " + obj["undef"].to_string())
  console_log("arr: " + obj["arr"].to_string())
  console_log("obj: " + obj["obj"].to_string())
  // Test Show trait via println
  println(obj["str"])
  println(obj["num"])
  println(obj["nil"])
}
