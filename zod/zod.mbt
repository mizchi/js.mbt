///| npm zod package FFI bindings
/// https://zod.dev/
/// https://github.com/colinhacks/zod

///|
/// ZodSchema - base schema type
#external
pub type ZodSchema

///|
pub extern "js" fn ZodSchema::as_any(self : ZodSchema) -> @core.Any =
  #| (x) => x

///|
/// ZodError - validation error
#external
pub type ZodError

///|
pub extern "js" fn ZodError::as_any(self : ZodError) -> @core.Any =
  #| (x) => x

///|
pub suberror ZodParseError ZodError

///|
/// SafeParseResult - result of safeParse (internal)
#external
priv type SafeParseResult

///|
extern "js" fn SafeParseResult::as_any(self : SafeParseResult) -> @core.Any =
  #| (x) => x

///|
/// ZodIssue - single validation issue
pub struct ZodIssue {
  code : String
  path : Array[String]
  message : String
}

///| Primitive schemas

///|
/// Create a string schema
#module("zod")
pub extern "js" fn string() -> ZodSchema = "string"

///|
/// Create a number schema
#module("zod")
pub extern "js" fn number() -> ZodSchema = "number"

///|
/// Create a boolean schema
#module("zod")
pub extern "js" fn boolean() -> ZodSchema = "boolean"

///|
/// Create a bigint schema
#module("zod")
pub extern "js" fn bigint() -> ZodSchema = "bigint"

///|
/// Create a date schema
#module("zod")
pub extern "js" fn date() -> ZodSchema = "date"

///|
/// Create an undefined schema
#module("zod")
extern "js" fn ffi_undefined() -> ZodSchema = "undefined"

///|
pub fn undefined_() -> ZodSchema {
  ffi_undefined()
}

///|
/// Create a null schema
#module("zod")
extern "js" fn ffi_null() -> ZodSchema = "null"

///|
pub fn null_() -> ZodSchema {
  ffi_null()
}

///|
/// Create a void schema
#module("zod")
extern "js" fn ffi_void() -> ZodSchema = "void"

///|
pub fn void_() -> ZodSchema {
  ffi_void()
}

///|
/// Create an any schema
#module("zod")
extern "js" fn ffi_any() -> ZodSchema = "any"

///|
pub fn any_() -> ZodSchema {
  ffi_any()
}

///|
/// Create an unknown schema
#module("zod")
pub extern "js" fn unknown() -> ZodSchema = "unknown"

///|
/// Create a never schema
#module("zod")
pub extern "js" fn never() -> ZodSchema = "never"

///| Complex schemas

///|
#module("zod")
extern "js" fn ffi_object(shape : @core.Any) -> ZodSchema = "object"

///|
/// Create an object schema from a Map
pub fn object(shape : Map[String, ZodSchema]) -> ZodSchema {
  let obj = @core.new_object()
  shape.each(fn(key, value) { obj[key] = value.as_any() })
  ffi_object(obj)
}

///|
/// Create an object schema from raw @core.Any
pub fn object_from_any(shape : @core.Any) -> ZodSchema {
  ffi_object(shape)
}

///|
/// Create an array schema
#module("zod")
pub extern "js" fn array(element : ZodSchema) -> ZodSchema = "array"

///|
/// Create a tuple schema from an Array
#module("zod")
pub extern "js" fn tuple(items : Array[ZodSchema]) -> ZodSchema = "tuple"

///|
/// Create a union schema from an Array
#module("zod")
pub extern "js" fn union(options : Array[ZodSchema]) -> ZodSchema = "union"

///|
/// Create an enum schema from string values
#module("zod")
extern "js" fn ffi_enum(values : Array[String]) -> ZodSchema = "enum"

///|
pub fn enum_(values : Array[String]) -> ZodSchema {
  ffi_enum(values)
}

///|
/// Create a literal schema
#module("zod")
pub extern "js" fn literal(value : @core.Any) -> ZodSchema = "literal"

///|
/// Create a record schema (object with dynamic keys)
#module("zod")
pub extern "js" fn record(
  key_schema : ZodSchema,
  value_schema : ZodSchema,
) -> ZodSchema = "record"

///|
/// Create a map schema
#module("zod")
pub extern "js" fn map(
  key_schema : ZodSchema,
  value_schema : ZodSchema,
) -> ZodSchema = "map"

///|
/// Create a set schema
#module("zod")
pub extern "js" fn set(element : ZodSchema) -> ZodSchema = "set"

///|
/// Create an intersection schema
#module("zod")
pub extern "js" fn intersection(
  left : ZodSchema,
  right : ZodSchema,
) -> ZodSchema = "intersection"

///|
/// Create a discriminated union schema
#module("zod")
pub extern "js" fn discriminated_union(
  discriminator : String,
  options : Array[ZodSchema],
) -> ZodSchema = "discriminatedUnion"

