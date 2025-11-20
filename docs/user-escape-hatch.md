# Escape Hatch: Working with Missing APIs

This library is still evolving. If you encounter missing APIs, you can directly use the `Js` type and the `JsImpl` trait methods to interact with any JavaScript API.

> **See also**: [Executable escape hatch examples](../src/examples/escape_hatch.mbt.md) - Runnable test cases demonstrating these patterns.

## Why You Might Need This

The `mizchi/js` library provides typed wrappers for many JavaScript APIs, but:

- Some APIs may not be implemented yet
- New browser/Node.js APIs may not be covered
- Third-party library bindings may be incomplete
- You may need to access unusual or experimental APIs

In these cases, you can use the **escape hatch**: direct manipulation using `Val` and the `Js` trait.

## Core Operations

Any type implementing the `Js` trait (including `Val`) provides these operations:

```moonbit
// Get property
value.get("propertyName") -> Val
// JS: value.propertyName or value["propertyName"]

// Set property
value.set("propertyName", jsValue)
// JS: value.propertyName = jsValue or value["propertyName"] = jsValue

// Call method
value.call("methodName", [arg1, arg2]) -> Val
// JS: value.methodName(arg1, arg2)

// Call as function
value.call_self([arg1, arg2]) -> Val
// JS: value(arg1, arg2)

// Delete property
value.delete("propertyName")
// JS: delete value.propertyName

// Check property existence
value.has_own_property("propertyName") -> Bool
// JS: value.hasOwnProperty("propertyName")
```

## Pattern 1: Accessing Missing Properties

When a property isn't exposed by the library:

```moonbit
// Example: Accessing navigator.userAgent (not in the library)
fn get_user_agent() -> String {
  let navigator = @js.globalThis().get("navigator")
  // JS: globalThis.navigator.userAgent
  unsafe_cast(navigator.get("userAgent"))
}

// Example: Accessing window.devicePixelRatio
fn get_device_pixel_ratio() -> Double {
  let window = @js.globalThis().get("window")
  unsafe_cast(window.get("devicePixelRatio"))
}

// Example: Reading a config object
fn read_config() -> String {
  let config = @js.globalThis().get("APP_CONFIG")
  unsafe_cast(config.get("apiEndpoint"))
}
```

## Pattern 2: Calling Missing Methods

When a method isn't wrapped:

```moonbit
// Example: Calling localStorage.clear() (not in the library)
fn clear_local_storage() {
  let storage = @js.globalThis().get("localStorage")
  // JS: localStorage.clear()
  storage.call("clear", []) |> ignore
}

// Example: Calling element.scrollIntoView()
fn scroll_element_into_view(element: Element) {
  element.call("scrollIntoView", [@js.js(true)]) |> ignore
}

// Example: Using Intl.DateTimeFormat
fn format_date(date: Val) -> String {
  let intl = @js.globalThis().get("Intl")
  let formatter = intl.get("DateTimeFormat")
  // JS: new Intl.DateTimeFormat("en-US")
  let instance = @js.new_(formatter, ["en-US"])
  // JS: instance.format(date)
  unsafe_cast(instance.call("format", [date]))
}
```

## Pattern 3: Building Complex Options

When you need to pass complex options objects:

```moonbit
// Example: Fetch with custom options
fn fetch_with_custom_options(url: String) -> Promise[Response] {
  let options = @js.Object::new()
  options.set("method", "POST")
  options.set("mode", "cors")
  options.set("credentials", "include")
  
  // Build headers object
  let headers = @js.Object::new()
  headers.set("Content-Type", "application/json")
  headers.set("X-Custom-Header", "value")
  options.set("headers", headers)
  
  // Build body
  let body = @js.Object::new()
  body.set("key", "value")
  options.set("body", @js.JSON::stringify(body.to_js()))
  
  // JS: fetch(url, options)
  let fetch_fn = @js.globalThis().get("fetch")
  unsafe_cast(fetch_fn.call_self([url, options]))
}

// Example: Creating a WebSocket with protocols
fn create_websocket(url: String, protocols: Array[String]) -> Val {
  let ws_constructor = @js.globalThis().get("WebSocket")
  // JS: new WebSocket(url, protocols)
  @js.new_(ws_constructor, [url, @js.from_array(protocols)])
}
```

