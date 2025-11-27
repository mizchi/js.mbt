///| Micro-benchmarks for mizchi/js FFI operations
// This benchmark tests the overhead of FFI calls and type conversions

///|
// Helper: Create a simple JavaScript function for testing
extern "js" fn ffi_create_test_function() -> Any =
  #|() => {
  #|  return {
  #|    identity: (x) => x,
  #|    add: (a, b) => a + b,
  #|    sum: (...args) => args.reduce((a, b) => a + b, 0),
  #|    noop: () => undefined,
  #|    getProperty: function() { return this.value; },
  #|    value: 42
  #|  };
  #|}

///|
fn get_test_obj() -> Any {
  ffi_create_test_function()
}

///|
/// Benchmark: Direct FFI call (baseline)
test "bench: direct FFI call (ffi_call0)" (b : @bench.T) {
  let obj = get_test_obj()
  b.bench(fn() { b.keep(ffi_call0(obj, "noop")) })
}

///|
/// Benchmark: call0 through JsImpl trait
test "bench: JsImpl call0 method" (b : @bench.T) {
  let obj = get_test_obj()
  b.bench(fn() { b.keep(obj.call0("noop")) })
}

///|
/// Benchmark: call1 with Int argument (needs to_any conversion)
test "bench: call1 with Int (to_any conversion)" (b : @bench.T) {
  let obj = get_test_obj()
  b.bench(fn() { b.keep(obj.call1("identity", 42)) })
}

///|
/// Benchmark: call2 with two Int arguments
test "bench: call2 with two Ints" (b : @bench.T) {
  let obj = get_test_obj()
  b.bench(fn() { b.keep(obj.call2("add", 10, 20)) })
}

///|
/// Benchmark: call with Array (requires map + to_any for each element)
test "bench: call with Array[Int] (map overhead)" (b : @bench.T) {
  let obj = get_test_obj()
  let args : Array[&JsImpl] = [1, 2, 3, 4, 5]
  b.bench(fn() { b.keep(obj.call("sum", args)) })
}

///|
/// Benchmark: call with pre-converted Array[Any]
test "bench: call with Array[Any] (no conversion)" (b : @bench.T) {
  let obj = get_test_obj()
  let args : Array[Any] = [any(1), any(2), any(3), any(4), any(5)]
  b.bench(fn() { b.keep(ffi_call(obj, "sum", args)) })
}

///|
/// Benchmark: Object creation
test "bench: Object::new()" (b : @bench.T) {
  b.bench(fn() { b.keep(Object::new().to_any()) })
}

///|
/// Benchmark: Object set operation
test "bench: Object set (single property)" (b : @bench.T) {
  b.bench(fn() {
    let obj = Object::new()
    obj.set("value", 42)
    b.keep(obj.to_any())
  })
}

///|
/// Benchmark: Object set multiple properties
test "bench: Object set (5 properties)" (b : @bench.T) {
  b.bench(fn() {
    let obj = Object::new()
    obj.set("a", 1)
    obj.set("b", 2)
    obj.set("c", 3)
    obj.set("d", 4)
    obj.set("e", 5)
    b.keep(obj.to_any())
  })
}

///|
/// Benchmark: Object get operation
test "bench: Object get" (b : @bench.T) {
  let obj = Object::new()
  obj.set("value", 42)
  b.bench(fn() { b.keep(obj.get("value")) })
}

///|
/// Benchmark: Array creation with from_array
test "bench: from_array (5 Ints)" (b : @bench.T) {
  let arr = [1, 2, 3, 4, 5]
  b.bench(fn() { b.keep(from_array(arr)) })
}

///|
/// Benchmark: Array creation with direct map
test "bench: Array map to_any (5 Ints)" (b : @bench.T) {
  let arr = [1, 2, 3, 4, 5]
  b.bench(fn() { b.keep(arr.map(fn(x) { any(x) })) })
}

///|
/// Benchmark: to_any trait call overhead (Int)
test "bench: Int to_any conversion" (b : @bench.T) {
  b.bench(fn() { b.keep(any(42)) })
}

///|
/// Benchmark: to_any trait call overhead (String)
test "bench: String to_any conversion" (b : @bench.T) {
  b.bench(fn() { b.keep(any("hello")) })
}

///|
/// Benchmark: identity (no conversion, baseline)
test "bench: identity Int to Js" (b : @bench.T) {
  b.bench(fn() {
    let result : Any = identity(42)
    b.keep(result)
  })
}

