///| MoonBit code generator from JSON Schema

///|
/// Generated type info
pub struct GeneratedType {
  /// Generated type name (e.g., "User_address_city")
  name : String
  /// Source path from root (e.g., ["address", "city"])
  path : Array[String]
  /// Generated MoonBit code
  code : String
}

///|
/// Internal context for code generation with nested types
priv struct CodegenContext {
  config : CodegenConfig
  /// Current path from root type
  current_path : Array[String]
  /// Accumulated nested types during generation
  nested_types : Array[GeneratedType]
}

///|
/// Code generator configuration
pub struct CodegenConfig {
  /// Prefix for generated types
  type_prefix : String
  /// Whether to generate derive macros
  derive_json : Bool
  /// Add description as doc comments
  add_docs : Bool
}

///|
pub fn CodegenConfig::default() -> CodegenConfig {
  { type_prefix: "", derive_json: false, add_docs: true }
}

///|
/// Convert JSON Schema type to MoonBit type (simple version without context)
fn json_type_to_moonbit(schema : JsonSchema) -> String {
  json_type_to_moonbit_ctx(schema, None, "")
}

///|
/// Handle $ref - extract type name from reference path
fn handle_ref(ref_ : String) -> String {
  let parts : Array[String] = ref_
    .split("/")
    .map(fn(s) { s.to_string() })
    .collect()
  parts[parts.length() - 1]
}

///|
/// Handle anyOf (union types) - check if nullable
fn handle_any_of(
  variants : Array[JsonSchema],
  ctx : CodegenContext?,
  root_name : String,
) -> String {
  let non_null = variants.filter(fn(v) {
    match v.type_() {
      Some("null") => false
      _ => true
    }
  })
  // T | null pattern -> optional type
  if non_null.length() == 1 && variants.length() == 2 {
    json_type_to_moonbit_ctx(non_null[0], ctx, root_name) + "?"
  } else {
    "@js.Any"
  }
}

///|
/// Handle object type with context for nested struct generation
fn handle_object_type(
  schema : JsonSchema,
  ctx : CodegenContext?,
  root_name : String,
) -> String {
  guard ctx is Some(context) else { return "@js.Any" }
  let props = schema.properties()
  guard not(@js.is_undefined(props)) else { return "@js.Any" }
  // Build type name from path: Root_field1_field2
  let type_name = build_type_name(root_name, context.current_path)
  let path = context.current_path.copy()
  // Generate nested struct
  let code = generate_struct_ctx(schema, type_name, root_name, context)
  context.nested_types.push({ name: type_name, path, code })
  context.config.type_prefix + type_name
}

///|
/// Handle primitive and complex types based on JSON Schema type field
fn handle_type(
  schema : JsonSchema,
  type_name : String,
  ctx : CodegenContext?,
  root_name : String,
) -> String {
  match type_name {
    "string" => "String"
    "number" => "Double"
    "integer" => "Int"
    "boolean" => "Bool"
    "null" => "Unit"
    "array" =>
      match schema.items() {
        Some(items) =>
          "Array[" + json_type_to_moonbit_ctx(items, ctx, root_name) + "]"
        None => "Array[@js.Any]"
      }
    "object" => handle_object_type(schema, ctx, root_name)
    _ => "@js.Any"
  }
}

///|
/// Convert JSON Schema type to MoonBit type with context for nested object generation
fn json_type_to_moonbit_ctx(
  schema : JsonSchema,
  ctx : CodegenContext?,
  root_name : String,
) -> String {
  // 1. Check for $ref
  if schema.ref_() is Some(ref_) {
    return handle_ref(ref_)
  }
  // 2. Check for anyOf (union types)
  if schema.any_of() is Some(variants) {
    return handle_any_of(variants, ctx, root_name)
  }
  // 3. Check for enum
  if schema.enum_values() is Some(_) {
    return "String"
  }
  // 4. Check for const
  if schema.const_value() is Some(_) {
    return "@js.Any"
  }
  // 5. Handle regular type
  match schema.type_() {
    Some(t) => handle_type(schema, t, ctx, root_name)
    None => "@js.Any"
  }
}

///|
/// Build type name from root name and path (e.g., "User" + ["address", "city"] -> "User_address_city")
fn build_type_name(root_name : String, path : Array[String]) -> String {
  if path.is_empty() {
    root_name
  } else {
    root_name + "_" + path.join("_")
  }
}