## Pattern 4: Working with Third-Party Libraries

When using npm packages without bindings:

```moonbit
// Example: Using lodash
fn use_lodash() {
  let _ = @js.globalThis().get("_")  // Assumes lodash is loaded globally
  
  let array = @js.from_array([1, 2, 3, 4, 5])
  // JS: _.chunk(array, 2)
  let result = _.call("chunk", [array, @js.js(2)])
  // result: [[1,2], [3,4], [5]]
  
  @js.log(result)
}

// Example: Using moment.js
fn format_with_moment() -> String {
  let moment = @js.globalThis().get("moment")
  // JS: moment()
  let now = moment.call_self([])
  // JS: now.format("YYYY-MM-DD")
  unsafe_cast(now.call("format", ["YYYY-MM-DD"]))
}

// Example: Using chart.js
fn create_chart(canvas_id: String) {
  let chart_class = @js.globalThis().get("Chart")
  let canvas = @dom.document().getElementById(canvas_id) catch {
    _ => {
      @js.log("Canvas not found")
      return
    }
  }
  
  let config = @js.Object::new()
  config.set("type", "line")
  
  let data = @js.Object::new()
  data.set("labels", @js.from_array(["Jan", "Feb", "Mar"]))
  config.set("data", data)
  
  // JS: new Chart(canvas, config)
  @js.new_(chart_class, [canvas, config]) |> ignore
}
```

## Pattern 5: Handling Node.js Modules Not in the Library

```moonbit
// Example: Using 'crypto' module directly
fn generate_random_uuid() -> String {
  let crypto = @node.require("node:crypto")
  // JS: crypto.randomUUID()
  unsafe_cast(crypto.call0("randomUUID"))
}

// Example: Using 'zlib' module
fn compress_data(data: String) {
  let zlib = @node.require("node:zlib")
  let buffer = @node.Buffer::from_string(data)
  let compressed = zlib.call("gzipSync", [buffer])
  @js.log(compressed)
}

// Example: Using 'dns' module
fn lookup_hostname(hostname: String) {
  let dns = @node.require("node:dns")
  let promises = dns.get("promises")
  let result = promises.call("lookup", [hostname])
  @js.log(result)
}
```

## Pattern 6: Event Listeners and Callbacks

```moonbit
// Example: Adding custom event listener
fn add_custom_listener(element: Element, event_name: String) {
  let callback = fn(event: Val) {
    @js.log("Event fired!")
    @js.log(event.get("type"))
  }
  
  // JS: element.addEventListener(event_name, callback)
  element.call("addEventListener", [event_name, @js.from_fn1(callback)]) |> ignore
}

// Example: Window resize handler
fn on_window_resize(handler: (Int, Int) -> Unit) {
  let window = @js.globalThis().get("window")
  
  let callback = fn(_event: Val) {
    let width: Int = unsafe_cast(window.get("innerWidth"))
    let height: Int = unsafe_cast(window.get("innerHeight"))
    handler(width, height)
  }
  
  window.call("addEventListener", ["resize", @js.from_fn1(callback)]) |> ignore
}
```

## Pattern 7: Working with Arrays and Collections

```moonbit
// Example: Using Array methods
fn use_array_methods() {
  let arr = @js.from_array([1, 2, 3, 4, 5])
  
  // Filter
  let filter_fn = fn(x: Val) -> Bool {
    let num: Int = unsafe_cast(x)
    num > 2
  }
  // JS: arr.filter(x => x > 2)
  let filtered = arr.call("filter", [@js.from_fn1(filter_fn)])
  @js.log(filtered)  // [3, 4, 5]
  
  // Map
  let map_fn = fn(x: Val) -> Val {
    let num: Int = unsafe_cast(x)
    @js.js(num * 2)
  }
  // JS: arr.map(x => x * 2)
  let mapped = arr.call("map", [@js.from_fn1(map_fn)])
  @js.log(mapped)  // [2, 4, 6, 8, 10]
}

// Example: Using Set
fn use_set() {
  let set_class = @js.globalThis().get("Set")
  // JS: new Set()
  let set = @js.new_(set_class, [])
  
  // JS: set.add(1), set.add(2), set.add(1)
  set.call("add", [1]) |> ignore
  set.call("add", [2]) |> ignore
  set.call("add", [1]) |> ignore  // Duplicate
  
  // JS: set.size
  let size: Int = unsafe_cast(set.get("size"))
  @js.log(size)  // 2
  
  // JS: set.has(1)
  let has_one: Bool = unsafe_cast(set.call("has", [1]))
  @js.log(has_one)  // true
}
```

