# Runtime Cost Analysis

This document analyzes the bundle size overhead when using various MoonBit built-in types with JavaScript interop.

## Measurement Method

- All sizes are **minified** using `terser --compress --mangle`
- Baseline: `size1_basic` (662B) - minimal nostd usage
- Test files: `src/nostd/_tests/size*`

## Bundle Size Overview

| Type Conversion | minified | Overhead | Category |
|-----------------|----------|----------|----------|
| `Array[T]` → Any (`from_array`) | 693B | +31B | Zero-cost |
| `Array[(String, Any)]` → Object (for loop) | 627B | -35B | Zero-cost |
| `Array[(String, Any)]` → Object (fromEntries FFI) | 380B | -282B | Zero-cost |
| `AsyncIterator` struct | 782B | +120B | Minimal |
| `async` / `Promise.wait` | 1,246B | +584B | Minimal |
| `Symbol` (iterator, asyncIterator) | 2,161B | +1,499B | Light |
| `identity_option` (Any → T?) | 2,248B | +1,586B | Light |
| `Any::to_string` + `Show` | 2,803B | +2,141B | Light |
| `HashSet[T]` → Array | 5,334B | +4,672B | Heavy |
| `Map[String, T]` → Object | 6,876B | +6,214B | Heavy |
| `Json` → Any | 7,585B | +6,923B | Heavy |
| `@immut/array.T[T]` → Array | 7,839B | +7,177B | Heavy |
| `@immut/hashmap.HashMap` → Object | 12,305B | +11,643B | Heavy |

## Categories

### Zero-cost (~0B overhead)

These use `%identity` and produce no runtime code:

```moonbit
pub fn[T] from_array(arr : Array[T]) -> @core.Any = "%identity"
```

- `Array[T]` → `@core.Any` - MoonBit arrays are JS arrays at runtime
- `Array[(String, Any)]` → Object - Tuples compile to `{_0, _1}` objects, simple iteration

### Minimal (<1KB overhead)

- **AsyncIterator struct**: Simple struct wrapper (~120B)
- **async/Promise.wait**: CPS transformation (~584B)

### Light (1-2KB overhead)

- **Symbol**: FFI function definitions for `Symbol.iterator`, `Symbol.asyncIterator`, etc.
- **identity_option**: `is_nullish` check + `Option` construction
- **Any::to_string**: Direct FFI call, but `println` adds StringBuilder overhead (~2KB)

### Heavy (>4KB overhead)

These types include full data structure implementations:

| Type | Why Heavy |
|------|-----------|
| `Map` | Full hash map implementation (hash functions, bucket management, iteration) |
| `HashSet` | Similar to Map, but for sets |
| `Json` | Json enum + Map implementation for `Object` variant |
| `@immut/array` | Persistent/immutable array (tree-based structure) |
| `@immut/hashmap` | Persistent/immutable hash map (HAMT structure) |

## Recommendations

### For Minimal Bundle Size

1. **Use `Array[T]` directly** - zero-cost conversion
2. **Build objects manually** instead of using `Map`:
   ```moonbit
   // Good: ~0B overhead
   let obj = @core.Object::new()
   obj["name"] = @core.any("Alice")
   obj["age"] = @core.any(30)

   // Bad: ~6KB overhead (Map implementation included)
   let map : Map[String, @core.Any] = { "name": @core.any("Alice"), "age": @core.any(30) }
   from_map(map)
   ```

3. **Avoid immutable collections** (`@immut/array`, `@immut/hashmap`) for JS interop
4. **Avoid `Json` type** if you only need to build JS objects

### When Heavy Types Are Acceptable

- Server-side code where bundle size is less critical
- Applications already using these types for other purposes
- When the ergonomics outweigh the size cost

## Test Files

Each test is in `src/nostd/_tests/`:

| Test | Description |
|------|-------------|
| `size1_basic` | Baseline - minimal nostd |
| `size5_from_array` | Array conversion |
| `size7_identity_option` | Nullable to Option |
| `size8_symbol` | JS Symbol access |
| `size9_async_iterator` | AsyncIterator struct |
| `size14_async` | Async/Promise usage |
| `size15_to_string` | Any::to_string + Show trait |
| `size16_from_tuple_array` | Array[(String, Any)] → Object (for loop) |
| `size17_from_entries` | Array[(String, Any)] → Object (Object.fromEntries) |
| `size_builtin_convert` | All builtin type conversions (Map, Json, HashSet, @immut/*) |

Run measurements:
```bash
moon build --target js
for f in target/js/release/build/nostd/_tests/size*/size*.js; do
  name=$(basename $f .js)
  minified=$(npx terser "$f" --compress --mangle | wc -c)
  echo "$name: ${minified}B"
done
```