///|
/// Generate a MoonBit struct from JSON Schema object (internal with context)
fn generate_struct_ctx(
  schema : JsonSchema,
  name : String,
  root_name : String,
  ctx : CodegenContext,
) -> String {
  let config = ctx.config
  let mut code = ""
  // Add doc comment if available
  if config.add_docs {
    match schema.description() {
      Some(desc) => code = code + "/// " + desc + "\n"
      None => ()
    }
  }
  code = code + "pub struct " + config.type_prefix + name + " {\n"
  // Get properties
  let props = schema.properties()
  if not(@js.is_undefined(props)) {
    let required = schema.required()
    let keys : Array[String] = @js.Object::keys(props) |> @js.identity
    for key in keys {
      let prop_schema = JsonSchema::from_any(props.get(key))
      let field_name = to_snake_case(key)
      // Push field to path before processing nested object
      ctx.current_path.push(key)
      let mut field_type = json_type_to_moonbit_ctx(
        prop_schema,
        Some(ctx),
        root_name,
      )
      // Pop field from path after processing
      let _ = ctx.current_path.pop()
      // Check if field is optional
      let is_required = required.contains(key)
      if not(is_required) && not(field_type.has_suffix("?")) {
        field_type = field_type + "?"
      }
      // Add field doc comment
      if config.add_docs {
        match prop_schema.description() {
          Some(desc) => code = code + "  /// " + desc + "\n"
          None => ()
        }
      }
      // Add field
      if field_name != key {
        // Need @json.field annotation for different names
        code = code +
          "  #json(name=\"" +
          key +
          "\")\n  " +
          field_name +
          " : " +
          field_type +
          "\n"
      } else {
        code = code + "  " + field_name + " : " + field_type + "\n"
      }
    }
  }
  code = code + "}"
  // Add derive clause after struct definition
  if config.derive_json {
    code = code + " derive(ToJson, @json.FromJson)"
  }
  code + "\n"
}

///|
/// Generate a MoonBit struct from JSON Schema object
pub fn generate_struct(
  schema : JsonSchema,
  name : String,
  config : CodegenConfig,
) -> String {
  let ctx : CodegenContext = { config, current_path: [], nested_types: [] }
  generate_struct_ctx(schema, name, name, ctx)
}

///|
/// Generate MoonBit code from a zod schema (single struct, no nested types)
pub fn generate_from_zod(
  schema : @zod.ZodSchema,
  name : String,
  config? : CodegenConfig = CodegenConfig::default(),
) -> String {
  let json_schema = JsonSchema::from_zod_with_name(schema, name)
  generate_struct(json_schema, name, config)
}

///|
/// Generate MoonBit code from a zod schema with nested types
pub fn generate_from_zod_nested(
  schema : @zod.ZodSchema,
  name : String,
  config? : CodegenConfig = CodegenConfig::default(),
) -> Array[GeneratedType] {
  let json_schema = JsonSchema::from_zod_with_name(schema, name)
  let ctx : CodegenContext = { config, current_path: [], nested_types: [] }
  let root_code = generate_struct_ctx(json_schema, name, name, ctx)
  // Return nested types first, then root type
  let result : Array[GeneratedType] = []
  for t in ctx.nested_types {
    result.push(t)
  }
  result.push({ name, path: [], code: root_code })
  result
}

///|
/// Generate multiple types from a schema with definitions
pub fn generate_all_types(
  schema : JsonSchema,
  root_name : String,
  config? : CodegenConfig = CodegenConfig::default(),
) -> Array[GeneratedType] {
  let types : Array[GeneratedType] = []
  // Generate definitions first
  let defs = schema.definitions()
  if not(@js.is_undefined(defs)) && not(@js.is_null(defs)) {
    let keys : Array[String] = @js.Object::keys(defs) |> @js.identity
    for key in keys {
      let def_schema = JsonSchema::from_any(defs.get(key))
      let code = generate_struct(def_schema, key, config)
      types.push({ name: key, path: [], code })
    }
  }
  // Generate root type
  let root_code = generate_struct(schema, root_name, config)
  types.push({ name: root_name, path: [], code: root_code })
  types
}

///|
/// Convert camelCase or PascalCase to snake_case
fn to_snake_case(s : String) -> String {
  let mut result = ""
  let chars = s.to_array()
  for i, c in chars {
    if c >= 'A' && c <= 'Z' {
      if i > 0 {
        result = result + "_"
      }
      result = result + Char::to_string((c.to_int() + 32).unsafe_to_char())
    } else {
      result = result + Char::to_string(c)
    }
  }
  result
}

///|
/// Generate a complete .mbt file content
pub fn generate_file(
  types : Array[GeneratedType],
  package_doc? : String,
) -> String {
  let mut code = ""
  match package_doc {
    Some(doc) => code = "///| " + doc + "\n\n"
    None => ()
  }
  for t in types {
    code = code + "///|\n" + t.code + "\n"
  }
  code
}
