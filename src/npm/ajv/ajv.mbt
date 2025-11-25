///| npm ajv package FFI bindings
/// https://www.npmjs.com/package/ajv
/// https://ajv.js.org/

///|
/// Ajv class - the main validator instance
#external
pub type Ajv

///|
pub impl @js.JsImpl for Ajv

///|
/// ValidateFunction - compiled validation function
#external
pub type ValidateFunction

///|
pub impl @js.JsImpl for ValidateFunction

///|
/// ValidationError - represents a single validation error
pub struct ValidationError {
  instance_path : String
  schema_path : String
  keyword : String
  params : @js.Any
  message : String?
}

///|
extern "js" fn ffi_new_ajv(options : @js.Any) -> Ajv =
  #| (options) => {
  #|   const Ajv = require("ajv").default || require("ajv");
  #|   return new Ajv(options);
  #| }

///|
/// Create a new Ajv instance with options
/// https://ajv.js.org/options.html
pub fn Ajv::new(
  all_errors? : Bool,
  verbose? : Bool,
  strict? : Bool,
  coerce_types? : Bool,
  use_defaults? : Bool,
  remove_additional? : Bool,
) -> Ajv {
  let opts = @js.Object::new()
  match all_errors {
    Some(v) => opts.set("allErrors", v)
    None => ()
  }
  match verbose {
    Some(v) => opts.set("verbose", v)
    None => ()
  }
  match strict {
    Some(v) => opts.set("strict", v)
    None => ()
  }
  match coerce_types {
    Some(v) => opts.set("coerceTypes", v)
    None => ()
  }
  match use_defaults {
    Some(v) => opts.set("useDefaults", v)
    None => ()
  }
  match remove_additional {
    Some(v) => opts.set("removeAdditional", v)
    None => ()
  }
  ffi_new_ajv(opts.to_any())
}

///|
/// Compile a schema and return a validation function
/// https://ajv.js.org/api.html#ajv-compile-schema-object-boolean-validate
pub fn Ajv::compile(self : Ajv, schema : @js.Any) -> ValidateFunction {
  self.call1("compile", schema).cast()
}

///|
/// Validate data against a schema directly
/// https://ajv.js.org/api.html#ajv-validate-schema-object-boolean-data-any-boolean
pub fn Ajv::validate(self : Ajv, schema : @js.Any, data : @js.Any) -> Bool {
  self.call2("validate", schema, data).cast()
}

///|
/// Add schema to the instance
/// https://ajv.js.org/api.html#ajv-addschema-schema-object-object-key-string-ajv
#alias(add_schema)
pub fn Ajv::addSchema(self : Ajv, schema : @js.Any, key? : String) -> Ajv {
  match key {
    Some(k) => self.call2("addSchema", schema, k).cast()
    None => self.call1("addSchema", schema).cast()
  }
}

///|
/// Get compiled schema from the instance
/// https://ajv.js.org/api.html#ajv-getschema-string-validate
#alias(get_schema)
pub fn Ajv::getSchema(self : Ajv, key : String) -> ValidateFunction? {
  let result = self.call1("getSchema", key)
  if @js.is_undefined(result) {
    None
  } else {
    Some(result.cast())
  }
}

///|
/// Remove schema from the instance
/// https://ajv.js.org/api.html#ajv-removeschema-schema-object-string-regexp-ajv
#alias(remove_schema)
pub fn Ajv::removeSchema(self : Ajv, schema_key : String) -> Ajv {
  self.call1("removeSchema", schema_key).cast()
}

///|
/// Get errors from the last validation
/// Returns null if no errors
pub fn Ajv::errors(self : Ajv) -> @js.Any {
  self.get("errors")
}

///|
/// Validate data using the compiled function
/// Returns true if valid
pub fn ValidateFunction::call(self : ValidateFunction, data : @js.Any) -> Bool {
  let fn_any : @js.Any = self.to_any()
  fn_any.call1("call", data).cast()
}

///|
extern "js" fn ffi_validate_call(
  validate : ValidateFunction,
  data : @js.Any,
) -> Bool =
  #| (validate, data) => validate(data)

///|
/// Validate data using the compiled function
pub fn ValidateFunction::validate(
  self : ValidateFunction,
  data : @js.Any,
) -> Bool {
  ffi_validate_call(self, data)
}

///|
/// Get errors from the compiled validation function
/// Returns null if no errors
pub fn ValidateFunction::errors(self : ValidateFunction) -> @js.Any {
  self.get("errors")
}

///|
/// Get errors as array
pub fn ValidateFunction::errors_array(
  self : ValidateFunction,
) -> Array[ValidationError] {
  let errors = self.errors()
  if @js.is_null(errors) || @js.is_undefined(errors) {
    return []
  }
  let length : Int = errors.get("length").cast()
  let result : Array[ValidationError] = []
  for i = 0; i < length; i = i + 1 {
    let err = errors.get(i.to_string())
    let instance_path : String = err.get("instancePath").cast()
    let schema_path : String = err.get("schemaPath").cast()
    let keyword : String = err.get("keyword").cast()
    let params = err.get("params")
    let msg = err.get("message")
    let message : String? = if @js.is_undefined(msg) || @js.is_null(msg) {
      None
    } else {
      Some(msg.cast())
    }
    result.push({ instance_path, schema_path, keyword, params, message })
  }
  result
}

///|
/// Helper to create a JSON schema object
pub fn schema() -> @js.Any {
  @js.Object::new()
}

///|
/// Helper to create a schema from JSON string
/// May throw if JSON is invalid
pub fn schema_from_json(json_str : String) -> @js.Any raise @js.ThrowError {
  @js.JSON::parse(json_str)
}
