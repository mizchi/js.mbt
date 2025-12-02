///|
/// Convert Array of (key, value) tuples to JS Object
pub fn from_tuple_array(entries : Array[(String, @core.Any)]) -> @core.Any {
  let obj = @core.Object::new()
  for entry in entries {
    let (k, v) = entry
    obj[k] = v
  }
  obj
}

///|
extern "js" fn console_log(v : @core.Any) -> Unit =
  #| (v) => console.log(v)

///|
fn main {
  let entries : Array[(String, @core.Any)] = [
    ("name", @core.any("Alice")),
    ("age", @core.any(30)),
    ("active", @core.any(true)),
  ]
  let obj = from_tuple_array(entries)
  console_log(obj)
}