## Pattern 8: Checking API Availability

```moonbit
// Example: Feature detection
fn supports_web_workers() -> Bool {
  let worker = @js.globalThis().get("Worker")
  !@js.is_undefined(worker)
}

// Example: Checking for specific API
fn has_intersection_observer() -> Bool {
  let io = @js.globalThis().get("IntersectionObserver")
  !@js.is_undefined(io)
}

// Example: Polyfill pattern
fn get_performance_now() -> Double {
  let performance = @js.globalThis().get("performance")
  
  if @js.is_undefined(performance) {
    // Fallback to Date.now()
    let date_class = @js.globalThis().get("Date")
    let now: Double = unsafe_cast(date_class.call0("now"))
    return now
  }
  
  unsafe_cast(performance.call0("now"))
}
```

## Pattern 9: Accessing Nested Properties

```moonbit
// Example: Deep property access
fn get_nested_value() -> String {
  // JS: window.myApp.config.api.endpoint
  let config = @js.globalThis().get("window")
    .get("myApp")
    .get("config")
    .get("api")
  
  unsafe_cast(config.get("endpoint"))
}

// Example: Safe nested access with checks
fn get_nested_safely() -> String? {
  let window = @js.globalThis().get("window")
  if @js.is_undefined(window) {
    return None
  }
  
  let my_app = window.get("myApp")
  if @js.is_undefined(my_app) {
    return None
  }
  
  let config = my_app.get("config")
  if @js.is_undefined(config) {
    return None
  }
  
  let value = config.get("apiKey")
  if @js.is_undefined(value) {
    return None
  }
  
  Some(unsafe_cast(value))
}
```

## Pattern 10: Handling JavaScript Exceptions

JavaScript functions can throw exceptions. Use `throwable` to safely wrap potentially throwing code:

```moonbit
// Example: Wrapping a potentially throwing function
fn call_risky_api() {
  let result = @js.throwable(fn() {
    let api = @js.globalThis().get("riskyAPI")
    // JS: riskyAPI.doSomething()
    api.call("doSomething", [])
  }) catch {
    @js.JsThrowError::Error(e) => {
      // Handle JavaScript Error objects
      @js.log("Error occurred: " + e.message())
      @js.log("Stack trace: " + e.stack())
      return
    }
    @js.JsThrowError::Value(v) => {
      // Handle non-Error throws (e.g., throw "string")
      @js.log("Thrown value: " + v.to_string())
      return
    }
  }
  @js.log(result)
}

// Example: Using call_throwable
fn call_method_safely(obj: Val, method_name: String) {
  // JS: obj.methodName() with try-catch
  let result = obj.call_throwable(method_name, []) catch {
    @js.JsThrowError::Error(e) => {
      @js.log("Method call failed: " + e.message())
      return @js.undefined()
    }
    e => {
      @js.log("Unexpected error: " + e.to_string())
      return @js.undefined()
    }
  }
  result
}

// Example: Calling undefined methods safely
fn try_call_method(obj: Val) {
  let result = try? obj.call_throwable("nonexistentMethod", [])
  
  match result {
    Ok(value) => @js.log("Success: " + value.to_string())
    Err(@js.JsThrowError::Error(e)) => {
      @js.log("Error: " + e.message())
    }
    Err(e) => @js.log("Other error: " + e.to_string())
  }
}

// Example: JSON parsing with error handling
fn parse_json_safely(json_string: String) -> Val? {
  let result = @js.throwable(fn() {
    let json = @js.globalThis().get("JSON")
    // JS: JSON.parse(json_string)
    json.call("parse", [json_string])
  }) catch {
    @js.JsThrowError::Error(e) => {
      @js.log("Invalid JSON: " + e.message())
      return None
    }
    _ => return None
  }
  Some(result)
}

// Example: Creating and throwing errors
fn validate_input(input: String) {
  if input.is_empty() {
    let error = @js.new_error("Input cannot be empty")
    @js.throw_(error)
  }
  
  if input.length() > 100 {
    let error = @js.new_error(
      "Input too long",
      cause=@js.new_error("Maximum length is 100")
    )
    @js.throw_(error)
  }
}
```

