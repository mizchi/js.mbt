# Bestpractice for MoonBit JavaScript FFI

Practical, executable examples of JavaScript FFI patterns using `mizchi/js`.

## TL;DR

- Use `#external pub type T` for opaque JS types, `pub(all) struct T {}` for data containers
- Use `@js.Nullable[T]`/`@js.Nullish[T]` for nullable struct fields (not `T?`)
- Use `identity_option` for safe null handling
- Use labeled optional arguments instead of Options structs
- Use `@core.Any` for lightweight JS interop without trait overhead
- Return concrete types, avoid redundant conversions
- Follow naming conventions (camelCase for Web APIs, snake_case for wrappers)
- Use `async fn` with `promise.wait()` internally for Promise-returning functions

| Type | Handles | Use Case |
|------|---------|----------|
| `@core.Any` | Any JS value | TypeScript `any` equivalent |
| `@core.Any` | Any JS value (lightweight) | Low overhead JS interop |
| `@js.Nullable[T]` | `T \| null` | API returns explicit null |
| `@js.Nullish[T]` | `T \| null \| undefined` | Optional/missing fields |
| `T?` | MoonBit Option | Function params/returns only |

---

## Type Declaration

### Opaque Types with `#external`

Use `#external pub type` for types created by JavaScript runtime:

```moonbit
///|
#external
pub type Value

///|
/// Provide as_any for JS interop
pub fn Value::as_any(self : Value) -> @core.Any = "%identity"
```

### Data Containers with `struct`

Use `pub(all) struct` for data containers with known fields:

```moonbit
///|
pub(all) struct DOMRect {
  x : Double
  y : Double
  width : Double
  height : Double
}
```

Avoid MoonBit reserved words (`method`, `ref`, `type`). Use getter functions as fallback:

```moonbit
///|
#external
pub type MyValue

///|
pub fn MyValue::as_any(self : MyValue) -> @core.Any = "%identity"

///|
pub fn MyValue::method_(self : Self) -> String {
  self.as_any()._get("method").cast()
}
```

## Type Conversion

```moonbit
///|
test "type conversion" {
  // Convert MoonBit types to Any
  let num : @core.Any = @core.any(42)
  let str = @core.any("hello")
  let bool = @core.any(true)

  // Convert back
  let num_back : Int = num.cast()
  let str_back : String = str.cast()
  let bool_back : Bool = bool.cast()
  assert_eq(num_back, 42)
  assert_eq(str_back, "hello")
  assert_eq(bool_back, true)
}
```

## Null/Undefined Handling

MoonBit cannot convert JS's `null` safely with `T?` (may result in `Some(null)`).

### Nullable Fields in Structs

Use `Nullable[T]` or `Nullish[T]` for struct fields:

```moonbit no-check
// Nullable[T] for fields that can be null
///|
pub(all) struct FileReader {
  readyState : Int
  result : @js.Nullable[@core.Any]
  error : @js.Nullable[@core.Any]
}

// Nullish[T] for fields that can be null or undefined

///|
pub(all) struct Config {
  timeout : @js.Nullish[Int]
}
```

### Converting to Option with `identity_option`

Use `identity_option` to safely convert nullable values from JS objects:

```moonbit
///|
test "identity_option for nullable values" {
  let obj = @core.Object::new()
  obj._set("exists", @core.any("value"))
  let exists : String? = @core.identity_option(obj._get("exists"))
  let missing : String? = @core.identity_option(obj._get("missing"))
  assert_eq(exists, Some("value"))
  assert_eq(missing, None)
  match exists {
    Some(v) => assert_eq(v, "value")
    None => fail("Should have value")
  }
}
```

## Method Calls

```moonbit
///|
test "_call methods" {
  let obj = @core.Object::new()
  obj._set("name", @core.any("test"))

  // _call with no arguments
  let str_repr : String = obj._call("toString", []).cast()
  inspect(str_repr, content="[object Object]")

  // _call with one argument
  let has_name : Bool = obj._call("hasOwnProperty", [@core.any("name")]).cast()
  assert_eq(has_name, true)

  // Object.keys
  let keys = @core.Object::keys(obj)
  assert_eq(keys.length(), 1)
}
```

