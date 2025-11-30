///| npm zod package FFI bindings
/// https://zod.dev/
/// https://github.com/colinhacks/zod

///|
// TODO: migrate to dynamic import when MoonBit supports ESM
extern "js" fn zod() -> @nostd.Any =
  #| () => require("zod")

///|
/// ZodSchema - base schema type
#external
pub type ZodSchema

///|
pub extern "js" fn ZodSchema::as_any(self : ZodSchema) -> @nostd.Any =
  #| (x) => x

///|
/// ZodError - validation error
#external
pub type ZodError

///|
pub extern "js" fn ZodError::as_any(self : ZodError) -> @nostd.Any =
  #| (x) => x

///|
pub suberror ZodParseError ZodError

///|
/// SafeParseResult - result of safeParse (internal)
#external
priv type SafeParseResult

///|
extern "js" fn SafeParseResult::as_any(self : SafeParseResult) -> @nostd.Any =
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
pub fn string() -> ZodSchema {
  zod()._call("string", []).cast()
}

///|
/// Create a number schema
pub fn number() -> ZodSchema {
  zod()._call("number", []).cast()
}

///|
/// Create a boolean schema
pub fn boolean() -> ZodSchema {
  zod()._call("boolean", []).cast()
}

///|
/// Create a bigint schema
pub fn bigint() -> ZodSchema {
  zod()._call("bigint", []).cast()
}

///|
/// Create a date schema
pub fn date() -> ZodSchema {
  zod()._call("date", []).cast()
}

///|
/// Create an undefined schema
pub fn undefined_() -> ZodSchema {
  zod()._call("undefined", []).cast()
}

///|
/// Create a null schema
pub fn null_() -> ZodSchema {
  zod()._call("null", []).cast()
}

///|
/// Create a void schema
pub fn void_() -> ZodSchema {
  zod()._call("void", []).cast()
}

///|
/// Create an any schema
pub fn any_() -> ZodSchema {
  zod()._call("any", []).cast()
}

///|
/// Create an unknown schema
pub fn unknown() -> ZodSchema {
  zod()._call("unknown", []).cast()
}

///|
/// Create a never schema
pub fn never() -> ZodSchema {
  zod()._call("never", []).cast()
}

///| Complex schemas

///|
/// Create an object schema from a Map
pub fn object(shape : Map[String, ZodSchema]) -> ZodSchema {
  let obj = @nostd.Object::new()
  shape.each(fn(key, value) { obj[key] = value.as_any() })
  zod()._call("object", [obj]).cast()
}

///|
/// Create an object schema from raw @nostd.Any
pub fn object_from_any(shape : @nostd.Any) -> ZodSchema {
  zod()._call("object", [shape]).cast()
}

///|
/// Create an array schema
pub fn array(element : ZodSchema) -> ZodSchema {
  zod()._call("array", [element.as_any()]).cast()
}

///|
/// Create a tuple schema from an Array
pub fn tuple(items : Array[ZodSchema]) -> ZodSchema {
  zod()._call("tuple", [items |> @nostd.identity]).cast()
}

///|
/// Create a union schema from an Array
pub fn union(options : Array[ZodSchema]) -> ZodSchema {
  zod()._call("union", [options |> @nostd.identity]).cast()
}

///|
/// Create an enum schema from string values
pub fn enum_(values : Array[String]) -> ZodSchema {
  zod()._call("enum", [values |> @nostd.identity]).cast()
}

///|
/// Create a literal schema
pub fn literal(value : @nostd.Any) -> ZodSchema {
  zod()._call("literal", [value]).cast()
}

///|
/// Create a record schema (object with dynamic keys)
pub fn record(key_schema : ZodSchema, value_schema : ZodSchema) -> ZodSchema {
  zod()._call("record", [key_schema.as_any(), value_schema.as_any()]).cast()
}

///|
/// Create a map schema
pub fn map(key_schema : ZodSchema, value_schema : ZodSchema) -> ZodSchema {
  zod()._call("map", [key_schema.as_any(), value_schema.as_any()]).cast()
}

