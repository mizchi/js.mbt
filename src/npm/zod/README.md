# @mizchi/js/npm/zod

MoonBit bindings for [Zod](https://zod.dev/) - TypeScript-first schema validation with static type inference.

## Basic Usage

```moonbit
// Create schemas
let str_schema = string()
let num_schema = number()
let bool_schema = boolean()

// Validate data
let result = str_schema.safeParse(@js.any("hello"))
if result.success() {
  let data : String = result.data().cast()
}
```

## Object Schema

```moonbit
let shape = @js.Object::new()
shape.set("name", string())
shape.set("age", number().int())
shape.set("email", string().email())

let user_schema = object(shape.to_any())

let data = @js.Object::new()
data.set("name", "Alice")
data.set("age", 30)
data.set("email", "alice@example.com")

let result = user_schema.safeParse(data.to_any())
assert_eq(result.success(), true)
```

## String Validations

```moonbit
string().min(1)           // minimum length
string().max(100)         // maximum length
string().length(10)       // exact length
string().email()          // email format
string().url()            // URL format
string().uuid()           // UUID format
string().regex("[a-z]+")  // regex pattern
string().trim()           // trim whitespace
string().toLowerCase()    // transform to lowercase
string().toUpperCase()    // transform to uppercase
```

## Number Validations

```moonbit
number().int()        // integer only
number().positive()   // > 0
number().negative()   // < 0
number().nonnegative() // >= 0
number().gt(5)        // > 5
number().gte(5)       // >= 5
number().lt(10)       // < 10
number().lte(10)      // <= 10
```

## Modifiers

```moonbit
string().optional()   // string | undefined
string().nullable()   // string | null
string().nullish()    // string | null | undefined
string().default_(@js.any("default"))  // with default value
```

## DSL (Type-Safe Schema Builder)

The DSL module provides MoonBit enums for building schemas in a type-safe way:

```moonbit
// Using DSL enums
let schema = Schema::Object(
  [
    ("id", positive_int()),
    ("username", Schema::String([StringRule::Min(3), StringRule::Max(20)])),
    ("email", email()),
    ("age", optional(Schema::Number([NumberRule::Int, NumberRule::Gte(0)]))),
    ("roles", Schema::Array(Schema::Enum(["admin", "user"]), [ArrayRule::Nonempty])),
  ],
  [ObjectRule::Strict],
)

// Build and validate
let zod_schema = schema.build()
let result = zod_schema.safeParse(data)

// Or use the validate helper
let result = validate(schema, data)
```

### DSL Helper Functions

```moonbit
str()           // Schema::String([])
num()           // Schema::Number([])
bool()          // Schema::Boolean
email()         // Schema::String([Email])
url_string()    // Schema::String([Url])
positive_int()  // Schema::Number([Int, Positive])
optional(s)     // Schema::WithModifier(s, Optional)
nullable(s)     // Schema::WithModifier(s, Nullable)
```

## Code Generation

Generate MoonBit structs from Zod schemas:

```moonbit
// Define a zod schema
let shape = @js.Object::new()
shape.set("id", number().int())
shape.set("name", string())
shape.set("email", string().email().optional())

let schema = object(shape.to_any())

// Generate MoonBit code
let code = generate_from_zod(schema, "User")
// Output:
// #derive(ToJson, FromJson)
// pub struct User {
//   id : Int
//   name : String
//   email : String?
// }
```

### Code Generation Options

```moonbit
let config : CodegenConfig = {
  type_prefix: "Api",      // Add prefix to type names
  derive_json: true,       // Generate #derive(ToJson, FromJson)
  add_docs: true,          // Include description as doc comments
}

let code = generate_from_zod(schema, "User", config=config)
// Output:
// #derive(ToJson, FromJson)
// pub struct ApiUser {
//   ...
// }
```

### JSON Schema Access

```moonbit
let json_schema = JsonSchema::from_zod(schema)

// Get schema properties
json_schema.type_()       // Some("object")
json_schema.required()    // ["id", "name"]
json_schema.to_json()     // JSON string representation
```

## Type Mapping (JSON Schema -> MoonBit)

| JSON Schema Type | MoonBit Type |
|------------------|--------------|
| `string` | `String` |
| `number` | `Double` |
| `integer` | `Int` |
| `boolean` | `Bool` |
| `array` | `Array[T]` |
| `object` | `@js.Any` (or generated struct) |
| nullable | `T?` |
| optional | `T?` |

## Error Handling

```moonbit
let result = schema.safeParse(invalid_data)
if not(result.success()) {
  let error = result.error()
  let flattened = error.flatten()  // Get flattened error structure
}
```