///|
/// Create a promise schema
#module("zod")
pub extern "js" fn promise(schema : ZodSchema) -> ZodSchema = "promise"

///|
/// Create a lazy schema (for recursive types)
#module("zod")
extern "js" fn ffi_lazy(getter : () -> @core.Any) -> ZodSchema = "lazy"

///|
pub fn lazy_(getter : () -> ZodSchema) -> ZodSchema {
  ffi_lazy(fn() { getter().as_any() })
}

///|
/// Create a native enum schema from JS object
#module("zod")
pub extern "js" fn native_enum(enum_obj : @core.Any) -> ZodSchema = "nativeEnum"

///| Schema methods

///|
/// Parse data (raises ZodParseError on validation failure)
pub fn ZodSchema::parse(
  self : Self,
  data : @core.Any,
) -> @core.Any raise ZodParseError {
  let result : SafeParseResult = self.as_any()._call("safeParse", [data]).cast()
  if result.success() {
    result.data()
  } else {
    raise ZodParseError(result.error())
  }
}

///|
/// Safe parse - returns Result type directly
#alias(safe_parse)
pub fn ZodSchema::safeParse(
  self : Self,
  data : @core.Any,
) -> Result[@core.Any, ZodError] {
  let result : SafeParseResult = self.as_any()._call("safeParse", [data]).cast()
  if result.success() {
    Ok(result.data())
  } else {
    Err(result.error())
  }
}

///|
/// Make schema optional
pub fn ZodSchema::optional(self : Self) -> Self {
  self.as_any()._call("optional", []).cast()
}

///|
/// Make schema nullable
pub fn ZodSchema::nullable(self : Self) -> Self {
  self.as_any()._call("nullable", []).cast()
}

///|
/// Make schema nullish (optional + nullable)
pub fn ZodSchema::nullish(self : Self) -> Self {
  self.as_any()._call("nullish", []).cast()
}

///|
/// Set default value
pub fn ZodSchema::default_(self : Self, value : @core.Any) -> Self {
  self.as_any()._call("default", [value]).cast()
}

///|
/// Transform parsed value
pub fn ZodSchema::transform(
  self : Self,
  fn_ : (@core.Any) -> @core.Any,
) -> Self {
  self.as_any()._call("transform", [@core.from_fn1(fn_)]).cast()
}

///|
/// Custom refinement validation
/// The predicate returns true if validation passes
pub fn ZodSchema::refine(
  self : Self,
  predicate : (@core.Any) -> Bool,
  message? : String,
) -> Self {
  match message {
    Some(msg) => {
      let opts = @core.new_object()
      opts["message"] = @core.any(msg)
      self.as_any()._call("refine", [@core.from_fn1(predicate), opts]).cast()
    }
    None => self.as_any()._call("refine", [@core.from_fn1(predicate)]).cast()
  }
}

///|
/// Custom refinement with custom error path and params
pub fn ZodSchema::refine_with_path(
  self : Self,
  predicate : (@core.Any) -> Bool,
  message : String,
  path : Array[String],
) -> Self {
  let opts = @core.new_object()
  opts["message"] = @core.any(message)
  opts["path"] = path |> @core.identity
  self.as_any()._call("refine", [@core.from_fn1(predicate), opts]).cast()
}

///|
/// Coerce input to the schema type before validation
pub fn ZodSchema::coerce(self : Self) -> Self {
  // Note: coerce is typically used at schema creation, not as a method
  // This is a passthrough for schemas that support coercion
  self
}

///|
/// Describe the schema (adds description metadata)
pub fn ZodSchema::describe(self : Self, description : String) -> Self {
  self.as_any()._call("describe", [@core.any(description)]).cast()
}

///|
/// Catch errors and return default value
pub fn ZodSchema::catch_(self : Self, value : @core.Any) -> Self {
  self.as_any()._call("catch", [value]).cast()
}

///|
/// Brand a schema with a type tag (for nominal typing)
pub fn ZodSchema::brand(self : Self, brand : String) -> Self {
  self.as_any()._call("brand", [@core.any(brand)]).cast()
}

///|
/// Pipe output to another schema
pub fn ZodSchema::pipe(self : Self, schema : Self) -> Self {
  self.as_any()._call("pipe", [schema.as_any()]).cast()
}

///| String schema methods

///|
/// String min length
pub fn ZodSchema::min(self : Self, length : Int) -> Self {
  self.as_any()._call("min", [@core.any(length)]).cast()
}

///|
/// String max length
pub fn ZodSchema::max(self : Self, length : Int) -> Self {
  self.as_any()._call("max", [@core.any(length)]).cast()
}