///|
/// Create a set schema
pub fn set(element : ZodSchema) -> ZodSchema {
  zod()._call("set", [element.as_any()]).cast()
}

///|
/// Create an intersection schema
pub fn intersection(left : ZodSchema, right : ZodSchema) -> ZodSchema {
  zod()._call("intersection", [left.as_any(), right.as_any()]).cast()
}

///|
/// Create a discriminated union schema
pub fn discriminated_union(
  discriminator : String,
  options : Array[ZodSchema],
) -> ZodSchema {
  zod()
  ._call("discriminatedUnion", [
    @nostd.any(discriminator),
    options |> @nostd.identity,
  ])
  .cast()
}

///|
/// Create a promise schema
pub fn promise(schema : ZodSchema) -> ZodSchema {
  zod()._call("promise", [schema.as_any()]).cast()
}

///|
/// Create a lazy schema (for recursive types)
pub fn lazy_(getter : () -> ZodSchema) -> ZodSchema {
  zod()._call("lazy", [@nostd.from_fn0(fn() { getter().as_any() })]).cast()
}

///|
/// Create a native enum schema from JS object
pub fn native_enum(enum_obj : @nostd.Any) -> ZodSchema {
  zod()._call("nativeEnum", [enum_obj]).cast()
}

///| Coercion schemas (convert input to type before validation)

///|
/// Create a coerced string schema (converts input to string)
pub fn coerce_string() -> ZodSchema {
  zod()["coerce"]._call("string", []).cast()
}

///|
/// Create a coerced number schema (converts input to number)
pub fn coerce_number() -> ZodSchema {
  zod()["coerce"]._call("number", []).cast()
}

///|
/// Create a coerced boolean schema (converts input to boolean)
pub fn coerce_boolean() -> ZodSchema {
  zod()["coerce"]._call("boolean", []).cast()
}

///|
/// Create a coerced bigint schema (converts input to bigint)
pub fn coerce_bigint() -> ZodSchema {
  zod()["coerce"]._call("bigint", []).cast()
}

///|
/// Create a coerced date schema (converts input to Date)
pub fn coerce_date() -> ZodSchema {
  zod()["coerce"]._call("date", []).cast()
}

///| Schema methods

