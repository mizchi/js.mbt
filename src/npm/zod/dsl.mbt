///| MoonBit DSL for Zod schema definition
/// Type-safe schema builder using enums

///|
/// String validation rules
pub enum StringRule {
  Min(Int)
  Max(Int)
  Length(Int)
  Email
  Url
  Uuid
  Regex(String)
  StartsWith(String)
  EndsWith(String)
  Trim
  ToLowerCase
  ToUpperCase
}

///|
/// Number validation rules
pub enum NumberRule {
  Gt(Int)
  Gte(Int)
  Lt(Int)
  Lte(Int)
  Int
  Positive
  Negative
  Nonnegative
  Nonpositive
  Finite
}

///|
/// Array validation rules
pub enum ArrayRule {
  Min(Int)
  Max(Int)
  Length(Int)
  Nonempty
}

///|
/// Object validation rules
pub enum ObjectRule {
  Strict
  Passthrough
  Strip
  Partial
}

///|
/// Schema modifiers
pub enum Modifier {
  Optional
  Nullable
  Nullish
  Default(@js.Any)
}

///|
/// Schema definition DSL
pub enum Schema {
  // Primitives
  String(Array[StringRule])
  Number(Array[NumberRule])
  Boolean
  BigInt
  Date
  // Complex types
  Array(Schema, Array[ArrayRule])
  Object(Array[(String, Schema)], Array[ObjectRule])
  Record(Schema, Schema)
  Tuple(Array[Schema])
  // Union and enum
  Union(Array[Schema])
  Enum(Array[String])
  Literal(@js.Any)
  // Special
  Any
  Unknown
  Never
  Null
  Undefined
  // With modifiers
  WithModifier(Schema, Modifier)
}

///|
/// Build a ZodSchema from Schema DSL
pub fn Schema::build(self : Schema) -> ZodSchema {
  match self {
    String(rules) => {
      let s = string()
      apply_string_rules(s, rules)
    }
    Number(rules) => {
      let n = number()
      apply_number_rules(n, rules)
    }
    Boolean => boolean()
    BigInt => bigint()
    Date => date()
    Array(element, rules) => {
      let arr = array(element.build())
      apply_array_rules(arr, rules)
    }
    Object(fields, rules) => {
      let shape = @js.Object::new()
      for pair in fields {
        let (key, schema) = pair
        shape.set(key, schema.build())
      }
      let obj = object(shape.to_any())
      apply_object_rules(obj, rules)
    }
    Record(key_schema, value_schema) =>
      record(key_schema.build(), value_schema.build())
    Tuple(items) => {
      let schemas : Array[ZodSchema] = []
      for item in items {
        schemas.push(item.build())
      }
      tuple(schemas)
    }
    Union(options) => {
      let schemas : Array[ZodSchema] = []
      for opt in options {
        schemas.push(opt.build())
      }
      union(schemas)
    }
    Enum(values) => enum_(values)
    Literal(value) => literal(value)
    Any => any_()
    Unknown => unknown()
    Never => never()
    Null => null_()
    Undefined => undefined_()
    WithModifier(inner, modifier) => {
      let schema = inner.build()
      match modifier {
        Optional => schema.optional()
        Nullable => schema.nullable()
        Nullish => schema.nullish()
        Default(value) => schema.default_(value)
      }
    }
  }
}

///|
fn apply_string_rules(
  schema : ZodSchema,
  rules : Array[StringRule],
) -> ZodSchema {
  let mut s = schema
  for rule in rules {
    s = match rule {
      Min(n) => s.min(n)
      Max(n) => s.max(n)
      Length(n) => s.length(n)
      Email => s.email()
      Url => s.url()
      Uuid => s.uuid()
      Regex(pattern) => s.regex(pattern)
      StartsWith(prefix) => s.startsWith(prefix)
      EndsWith(suffix) => s.endsWith(suffix)
      Trim => s.trim()
      ToLowerCase => s.toLowerCase()
      ToUpperCase => s.toUpperCase()
    }
  }
  s
}

///|
fn apply_number_rules(
  schema : ZodSchema,
  rules : Array[NumberRule],
) -> ZodSchema {
  let mut n = schema
  for rule in rules {
    n = match rule {
      Gt(v) => n.gt(v)
      Gte(v) => n.gte(v)
      Lt(v) => n.lt(v)
      Lte(v) => n.lte(v)
      Int => n.int()
      Positive => n.positive()
      Negative => n.negative()
      Nonnegative => n.nonnegative()
      Nonpositive => n.nonpositive()
      Finite => n.finite()
    }
  }
  n
}

///|
fn apply_array_rules(schema : ZodSchema, rules : Array[ArrayRule]) -> ZodSchema {
  let mut a = schema
  for rule in rules {
    a = match rule {
      Min(n) => a.min(n)
      Max(n) => a.max(n)
      Length(n) => a.length(n)
      Nonempty => a.nonempty()
    }
  }
  a
}

///|
fn apply_object_rules(
  schema : ZodSchema,
  rules : Array[ObjectRule],
) -> ZodSchema {
  let mut o = schema
  for rule in rules {
    o = match rule {
      Strict => o.strict()
      Passthrough => o.passthrough()
      Strip => o.strip()
      Partial => o.partial()
    }
  }
  o
}

///| Convenience constructors for common patterns

///|
/// String schema with no rules
pub fn str() -> Schema {
  String([])
}

///|
/// String with email validation
pub fn email() -> Schema {
  String([Email])
}

///|
/// String with url validation
pub fn url_string() -> Schema {
  String([Url])
}

///|
/// String with uuid validation
pub fn uuid_string() -> Schema {
  String([Uuid])
}

