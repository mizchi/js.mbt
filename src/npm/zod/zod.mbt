///| npm zod package FFI bindings
/// https://zod.dev/
/// https://github.com/colinhacks/zod

///|
fn zod() -> @js.Any {
  @node.require("zod")
}

///|
/// ZodSchema - base schema type
#external
pub type ZodSchema

///|
pub impl @js.JsImpl for ZodSchema

///|
/// ZodError - validation error
#external
pub type ZodError

///|
pub impl @js.JsImpl for ZodError

///|
/// SafeParseResult - result of safeParse
#external
pub type SafeParseResult

///|
pub impl @js.JsImpl for SafeParseResult

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
  zod().call0("string").cast()
}

///|
/// Create a number schema
pub fn number() -> ZodSchema {
  zod().call0("number").cast()
}

///|
/// Create a boolean schema
pub fn boolean() -> ZodSchema {
  zod().call0("boolean").cast()
}

///|
/// Create a bigint schema
pub fn bigint() -> ZodSchema {
  zod().call0("bigint").cast()
}

///|
/// Create a date schema
pub fn date() -> ZodSchema {
  zod().call0("date").cast()
}

///|
/// Create an undefined schema
pub fn undefined_() -> ZodSchema {
  zod().call0("undefined").cast()
}

///|
/// Create a null schema
pub fn null_() -> ZodSchema {
  zod().call0("null").cast()
}

///|
/// Create a void schema
pub fn void_() -> ZodSchema {
  zod().call0("void").cast()
}

///|
/// Create an any schema
pub fn any_() -> ZodSchema {
  zod().call0("any").cast()
}

///|
/// Create an unknown schema
pub fn unknown() -> ZodSchema {
  zod().call0("unknown").cast()
}

///|
/// Create a never schema
pub fn never() -> ZodSchema {
  zod().call0("never").cast()
}

///| Complex schemas

///|
/// Create an object schema from a shape
pub fn object(shape : @js.Any) -> ZodSchema {
  zod().call1("object", shape).cast()
}

///|
/// Create an array schema
pub fn array(element : ZodSchema) -> ZodSchema {
  zod().call1("array", element).cast()
}

///|
/// Create a tuple schema
pub fn tuple(items : Array[ZodSchema]) -> ZodSchema {
  zod().call1("tuple", @js.from_array(items)).cast()
}

///|
/// Create a union schema
pub fn union(options : Array[ZodSchema]) -> ZodSchema {
  zod().call1("union", @js.from_array(options)).cast()
}

///|
/// Create an enum schema from string values
pub fn enum_(values : Array[String]) -> ZodSchema {
  zod().call1("enum", @js.from_array(values)).cast()
}

///|
/// Create a literal schema
pub fn literal(value : @js.Any) -> ZodSchema {
  zod().call1("literal", value).cast()
}

///|
/// Create a record schema (object with dynamic keys)
pub fn record(key_schema : ZodSchema, value_schema : ZodSchema) -> ZodSchema {
  zod().call2("record", key_schema, value_schema).cast()
}

///|
/// Create a map schema
pub fn map(key_schema : ZodSchema, value_schema : ZodSchema) -> ZodSchema {
  zod().call2("map", key_schema, value_schema).cast()
}

///|
/// Create a set schema
pub fn set(element : ZodSchema) -> ZodSchema {
  zod().call1("set", element).cast()
}

///| Schema methods

///|
/// Parse data (throws on error)
pub fn ZodSchema::parse(self : ZodSchema, data : @js.Any) -> @js.Any {
  self.call1("parse", data)
}

///|
/// Safe parse - returns result object instead of throwing
#alias(safe_parse)
pub fn ZodSchema::safeParse(
  self : ZodSchema,
  data : @js.Any,
) -> SafeParseResult {
  self.call1("safeParse", data).cast()
}

///|
/// Make schema optional
pub fn ZodSchema::optional(self : ZodSchema) -> ZodSchema {
  self.call0("optional").cast()
}

