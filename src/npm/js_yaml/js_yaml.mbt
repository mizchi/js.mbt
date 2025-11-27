///|
/// js-yaml bindings for MoonBit
/// https://github.com/nodeca/js-yaml
///
/// YAML parser and serializer for JavaScript.

///| Schema Types

///|
/// Schema type for YAML parsing/dumping
#external
pub type Schema

///|
pub impl @js.JsImpl for Schema

///| FFI Functions

///|
extern "js" fn ffi_load(str : String) -> @js.Any =
  #| (str) => {
  #|   const yaml = require('js-yaml');
  #|   return yaml.load(str);
  #| }

///|
extern "js" fn ffi_load_with_options(
  str : String,
  options : @js.Any,
) -> @js.Any =
  #| (str, options) => {
  #|   const yaml = require('js-yaml');
  #|   return yaml.load(str, options);
  #| }

///|
extern "js" fn ffi_load_all(str : String) -> @js.Any =
  #| (str) => {
  #|   const yaml = require('js-yaml');
  #|   const result = [];
  #|   yaml.loadAll(str, (doc) => result.push(doc));
  #|   return result;
  #| }

///|
extern "js" fn ffi_load_all_with_options(
  str : String,
  options : @js.Any,
) -> @js.Any =
  #| (str, options) => {
  #|   const yaml = require('js-yaml');
  #|   const result = [];
  #|   yaml.loadAll(str, (doc) => result.push(doc), options);
  #|   return result;
  #| }

///|
extern "js" fn ffi_dump(obj : @js.Any) -> String =
  #| (obj) => {
  #|   const yaml = require('js-yaml');
  #|   return yaml.dump(obj);
  #| }

///|
extern "js" fn ffi_dump_with_options(
  obj : @js.Any,
  options : @js.Any,
) -> String =
  #| (obj, options) => {
  #|   const yaml = require('js-yaml');
  #|   return yaml.dump(obj, options);
  #| }

///|
extern "js" fn ffi_default_schema() -> Schema =
  #| () => {
  #|   const yaml = require('js-yaml');
  #|   return yaml.DEFAULT_SCHEMA;
  #| }

///|
extern "js" fn ffi_failsafe_schema() -> Schema =
  #| () => {
  #|   const yaml = require('js-yaml');
  #|   return yaml.FAILSAFE_SCHEMA;
  #| }

///|
extern "js" fn ffi_json_schema() -> Schema =
  #| () => {
  #|   const yaml = require('js-yaml');
  #|   return yaml.JSON_SCHEMA;
  #| }

///|
extern "js" fn ffi_core_schema() -> Schema =
  #| () => {
  #|   const yaml = require('js-yaml');
  #|   return yaml.CORE_SCHEMA;
  #| }

///| Schema Constants

///|
/// Default schema - all supported YAML types
pub fn defaultSchema() -> Schema {
  ffi_default_schema()
}

///|
/// Failsafe schema - strings, arrays, plain objects only
pub fn failsafeSchema() -> Schema {
  ffi_failsafe_schema()
}

///|
/// JSON schema - all JSON-supported types
pub fn jsonSchema() -> Schema {
  ffi_json_schema()
}

///|
/// Core schema - equivalent to JSON_SCHEMA
pub fn coreSchema() -> Schema {
  ffi_core_schema()
}

///| Load Functions

///|
/// Parse YAML string to JavaScript value
pub fn load(
  str : String,
  filename? : String,
  schema? : Schema,
  json? : Bool,
) -> @js.Any {
  if filename is None && schema is None && json is None {
    return ffi_load(str)
  }
  let options = @js.Object::new()
  if filename is Some(v) {
    options["filename"] = v
  }
  if schema is Some(v) {
    options["schema"] = v.to_any()
  }
  if json is Some(v) {
    options["json"] = v
  }
  ffi_load_with_options(str, options.to_any())
}

///|
/// Parse multi-document YAML string
pub fn loadAll(
  str : String,
  filename? : String,
  schema? : Schema,
  json? : Bool,
) -> Array[@js.Any] {
  if filename is None && schema is None && json is None {
    return @js.identity(ffi_load_all(str))
  }
  let options = @js.Object::new()
  if filename is Some(v) {
    options["filename"] = v
  }
  if schema is Some(v) {
    options["schema"] = v.to_any()
  }
  if json is Some(v) {
    options["json"] = v
  }
  @js.identity(ffi_load_all_with_options(str, options.to_any()))
}

///| Dump Functions

///|
/// Serialize JavaScript value to YAML string
pub fn dump(
  obj : @js.Any,
  indent? : Int,
  noArrayIndent? : Bool,
  skipInvalid? : Bool,
  flowLevel? : Int,
  sortKeys? : Bool,
  lineWidth? : Int,
  noRefs? : Bool,
  noCompatMode? : Bool,
  condenseFlow? : Bool,
  quotingType? : String,
  forceQuotes? : Bool,
  schema? : Schema,
) -> String {
  if indent is None &&
    noArrayIndent is None &&
    skipInvalid is None &&
    flowLevel is None &&
    sortKeys is None &&
    lineWidth is None &&
    noRefs is None &&
    noCompatMode is None &&
    condenseFlow is None &&
    quotingType is None &&
    forceQuotes is None &&
    schema is None {
    return ffi_dump(obj)
  }
  let options = @js.Object::new()
  if indent is Some(v) {
    options["indent"] = v
  }
  if noArrayIndent is Some(v) {
    options["noArrayIndent"] = v
  }
  if skipInvalid is Some(v) {
    options["skipInvalid"] = v
  }
  if flowLevel is Some(v) {
    options["flowLevel"] = v
  }
  if sortKeys is Some(v) {
    options["sortKeys"] = v
  }
  if lineWidth is Some(v) {
    options["lineWidth"] = v
  }
  if noRefs is Some(v) {
    options["noRefs"] = v
  }
  if noCompatMode is Some(v) {
    options["noCompatMode"] = v
  }
  if condenseFlow is Some(v) {
    options["condenseFlow"] = v
  }
  if quotingType is Some(v) {
    options["quotingType"] = v
  }
  if forceQuotes is Some(v) {
    options["forceQuotes"] = v
  }
  if schema is Some(v) {
    options["schema"] = v.to_any()
  }
  ffi_dump_with_options(obj, options.to_any())
}

///| Convenience Functions

///|
/// Parse YAML to Object
pub fn loadObject(str : String) -> @js.Object {
  @js.identity(ffi_load(str))
}

///|
/// Dump Object to YAML
pub fn dumpObject(obj : @js.Object) -> String {
  ffi_dump(obj.to_any())
}

///|
/// Parse YAML and convert to JSON string
pub fn yamlToJson(yaml_str : String) -> String {
  let obj = ffi_load(yaml_str)
  @js.JSON::stringify(obj)
}

///|
/// Parse JSON and convert to YAML string
pub fn jsonToYaml(json_str : String) -> String raise {
  let obj = @js.JSON::parse(json_str)
  ffi_dump(obj)
}
