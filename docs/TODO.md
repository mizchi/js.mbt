## ESM Migration (Blocked)

The following Node.js modules cannot use `#module` directive due to technical limitations:

- [ ] node:buffer - Buffer class static methods
- [ ] node:http - All functions have callbacks/optional args
- [ ] node:sqlite - Database class constructor

### `#module` Limitations

❌ Cannot use `#module`:
- **Class constructors**: `new Database()`, `new Session()`
- **Property access**: `path.delimiter`, `process.env`, `os.EOL`
- **Variadic functions**: `path.join(...args)`, `path.resolve(...args)`
- **Functions with optional args**: `readFileSync(path, encoding?)`, `mkdir(path, options?)`

---

## Known Issues

### Flaky tests with NEW_MOON=0 (2025-12-09)

**Problem**: Running `NEW_MOON=0 moon test` occasionally fails with PanicError in async driver:

**Error**:
```
$PanicError
    at $bytes_literal$0 (/Users/mizchi/.moon/lib/core/builtin/hasher.mbt:1:1)
    at *async_driver (/Users/mizchi/mizchi/js.mbt/src/core/promise.mbt:322:3)
```

**Note**: This appears to be a flaky test issue, not consistently reproducible. The error originates from the async driver in `src/core/promise.mbt:322`.

**TODO**:
- [ ] Identify which specific tests are flaky
- [ ] Investigate async driver stability with legacy moon runtime

---

## TypeScript Definition Generator

### Background

MoonBit currently lacks support for generating TypeScript type definitions from compiled code. This makes it difficult to use MoonBit libraries from TypeScript with proper type safety.

### Goal

Create a transpiler that converts `.mbti` (MoonBit interface) files to TypeScript `.d.ts` definition files.

### Key Features

- [ ] Parse `.mbti` files to extract type information
- [ ] Convert MoonBit primitive types to TypeScript equivalents
- [ ] Handle `enum` to TypeScript union type conversion
- [ ] Handle `struct` to TypeScript interface conversion
- [ ] Support generic types (`T`, `Array[T]`, etc.)
- [ ] Generate proper function signatures with labeled arguments

### Type Mapping

| MoonBit | TypeScript |
|---------|------------|
| `Int`, `UInt` | `number` |
| `Float`, `Double` | `number` |
| `String` | `string` |
| `Bool` | `boolean` |
| `BigInt` | `bigint` |
| `Bytes` | `Uint8Array` |
| `Array[T]` | `T[]` |
| `T?` (Option) | `T \| null` |
| `Unit` | `void` |
| `@core.Any` | `unknown` |

### Enum to Union Example

```moonbit
// MoonBit (.mbti)
pub enum Result[T, E] {
  Ok(T)
  Err(E)
}
```

```typescript
// TypeScript (.d.ts)
type Result<T, E> =
  | { $tag: "Ok"; 0: T }
  | { $tag: "Err"; 0: E };
```

### Implementation Notes

- Input: `.mbti` files from `moon info` output
- Output: `.d.ts` files for TypeScript consumers
- Consider: Integration with build pipeline (`moon build` hook)