///|
/// Make schema nullable
pub fn ZodSchema::nullable(self : ZodSchema) -> ZodSchema {
  self.call0("nullable").cast()
}

///|
/// Make schema nullish (optional + nullable)
pub fn ZodSchema::nullish(self : ZodSchema) -> ZodSchema {
  self.call0("nullish").cast()
}

///|
/// Set default value
pub fn ZodSchema::default_(self : ZodSchema, value : @js.Any) -> ZodSchema {
  self.call1("default", value).cast()
}

///|
/// Transform parsed value
pub fn ZodSchema::transform(
  self : ZodSchema,
  fn_ : (@js.Any) -> @js.Any,
) -> ZodSchema {
  self.call1("transform", @js.from_fn1(fn_)).cast()
}

///| String schema methods

///|
/// String min length
pub fn ZodSchema::min(self : ZodSchema, length : Int) -> ZodSchema {
  self.call1("min", length).cast()
}

///|
/// String max length
pub fn ZodSchema::max(self : ZodSchema, length : Int) -> ZodSchema {
  self.call1("max", length).cast()
}

///|
/// String length
pub fn ZodSchema::length(self : ZodSchema, length : Int) -> ZodSchema {
  self.call1("length", length).cast()
}

///|
/// String email validation
pub fn ZodSchema::email(self : ZodSchema) -> ZodSchema {
  self.call0("email").cast()
}

///|
/// String url validation
pub fn ZodSchema::url(self : ZodSchema) -> ZodSchema {
  self.call0("url").cast()
}

///|
/// String uuid validation
pub fn ZodSchema::uuid(self : ZodSchema) -> ZodSchema {
  self.call0("uuid").cast()
}

///|
/// String regex validation
pub fn ZodSchema::regex(self : ZodSchema, pattern : String) -> ZodSchema {
  self.call1("regex", new_regexp(pattern)).cast()
}

///|
/// String starts with
#alias(starts_with)
pub fn ZodSchema::startsWith(self : ZodSchema, prefix : String) -> ZodSchema {
  self.call1("startsWith", prefix).cast()
}

///|
/// String ends with
#alias(ends_with)
pub fn ZodSchema::endsWith(self : ZodSchema, suffix : String) -> ZodSchema {
  self.call1("endsWith", suffix).cast()
}

///|
/// String trim
pub fn ZodSchema::trim(self : ZodSchema) -> ZodSchema {
  self.call0("trim").cast()
}

///|
/// String toLowerCase
#alias(to_lower_case)
pub fn ZodSchema::toLowerCase(self : ZodSchema) -> ZodSchema {
  self.call0("toLowerCase").cast()
}

///|
/// String toUpperCase
#alias(to_upper_case)
pub fn ZodSchema::toUpperCase(self : ZodSchema) -> ZodSchema {
  self.call0("toUpperCase").cast()
}

///| Number schema methods

///|
/// Number greater than
pub fn ZodSchema::gt(self : ZodSchema, value : Int) -> ZodSchema {
  self.call1("gt", value).cast()
}

///|
/// Number greater than or equal
pub fn ZodSchema::gte(self : ZodSchema, value : Int) -> ZodSchema {
  self.call1("gte", value).cast()
}

///|
/// Number less than
pub fn ZodSchema::lt(self : ZodSchema, value : Int) -> ZodSchema {
  self.call1("lt", value).cast()
}

///|
/// Number less than or equal
pub fn ZodSchema::lte(self : ZodSchema, value : Int) -> ZodSchema {
  self.call1("lte", value).cast()
}

///|
/// Number integer
pub fn ZodSchema::int(self : ZodSchema) -> ZodSchema {
  self.call0("int").cast()
}

///|
/// Number positive
pub fn ZodSchema::positive(self : ZodSchema) -> ZodSchema {
  self.call0("positive").cast()
}

///|
/// Number negative
pub fn ZodSchema::negative(self : ZodSchema) -> ZodSchema {
  self.call0("negative").cast()
}

