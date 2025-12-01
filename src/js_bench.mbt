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
/// Benchmark: call0 through nostd.Any
test "bench: nostd.Any _call method" (b : @bench.T) {
  let obj = get_test_obj()
  b.bench(fn() { b.keep(@nostd.any(obj)._call("noop", [])) })
}

///|
/// Benchmark: call1 with Int argument
test "bench: _call with Int" (b : @bench.T) {
  let obj = get_test_obj()
  b.bench(fn() { b.keep(@nostd.any(obj)._call("identity", [@nostd.any(42)])) })
}

///|
/// Benchmark: call2 with two Int arguments
test "bench: _call with two Ints" (b : @bench.T) {
  let obj = get_test_obj()
  b.bench(fn() {
    b.keep(@nostd.any(obj)._call("add", [@nostd.any(10), @nostd.any(20)]))
  })
}

///|
/// Benchmark: call with Array (requires map + any for each element)
test "bench: _call with Array[Int] (map overhead)" (b : @bench.T) {
  let obj = get_test_obj()
  let args : Array[@nostd.Any] = [
    @nostd.any(1),
    @nostd.any(2),
    @nostd.any(3),
    @nostd.any(4),
    @nostd.any(5),
  ]
  b.bench(fn() { b.keep(@nostd.any(obj)._call("sum", args)) })
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
  b.bench(fn() { b.keep(Object::new()) })
}

///|
/// Benchmark: Object set operation
test "bench: Object set (single property)" (b : @bench.T) {
  b.bench(fn() {
    let obj = Object::new()
    ffi_set(obj, "value", any(42))
    b.keep(obj)
  })
}

///|
/// Benchmark: Object set multiple properties
test "bench: Object set (5 properties)" (b : @bench.T) {
  b.bench(fn() {
    let obj = Object::new()
    ffi_set(obj, "a", any(1))
    ffi_set(obj, "b", any(2))
    ffi_set(obj, "c", any(3))
    ffi_set(obj, "d", any(4))
    ffi_set(obj, "e", any(5))
    b.keep(obj)
  })
}

///|
/// Benchmark: Object get operation
test "bench: Object get" (b : @bench.T) {
  let obj = Object::new()
  ffi_set(obj, "value", any(42))
  b.bench(fn() { b.keep(ffi_get(obj, "value")) })
}

///|
/// Benchmark: Array creation with from_array
test "bench: from_array (5 Ints)" (b : @bench.T) {
  let arr = [1, 2, 3, 4, 5]
  b.bench(fn() { b.keep(from_array(arr)) })
}

///|
/// Benchmark: Array creation with direct map
test "bench: Array map as_any (5 Ints)" (b : @bench.T) {
  let arr = [1, 2, 3, 4, 5]
  b.bench(fn() { b.keep(arr.map(fn(x) { any(x) })) })
}

///|
/// Benchmark: as_any trait call overhead (Int)
test "bench: Int as_any conversion" (b : @bench.T) {
  b.bench(fn() { b.keep(any(42)) })
}