///|
/// Number schema with no rules
pub fn num() -> Schema {
  Number([])
}

///|
/// Integer schema
pub fn int_() -> Schema {
  Number([Int])
}

///|
/// Positive integer schema
pub fn positive_int() -> Schema {
  Number([Int, Positive])
}

///|
/// Non-negative integer schema
pub fn nonnegative_int() -> Schema {
  Number([Int, Nonnegative])
}

///|
/// Boolean schema
pub fn bool() -> Schema {
  Boolean
}

///|
/// Optional wrapper
pub fn optional(schema : Schema) -> Schema {
  WithModifier(schema, Optional)
}

///|
/// Nullable wrapper
pub fn nullable(schema : Schema) -> Schema {
  WithModifier(schema, Nullable)
}

///|
/// Nullish wrapper (optional + nullable)
pub fn nullish(schema : Schema) -> Schema {
  WithModifier(schema, Nullish)
}

///|
/// Default value wrapper
pub fn with_default(schema : Schema, value : @js.Any) -> Schema {
  WithModifier(schema, Default(value))
}

///| Additional convenience constructors

///|
/// String with min length
pub fn str_min(n : Int) -> Schema {
  String([Min(n)])
}

///|
/// String with max length
pub fn str_max(n : Int) -> Schema {
  String([Max(n)])
}

///|
/// String with exact length
pub fn str_length(n : Int) -> Schema {
  String([Length(n)])
}

///|
/// String with regex pattern
pub fn str_regex(pattern : String) -> Schema {
  String([Regex(pattern)])
}

///|
/// String that starts with prefix
pub fn str_starts_with(prefix : String) -> Schema {
  String([StartsWith(prefix)])
}

///|
/// String that ends with suffix
pub fn str_ends_with(suffix : String) -> Schema {
  String([EndsWith(suffix)])
}

///|
/// String with trim transformation
pub fn str_trim() -> Schema {
  String([Trim])
}

///|
/// String with toLowerCase transformation
pub fn str_lower() -> Schema {
  String([ToLowerCase])
}

///|
/// String with toUpperCase transformation
pub fn str_upper() -> Schema {
  String([ToUpperCase])
}

///|
/// Number greater than
pub fn num_gt(n : Int) -> Schema {
  Number([Gt(n)])
}

///|
/// Number greater than or equal
pub fn num_gte(n : Int) -> Schema {
  Number([Gte(n)])
}

///|
/// Number less than
pub fn num_lt(n : Int) -> Schema {
  Number([Lt(n)])
}

///|
/// Number less than or equal
pub fn num_lte(n : Int) -> Schema {
  Number([Lte(n)])
}

///|
/// Negative number
pub fn num_negative() -> Schema {
  Number([Negative])
}

///|
/// Non-positive number
pub fn num_nonpositive() -> Schema {
  Number([Nonpositive])
}

///|
/// Finite number
pub fn num_finite() -> Schema {
  Number([Finite])
}

///|
/// Array with min length
pub fn arr_min(element : Schema, n : Int) -> Schema {
  Array(element, [ArrayRule::Min(n)])
}

///|
/// Array with max length
pub fn arr_max(element : Schema, n : Int) -> Schema {
  Array(element, [ArrayRule::Max(n)])
}

///|
/// Array with exact length
pub fn arr_length(element : Schema, n : Int) -> Schema {
  Array(element, [ArrayRule::Length(n)])
}

///|
/// Non-empty array
pub fn arr_nonempty(element : Schema) -> Schema {
  Array(element, [Nonempty])
}

///|
/// Object with strict mode
pub fn obj_strict(fields : Array[(String, Schema)]) -> Schema {
  Object(fields, [Strict])
}

///|
/// Object with passthrough mode
pub fn obj_passthrough(fields : Array[(String, Schema)]) -> Schema {
  Object(fields, [Passthrough])
}

///|
/// Object with strip mode
pub fn obj_strip(fields : Array[(String, Schema)]) -> Schema {
  Object(fields, [Strip])
}

///|
/// Partial object (all fields optional)
pub fn obj_partial(fields : Array[(String, Schema)]) -> Schema {
  Object(fields, [Partial])
}

///|
/// BigInt schema
pub fn bigint_() -> Schema {
  BigInt
}

///|
/// Date schema
pub fn date_() -> Schema {
  Date
}

///|
/// Record schema
pub fn record_(key : Schema, value : Schema) -> Schema {
  Record(key, value)
}

///|
/// Tuple schema
pub fn tuple_(items : Array[Schema]) -> Schema {
  Tuple(items)
}

///|
/// Union schema
pub fn union_(options : Array[Schema]) -> Schema {
  Union(options)
}

///|
/// Enum schema
pub fn enum__(values : Array[String]) -> Schema {
  Enum(values)
}

///|
/// Literal schema
pub fn literal_(value : @js.Any) -> Schema {
  Literal(value)
}

///|
/// Any schema
pub fn any__() -> Schema {
  Any
}

///|
/// Unknown schema
pub fn unknown_() -> Schema {
  Unknown
}

///|
/// Never schema
pub fn never_() -> Schema {
  Never
}

///|
/// Null schema
pub fn null__() -> Schema {
  Null
}

///|
/// Undefined schema
pub fn undefined__() -> Schema {
  Undefined
}

///| Validation helpers

///|
/// Validate data against a Schema DSL
pub fn validate(schema : Schema, data : @js.Any) -> SafeParseResult {
  schema.build().safeParse(data)
}

///|
/// Parse data against a Schema DSL (throws on error)
pub fn parse_schema(schema : Schema, data : @js.Any) -> @js.Any {
  schema.build().parse(data)
}