///|
/// Number nonnegative
pub fn ZodSchema::nonnegative(self : ZodSchema) -> ZodSchema {
  self.call0("nonnegative").cast()
}

///|
/// Number nonpositive
pub fn ZodSchema::nonpositive(self : ZodSchema) -> ZodSchema {
  self.call0("nonpositive").cast()
}

///|
/// Number finite
pub fn ZodSchema::finite(self : ZodSchema) -> ZodSchema {
  self.call0("finite").cast()
}

///| Array schema methods

///|
/// Array nonempty
pub fn ZodSchema::nonempty(self : ZodSchema) -> ZodSchema {
  self.call0("nonempty").cast()
}

///| Object schema methods

///|
/// Object extend with additional properties
pub fn ZodSchema::extend(self : ZodSchema, shape : @js.Any) -> ZodSchema {
  self.call1("extend", shape).cast()
}

///|
/// Object merge with another object schema
pub fn ZodSchema::merge(self : ZodSchema, other : ZodSchema) -> ZodSchema {
  self.call1("merge", other).cast()
}

///|
/// Object pick certain keys
pub fn ZodSchema::pick(self : ZodSchema, keys : @js.Any) -> ZodSchema {
  self.call1("pick", keys).cast()
}

///|
/// Object omit certain keys
pub fn ZodSchema::omit(self : ZodSchema, keys : @js.Any) -> ZodSchema {
  self.call1("omit", keys).cast()
}

///|
/// Object partial (all properties optional)
pub fn ZodSchema::partial(self : ZodSchema) -> ZodSchema {
  self.call0("partial").cast()
}

///|
/// Object required (all properties required)
pub fn ZodSchema::required_(self : ZodSchema) -> ZodSchema {
  self.call0("required").cast()
}

///|
/// Object passthrough (allow additional properties)
pub fn ZodSchema::passthrough(self : ZodSchema) -> ZodSchema {
  self.call0("passthrough").cast()
}

///|
/// Object strict (reject additional properties)
pub fn ZodSchema::strict(self : ZodSchema) -> ZodSchema {
  self.call0("strict").cast()
}

///|
/// Object strip (remove additional properties)
pub fn ZodSchema::strip(self : ZodSchema) -> ZodSchema {
  self.call0("strip").cast()
}

///| SafeParseResult methods

///|
/// Check if parse was successful
pub fn SafeParseResult::success(self : SafeParseResult) -> Bool {
  self.get("success").cast()
}

///|
/// Get parsed data (only valid if success)
pub fn SafeParseResult::data(self : SafeParseResult) -> @js.Any {
  self.get("data")
}

///|
/// Get error (only valid if not success)
pub fn SafeParseResult::error(self : SafeParseResult) -> ZodError {
  self.get("error").cast()
}

///| ZodError methods

///|
/// Get issues array
pub fn ZodError::issues(self : ZodError) -> @js.Any {
  self.get("issues")
}

///|
/// Get issues as array
#alias(issues_array)
pub fn ZodError::issuesArray(self : ZodError) -> Array[ZodIssue] {
  let issues = self.issues()
  let length : Int = issues.get("length").cast()
  let result : Array[ZodIssue] = []
  for i = 0; i < length; i = i + 1 {
    let issue = issues.get(i.to_string())
    let code : String = issue.get("code").cast()
    let path_any = issue.get("path")
    let path_len : Int = path_any.get("length").cast()
    let path : Array[String] = []
    for j = 0; j < path_len; j = j + 1 {
      let p = path_any.get(j.to_string())
      path.push(p.to_string())
    }
    let message : String = issue.get("message").cast()
    result.push({ code, path, message })
  }
  result
}

///|
/// Format error as string
pub fn ZodError::format(self : ZodError) -> @js.Any {
  self.call0("format")
}

///|
/// Flatten error
pub fn ZodError::flatten(self : ZodError) -> @js.Any {
  self.call0("flatten")
}

///| Helper for creating regexp

///|
extern "js" fn new_regexp(pattern : String) -> @js.Any =
  #| (pattern) => new RegExp(pattern)