///|
/// String length
pub fn ZodSchema::length(self : Self, length : Int) -> Self {
  self.as_any()._call("length", [@core.any(length)]).cast()
}

///|
/// String email validation
pub fn ZodSchema::email(self : Self) -> Self {
  self.as_any()._call("email", []).cast()
}

///|
/// String url validation
pub fn ZodSchema::url(self : Self) -> Self {
  self.as_any()._call("url", []).cast()
}

///|
/// String uuid validation
pub fn ZodSchema::uuid(self : Self) -> Self {
  self.as_any()._call("uuid", []).cast()
}

///|
/// String regex validation
pub fn ZodSchema::regex(self : Self, pattern : String) -> Self {
  self.as_any()._call("regex", [new_regexp(pattern)]).cast()
}

///|
/// String starts with
#alias(starts_with)
pub fn ZodSchema::startsWith(self : Self, prefix : String) -> Self {
  self.as_any()._call("startsWith", [@core.any(prefix)]).cast()
}

///|
/// String ends with
#alias(ends_with)
pub fn ZodSchema::endsWith(self : Self, suffix : String) -> Self {
  self.as_any()._call("endsWith", [@core.any(suffix)]).cast()
}

///|
/// String trim
pub fn ZodSchema::trim(self : Self) -> Self {
  self.as_any()._call("trim", []).cast()
}

///|
/// String toLowerCase
#alias(to_lower_case)
pub fn ZodSchema::toLowerCase(self : Self) -> Self {
  self.as_any()._call("toLowerCase", []).cast()
}

///|
/// String toUpperCase
#alias(to_upper_case)
pub fn ZodSchema::toUpperCase(self : Self) -> Self {
  self.as_any()._call("toUpperCase", []).cast()
}

///|
/// String cuid validation
pub fn ZodSchema::cuid(self : Self) -> Self {
  self.as_any()._call("cuid", []).cast()
}

///|
/// String cuid2 validation
pub fn ZodSchema::cuid2(self : Self) -> Self {
  self.as_any()._call("cuid2", []).cast()
}

///|
/// String ulid validation
pub fn ZodSchema::ulid(self : Self) -> Self {
  self.as_any()._call("ulid", []).cast()
}

///|
/// String emoji validation
pub fn ZodSchema::emoji(self : Self) -> Self {
  self.as_any()._call("emoji", []).cast()
}

///|
/// String datetime validation (ISO 8601)
pub fn ZodSchema::datetime(self : Self) -> Self {
  self.as_any()._call("datetime", []).cast()
}

///|
/// String ipv4 address validation
pub fn ZodSchema::ipv4(self : Self) -> Self {
  self.as_any()._call("ipv4", []).cast()
}

///|
/// String ipv6 address validation
pub fn ZodSchema::ipv6(self : Self) -> Self {
  self.as_any()._call("ipv6", []).cast()
}

///|
/// String base64 validation
pub fn ZodSchema::base64(self : Self) -> Self {
  self.as_any()._call("base64", []).cast()
}

///|
/// String includes substring
pub fn ZodSchema::includes(self : Self, value : String) -> Self {
  self.as_any()._call("includes", [@core.any(value)]).cast()
}

///|
/// String contains substring (alias for includes)
pub fn ZodSchema::contains(self : Self, value : String) -> Self {
  self.as_any()._call("includes", [@core.any(value)]).cast()
}

///|
/// Date schema - minimum date
pub fn ZodSchema::min_date(self : Self, date : @core.Any) -> Self {
  self.as_any()._call("min", [date]).cast()
}

///|
/// Date schema - maximum date
pub fn ZodSchema::max_date(self : Self, date : @core.Any) -> Self {
  self.as_any()._call("max", [date]).cast()
}

///| Number schema methods

///|
/// Number greater than
pub fn ZodSchema::gt(self : Self, value : Int) -> Self {
  self.as_any()._call("gt", [@core.any(value)]).cast()
}

///|
/// Number greater than or equal
pub fn ZodSchema::gte(self : Self, value : Int) -> Self {
  self.as_any()._call("gte", [@core.any(value)]).cast()
}

///|
/// Number less than
pub fn ZodSchema::lt(self : Self, value : Int) -> Self {
  self.as_any()._call("lt", [@core.any(value)]).cast()
}

///|
/// Number less than or equal
pub fn ZodSchema::lte(self : Self, value : Int) -> Self {
  self.as_any()._call("lte", [@core.any(value)]).cast()
}

///|
/// Number integer
pub fn ZodSchema::int(self : Self) -> Self {
  self.as_any()._call("int", []).cast()
}

///|
/// Number positive
pub fn ZodSchema::positive(self : Self) -> Self {
  self.as_any()._call("positive", []).cast()
}

///|
/// Number negative
pub fn ZodSchema::negative(self : Self) -> Self {
  self.as_any()._call("negative", []).cast()
}