### Error Handling Best Practices

```moonbit
// Good: Handle both Error and Value cases
let result = @js.throwable(fn() { risky_operation() }) catch {
  @js.JsThrowError::Error(e) => handle_error(e)
  @js.JsThrowError::Value(v) => handle_value(v)
}

// Good: Use try? for optional results
let maybe_result = try? obj.call_throwable("method", [])
match maybe_result {
  Ok(val) => use_value(val)
  Err(e) => handle_error(e)
}

// Good: Check if a value is an Error
if @js.JsError::isError(value) {
  let error: JsError = @js.unsafe_cast(value)
  @js.log(error.message())
}
```

## Best Practices

### 1. Type Safety with `unsafe_cast`

Always cast to the expected type immediately:

```moonbit
// Good: Immediate cast with clear type
let count: Int = unsafe_cast(element.get("childElementCount"))

// Avoid: Keeping Val around
let count_val = element.get("childElementCount")
// ... later ...
let count: Int = unsafe_cast(count_val)  // What type was it again?
```

### 2. Check for Undefined/Null

```moonbit
let value = obj.get("maybeUndefined")
if @js.is_undefined(value) || @js.is_null(value) {
  // Handle missing value
  return default_value
}
let actual: String = unsafe_cast(value)
```

### 3. Wrap in Functions

Create your own wrapper functions:

```moonbit
// Create a reusable wrapper
fn scroll_to_top(element: Element) {
  element.call("scrollTo", [@js.js(0), @js.js(0)]) |> ignore
}

// Use it cleanly
scroll_to_top(my_element)
```

### 4. Document Your Escape Hatches

```moonbit
/// Accesses the experimental navigator.share API
/// https://developer.mozilla.org/en-US/docs/Web/API/Navigator/share
/// 
/// Note: Not all browsers support this API
fn share_content(title: String, text: String, url: String) {
  let navigator = @js.globalThis().get("navigator")
  let data = @js.Object::new()
  data.set("title", title)
  data.set("text", text)
  data.set("url", url)
  
  navigator.call("share", [data]) |> ignore
}
```

### 5. Consider Contributing Back

If you find yourself frequently using an escape hatch for a common API, consider:

1. Creating a proper typed wrapper
2. Contributing it to the `mizchi/js` library
3. Or creating your own library package

## Helper Functions Reference

These functions are useful when working with `Val`:

```moonbit
// Type checking
@js.is_undefined(val) -> Bool
@js.is_null(val) -> Bool
@js.is_array(val) -> Bool
@js.is_object(val) -> Bool
@js.typeof_(val) -> String
@js.instanceof_(val, constructor) -> Bool

// Type conversion
@js.js(value) -> Val              // MoonBit -> JS
@js.unsafe_cast(val) -> T         // JS -> MoonBit (unsafe)

// Object creation
@js.Object::new() -> Object        // {}
@js.from_array(arr) -> Val        // MoonBit Array -> JS Array
@js.from_map(map) -> Val          // Map -> JS Object

// Function conversion
@js.from_fn0(fn() -> T) -> Val
@js.from_fn1(fn(A) -> T) -> Val
@js.from_fn2(fn(A, B) -> T) -> Val

// Logging
@js.log(value)                    // console.log

// Global access
@js.globalThis() -> Val           // globalThis
@js.undefined() -> Val            // undefined
@js.null_() -> Val                // null
```

## When to Use the Escape Hatch

✅ **Use when:**
- The API is missing from the library
- You need a quick prototype
- The API is experimental or non-standard
- You're working with a third-party library

❌ **Avoid when:**
- The API is already provided by the library
- You can wait for a proper implementation
- Type safety is critical (consider creating proper bindings first)

## Next Steps

If you find yourself using escape hatches frequently for a particular API:

1. Check if there's already an issue requesting that API
2. Open a feature request on the GitHub repository
3. Consider contributing a proper typed implementation
4. Share your escape hatch solution with the community

Remember: Escape hatches are powerful but should be used thoughtfully. When possible, prefer the typed APIs provided by the library.
