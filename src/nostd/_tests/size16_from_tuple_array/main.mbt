///|
/// Convert Array of (key, value) tuples to JS Object
pub fn from_tuple_array(entries : Array[(String, @nostd.Any)]) -> @nostd.Any {
  let obj = @nostd.Object::new()
  for entry in entries {
    let (k, v) = entry
    obj[k] = v
  }
  obj
}

///|
extern "js" fn console_log(v : @nostd.Any) -> Unit =
  #| (v) => console.log(v)

///|
fn main {
  let entries : Array[(String, @nostd.Any)] = [
    ("name", @nostd.any("Alice")),
    ("age", @nostd.any(30)),
    ("active", @nostd.any(true)),
  ]
  let obj = from_tuple_array(entries)
  console_log(obj)
}
