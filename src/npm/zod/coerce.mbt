///| Coercion schemas - NOT YET MIGRATED TO ESM

///|

///| These functions still use `require()` because `coerce` is an object export,

///| not a function export. `#module` only works with function exports.

///| TODO: Migrate to ESM when MoonBit supports non-function module imports.

///|
/// Create a coerced string schema (converts input to string)
pub extern "js" fn coerce_string() -> ZodSchema =
  #| () => require("zod").coerce.string()

///|
/// Create a coerced number schema (converts input to number)
pub extern "js" fn coerce_number() -> ZodSchema =
  #| () => require("zod").coerce.number()

///|
/// Create a coerced boolean schema (converts input to boolean)
pub extern "js" fn coerce_boolean() -> ZodSchema =
  #| () => require("zod").coerce.boolean()

///|
/// Create a coerced bigint schema (converts input to bigint)
pub extern "js" fn coerce_bigint() -> ZodSchema =
  #| () => require("zod").coerce.bigint()

///|
/// Create a coerced date schema (converts input to Date)
pub extern "js" fn coerce_date() -> ZodSchema =
  #| () => require("zod").coerce.date()