///|
/// Benchmark: Map to Object conversion
test "bench: from_map (5 entries)" (b : @bench.T) {
  let map : Map[String, Any] = {
    "a": any(1),
    "b": any(2),
    "c": any(3),
    "d": any(4),
    "e": any(5),
  }
  b.bench(fn() { b.keep(from_map(map)) })
}

///|
/// Benchmark: Object creation comparison - Object::new() with FFI set
test "bench: Object::new() + set (5 properties, FFI)" (b : @bench.T) {
  b.bench(fn() {
    let obj = Object::new()
    obj.set("a", any(1))
    obj.set("b", any(2))
    obj.set("c", any(3))
    obj.set("d", any(4))
    obj.set("e", any(5))
    b.keep(obj.to_any())
  })
}

///|
/// Benchmark: Object creation from Map (goes through MoonBit iteration)
test "bench: from_map vs Object::new (5 properties)" (b : @bench.T) {
  let map : Map[String, Any] = {
    "a": any(1),
    "b": any(2),
    "c": any(3),
    "d": any(4),
    "e": any(5),
  }
  b.bench(fn() { b.keep(from_map(map)) })
}

///|
/// Benchmark: Object creation from option map (all Some)
test "bench: from_option_map (5 Some)" (b : @bench.T) {
  let map : Map[String, Any?] = {
    "a": Some(any(1)),
    "b": Some(any(2)),
    "c": Some(any(3)),
    "d": Some(any(4)),
    "e": Some(any(5)),
  }
  b.bench(fn() { b.keep(from_option_map(map)) })
}

///|
/// Benchmark: Object creation from option map (mixed)
test "bench: from_option_map (3 Some, 2 None)" (b : @bench.T) {
  let map : Map[String, Any?] = {
    "a": Some(any(1)),
    "b": None,
    "c": Some(any(3)),
    "d": None,
    "e": Some(any(5)),
  }
  b.bench(fn() { b.keep(from_option_map(map)) })
}

///|
/// Benchmark: typeof_ operation
test "bench: typeof_ check" (b : @bench.T) {
  let val = any(42)
  b.bench(fn() { b.keep(typeof_(val)) })
}

///|
/// Benchmark: is_array check
test "bench: is_array check" (b : @bench.T) {
  let arr = from_array([1, 2, 3])
  b.bench(fn() { b.keep(is_array(arr)) })
}

///|
/// Benchmark: Object::keys operation
test "bench: Object::keys" (b : @bench.T) {
  let obj = Object::new()
  obj.set("a", 1)
  obj.set("b", 2)
  obj.set("c", 3)
  obj.set("d", 4)
  obj.set("e", 5)
  b.bench(fn() { b.keep(Object::keys(obj)) })
}

///|
/// Benchmark: Complex nested object creation (realistic workload)
test "bench: create nested object (realistic)" (b : @bench.T) {
  b.bench(fn() {
    let user = Object::new()
    user.set("name", "Alice")
    user.set("age", 30)
    let address = Object::new()
    address.set("city", "Tokyo")
    address.set("zip", "100-0001")
    user.set("address", address)
    let tags = from_array(["developer", "moonbit", "javascript"])
    user.set("tags", tags)
    b.keep(user.to_any())
  })
}

///|
/// Benchmark: Function call chain (method chaining overhead)
test "bench: chained method calls" (b : @bench.T) {
  let obj = get_test_obj()
  b.bench(fn() {
    let result = obj.call1(
      "identity",
      obj.call1("identity", obj.call1("identity", 42)),
    )
    b.keep(result)
  })
}

// =============================================================================
// Object Creation Comparison: from_json vs from_map vs Object::new()
// =============================================================================

///|
/// Benchmark: from_json - simple object with 3 properties
test "bench: from_json (simple 3 props)" (b : @bench.T) {
  b.bench(fn() {
    let result = from_json({ "name": "Alice", "age": 30, "active": true })
    b.keep(result)
  })
}

///|
/// Benchmark: from_map - simple object with 3 properties
test "bench: from_map (simple 3 props)" (b : @bench.T) {
  b.bench(fn() {
    let result = from_map({
      "name": any("Alice"),
      "age": any(30),
      "active": any(true),
    })
    b.keep(result)
  })
}

