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
pub extern "js" fn Schema::as_any(self : Schema) -> @core.Any =
  #| (x) => x

///| FFI Functions

///|
extern "js" fn ffi_load(str : String) -> @core.Any =
  #| (str) => {
  #|   const yaml = require('js-yaml');
  #|   return yaml.load(str);
  #| }

///|
extern "js" fn ffi_load_with_options(
  str : String,
  options : @core.Any,
) -> @core.Any =
  #| (str, options) => {
  #|   const yaml = require('js-yaml');
  #|   return yaml.load(str, options);
  #| }

///|
extern "js" fn ffi_load_all(str : String) -> @core.Any =
  #| (str) => {
  #|   const yaml = require('js-yaml');
  #|   const result = [];
  #|   yaml.loadAll(str, (doc) => result.push(doc));
  #|   return result;
  #| }

///|
extern "js" fn ffi_load_all_with_options(
  str : String,
  options : @core.Any,
) -> @core.Any =
  #| (str, options) => {
  #|   const yaml = require('js-yaml');
  #|   const result = [];
  #|   yaml.loadAll(str, (doc) => result.push(doc), options);
  #|   return result;
  #| }

///|
extern "js" fn ffi_dump(obj : @core.Any) -> String =
  #| (obj) => {
  #|   const yaml = require('js-yaml');
  #|   return yaml.dump(obj);
  #| }

///|
extern "js" fn ffi_dump_with_options(
  obj : @core.Any,
  options : @core.Any,
) -> String =
  #| (obj, options) => {
  #|   const yaml = require('js-yaml');
  #|   return yaml.dump(obj, options);
  #| }

///| Schema Constants

///|
/// Default schema - all supported YAML types
pub extern "js" fn defaultSchema() -> Schema =
  #| () => {
  #|   const yaml = require('js-yaml');
  #|   return yaml.DEFAULT_SCHEMA;
  #| }

///|
/// Failsafe schema - strings, arrays, plain objects only
pub extern "js" fn failsafeSchema() -> Schema =
  #| () => {
  #|   const yaml = require('js-yaml');
  #|   return yaml.FAILSAFE_SCHEMA;
  #| }

///|
/// JSON schema - all JSON-supported types
pub extern "js" fn jsonSchema() -> Schema =
  #| () => {
  #|   const yaml = require('js-yaml');
  #|   return yaml.JSON_SCHEMA;
  #| }

///|
/// Core schema - equivalent to JSON_SCHEMA
pub extern "js" fn coreSchema() -> Schema =
  #| () => {
  #|   const yaml = require('js-yaml');
  #|   return yaml.CORE_SCHEMA;
  #| }

///| Load Functions

///|
/// Parse YAML string to JavaScript value
pub fn load(
  str : String,
  filename? : String,
  schema? : Schema,
  json? : Bool,
) -> @core.Any {
  if filename is None && schema is None && json is None {
    return ffi_load(str)
  }
  let options = @core.new_object()
  if filename is Some(v) {
    options["filename"] = @core.any(v)
  }
  if schema is Some(v) {
    options["schema"] = v.as_any()
  }
  if json is Some(v) {
    options["json"] = @core.any(v)
  }
  ffi_load_with_options(str, options)
}

///|
/// Parse multi-document YAML string
pub fn loadAll(
  str : String,
  filename? : String,
  schema? : Schema,
  json? : Bool,
) -> Array[@core.Any] {
  if filename is None && schema is None && json is None {
    return ffi_load_all(str).cast()
  }
  let options = @core.new_object()
  if filename is Some(v) {
    options["filename"] = @core.any(v)
  }
  if schema is Some(v) {
    options["schema"] = v.as_any()
  }
  if json is Some(v) {
    options["json"] = @core.any(v)
  }
  ffi_load_all_with_options(str, options).cast()
}

///| Dump Functions

///|
/// Serialize JavaScript value to YAML string
pub fn dump(
  obj : @core.Any,
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
  let options = @core.new_object()
  if indent is Some(v) {
    options["indent"] = @core.any(v)
  }
  if noArrayIndent is Some(v) {
    options["noArrayIndent"] = @core.any(v)
  }
  if skipInvalid is Some(v) {
    options["skipInvalid"] = @core.any(v)
  }
  if flowLevel is Some(v) {
    options["flowLevel"] = @core.any(v)
  }
  if sortKeys is Some(v) {
    options["sortKeys"] = @core.any(v)
  }
  if lineWidth is Some(v) {
    options["lineWidth"] = @core.any(v)
  }
  if noRefs is Some(v) {
    options["noRefs"] = @core.any(v)
  }
  if noCompatMode is Some(v) {
    options["noCompatMode"] = @core.any(v)
  }
  if condenseFlow is Some(v) {
    options["condenseFlow"] = @core.any(v)
  }
  if quotingType is Some(v) {
    options["quotingType"] = @core.any(v)
  }
  if forceQuotes is Some(v) {
    options["forceQuotes"] = @core.any(v)
  }
  if schema is Some(v) {
    options["schema"] = v.as_any()
  }
  ffi_dump_with_options(obj, options)
}

///| Convenience Functions

///|
/// Parse YAML to Object
pub fn loadObject(str : String) -> @core.Any {
  ffi_load(str)
}

///|
/// Dump Object to YAML
pub fn dumpObject(obj : @core.Any) -> String {
  ffi_dump(obj)
}

///|
extern "js" fn ffi_json_stringify(obj : @core.Any) -> String =
  #| (obj) => JSON.stringify(obj)

///|
extern "js" fn ffi_json_parse(str : String) -> @core.Any =
  #| (str) => JSON.parse(str)

///|
/// Parse YAML and convert to JSON string
pub fn yamlToJson(yaml_str : String) -> String {
  let obj = ffi_load(yaml_str)
  ffi_json_stringify(obj)
}

///|
/// Parse JSON and convert to YAML string
pub fn jsonToYaml(json_str : String) -> String {
  let obj = ffi_json_parse(json_str)
  ffi_dump(obj)
}
