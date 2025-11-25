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
