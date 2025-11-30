///|
/// Convert Array of tuples to JS Object using Object.fromEntries
/// FFI directly converts {_0, _1} tuples to [key, value] arrays
pub extern "js" fn from_entries(
  entries : Array[(String, @nostd.Any)],
) -> @nostd.Any =
  #| (entries) => Object.fromEntries(entries.map(e => [e._0, e._1]))

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
  let obj = from_entries(entries)
  console_log(obj)
}
