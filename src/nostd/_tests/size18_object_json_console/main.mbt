///|
fn main {
  // Test Object methods
  let obj = @nostd.from_entries([
    ("name", @nostd.any("Alice")),
    ("age", @nostd.any(30)),
  ])

  // Object.keys/values/entries
  let keys = @nostd.Object::keys(obj)
  @nostd.console_log(@nostd.any(keys))
  let values = @nostd.Object::values(obj)
  @nostd.console_log(@nostd.any(values))
  let entries = @nostd.Object::entries(obj)
  @nostd.console_log(@nostd.any(entries))

  // Object.hasOwn
  let has_name = @nostd.Object::has_own(obj, "name")
  @nostd.console_log(@nostd.any(has_name))

  // JSON.stringify/parse
  let json_str = @nostd.json_stringify(obj)
  @nostd.console_log(@nostd.any(json_str))
  let json_pretty = @nostd.json_stringify_pretty(obj, 2)
  @nostd.console_log(@nostd.any(json_pretty))
  let parsed = @nostd.json_parse(json_str)
  @nostd.console_log(parsed)

  // console variants
  @nostd.console_info(@nostd.any("info message"))
  @nostd.console_warn(@nostd.any("warn message"))
  @nostd.console_error(@nostd.any("error message"))
}
