///|
pub struct Point {
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
  let obj = @core.from_entries([
    ("name", @core.nullable(name)),
    ("age", @core.nullable(age)),
    ("point", @core.nullable(point)),
    ("missing", @core.nullable(missing)),
  ])
  @core.console_log(obj)
  @core.console_log(@core.any(@core.json_stringify(obj)))

  // Inline usage
  let obj2 = @core.from_entries([
    ("a", @core.nullable(Some(1))),
    ("b", @core.nullable(Some("hello"))),
    ("c", @core.nullable((None : Int?))),
  ])
  @core.console_log(obj2)
  @core.console_log(@core.any(@core.json_stringify(obj2)))
}
