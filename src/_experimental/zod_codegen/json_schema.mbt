///| zod v4 JSON Schema conversion bindings
/// Uses zod's built-in toJSONSchema function

///|
#module("zod")
extern "js" fn ffi_to_json_schema(schema : @core.Any) -> @core.Any = "toJSONSchema"

///|
/// Convert a ZodSchema to JSON Schema (zod v4 built-in)
pub fn to_json_schema(schema : @zod.ZodSchema) -> @core.Any {
  let schema_any : @core.Any = schema.as_any() |> @core.identity()
  ffi_to_json_schema(schema_any)
}

///|
#module("zod")
extern "js" fn ffi_to_json_schema_with_opts(
  schema : @core.Any,
  opts : @core.Any,
) -> @core.Any = "toJSONSchema"

///|
/// Convert a ZodSchema to JSON Schema with options
pub fn to_json_schema_with_options(
  schema : @zod.ZodSchema,
  name? : String,
  io? : String,
  unrepresentable? : String,
  override_? : @core.Any,
) -> @core.Any {
  let opts = @core.new_object()
  match name {
    Some(v) => opts._set("name", v |> @core.any)
    None => ()
  }
  match io {
    Some(v) => opts._set("io", v |> @core.any)
    None => ()
  }
  match unrepresentable {
    Some(v) => opts._set("unrepresentable", v |> @core.any)
    None => ()
  }
  match override_ {
    Some(v) => opts._set("override", v)
    None => ()
  }
  let schema_any : @core.Any = schema.as_any() |> @core.identity()
  ffi_to_json_schema_with_opts(schema_any, opts)
}

///|
/// JSON Schema type representation
pub struct JsonSchema {
  raw : @core.Any
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
/// Create JsonSchema from raw @core.Any value
pub fn JsonSchema::from_any(raw : @core.Any) -> JsonSchema {
  { raw, }
}

///|
pub fn JsonSchema::as_any(self : JsonSchema) -> @core.Any {
  self.raw
}

///|
pub fn JsonSchema::to_json(self : JsonSchema) -> String {
  @js.JSON::stringify(self.raw)
}

///|
pub fn JsonSchema::type_(self : JsonSchema) -> String? {
  let t = self.raw._get("type")
  if @core.is_undefined(t) {
    None
  } else {
    Some(t.cast())
  }
}

///|
pub fn JsonSchema::properties(self : JsonSchema) -> @core.Any {
  self.raw._get("properties")
}

///|
pub fn JsonSchema::required(self : JsonSchema) -> Array[String] {
  let req = self.raw._get("required")
  if @core.is_undefined(req) || @core.is_null(req) {
    []
  } else {
    @core.identity(req)
  }
}

///|
pub fn JsonSchema::items(self : JsonSchema) -> JsonSchema? {
  let items = self.raw._get("items")
  if @core.is_undefined(items) {
    None
  } else {
    Some({ raw: items })
  }
}

///|
pub fn JsonSchema::definitions(self : JsonSchema) -> @core.Any {
  let defs = self.raw._get("definitions")
  if @core.is_undefined(defs) {
    self.raw._get("$defs")
  } else {
    defs
  }
}

///|
pub fn JsonSchema::ref_(self : JsonSchema) -> String? {
  let r = self.raw._get("$ref")
  if @core.is_undefined(r) {
    None
  } else {
    Some(r.cast())
  }
}

///|
pub fn JsonSchema::any_of(self : JsonSchema) -> Array[JsonSchema]? {
  let any = self.raw._get("anyOf")
  if @core.is_undefined(any) {
    None
  } else {
    let arr : Array[@core.Any] = @core.identity(any)
    Some(arr.map(fn(x) { { raw: x } }))
  }
}

///|
pub fn JsonSchema::enum_values(self : JsonSchema) -> Array[String]? {
  let e = self.raw._get("enum")
  if @core.is_undefined(e) {
    None
  } else {
    Some(@core.identity(e))
  }
}

///|
pub fn JsonSchema::const_value(self : JsonSchema) -> @core.Any? {
  let c = self.raw._get("const")
  if @core.is_undefined(c) {
    None
  } else {
    Some(c)
  }
}

///|
pub fn JsonSchema::minimum(self : JsonSchema) -> Double? {
  let m = self.raw._get("minimum")
  if @core.is_undefined(m) {
    None
  } else {
    Some(m.cast())
  }
}

///|
pub fn JsonSchema::maximum(self : JsonSchema) -> Double? {
  let m = self.raw._get("maximum")
  if @core.is_undefined(m) {
    None
  } else {
    Some(m.cast())
  }
}

///|
pub fn JsonSchema::min_length(self : JsonSchema) -> Int? {
  let m = self.raw._get("minLength")
  if @core.is_undefined(m) {
    None
  } else {
    Some(m.cast())
  }
}

///|
pub fn JsonSchema::max_length(self : JsonSchema) -> Int? {
  let m = self.raw._get("maxLength")
  if @core.is_undefined(m) {
    None
  } else {
    Some(m.cast())
  }
}

///|
pub fn JsonSchema::format(self : JsonSchema) -> String? {
  let f = self.raw._get("format")
  if @core.is_undefined(f) {
    None
  } else {
    Some(f.cast())
  }
}

///|
pub fn JsonSchema::description(self : JsonSchema) -> String? {
  let d = self.raw._get("description")
  if @core.is_undefined(d) {
    None
  } else {
    Some(d.cast())
  }
}

///|
pub fn JsonSchema::default_value(self : JsonSchema) -> @core.Any? {
  let d = self.raw._get("default")
  if @core.is_undefined(d) {
    None
  } else {
    Some(d)
  }
}

///|
pub fn JsonSchema::additional_properties(self : JsonSchema) -> JsonSchema? {
  let ap = self.raw._get("additionalProperties")
  if @core.is_undefined(ap) || @core.is_null(ap) {
    None
  } else if @core.typeof_(ap) == "boolean" {
    None
  } else {
    Some({ raw: ap })
  }
}