## Best Practices

### Use Labeled Arguments Instead of Options Structs

Convert JS options objects to labeled optional arguments for better ergonomics:

```moonbit no-check
// Avoid: Options struct
pub struct ServerOptions {
  host : String
  port : Int
  timeout : Int
}

pub fn createServer(options : ServerOptions) -> Server

// Prefer: Labeled optional arguments
pub fn createServer(
  host? : String,
  port? : Int,
  timeout? : Int,
) -> Server {
  let options = @core.Object::new()
  if host is Some(v) { options._set("host", @core.any(v)) }
  if port is Some(v) { options._set("port", @core.any(v)) }
  if timeout is Some(v) { options._set("timeout", @core.any(v)) }
  ffi_create_server(options)
}
```

Benefits:
- Caller doesn't need to import/construct Options struct
- Optional fields are naturally optional
- Better IDE completion and documentation

### Return Concrete Types

Return specific types instead of `@core.Any` when possible:

```
// Avoid
fn Document::getElementById(self : Document, id : String) -> @core.Any?

// Prefer
fn Document::getElementById(self : Document, id : String) -> Element?
```

### Using @core.Any for Lightweight JS Interop

Use `@core.Any` with `_get`, `_set`, `_call` for low-overhead JS interop:

```moonbit no-check
///|
#external
pub type MyObject

///|
pub fn MyObject::as_any(self : MyObject) -> @core.Any = "%identity"

// Get property

///|
pub fn MyObject::name(self : MyObject) -> String {
  self.as_any()._get("name").cast()
}

// Set property

///|
pub fn MyObject::set_name(self : MyObject, name : String) -> Unit {
  self.as_any()._set("name", @core.any(name)) |> ignore
}

// Call method

///|
pub fn MyObject::greet(self : MyObject, msg : String) -> String {
  self.as_any()._call("greet", [@core.any(msg)]).cast()
}
```

**Benefits of `@core.Any`:**
- Zero trait vtable overhead
- Direct FFI calls without intermediate conversions
- Smaller generated code size

## Naming Conventions

### Function Naming

- **Web Standard APIs**: Use camelCase
  ```
  fn createElement(tag : String) -> Element
  fn getElementById(id : String) -> @js.Nullable[Element]
  ```

- **MoonBit-specific wrappers**: Use snake_case
  ```
  fn from_map(map : Map[String, @core.Any]) -> @core.Any
  fn to_string_radix(n : Int) -> String
  ```

### Documentation

Include links to official documentation:

```
/// See: https://developer.mozilla.org/en-US/docs/Web/API/Document/createElement
pub fn Document::create_element(self : Document, tag : String) -> Element

/// See: https://nodejs.org/api/fs.html#fsstatpath-options-callback
pub fn statSync(path : String) -> Stats
```

## Async Function Patterns

### Wrapping Promise-Returning Functions

When wrapping JavaScript functions that return Promises, use `async fn` and call `promise.wait()` internally:

```moonbit no-check
// FFI declaration - returns Promise
///|
extern "js" fn ffi_fetch(url : String) -> @core.Promise[Response] =
  #|(url) => fetch(url)

// Public API - async fn returns value directly

///|
pub async fn fetch(url : String) -> Response {
  ffi_fetch(url).wait()
}
```

**Benefits:**
- Callers don't need to call `.wait()` - values are awaited automatically
- Type signatures are cleaner (`-> T` instead of `-> @js.Promise[T]`)
- Consistent with MoonBit's async model

### Pattern: FFI + Async Wrapper

The standard pattern for async FFI functions:

```moonbit no-check
// 1. FFI function (private) - returns Promise
///|
extern "js" fn ffi_read_file(path : String) -> @core.Promise[String] =
  #|(path) => fs.promises.readFile(path, 'utf-8')

// 2. Public async function - wraps the Promise

///|
pub async fn read_file(path : String) -> String {
  ffi_read_file(path).wait()
}

// Usage in async context

///|
async test "read file" {
  let content = read_file("./test.txt") // No .wait() needed
  inspect(content.length() > 0, content="true")
}
```
