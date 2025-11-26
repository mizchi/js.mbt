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
/// Create an object schema from a Map
pub fn object(shape : Map[String, ZodSchema]) -> ZodSchema {
  let obj = @js.Object::new()
  shape.each(fn(key, value) { obj.set(key, value) })
  zod().call1("object", obj.to_any()).cast()
}

///|
/// Create an object schema from raw @js.Any
pub fn object_from_any(shape : @js.Any) -> ZodSchema {
  zod().call1("object", shape).cast()
}

///|
/// Create an array schema
pub fn array(element : ZodSchema) -> ZodSchema {
  zod().call1("array", element).cast()
}

///|
/// Create a tuple schema from an Array
pub fn tuple(items : Array[ZodSchema]) -> ZodSchema {
  zod().call1("tuple", @js.from_array(items)).cast()
}

///|
/// Create a union schema from an Array
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

///|
/// Create an intersection schema
pub fn intersection(left : ZodSchema, right : ZodSchema) -> ZodSchema {
  zod().call2("intersection", left, right).cast()
}

///|
/// Create a discriminated union schema
pub fn discriminated_union(
  discriminator : String,
  options : Array[ZodSchema],
) -> ZodSchema {
  zod()
  .call2("discriminatedUnion", discriminator, @js.from_array(options))
  .cast()
}

///|
/// Create a promise schema
pub fn promise(schema : ZodSchema) -> ZodSchema {
  zod().call1("promise", schema).cast()
}

///|
/// Create a lazy schema (for recursive types)
pub fn lazy_(getter : () -> ZodSchema) -> ZodSchema {
  zod().call1("lazy", @js.from_fn0(fn() { getter().to_any() })).cast()
}

///|
/// Create a native enum schema from JS object
pub fn native_enum(enum_obj : @js.Any) -> ZodSchema {
  zod().call1("nativeEnum", enum_obj).cast()
}

///| Coercion schemas (convert input to type before validation)

///|
/// Create a coerced string schema (converts input to string)
pub fn coerce_string() -> ZodSchema {
  zod().get("coerce").call0("string").cast()
}

///|
/// Create a coerced number schema (converts input to number)
pub fn coerce_number() -> ZodSchema {
  zod().get("coerce").call0("number").cast()
}

///|
/// Create a coerced boolean schema (converts input to boolean)
pub fn coerce_boolean() -> ZodSchema {
  zod().get("coerce").call0("boolean").cast()
}

///|
/// Create a coerced bigint schema (converts input to bigint)
pub fn coerce_bigint() -> ZodSchema {
  zod().get("coerce").call0("bigint").cast()
}

///|
/// Create a coerced date schema (converts input to Date)
pub fn coerce_date() -> ZodSchema {
  zod().get("coerce").call0("date").cast()
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

///|
/// Custom refinement validation
/// The predicate returns true if validation passes
pub fn ZodSchema::refine(
  self : ZodSchema,
  predicate : (@js.Any) -> Bool,
  message? : String,
) -> ZodSchema {
  match message {
    Some(msg) => {
      let opts = @js.Object::new()
      opts.set("message", msg)
      self.call2("refine", @js.from_fn1(predicate), opts.to_any()).cast()
    }
    None => self.call1("refine", @js.from_fn1(predicate)).cast()
  }
}

///|
/// Custom refinement with custom error path and params
pub fn ZodSchema::refine_with_path(
  self : ZodSchema,
  predicate : (@js.Any) -> Bool,
  message : String,
  path : Array[String],
) -> ZodSchema {
  let opts = @js.Object::new()
  opts.set("message", message)
  opts.set("path", path |> @js.from_array)
  self.call2("refine", @js.from_fn1(predicate), opts.to_any()).cast()
}

///|
/// Coerce input to the schema type before validation
pub fn ZodSchema::coerce(self : ZodSchema) -> ZodSchema {
  // Note: coerce is typically used at schema creation, not as a method
  // This is a passthrough for schemas that support coercion
  self
}

///|
/// Describe the schema (adds description metadata)
pub fn ZodSchema::describe(self : ZodSchema, description : String) -> ZodSchema {
  self.call1("describe", description).cast()
}

///|
/// Catch errors and return default value
pub fn ZodSchema::catch_(self : ZodSchema, value : @js.Any) -> ZodSchema {
  self.call1("catch", value).cast()
}

///|
/// Brand a schema with a type tag (for nominal typing)
pub fn ZodSchema::brand(self : ZodSchema, brand : String) -> ZodSchema {
  self.call1("brand", brand).cast()
}

///|
/// Pipe output to another schema
pub fn ZodSchema::pipe(self : ZodSchema, schema : ZodSchema) -> ZodSchema {
  self.call1("pipe", schema).cast()
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

///|
/// String cuid validation
pub fn ZodSchema::cuid(self : ZodSchema) -> ZodSchema {
  self.call0("cuid").cast()
}

///|
/// String cuid2 validation
pub fn ZodSchema::cuid2(self : ZodSchema) -> ZodSchema {
  self.call0("cuid2").cast()
}

///|
/// String ulid validation
pub fn ZodSchema::ulid(self : ZodSchema) -> ZodSchema {
  self.call0("ulid").cast()
}

///|
/// String emoji validation
pub fn ZodSchema::emoji(self : ZodSchema) -> ZodSchema {
  self.call0("emoji").cast()
}

///|
/// String datetime validation (ISO 8601)
pub fn ZodSchema::datetime(self : ZodSchema) -> ZodSchema {
  self.call0("datetime").cast()
}

///|
/// String ipv4 address validation
pub fn ZodSchema::ipv4(self : ZodSchema) -> ZodSchema {
  self.call0("ipv4").cast()
}

///|
/// String ipv6 address validation
pub fn ZodSchema::ipv6(self : ZodSchema) -> ZodSchema {
  self.call0("ipv6").cast()
}

///|
/// String base64 validation
pub fn ZodSchema::base64(self : ZodSchema) -> ZodSchema {
  self.call0("base64").cast()
}

///|
/// String includes substring
pub fn ZodSchema::includes(self : ZodSchema, value : String) -> ZodSchema {
  self.call1("includes", value).cast()
}

///|
/// String contains substring (alias for includes)
pub fn ZodSchema::contains(self : ZodSchema, value : String) -> ZodSchema {
  self.call1("includes", value).cast()
}

///|
/// Date schema - minimum date
pub fn ZodSchema::min_date(self : ZodSchema, date : @js.Any) -> ZodSchema {
  self.call1("min", date).cast()
}

///|
/// Date schema - maximum date
pub fn ZodSchema::max_date(self : ZodSchema, date : @js.Any) -> ZodSchema {
  self.call1("max", date).cast()
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

///|
/// Number multipleOf (step validation)
pub fn ZodSchema::multipleOf(self : ZodSchema, value : Int) -> ZodSchema {
  self.call1("multipleOf", value).cast()
}

///|
/// Number safe (within JavaScript safe integer range)
pub fn ZodSchema::safe(self : ZodSchema) -> ZodSchema {
  self.call0("safe").cast()
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

///|
/// Convert SafeParseResult to MoonBit Result type
pub fn SafeParseResult::to_result(
  self : SafeParseResult,
) -> Result[@js.Any, ZodError] {
  if self.success() {
    Ok(self.data())
  } else {
    Err(self.error())
  }
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
