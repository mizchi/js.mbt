# MoonBit JavaScript FFI Guide

A practical guide for writing JavaScript FFI bindings using `mizchi/js`.

> **See also**: [Executable FFI examples](../src/examples/js_ffi.mbt.md) - Runnable test cases demonstrating these patterns.

## Core Concepts

### The `JsImpl` Trait

When you implement `JsImpl` for a type, you can:

- **Convert to JavaScript**: `value.to_js() -> Js`
- **Access properties**: `value.get("propertyName") -> Js` (accepts `&PropertyKey`)
- **Set properties**: `value.set("propertyName", jsValue)` (accepts `&PropertyKey`)
- **Call methods**: `value.call("methodName", [arg1, arg2])`
- **Call with specific arity**: `value.call0("method")`, `value.call1("method", arg1)`, `value.call2("method", arg1, arg2)`
- **Call as function**: `value.call_self([arg1, arg2])`, `value.call_self0()`
- **Error handling**: `value.call_throwable("method", [args])`, `value.call_self_throwable([args])`
- **Property operations**: `value.delete("propertyName")`, `value.hasOwnProperty("propertyName")`
- **Cast types**: `unsafe_cast(value) -> T`

### PropertyKey Trait

Properties can be accessed using `String`, `Int`, or `Symbol` keys:

```moonbit
pub trait PropertyKey {
  to_key(Self) -> Js
}

// Implementations
pub impl PropertyKey for String  // obj["name"]
pub impl PropertyKey for Int     // arr[0]
pub impl PropertyKey for Symbol  // obj[Symbol.iterator]
```

### Basic Type Usage

```moonbit
// Define an external type
#external
pub type Document

// Implement Js trait
pub impl JsImpl for Document

// Now you can use it
fn example(doc: Document) {
  // Get property
  let title: String = unsafe_cast(doc.get("title"))
  
  // Set property
  doc.set("title", "New Title")
  
  // Call method
  let element = doc.call("createElement", ["div"])
}
```

## Naming Conventions with `#alias`

JavaScript uses camelCase, MoonBit uses snake_case. Use `#alias` to support both:

```moonbit
#alias(encode_uri_component)
pub fn encodeURIComponent(str: String) -> String

#alias(query_selector)
pub fn querySelector(selector: String) -> Element
```

**When to use `#alias`:**
- ✅ Functions mapping to JavaScript APIs with underscores
- ❌ MoonBit utilities (`from_map`, `array_from`)
- ❌ Functions without underscores (no conversion needed)
- ❌ Reserved word functions (`throw_`, `new_`)

## Common Patterns

### Pattern 1: Simple FFI Function

```moonbit
#alias(encode_uri)
pub extern "js" fn encodeURI(uri: String) -> String =
  #|(uri) => encodeURI(uri)
```

### Pattern 2: Object Methods

```moonbit
#external
pub type Document
pub impl JsImpl for Document

// Method via extern
#alias(create_element)
pub extern "js" fn Document::createElement(self: Self, tag: String) -> Element =
  #|(self, tag) => self.createElement(tag)

// Method via call
#alias(query_selector)
pub fn Document::querySelector(self: Self, selector: String) -> Element? {
  self.call1("querySelector", selector) |> @js.unsafe_cast_option()
}
```

### Pattern 3: Properties (Getters/Setters)

```moonbit
// Getter
pub fn Document::title(self: Self) -> String {
  unsafe_cast(self.get("title"))
}

// Setter
#alias(set_title)
pub fn Document::setTitle(self: Self, title: String) -> Unit {
  self.set("title", title) |> ignore
}
```

### Pattern 4: Optional Parameters

```moonbit
#alias(mkdir_sync)
pub fn mkdirSync(path: String, recursive?: Bool) -> Unit {
  let fs = @node.require("node:fs")
  match recursive {
    Some(r) => {
      let opts = @js.Object::new()
      opts.set("recursive", r)
      fs.call2("mkdirSync", path, opts) |> ignore
    }
    None => fs.call1("mkdirSync", path) |> ignore
  }
}

// Usage
mkdirSync("/tmp/test")
mkdirSync("/tmp/test", recursive=true)
```

### Pattern 5: Named Parameters

```moonbit
pub fn fetch(
  url: String,
  method_~: String,           // Required named parameter
  headers?: Map[String, String] = {},  // Optional with default
  body?: &JsImpl
) -> Promise[Response] {
  let init = @js.Object::new()
  init.set("method", method_)
  
  if body is Some(b) {
    init.set("body", b)
  }
  
  // Build headers
  let h = @js.Object::new()
  for k, v in headers {
    h.set(k, v)
  }
  init.set("headers", h)
  
  ffi_fetch(url, init.to_js())
}

// Usage
fetch("https://api.example.com", method_="POST", body=json_data)
```

### Pattern 6: Constructors

