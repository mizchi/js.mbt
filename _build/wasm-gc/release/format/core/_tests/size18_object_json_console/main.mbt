///|
fn main {
  // Test Object methods
  let obj = @core.from_entries([
    ("name", @core.any("Alice")),
    ("age", @core.any(30)),
  ])

  // Object.keys/values/entries
  let keys = @core.object_keys(obj)
  @core.log(@core.any(keys))
  let values = @core.object_values(obj)
  @core.log(@core.any(values))

  // Object.hasOwn
  let has_name = @core.object_has_own(obj, "name")
  @core.log(@core.any(has_name))

  // JSON.stringify/parse
  let json_str = @core.json_stringify(obj)
  @core.log(@core.any(json_str))
  let json_pretty = @core.json_stringify_pretty(obj, 2)
  @core.log(@core.any(json_pretty))
  let parsed = @core.json_parse(json_str)
  @core.log(parsed)
}