///|
/// Benchmark: as_any trait call overhead (String)
test "bench: String as_any conversion" (b : @bench.T) {
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
test "bench: @mbtconv.from_map (5 entries)" (b : @bench.T) {
  let map : Map[String, @nostd.Any] = {
    "a": @nostd.any(1),
    "b": @nostd.any(2),
    "c": @nostd.any(3),
    "d": @nostd.any(4),
    "e": @nostd.any(5),
  }
  b.bench(fn() { b.keep(@mbtconv.from_map(map)) })
}

///|
/// Benchmark: Object creation comparison - Object::new() with FFI set
test "bench: Object::new() + set (5 properties, FFI)" (b : @bench.T) {
  b.bench(fn() {
    let obj = Object::new()
    ffi_set(obj, "a", any(1))
    ffi_set(obj, "b", any(2))
    ffi_set(obj, "c", any(3))
    ffi_set(obj, "d", any(4))
    ffi_set(obj, "e", any(5))
    b.keep(obj)
  })
}

///|
/// Benchmark: Object creation from Map (goes through MoonBit iteration)
test "bench: @mbtconv.from_map vs Object::new (5 properties)" (b : @bench.T) {
  let map : Map[String, @nostd.Any] = {
    "a": @nostd.any(1),
    "b": @nostd.any(2),
    "c": @nostd.any(3),
    "d": @nostd.any(4),
    "e": @nostd.any(5),
  }
  b.bench(fn() { b.keep(@mbtconv.from_map(map)) })
}

///|
/// Benchmark: Object creation from option map (all Some)
test "bench: from_option_map (5 Some)" (b : @bench.T) {
  let map : Map[String, @nostd.Any?] = {
    "a": Some(@nostd.any(1)),
    "b": Some(@nostd.any(2)),
    "c": Some(@nostd.any(3)),
    "d": Some(@nostd.any(4)),
    "e": Some(@nostd.any(5)),
  }
  b.bench(fn() { b.keep(@mbtconv.from_option_map(map)) })
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
  ffi_set(obj, "a", any(1))
  ffi_set(obj, "b", any(2))
  ffi_set(obj, "c", any(3))
  ffi_set(obj, "d", any(4))
  ffi_set(obj, "e", any(5))
  b.bench(fn() { b.keep(Object::keys(@nostd.any(obj))) })
}

///|
/// Benchmark: Complex nested object creation (realistic workload)
test "bench: create nested object (realistic)" (b : @bench.T) {
  b.bench(fn() {
    let user = Object::new()
    ffi_set(user, "name", any("Alice"))
    ffi_set(user, "age", any(30))
    let address = Object::new()
    ffi_set(address, "city", any("Tokyo"))
    ffi_set(address, "zip", any("100-0001"))
    ffi_set(user, "address", address)
    let tags = from_array(["developer", "moonbit", "javascript"])
    ffi_set(user, "tags", tags)
    b.keep(user)
  })
}

///|
/// Benchmark: Function call chain (method chaining overhead)
test "bench: chained method calls" (b : @bench.T) {
  let obj = @nostd.any(get_test_obj())
  b.bench(fn() {
    let result = obj._call("identity", [
      obj._call("identity", [obj._call("identity", [@nostd.any(42)])]),
    ])
    b.keep(result)
  })
}

// =============================================================================
// Object Creation Comparison: from_json vs @mbtconv.from_map vs Object::new()
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
/// Benchmark: @mbtconv.from_map - simple object with 3 properties
test "bench: @mbtconv.from_map (simple 3 props)" (b : @bench.T) {
  b.bench(fn() {
    let result = @mbtconv.from_map({
      "name": @nostd.any("Alice"),
      "age": @nostd.any(30),
      "active": @nostd.any(true),
    })
    b.keep(result)
  })
}

///|
/// Benchmark: Object::new() - simple object with 3 properties
test "bench: Object::new (simple 3 props)" (b : @bench.T) {
  b.bench(fn() {
    let obj = Object::new()
    ffi_set(obj, "name", any("Alice"))
    ffi_set(obj, "age", any(30))
    ffi_set(obj, "active", any(true))
    b.keep(obj)
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
/// Benchmark: @mbtconv.from_map - nested object
test "bench: @mbtconv.from_map (nested)" (b : @bench.T) {
  b.bench(fn() {
    let result = @mbtconv.from_map({
      "user": @mbtconv.from_map({
        "name": @nostd.any("Alice"),
        "age": @nostd.any(30),
        "address": @mbtconv.from_map({
          "city": @nostd.any("Tokyo"),
          "zip": @nostd.any("100-0001"),
        }),
      }),
      "active": @nostd.any(true),
    })
    b.keep(result)
  })
}

///|
/// Benchmark: Object::new() - nested object
test "bench: Object::new (nested)" (b : @bench.T) {
  b.bench(fn() {
    let address = Object::new()
    ffi_set(address, "city", any("Tokyo"))
    ffi_set(address, "zip", any("100-0001"))
    let user = Object::new()
    ffi_set(user, "name", any("Alice"))
    ffi_set(user, "age", any(30))
    ffi_set(user, "address", address)
    let obj = Object::new()
    ffi_set(obj, "user", user)
    ffi_set(obj, "active", any(true))
    b.keep(obj)
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
/// Benchmark: @mbtconv.from_map - object with array
test "bench: @mbtconv.from_map (with array)" (b : @bench.T) {
  b.bench(fn() {
    let result = @mbtconv.from_map({
      "name": @nostd.any("Alice"),
      "tags": @nostd.any(["developer", "moonbit", "javascript"]),
    })
    b.keep(result)
  })
}

///|
/// Benchmark: Object::new() - object with array
test "bench: Object::new (with array)" (b : @bench.T) {
  b.bench(fn() {
    let obj = Object::new()
    ffi_set(obj, "name", any("Alice"))
    ffi_set(obj, "tags", from_array(["developer", "moonbit", "javascript"]))
    b.keep(obj)
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
/// Benchmark: @mbtconv.from_map - large flat object (10 properties)
test "bench: @mbtconv.from_map (10 props)" (b : @bench.T) {
  b.bench(fn() {
    let result = @mbtconv.from_map({
      "a": @nostd.any(1),
      "b": @nostd.any(2),
      "c": @nostd.any(3),
      "d": @nostd.any(4),
      "e": @nostd.any(5),
      "f": @nostd.any(6),
      "g": @nostd.any(7),
      "h": @nostd.any(8),
      "i": @nostd.any(9),
      "j": @nostd.any(10),
    })
    b.keep(result)
  })
}

///|
/// Benchmark: Object::new() - large flat object (10 properties)
test "bench: Object::new (10 props)" (b : @bench.T) {
  b.bench(fn() {
    let obj = Object::new()
    ffi_set(obj, "a", any(1))
    ffi_set(obj, "b", any(2))
    ffi_set(obj, "c", any(3))
    ffi_set(obj, "d", any(4))
    ffi_set(obj, "e", any(5))
    ffi_set(obj, "f", any(6))
    ffi_set(obj, "g", any(7))
    ffi_set(obj, "h", any(8))
    ffi_set(obj, "i", any(9))
    ffi_set(obj, "j", any(10))
    b.keep(obj)
  })
}

///|
/// Benchmark: from_json with pre-built Json value (amortized)
test "bench: from_json (pre-built Json)" (b : @bench.T) {
  let json : Json = { "name": "Alice", "age": 30, "active": true }
  b.bench(fn() { b.keep(@mbtconv.from_json(json)) })
}

///|
/// Benchmark: @mbtconv.from_map with pre-built Map (amortized)
test "bench: @mbtconv.from_map (pre-built Map)" (b : @bench.T) {
  let map : Map[String, @nostd.Any] = {
    "name": @nostd.any("Alice"),
    "age": @nostd.any(30),
    "active": @nostd.any(true),
  }
  b.bench(fn() { b.keep(@mbtconv.from_map(map)) })
}
