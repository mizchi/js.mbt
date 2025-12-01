# @mizchi/js/npm/zod

MoonBit bindings for [Zod](https://zod.dev/) - TypeScript-first schema validation with static type inference.

## Limitations

Unlike TypeScript, MoonBit's current type system cannot infer types from Zod schemas at compile time. In TypeScript, you can do `z.infer<typeof schema>` to get static types, but this is not possible in MoonBit. Use the `@zod_codegen` package to generate MoonBit structs from Zod schemas if you need type definitions.

## Basic Usage

```moonbit
// Create schemas
let str_schema = @zod.string()
let num_schema = @zod.number()
let bool_schema = @zod.boolean()

// Validate data
let result = str_schema.safeParse(@nostd.any("hello"))
if result.success() {
  let data : String = result.data().cast()
}
```

## Object Schema

```moonbit
// Using Map syntax
let user_schema = @zod.object({
  "name": @zod.string(),
  "age": @zod.number().int(),
  "email": @zod.string().email(),
})

let data = @nostd.Object::new()
data.set("name", "Alice")
data.set("age", 30)
data.set("email", "alice@example.com")

let result = user_schema.safeParse(data.as_any())
assert_eq(result.success(), true)
```

## String Validations

```moonbit
@zod.string().min(1)           // minimum length
@zod.string().max(100)         // maximum length
@zod.string().length(10)       // exact length
@zod.string().email()          // email format
@zod.string().url()            // URL format
@zod.string().uuid()           // UUID format
@zod.string().regex("[a-z]+")  // regex pattern
@zod.string().trim()           // trim whitespace
@zod.string().toLowerCase()    // transform to lowercase
@zod.string().toUpperCase()    // transform to uppercase
```

## Number Validations

```moonbit
@zod.number().int()        // integer only
@zod.number().positive()   // > 0
@zod.number().negative()   // < 0
@zod.number().nonnegative() // >= 0
@zod.number().gt(5)        // > 5
@zod.number().gte(5)       // >= 5
@zod.number().lt(10)       // < 10
@zod.number().lte(10)      // <= 10
```

## Modifiers

```moonbit
@zod.string().optional()   // string | undefined
@zod.string().nullable()   // string | null
@zod.string().nullish()    // string | null | undefined
@zod.string().default_(@nostd.any("default"))  // with default value
```

## Error Handling

```moonbit
let result = schema.safeParse(invalid_data)
if not(result.success()) {
  let error = result.error()
  let issues = error.issuesArray()  // Get array of ZodIssue
  for issue in issues {
    println(issue.message)
    println(issue.path)
  }
}
```

## See Also

- `@mizchi/js/npm/zod_codegen` - Generate MoonBit structs from Zod schemas
