///| zod v4 JSON Schema conversion bindings
/// Uses zod's built-in toJSONSchema function

///|
fn zod_module() -> @js.Any {
  @node.require("zod")
}

///|
/// Convert a ZodSchema to JSON Schema (zod v4 built-in)
pub fn to_json_schema(schema : @zod.ZodSchema) -> @js.Any {
  let schema_any : @js.Any = schema.to_any() |> @nostd.identity()
  zod_module().call1("toJSONSchema", schema_any)
}

///|
/// Convert a ZodSchema to JSON Schema with options
pub fn to_json_schema_with_options(
  schema : @zod.ZodSchema,
  name? : String,
  io? : String,
  unrepresentable? : String,
  override_? : @js.Any,
) -> @js.Any {
  let opts = @js.Object::new()
  match name {
    Some(v) => opts.set("name", v)
    None => ()
  }
  match io {
    Some(v) => opts.set("io", v)
    None => ()
  }
  match unrepresentable {
    Some(v) => opts.set("unrepresentable", v)
    None => ()
  }
  match override_ {
    Some(v) => opts.set("override", v)
    None => ()
  }
  let schema_any : @js.Any = schema.to_any() |> @nostd.identity()
  zod_module().call2("toJSONSchema", schema_any, opts.to_any())
}

///|
/// JSON Schema type representation
pub struct JsonSchema {
  raw : @js.Any
}

///|
pub fn JsonSchema::from_zod(schema : @zod.ZodSchema) -> JsonSchema {
  { raw: to_json_schema(schema) }
}

///|
pub fn JsonSchema::from_zod_with_name(
  schema : @zod.ZodSchema,
  name : String,
) -> JsonSchema {
  { raw: to_json_schema_with_options(schema, name~) }
}

///|
/// Create JsonSchema from raw @js.Any value
pub fn JsonSchema::from_any(raw : @js.Any) -> JsonSchema {
  { raw, }
}

///|
pub fn JsonSchema::to_any(self : JsonSchema) -> @js.Any {
  self.raw
}

///|
pub fn JsonSchema::to_json(self : JsonSchema) -> String {
  @js.JSON::stringify(self.raw)
}

///|
pub fn JsonSchema::type_(self : JsonSchema) -> String? {
  let t = self.raw.get("type")
  if @js.is_undefined(t) {
    None
  } else {
    Some(t.cast())
  }
}

///|
pub fn JsonSchema::properties(self : JsonSchema) -> @js.Any {
  self.raw.get("properties")
}

///|
pub fn JsonSchema::required(self : JsonSchema) -> Array[String] {
  let req = self.raw.get("required")
  if @js.is_undefined(req) || @js.is_null(req) {
    []
  } else {
    @js.identity(req)
  }
}

///|
pub fn JsonSchema::items(self : JsonSchema) -> JsonSchema? {
  let items = self.raw.get("items")
  if @js.is_undefined(items) {
    None
  } else {
    Some({ raw: items })
  }
}

///|
pub fn JsonSchema::definitions(self : JsonSchema) -> @js.Any {
  let defs = self.raw.get("definitions")
  if @js.is_undefined(defs) {
    self.raw.get("$defs")
  } else {
    defs
  }
}

///|
pub fn JsonSchema::ref_(self : JsonSchema) -> String? {
  let r = self.raw.get("$ref")
  if @js.is_undefined(r) {
    None
  } else {
    Some(r.cast())
  }
}

///|
pub fn JsonSchema::any_of(self : JsonSchema) -> Array[JsonSchema]? {
  let any = self.raw.get("anyOf")
  if @js.is_undefined(any) {
    None
  } else {
    let arr : Array[@js.Any] = @js.identity(any)
    Some(arr.map(fn(x) { { raw: x } }))
  }
}

///|
pub fn JsonSchema::enum_values(self : JsonSchema) -> Array[String]? {
  let e = self.raw.get("enum")
  if @js.is_undefined(e) {
    None
  } else {
    Some(@js.identity(e))
  }
}

///|
pub fn JsonSchema::const_value(self : JsonSchema) -> @js.Any? {
  let c = self.raw.get("const")
  if @js.is_undefined(c) {
    None
  } else {
    Some(c)
  }
}

///|
pub fn JsonSchema::minimum(self : JsonSchema) -> Double? {
  let m = self.raw.get("minimum")
  if @js.is_undefined(m) {
    None
  } else {
    Some(m.cast())
  }
}

///|
pub fn JsonSchema::maximum(self : JsonSchema) -> Double? {
  let m = self.raw.get("maximum")
  if @js.is_undefined(m) {
    None
  } else {
    Some(m.cast())
  }
}

///|
pub fn JsonSchema::min_length(self : JsonSchema) -> Int? {
  let m = self.raw.get("minLength")
  if @js.is_undefined(m) {
    None
  } else {
    Some(m.cast())
  }
}

///|
pub fn JsonSchema::max_length(self : JsonSchema) -> Int? {
  let m = self.raw.get("maxLength")
  if @js.is_undefined(m) {
    None
  } else {
    Some(m.cast())
  }
}

///|
pub fn JsonSchema::format(self : JsonSchema) -> String? {
  let f = self.raw.get("format")
  if @js.is_undefined(f) {
    None
  } else {
    Some(f.cast())
  }
}

///|
pub fn JsonSchema::description(self : JsonSchema) -> String? {
  let d = self.raw.get("description")
  if @js.is_undefined(d) {
    None
  } else {
    Some(d.cast())
  }
}

///|
pub fn JsonSchema::default_value(self : JsonSchema) -> @js.Any? {
  let d = self.raw.get("default")
  if @js.is_undefined(d) {
    None
  } else {
    Some(d)
  }
}

///|
pub fn JsonSchema::additional_properties(self : JsonSchema) -> JsonSchema? {
  let ap = self.raw.get("additionalProperties")
  if @js.is_undefined(ap) || @js.is_null(ap) {
    None
  } else if @js.typeof_(ap) == "boolean" {
    None
  } else {
    Some({ raw: ap })
  }
}
