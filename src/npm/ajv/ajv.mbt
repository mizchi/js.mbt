///| npm ajv package FFI bindings
/// https://www.npmjs.com/package/ajv
/// https://ajv.js.org/

///|
/// Ajv class - the main validator instance
#external
pub type Ajv

///|
pub fn Ajv::as_any(self : Ajv) -> @core.Any = "%identity"

///|
/// ValidateFunction - compiled validation function
#external
pub type ValidateFunction

///|
pub fn ValidateFunction::as_any(self : ValidateFunction) -> @core.Any = "%identity"

///|
/// ValidationError - represents a single validation error
pub struct ValidationError {
  instance_path : String
  schema_path : String
  keyword : String
  params : @core.Any
  message : String?
}

///|
extern "js" fn ffi_new_ajv(options : @core.Any) -> Ajv =
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
  let opts = @core.Object::new()
  match all_errors {
    Some(v) => opts["allErrors"] = @core.any(v)
    None => ()
  }
  match verbose {
    Some(v) => opts["verbose"] = @core.any(v)
    None => ()
  }
  match strict {
    Some(v) => opts["strict"] = @core.any(v)
    None => ()
  }
  match coerce_types {
    Some(v) => opts["coerceTypes"] = @core.any(v)
    None => ()
  }
  match use_defaults {
    Some(v) => opts["useDefaults"] = @core.any(v)
    None => ()
  }
  match remove_additional {
    Some(v) => opts["removeAdditional"] = @core.any(v)
    None => ()
  }
  ffi_new_ajv(opts)
}

///|
/// Compile a schema and return a validation function
/// https://ajv.js.org/api.html#ajv-compile-schema-object-boolean-validate
pub fn Ajv::compile(self : Ajv, schema : @core.Any) -> ValidateFunction {
  self.as_any()._call("compile", [schema]).cast()
}

///|
/// Validate data against a schema directly
/// https://ajv.js.org/api.html#ajv-validate-schema-object-boolean-data-any-boolean
pub fn Ajv::validate(self : Ajv, schema : @core.Any, data : @core.Any) -> Bool {
  self.as_any()._call("validate", [schema, data]).cast()
}

///|
/// Add schema to the instance
/// https://ajv.js.org/api.html#ajv-addschema-schema-object-object-key-string-ajv
#alias(add_schema)
pub fn Ajv::addSchema(self : Ajv, schema : @core.Any, key? : String) -> Ajv {
  match key {
    Some(k) => self.as_any()._call("addSchema", [schema, @core.any(k)]).cast()
    None => self.as_any()._call("addSchema", [schema]).cast()
  }
}

///|
/// Get compiled schema from the instance
/// https://ajv.js.org/api.html#ajv-getschema-string-validate
#alias(get_schema)
pub fn Ajv::getSchema(self : Ajv, key : String) -> ValidateFunction? {
  let result = self.as_any()._call("getSchema", [@core.any(key)])
  if @core.is_undefined(result) {
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
  self.as_any()._call("removeSchema", [@core.any(schema_key)]).cast()
}

///|
/// Get errors from the last validation
/// Returns null if no errors
pub fn Ajv::errors(self : Ajv) -> @core.Any {
  self.as_any()["errors"]
}

///|
extern "js" fn ffi_validate_call(
  validate : ValidateFunction,
  data : @core.Any,
) -> Bool =
  #| (validate, data) => validate(data)

///|
/// Validate data using the compiled function
pub fn ValidateFunction::validate(
  self : ValidateFunction,
  data : @core.Any,
) -> Bool {
  ffi_validate_call(self, data)
}

///|
/// Get errors from the compiled validation function
/// Returns null if no errors
pub fn ValidateFunction::errors(self : ValidateFunction) -> @core.Any {
  self.as_any()["errors"]
}

///|
/// Get errors as array
pub fn ValidateFunction::errors_array(
  self : ValidateFunction,
) -> Array[ValidationError] {
  let errors = self.errors()
  if @core.is_null(errors) || @core.is_undefined(errors) {
    return []
  }
  let length : Int = errors["length"].cast()
  let result : Array[ValidationError] = []
  for i = 0; i < length; i = i + 1 {
    let err = errors[i.to_string()]
    let instance_path : String = err["instancePath"].cast()
    let schema_path : String = err["schemaPath"].cast()
    let keyword : String = err["keyword"].cast()
    let params = err["params"]
    let msg = err["message"]
    let message : String? = if @core.is_undefined(msg) || @core.is_null(msg) {
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
pub fn schema() -> @core.Any {
  @core.Object::new()
}

///|
/// Helper to create a schema from JSON string
/// May throw if JSON is invalid
pub fn schema_from_json(json_str : String) -> @core.Any {
  @core.json_parse(json_str)
}
