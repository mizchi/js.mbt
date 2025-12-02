///|
fn main {
  // Test Object methods
  let obj = @core.from_entries([
    ("name", @core.any("Alice")),
    ("age", @core.any(30)),
  ])

  // Object.keys/values/entries
  let keys = @core.Object::keys(obj)
  @core.console_log(@core.any(keys))
  let values = @core.Object::values(obj)
  @core.console_log(@core.any(values))
  let entries = @core.Object::entries(obj)
  @core.console_log(@core.any(entries))

  // Object.hasOwn
  let has_name = @core.Object::has_own(obj, "name")
  @core.console_log(@core.any(has_name))

  // JSON.stringify/parse
  let json_str = @core.json_stringify(obj)
  @core.console_log(@core.any(json_str))
  let json_pretty = @core.json_stringify_pretty(obj, 2)
  @core.console_log(@core.any(json_pretty))
  let parsed = @core.json_parse(json_str)
  @core.console_log(parsed)

  // console variants
  @core.console_info(@core.any("info message"))
  @core.console_warn(@core.any("warn message"))
  @core.console_error(@core.any("error message"))
}
