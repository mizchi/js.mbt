///| MoonBit code generator from JSON Schema

///|
/// Generated type info
pub struct GeneratedType {
  name : String
  code : String
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
  { type_prefix: "", derive_json: true, add_docs: true }
}

///|
/// Convert JSON Schema type to MoonBit type
fn json_type_to_moonbit(schema : JsonSchema) -> String {
  // Check for $ref first
  match schema.ref_() {
    Some(ref_) => {
      // Extract type name from $ref like "#/definitions/User" or "#/$defs/User"
      let parts : Array[String] = ref_
        .split("/")
        .map(fn(s) { s.to_string() })
        .collect()
      parts[parts.length() - 1]
    }
    None =>
      // Check for anyOf (union types)
      match schema.any_of() {
        Some(variants) => {
          // Check if it's a nullable type (anyOf with null)
          let non_null = variants.filter(fn(v) {
            match v.type_() {
              Some("null") => false
              _ => true
            }
          })
          if non_null.length() == 1 && variants.length() == 2 {
            // It's T | null, make it optional
            json_type_to_moonbit(non_null[0]) + "?"
          } else {
            // Complex union - use @js.Any for now
            "@js.Any"
          }
        }
        None =>
          // Check for enum
          match schema.enum_values() {
            Some(_) =>
              // Enum values - would need to generate a separate enum type
              "String"
            None =>
              // Check for const
              match schema.const_value() {
                Some(_) =>
                  // Literal type
                  "@js.Any"
                None =>
                  // Regular type
                  match schema.type_() {
                    Some("string") =>
                      match schema.format() {
                        Some("date-time") => "String" // Could use a Date type
                        Some("date") => "String"
                        Some("email") => "String"
                        Some("uri") => "String"
                        Some("uuid") => "String"
                        _ => "String"
                      }
                    Some("number") => "Double"
                    Some("integer") => "Int"
                    Some("boolean") => "Bool"
                    Some("null") => "Unit"
                    Some("array") =>
                      match schema.items() {
                        Some(items) =>
                          "Array[" + json_type_to_moonbit(items) + "]"
                        None => "Array[@js.Any]"
                      }
                    Some("object") =>
                      // Anonymous object - use @js.Any or generate inline struct
                      "@js.Any"
                    _ => "@js.Any"
                  }
              }
          }
      }
  }
}

///|
/// Generate a MoonBit struct from JSON Schema object
pub fn generate_struct(
  schema : JsonSchema,
  name : String,
  config : CodegenConfig,
) -> String {
  let mut code = ""
  // Add doc comment if available
  if config.add_docs {
    match schema.description() {
      Some(desc) => code = code + "/// " + desc + "\n"
      None => ()
    }
  }
  // Add derive attribute
  if config.derive_json {
    code = code + "#derive(ToJson, FromJson)\n"
  }
  code = code + "pub struct " + config.type_prefix + name + " {\n"
  // Get properties
  let props = schema.properties()
  if not(@js.is_undefined(props)) {
    let required = schema.required()
    let keys : Array[String] = @js.Object::keys(props) |> @js.identity
    for key in keys {
      let prop_schema : JsonSchema = { raw: props.get(key) }
      let field_name = to_snake_case(key)
      let mut field_type = json_type_to_moonbit(prop_schema)
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
  code + "}\n"
}

///|
/// Generate MoonBit code from a zod schema
pub fn generate_from_zod(
  schema : ZodSchema,
  name : String,
  config? : CodegenConfig = CodegenConfig::default(),
) -> String {
  let json_schema = JsonSchema::from_zod_with_name(schema, name)
  generate_struct(json_schema, name, config)
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
      let def_schema : JsonSchema = { raw: defs.get(key) }
      let code = generate_struct(def_schema, key, config)
      types.push({ name: key, code })
    }
  }
  // Generate root type
  let root_code = generate_struct(schema, root_name, config)
  types.push({ name: root_name, code: root_code })
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