///|
/// Number nonnegative
pub fn ZodSchema::nonnegative(self : Self) -> Self {
  self.as_any()._call("nonnegative", []).cast()
}

///|
/// Number nonpositive
pub fn ZodSchema::nonpositive(self : Self) -> Self {
  self.as_any()._call("nonpositive", []).cast()
}

///|
/// Number finite
pub fn ZodSchema::finite(self : Self) -> Self {
  self.as_any()._call("finite", []).cast()
}

///|
/// Number multipleOf (step validation)
pub fn ZodSchema::multipleOf(self : Self, value : Int) -> Self {
  self.as_any()._call("multipleOf", [@core.any(value)]).cast()
}

///|
/// Number safe (within JavaScript safe integer range)
pub fn ZodSchema::safe(self : Self) -> Self {
  self.as_any()._call("safe", []).cast()
}

///| Array schema methods

///|
/// Array nonempty
pub fn ZodSchema::nonempty(self : Self) -> Self {
  self.as_any()._call("nonempty", []).cast()
}

///| Object schema methods

///|
/// Object extend with additional properties
pub fn ZodSchema::extend(self : Self, shape : @core.Any) -> Self {
  self.as_any()._call("extend", [shape]).cast()
}

///|
/// Object merge with another object schema
pub fn ZodSchema::merge(self : Self, other : Self) -> Self {
  self.as_any()._call("merge", [other.as_any()]).cast()
}

///|
/// Object pick certain keys
pub fn ZodSchema::pick(self : Self, keys : @core.Any) -> Self {
  self.as_any()._call("pick", [keys]).cast()
}

///|
/// Object omit certain keys
pub fn ZodSchema::omit(self : Self, keys : @core.Any) -> Self {
  self.as_any()._call("omit", [keys]).cast()
}

///|
/// Object partial (all properties optional)
pub fn ZodSchema::partial(self : Self) -> Self {
  self.as_any()._call("partial", []).cast()
}

///|
/// Object required (all properties required)
pub fn ZodSchema::required_(self : Self) -> Self {
  self.as_any()._call("required", []).cast()
}

///|
/// Object passthrough (allow additional properties)
pub fn ZodSchema::passthrough(self : Self) -> Self {
  self.as_any()._call("passthrough", []).cast()
}

///|
/// Object strict (reject additional properties)
pub fn ZodSchema::strict(self : Self) -> Self {
  self.as_any()._call("strict", []).cast()
}

///|
/// Object strip (remove additional properties)
pub fn ZodSchema::strip(self : Self) -> Self {
  self.as_any()._call("strip", []).cast()
}

///| SafeParseResult methods (internal)

///|
/// Check if parse was successful
fn SafeParseResult::success(self : SafeParseResult) -> Bool {
  self.as_any()["success"].cast()
}

///|
/// Get parsed data (only valid if success)
fn SafeParseResult::data(self : SafeParseResult) -> @core.Any {
  self.as_any()["data"]
}

///|
/// Get error (only valid if not success)
fn SafeParseResult::error(self : SafeParseResult) -> ZodError {
  self.as_any()["error"].cast()
}

///| ZodError methods

///|
/// Get issues array
pub fn ZodError::issues(self : ZodError) -> @core.Any {
  self.as_any()["issues"]
}

///|
/// Get issues as array
#alias(issues_array)
pub fn ZodError::issuesArray(self : ZodError) -> Array[ZodIssue] {
  let issues = self.issues()
  let length : Int = issues["length"].cast()
  let result : Array[ZodIssue] = []
  for i = 0; i < length; i = i + 1 {
    let issue = issues[i.to_string()]
    let code : String = issue["code"].cast()
    let path_any = issue["path"]
    let path_len : Int = path_any["length"].cast()
    let path : Array[String] = []
    for j = 0; j < path_len; j = j + 1 {
      let p : String = path_any[j.to_string()].cast()
      path.push(p)
    }
    let message : String = issue["message"].cast()
    result.push({ code, path, message })
  }
  result
}

///|
/// Format error as string
pub fn ZodError::format(self : ZodError) -> @core.Any {
  self.as_any()._call("format", [])
}

///|
/// Flatten error
pub fn ZodError::flatten(self : ZodError) -> @core.Any {
  self.as_any()._call("flatten", [])
}

///| Helper for creating regexp

///|
extern "js" fn new_regexp(pattern : String) -> @core.Any =
  #| (pattern) => new RegExp(pattern)

///| Helper functions for tests

///|
/// Convert JSON to Any for testing
pub fn[T] from_json(value : T) -> @core.Any = "%identity"

///|
/// Convert Array to Any for testing
pub fn[T] from_array(value : Array[T]) -> @core.Any = "%identity"
