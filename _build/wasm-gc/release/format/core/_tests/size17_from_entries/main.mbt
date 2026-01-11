///|
/// Convert Array of tuples to JS Object using Object.fromEntries
/// FFI directly converts {_0, _1} tuples to [key, value] arrays
pub extern "js" fn from_entries(
  entries : Array[(String, @core.Any)],
) -> @core.Any =
  #| (entries) => Object.fromEntries(entries.map(e => [e._0, e._1]))

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
  let obj = from_entries(entries)
  console_log(obj)
}