///|
/// Parse data (raises ZodParseError on validation failure)
pub fn ZodSchema::parse(
  self : Self,
  data : @nostd.Any,
) -> @nostd.Any raise ZodParseError {
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
  data : @nostd.Any,
) -> Result[@nostd.Any, ZodError] {
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
pub fn ZodSchema::default_(self : Self, value : @nostd.Any) -> Self {
  self.as_any()._call("default", [value]).cast()
}

///|
/// Transform parsed value
pub fn ZodSchema::transform(
  self : Self,
  fn_ : (@nostd.Any) -> @nostd.Any,
) -> Self {
  self.as_any()._call("transform", [@nostd.from_fn1(fn_)]).cast()
}

///|
/// Custom refinement validation
/// The predicate returns true if validation passes
pub fn ZodSchema::refine(
  self : Self,
  predicate : (@nostd.Any) -> Bool,
  message? : String,
) -> Self {
  match message {
    Some(msg) => {
      let opts = @nostd.Object::new()
      opts["message"] = @nostd.any(msg)
      self.as_any()._call("refine", [@nostd.from_fn1(predicate), opts]).cast()
    }
    None => self.as_any()._call("refine", [@nostd.from_fn1(predicate)]).cast()
  }
}

///|
/// Custom refinement with custom error path and params
pub fn ZodSchema::refine_with_path(
  self : Self,
  predicate : (@nostd.Any) -> Bool,
  message : String,
  path : Array[String],
) -> Self {
  let opts = @nostd.Object::new()
  opts["message"] = @nostd.any(message)
  opts["path"] = path |> @nostd.identity
  self.as_any()._call("refine", [@nostd.from_fn1(predicate), opts]).cast()
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
  self.as_any()._call("describe", [@nostd.any(description)]).cast()
}

///|
/// Catch errors and return default value
pub fn ZodSchema::catch_(self : Self, value : @nostd.Any) -> Self {
  self.as_any()._call("catch", [value]).cast()
}

///|
/// Brand a schema with a type tag (for nominal typing)
pub fn ZodSchema::brand(self : Self, brand : String) -> Self {
  self.as_any()._call("brand", [@nostd.any(brand)]).cast()
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
  self.as_any()._call("min", [@nostd.any(length)]).cast()
}

///|
/// String max length
pub fn ZodSchema::max(self : Self, length : Int) -> Self {
  self.as_any()._call("max", [@nostd.any(length)]).cast()
}

///|
/// String length
pub fn ZodSchema::length(self : Self, length : Int) -> Self {
  self.as_any()._call("length", [@nostd.any(length)]).cast()
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
  self.as_any()._call("startsWith", [@nostd.any(prefix)]).cast()
}

///|
/// String ends with
#alias(ends_with)
pub fn ZodSchema::endsWith(self : Self, suffix : String) -> Self {
  self.as_any()._call("endsWith", [@nostd.any(suffix)]).cast()
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
  self.as_any()._call("includes", [@nostd.any(value)]).cast()
}

///|
/// String contains substring (alias for includes)
pub fn ZodSchema::contains(self : Self, value : String) -> Self {
  self.as_any()._call("includes", [@nostd.any(value)]).cast()
}

///|
/// Date schema - minimum date
pub fn ZodSchema::min_date(self : Self, date : @nostd.Any) -> Self {
  self.as_any()._call("min", [date]).cast()
}

///|
/// Date schema - maximum date
pub fn ZodSchema::max_date(self : Self, date : @nostd.Any) -> Self {
  self.as_any()._call("max", [date]).cast()
}

///| Number schema methods

///|
/// Number greater than
pub fn ZodSchema::gt(self : Self, value : Int) -> Self {
  self.as_any()._call("gt", [@nostd.any(value)]).cast()
}

///|
/// Number greater than or equal
pub fn ZodSchema::gte(self : Self, value : Int) -> Self {
  self.as_any()._call("gte", [@nostd.any(value)]).cast()
}

///|
/// Number less than
pub fn ZodSchema::lt(self : Self, value : Int) -> Self {
  self.as_any()._call("lt", [@nostd.any(value)]).cast()
}

///|
/// Number less than or equal
pub fn ZodSchema::lte(self : Self, value : Int) -> Self {
  self.as_any()._call("lte", [@nostd.any(value)]).cast()
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
  self.as_any()._call("multipleOf", [@nostd.any(value)]).cast()
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
pub fn ZodSchema::extend(self : Self, shape : @nostd.Any) -> Self {
  self.as_any()._call("extend", [shape]).cast()
}

///|
/// Object merge with another object schema
pub fn ZodSchema::merge(self : Self, other : Self) -> Self {
  self.as_any()._call("merge", [other.as_any()]).cast()
}

///|
/// Object pick certain keys
pub fn ZodSchema::pick(self : Self, keys : @nostd.Any) -> Self {
  self.as_any()._call("pick", [keys]).cast()
}

///|
/// Object omit certain keys
pub fn ZodSchema::omit(self : Self, keys : @nostd.Any) -> Self {
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
fn SafeParseResult::data(self : SafeParseResult) -> @nostd.Any {
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
pub fn ZodError::issues(self : ZodError) -> @nostd.Any {
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
pub fn ZodError::format(self : ZodError) -> @nostd.Any {
  self.as_any()._call("format", [])
}

///|
/// Flatten error
pub fn ZodError::flatten(self : ZodError) -> @nostd.Any {
  self.as_any()._call("flatten", [])
}

///| Helper for creating regexp

///|
extern "js" fn new_regexp(pattern : String) -> @nostd.Any =
  #| (pattern) => new RegExp(pattern)

///| Helper functions for tests

///|
/// Convert JSON to Any for testing
pub fn[T] from_json(value : T) -> @nostd.Any = "%identity"

///|
/// Convert Array to Any for testing
pub fn[T] from_array(value : Array[T]) -> @nostd.Any = "%identity"
