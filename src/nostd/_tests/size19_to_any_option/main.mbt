///|
struct Point {
  x : Int
  y : Int
}

///|
fn main {
  // Test nullable with various types
  let name : String? = Some("Alice")
  let age : Int? = Some(30)
  let point : Point? = Some({ x: 10, y: 20 })
  let missing : String? = None

  // Direct usage with from_entries - clean syntax
  let obj = @nostd.from_entries([
    ("name", @nostd.nullable(name)),
    ("age", @nostd.nullable(age)),
    ("point", @nostd.nullable(point)),
    ("missing", @nostd.nullable(missing)),
  ])
  @nostd.console_log(obj)
  @nostd.console_log(@nostd.any(@nostd.json_stringify(obj)))

  // Inline usage
  let obj2 = @nostd.from_entries([
    ("a", @nostd.nullable(Some(1))),
    ("b", @nostd.nullable(Some("hello"))),
    ("c", @nostd.nullable((None : Int?))),
  ])
  @nostd.console_log(obj2)
  @nostd.console_log(@nostd.any(@nostd.json_stringify(obj2)))
}
