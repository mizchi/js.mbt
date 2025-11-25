# Bestpractice for MoonBit JavaScript FFI 

Practical, executable examples of JavaScript FFI patterns using `mizchi/js`.

## TL;DR

- Use `#external pub type T` for opaque JS types, `pub(all) struct T {}` for data containers
- Use `@js.Nullable[T]`/`@js.Nullish[T]` for nullable struct fields (not `T?`)
- Use `identity_option` for safe null handling
- Use labeled optional arguments instead of Options structs
- Use `&@js.JsImpl` for generic JS values, but always call `.to_any()` before passing to FFI
- Return concrete types, avoid redundant conversions
- Follow naming conventions (camelCase for Web APIs, snake_case for wrappers)
- Use `async fn` with `promise.wait()` internally for Promise-returning functions

| Type | Handles | Use Case |
|------|---------|----------|
| `@js.Any` | Any JS value | TypeScript `any` equivalent |
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

// Allow .get(key), set(key, val), .call()

///|
impl @js.JsImpl for Value
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
pub struct MyValue {}

///|
pub impl @js.JsImpl for MyValue

///|
pub fn MyValue::method_(self : Self) -> String {
  self.get("method").cast()
}
```

## Type Conversion

```moonbit
///|
test "type conversion" {
  // Convert MoonBit types to Js
  let num : @js.Any = @js.any(42)
  let str = @js.any("hello")
  let bool = @js.any(true)

  // Convert back
  let num_back : Int = @js.identity(num)
  let str_back : String = @js.identity(str)
  let bool_back : Bool = @js.identity(bool)
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
pub(all) struct FileReader {
  readyState : Int
  result : @js.Nullable[@js.Any]
  error : @js.Nullable[@js.Any]
}

// Nullish[T] for fields that can be null or undefined
pub(all) struct Config {
  timeout : @js.Nullish[Int]
}
```

### Converting to Option with `identity_option`

Use `identity_option` to safely convert nullable values from JS objects:

```moonbit
///|
test "identity_option for nullable values" {
  let obj = @js.Object::new()
  obj.set("exists", "value")
  let exists : String? = @js.identity_option(obj.get("exists"))
  let missing : String? = @js.identity_option(obj.get("missing"))
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
test "call0, call1, call2 methods" {
  let obj = @js.Object::new()
  obj.set("name", "test")

  // call0 - no arguments
  let str_repr = obj.call0("toString")
  inspect(str_repr, content="[object Object]")

  // call1 - one argument
  let has_name : Bool = @js.identity(obj.call1("hasOwnProperty", "name"))
  assert_eq(has_name, true)

  // call - variable arguments
  let keys = @js.Object::keys(obj)
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
  let options = @js.Object::new()
  if host is Some(v) { options.set("host", v) }
  if port is Some(v) { options.set("port", v) }
  if timeout is Some(v) { options.set("timeout", v) }
  ffi_create_server(options)
}
```

Benefits:
- Caller doesn't need to import/construct Options struct
- Optional fields are naturally optional
- Better IDE completion and documentation

### Return Concrete Types

Return specific types instead of `@js.Any` when possible:

```
// Avoid
fn Document::getElementById(self : Document, id : String) -> @js.Any?

// Prefer
fn Document::getElementById(self : Document, id : String) -> Element?
```

### Accepting Any JsImpl Type with `&JsImpl`

Use `&@js.JsImpl` to accept any type implementing JsImpl (Int, String, Object, etc.):

```moonbit no-check
// Accept any JsImpl type
fn setProperty(obj : @js.Any, key : String, value : &@js.JsImpl) -> Unit {
  // IMPORTANT: Always call .to_any() when passing to FFI
  obj.set(key, value.to_any())
}

// Usage
setProperty(obj, "count", 42)        // Int
setProperty(obj, "name", "test")     // String
setProperty(obj, "data", someObject) // Object
```

**⚠️ Warning**: Always use `.to_any()` when passing `&JsImpl` to JavaScript FFI:

```moonbit no-check
// ❌ WRONG: identity exposes internal structure
fn bad_example(value : &@js.JsImpl) -> @js.Any {
  @js.identity(value)  // Returns { "self": value, "method_0": ... }
}

// ✅ CORRECT: use .to_any()
fn good_example(value : &@js.JsImpl) -> @js.Any {
  value.to_any()  // Returns the actual JS value
}
```

### Avoid Redundant Conversions

Types implementing `JsImpl` don't need `.to_any()` in Array contexts:

```
// Avoid
self.call("digest", [algorithm, data.to_any()])

// Prefer
self.call("digest", [algorithm, data])
```

## Naming Conventions

### Function Naming

- **Web Standard APIs**: Use camelCase
  ```
  fn createElement(tag : String) -> Element
  fn getElementById(id : String) -> @js.Nullable[Element]
  ```

- **MoonBit-specific wrappers**: Use snake_case
  ```
  fn from_map(map : Map[String, @js.Any]) -> @js.Any
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
extern "js" fn ffi_fetch(url : String) -> @js.Promise[Response] =
  #|(url) => fetch(url)

// Public API - async fn returns value directly
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
extern "js" fn ffi_read_file(path : String) -> @js.Promise[String] =
  #|(path) => fs.promises.readFile(path, 'utf-8')

// 2. Public async function - wraps the Promise
pub async fn read_file(path : String) -> String {
  ffi_read_file(path).wait()
}

// Usage in async context
async test "read file" {
  let content = read_file("./test.txt")  // No .wait() needed
  inspect(content.length() > 0, content="true")
}
```