```moonbit
// Using extern
extern "js" fn ffi_new_url(url: String) -> Val =
  #|(url) => new URL(url)

pub fn URL::new(url: String) -> URL {
  unsafe_cast(ffi_new_url(url))
}

// Using helper
pub fn Array::new() -> JsArray {
  unsafe_cast(@js.new_(@js.global_get("Array"), []))
}
```

### Pattern 7: Handling Null/Undefined

```moonbit
// Built-in helper function
pub fn[A] unsafe_cast_option(v : Js) -> A?

#alias(get_element_by_id)
pub fn getElementById(id: String) -> Element? {
  document().call1("getElementById", id) |> @js.unsafe_cast_option()
}

// Usage
match getElementById("header") {
  Some(el) => el.set("textContent", "Hello")
  None => console.log("Element not found")
}

// Safe property setting with optional values
pub fn[O : JsImpl, V : JsImpl] set_if_exists(
  o : O,
  key : &PropertyKey,
  value : V?,
) -> Unit

// Example
set_if_exists(obj, "optional_field", Some("value"))  // Sets property
set_if_exists(obj, "optional_field", None)           // Skips setting
```

### Pattern 8: Promises and Async

```moonbit
// Create Promise
pub fn Promise::new(f: ((A) -> Unit, (JsError) -> Unit) -> Unit) -> Promise[A]

// Use async/await
pub async fn Promise::unwrap(self: Self[A]) -> A

// Error handling with throwable
pub fn[T] throwable(f : () -> T raise?) -> T raise JsThrowError

// Example
run_async(() => {
  let response = fetch("https://api.example.com", method_="GET")
    .unwrap() catch {
      e => {
        console.log("Error: " + e.to_string())
        return
      }
    }
  
  let data = response.json().unwrap() catch {
    e => {
      console.log("Parse error: " + e.to_string())
      return
    }
  }
  
  console.log(data)
})

// Using throwable for explicit error handling
fn fetch_data() -> Js raise JsThrowError {
  throwable(() => {
    globalThis().call1("fetch", "https://api.example.com")
  })
}
```

### Pattern 9: Node.js Modules

```moonbit
fn fs_module() -> Val {
  @node.require("node:fs")
}

#alias(read_file_sync)
pub fn readFileSync(path: String) -> Buffer {
  let fs = fs_module()
  fs.call1("readFileSync", path) |> unsafe_cast
}

#alias(write_file_sync)
pub fn writeFileSync(path: String, data: &JsImpl) -> Unit {
  let fs = fs_module()
  fs.call2("writeFileSync", path, data) |> ignore
}

// Usage
let content = readFileSync("package.json")
writeFileSync("output.txt", "Hello World")
```

## Real-World Examples

### Example 1: DOM Manipulation

```moonbit
fn init {
  let doc = document()
  
  // Create element
  let div = doc.createElement("div")
  div.set("className", "container")
  div.set("textContent", "Hello, World!")
  
  // Query and append
  match doc.getElementById("app") {
    Some(app) => app.call1("appendChild", div) |> ignore
    None => console.log("App element not found")
  }
}
```

### Example 2: Fetch API

```moonbit
fn init {
  run_async(() => {
    let response = fetch(
      "https://jsonplaceholder.typicode.com/todos/1",
      method_="GET",
      headers={"Accept": "application/json"}
    ).unwrap() catch {
      e => {
        console.log("Fetch failed: " + e.to_string())
        return
      }
    }
    
    let json = response.json().unwrap() catch {
      e => {
        console.log("Parse failed: " + e.to_string())
        return
      }
    }
    
    console.log(json)
  })
}
```

### Example 3: Node.js File Operations

```moonbit
fn main {
  // Read file
  let content = readFileSync("input.txt")
  let text = content.toString("utf-8")
  
  // Process
  let lines = text.split("\n")
  let processed = lines.map(fn(line) { line.trim() })
  
  // Write file
  writeFileSync("output.txt", processed.join("\n"))
  
  console.log("Processing complete")
}
```

### Example 4: React Component

```moonbit
fn TodoApp() -> Element {
  let (todos, setTodos) = useState([])
  
  let addTodo = fn(text: String) {
    setTodos(fn(prev) { prev.push(text); prev })
  }
  
  createElement(
    "div",
    Object::from_pairs([("className", "todo-app")]),
    [
      createElement("h1", null(), ["Todo List"]),
      createElement(TodoList, Object::from_pairs([("todos", todos)])),
      createElement(AddTodo, Object::from_pairs([("onAdd", addTodo)]))
    ]
  )
}
```

### Pattern 10: BigInt Operations

```moonbit
// Create BigInt
let bigint = @js.JsBigInt::from_int(42)
let bigint2 = @js.JsBigInt::from_string("123456789012345678901234567890")

// Arithmetic operations
let sum = @js.JsBigInt::add(bigint, bigint2)
let diff = @js.JsBigInt::sub(bigint, bigint2)
let product = @js.JsBigInt::mul(bigint, bigint2)
let quotient = @js.JsBigInt::div(bigint, bigint2)
let remainder = @js.JsBigInt::mod(bigint, bigint2)

// Comparison
let is_equal = @js.JsBigInt::equal(bigint, bigint2)
let is_less = @js.JsBigInt::lt(bigint, bigint2)

// Convert to string
let str = bigint.to_string()
let hex = bigint.to_string_radix(16)
```