///|
/// Benchmark: Object::new() - simple object with 3 properties
test "bench: Object::new (simple 3 props)" (b : @bench.T) {
  b.bench(fn() {
    let obj = Object::new()
    obj.set("name", "Alice")
    obj.set("age", 30)
    obj.set("active", true)
    b.keep(obj.to_any())
  })
}

///|
/// Benchmark: from_json - nested object
test "bench: from_json (nested)" (b : @bench.T) {
  b.bench(fn() {
    let result = from_json({
      "user": {
        "name": "Alice",
        "age": 30,
        "address": { "city": "Tokyo", "zip": "100-0001" },
      },
      "active": true,
    })
    b.keep(result)
  })
}

///|
/// Benchmark: from_map - nested object
test "bench: from_map (nested)" (b : @bench.T) {
  b.bench(fn() {
    let result = from_map({
      "user": from_map({
        "name": any("Alice"),
        "age": any(30),
        "address": from_map({ "city": any("Tokyo"), "zip": any("100-0001") }),
      }),
      "active": any(true),
    })
    b.keep(result)
  })
}

///|
/// Benchmark: Object::new() - nested object
test "bench: Object::new (nested)" (b : @bench.T) {
  b.bench(fn() {
    let address = Object::new()
    address.set("city", "Tokyo")
    address.set("zip", "100-0001")
    let user = Object::new()
    user.set("name", "Alice")
    user.set("age", 30)
    user.set("address", address.to_any())
    let obj = Object::new()
    obj.set("user", user.to_any())
    obj.set("active", true)
    b.keep(obj.to_any())
  })
}

///|
/// Benchmark: from_json - object with array
test "bench: from_json (with array)" (b : @bench.T) {
  b.bench(fn() {
    let result = from_json({
      "name": "Alice",
      "tags": ["developer", "moonbit", "javascript"],
    })
    b.keep(result)
  })
}

///|
/// Benchmark: from_map - object with array
test "bench: from_map (with array)" (b : @bench.T) {
  b.bench(fn() {
    let result = from_map({
      "name": any("Alice"),
      "tags": from_array(["developer", "moonbit", "javascript"]),
    })
    b.keep(result)
  })
}

///|
/// Benchmark: Object::new() - object with array
test "bench: Object::new (with array)" (b : @bench.T) {
  b.bench(fn() {
    let obj = Object::new()
    obj.set("name", "Alice")
    obj.set("tags", from_array(["developer", "moonbit", "javascript"]))
    b.keep(obj.to_any())
  })
}

///|
/// Benchmark: from_json - large flat object (10 properties)
test "bench: from_json (10 props)" (b : @bench.T) {
  b.bench(fn() {
    let result = from_json({
      "a": 1,
      "b": 2,
      "c": 3,
      "d": 4,
      "e": 5,
      "f": 6,
      "g": 7,
      "h": 8,
      "i": 9,
      "j": 10,
    })
    b.keep(result)
  })
}

///|
/// Benchmark: from_map - large flat object (10 properties)
test "bench: from_map (10 props)" (b : @bench.T) {
  b.bench(fn() {
    let result = from_map({
      "a": any(1),
      "b": any(2),
      "c": any(3),
      "d": any(4),
      "e": any(5),
      "f": any(6),
      "g": any(7),
      "h": any(8),
      "i": any(9),
      "j": any(10),
    })
    b.keep(result)
  })
}

///|
/// Benchmark: Object::new() - large flat object (10 properties)
test "bench: Object::new (10 props)" (b : @bench.T) {
  b.bench(fn() {
    let obj = Object::new()
    obj.set("a", 1)
    obj.set("b", 2)
    obj.set("c", 3)
    obj.set("d", 4)
    obj.set("e", 5)
    obj.set("f", 6)
    obj.set("g", 7)
    obj.set("h", 8)
    obj.set("i", 9)
    obj.set("j", 10)
    b.keep(obj.to_any())
  })
}

///|
/// Benchmark: from_json with pre-built Json value (amortized)
test "bench: from_json (pre-built Json)" (b : @bench.T) {
  let json : Json = { "name": "Alice", "age": 30, "active": true }
  b.bench(fn() { b.keep(from_json(json)) })
}

///|
/// Benchmark: from_map with pre-built Map (amortized)
test "bench: from_map (pre-built Map)" (b : @bench.T) {
  let map : Map[String, Any] = {
    "name": any("Alice"),
    "age": any(30),
    "active": any(true),
  }
  b.bench(fn() { b.keep(from_map(map)) })
}
