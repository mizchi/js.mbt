///|
/// Convert MoonBit Array to JS Array (zero-cost via %identity)
/// This works because MoonBit arrays are already JS arrays at runtime
pub fn[T] from_array(arr : Array[T]) -> @nostd.Any = "%identity"

///|
extern "js" fn console_log(v : @nostd.Any) -> Unit =
  #| (v) => console.log(v)

///|
extern "js" fn array_length(arr : @nostd.Any) -> Int =
  #| (arr) => arr.length

///|
extern "js" fn array_join(arr : @nostd.Any, sep : String) -> String =
  #| (arr, sep) => arr.join(sep)

///|
fn main {
  // Test from_array with strings
  let arr : Array[String] = ["hello", "world", "moonbit"]
  let js_arr = from_array(arr)
  console_log(js_arr)

  // Verify it's a real JS array
  let len = array_length(js_arr)
  console_log(@nostd.any(len))

  // Use JS array methods
  let joined = array_join(js_arr, ", ")
  console_log(@nostd.any(joined))

  // Test from_array with integers
  let nums : Array[Int] = [1, 2, 3, 4, 5]
  let js_nums = from_array(nums)
  console_log(js_nums)

  // Test from_array with Any values
  let mixed : Array[@nostd.Any] = [
    @nostd.any(1),
    @nostd.any("two"),
    @nostd.any(true),
  ]
  let js_mixed = from_array(mixed)
  console_log(js_mixed)
}