### Pattern 11: WeakMap, WeakSet, and WeakRef

```moonbit
// WeakMap for object metadata
let metadata : WeakMap[Element, String] = @js.WeakMap::new()
metadata.set(element, "some metadata")
match metadata.get(element) {
  Some(data) => console.log(data)
  None => console.log("No metadata")
}

// WeakSet for tracking objects
let tracked : WeakSet[Element] = @js.WeakSet::new()
tracked.add(element)
if tracked.has(element) {
  console.log("Element is tracked")
}

// WeakRef for caching
let cache : WeakRef[LargeObject] = @js.WeakRef::new(large_object)
match cache.deref() {
  Some(obj) => console.log("Object still alive")
  None => console.log("Object was garbage collected")
}

// FinalizationRegistry for cleanup
let registry = @js.FinalizationRegistry::new(fn(held_value) {
  console.log("Object was finalized: " + held_value.to_string())
})
registry.register(element, "cleanup data")
```

## Best Practices

### 1. Type Safety

```moonbit
// Good: Specific types
pub fn createElement(tag: String) -> Element

// Avoid: Generic Js when type is known
pub fn createElement(tag: String) -> Js
```

### 2. Document Your APIs

```moonbit
///|
/// Creates a new HTML element with the given tag name
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/createElement
#alias(create_element)
pub fn createElement(tag: String) -> Element
```

### 3. Handle Errors Gracefully

```moonbit
// Use Option for nullable values
pub fn getElementById(id: String) -> Element?

// Use raise for operations that can fail
pub fn fetch(url: String) -> Js raise JsThrowError {
  throwable(() => globalThis().call1("fetch", url))
}
```

### 4. Consistent Naming

- Use `#alias(snake_case)` followed by `pub fn camelCase`
- Use `~` for required named parameters
- Use `?` for optional parameters  
- Use `_` suffix for reserved words (`throw_`, `new_`)

### 5. Use PropertyKey for Flexible Access

```moonbit
// Accept any PropertyKey type
pub fn get_property[K : PropertyKey](obj : Js, key : K) -> Js {
  obj.get(key)
}

// Works with String, Int, Symbol
get_property(obj, "name")
get_property(arr, 0)
get_property(obj, Symbol::iterator())
```

## Quick Reference

```moonbit
// Type definition
#external
pub type MyType
pub impl JsImpl for MyType

// Property access (accepts &PropertyKey)
value.get("prop")              // Get property
value.get(0)                   // Get by index
value.get(symbol)              // Get by symbol
value.set("prop", val)         // Set property
value.delete("prop")           // Delete property
value.hasOwnProperty("prop")   // Check property

// Method calls
value.call("method", [arg1, arg2])     // Call with array
value.call0("method")                  // Call with no args
value.call1("method", arg1)            // Call with 1 arg
value.call2("method", arg1, arg2)      // Call with 2 args
value.call_self([arg1, arg2])          // Call as function
value.call_self0()                     // Call as function (no args)

// Error handling
value.call_throwable("method", [args])           // Call with error handling
value.call_self_throwable([args])                // Call self with error handling
throwable(() => risky_operation())               // Wrap risky code

// Type conversion
unsafe_cast(value)             // Cast to target type
unsafe_cast_option(value)      // Cast to Option type
value.to_js()                  // Convert to Js
js(value)                      // Convert MoonBit value to JS
option_js(value)               // Convert to Js?

// Helpers
@js.Object::new()              // Create empty object
@js.Object::keys(obj)          // Get object keys
@js.Object::values(obj)        // Get object values
@js.Object::entries(obj)       // Get object entries
@js.Object::freeze(obj)        // Freeze object
@js.Object::seal(obj)          // Seal object
@js.from_map(map)              // Map to object
@js.from_array(arr)            // Array to JS array
@js.set_if_exists(obj, key, opt_val)  // Set if value exists

// Type checking
is_null(val)                   // Check null
is_undefined(val)              // Check undefined
is_nullish(val)                // Check null or undefined
is_array(val)                  // Check array
is_object(val)                 // Check object

// Symbol operations
@js.symbol("name")             // Create symbol
@js.Symbol::iterator()         // Get iterator symbol
@js.Symbol::asyncIterator()    // Get async iterator symbol
@js.Symbol::dispose()          // Get dispose symbol
@js.Symbol::asyncDispose()     // Get async dispose symbol
```

## Learn More

- Source code: https://github.com/mizchi/js.mbt
- MoonBit docs: https://docs.moonbitlang.com
- Prior art: https://mooncakes.io/docs/rami3l/js-ffi
