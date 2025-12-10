///|
extern "js" fn ffi_set(
  obj : @core.Any,
  key : String,
  value : @core.Any,
) -> Unit =
  #| (obj, key, value) => { obj[key] = value }

///|
extern "js" fn ffi_get(obj : @core.Any, key : String) -> @core.Any =
  #| (obj, key) => obj[key]

///| Micro-benchmarks for mizchi/js FFI operations
// This benchmark tests the overhead of FFI calls and type conversions

///|
// Helper: Create a simple JavaScript function for testing
extern "js" fn ffi_create_test_function() -> @core.Any =
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
fn get_test_obj() -> @core.Any {
  ffi_create_test_function()
}

///|
/// Benchmark: call0 through nostd.Any
test "bench: nostd.Any _call method" (b : @bench.T) {
  let obj = get_test_obj()
  b.bench(fn() { b.keep(@core.any(obj)._call("noop", [])) })
}

///|
/// Benchmark: call1 with Int argument
test "bench: _call with Int" (b : @bench.T) {
  let obj = get_test_obj()
  b.bench(fn() { b.keep(@core.any(obj)._call("identity", [@core.any(42)])) })
}

///|
/// Benchmark: call2 with two Int arguments
test "bench: _call with two Ints" (b : @bench.T) {
  let obj = get_test_obj()
  b.bench(fn() {
    b.keep(@core.any(obj)._call("add", [@core.any(10), @core.any(20)]))
  })
}

///|
/// Benchmark: call with Array (requires map + any for each element)
test "bench: _call with Array[Int] (map overhead)" (b : @bench.T) {
  let obj = get_test_obj()
  let args : Array[@core.Any] = [
    @core.any(1),
    @core.any(2),
    @core.any(3),
    @core.any(4),
    @core.any(5),
  ]
  b.bench(fn() { b.keep(@core.any(obj)._call("sum", args)) })
}

///|
/// Benchmark: Object creation
test "bench: Object::new()" (b : @bench.T) {
  b.bench(fn() { b.keep(@core.new_object()) })
}

///|
/// Benchmark: Object set operation
test "bench: Object set (single property)" (b : @bench.T) {
  b.bench(fn() {
    let obj = @core.new_object()
    ffi_set(obj, "value", @core.any(42))
    b.keep(obj)
  })
}

///|
/// Benchmark: Object set multiple properties
test "bench: Object set (5 properties)" (b : @bench.T) {
  b.bench(fn() {
    let obj = @core.new_object()
    ffi_set(obj, "a", @core.any(1))
    ffi_set(obj, "b", @core.any(2))
    ffi_set(obj, "c", @core.any(3))
    ffi_set(obj, "d", @core.any(4))
    ffi_set(obj, "e", @core.any(5))
    b.keep(obj)
  })
}

///|
/// Benchmark: Object get operation
test "bench: Object get" (b : @bench.T) {
  let obj = @core.new_object()
  ffi_set(obj, "value", @core.any(42))
  b.bench(fn() { b.keep(ffi_get(obj, "value")) })
}

///|
/// Benchmark: Array creation with direct map
test "bench: Array map as_any (5 Ints)" (b : @bench.T) {
  let arr = [1, 2, 3, 4, 5]
  b.bench(fn() { b.keep(arr.map(fn(x) { @core.any(x) })) })
}

///|
/// Benchmark: as_any trait call overhead (Int)
test "bench: Int as_any conversion" (b : @bench.T) {
  b.bench(fn() { b.keep(@core.any(42)) })
}

///|
/// Benchmark: as_any trait call overhead (String)
test "bench: String as_any conversion" (b : @bench.T) {
  b.bench(fn() { b.keep(@core.any("hello")) })
}

///|
/// Benchmark: identity (no conversion, baseline)
test "bench: identity Int to Js" (b : @bench.T) {
  b.bench(fn() {
    let result : @core.Any = @core.identity(42)
    b.keep(result)
  })
}

///|
/// Benchmark: Map to Object conversion
test "bench: @mbtconv.from_map (5 entries)" (b : @bench.T) {
  let map : Map[String, @core.Any] = {
    "a": @core.any(1),
    "b": @core.any(2),
    "c": @core.any(3),
    "d": @core.any(4),
    "e": @core.any(5),
  }
  b.bench(fn() { b.keep(@mbtconv.from_map(map)) })
}

///|
/// Benchmark: Object creation comparison - Object::new() with FFI set
test "bench: Object::new() + set (5 properties, FFI)" (b : @bench.T) {
  b.bench(fn() {
    let obj = @core.new_object()
    ffi_set(obj, "a", @core.any(1))
    ffi_set(obj, "b", @core.any(2))
    ffi_set(obj, "c", @core.any(3))
    ffi_set(obj, "d", @core.any(4))
    ffi_set(obj, "e", @core.any(5))
    b.keep(obj)
  })
}

///|
/// Benchmark: Object creation from Map (goes through MoonBit iteration)
test "bench: @mbtconv.from_map vs Object::new (5 properties)" (b : @bench.T) {
  let map : Map[String, @core.Any] = {
    "a": @core.any(1),
    "b": @core.any(2),
    "c": @core.any(3),
    "d": @core.any(4),
    "e": @core.any(5),
  }
  b.bench(fn() { b.keep(@mbtconv.from_map(map)) })
}

///|
/// Benchmark: Object creation from option map (all Some)
test "bench: from_option_map (5 Some)" (b : @bench.T) {
  let map : Map[String, @core.Any?] = {
    "a": Some(@core.any(1)),
    "b": Some(@core.any(2)),
    "c": Some(@core.any(3)),
    "d": Some(@core.any(4)),
    "e": Some(@core.any(5)),
  }
  b.bench(fn() { b.keep(@mbtconv.from_option_map(map)) })
}

///|
/// Benchmark: Object creation from option map (mixed)
test "bench: from_option_map (3 Some, 2 None)" (b : @bench.T) {
  let map : Map[String, @core.Any?] = {
    "a": Some(@core.any(1)),
    "b": None,
    "c": Some(@core.any(3)),
    "d": None,
    "e": Some(@core.any(5)),
  }
  b.bench(fn() { b.keep(@mbtconv.from_option_map(map)) })
}

///|
/// Benchmark: typeof_ operation
test "bench: typeof_ check" (b : @bench.T) {
  let val = @core.any(42)
  b.bench(fn() { b.keep(@core.typeof_(val)) })
}

///|
/// Benchmark: is_array check
test "bench: is_array check" (b : @bench.T) {
  let arr = @core.any([1, 2, 3])
  b.bench(fn() { b.keep(@core.is_array(arr)) })
}

///|
/// Benchmark: Object::keys operation
test "bench: Object::keys" (b : @bench.T) {
  let obj = @core.new_object()
  ffi_set(obj, "a", @core.any(1))
  ffi_set(obj, "b", @core.any(2))
  ffi_set(obj, "c", @core.any(3))
  ffi_set(obj, "d", @core.any(4))
  ffi_set(obj, "e", @core.any(5))
  b.bench(fn() { b.keep(@core.object_keys(@core.any(obj))) })
}

///|
/// Benchmark: Complex nested object creation (realistic workload)
test "bench: create nested object (realistic)" (b : @bench.T) {
  b.bench(fn() {
    let user = @core.new_object()
    ffi_set(user, "name", @core.any("Alice"))
    ffi_set(user, "age", @core.any(30))
    let address = @core.new_object()
    ffi_set(address, "city", @core.any("Tokyo"))
    ffi_set(address, "zip", @core.any("100-0001"))
    ffi_set(user, "address", address)
    let tags = @core.any(["developer", "moonbit", "javascript"])
    ffi_set(user, "tags", tags)
    b.keep(user)
  })
}

///|
/// Benchmark: Function call chain (method chaining overhead)
test "bench: chained method calls" (b : @bench.T) {
  let obj = @core.any(get_test_obj())
  b.bench(fn() {
    let result = obj._call("identity", [
      obj._call("identity", [obj._call("identity", [@core.any(42)])]),
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
    let result = @mbtconv.from_json({
      "name": "Alice",
      "age": 30,
      "active": true,
    })
    b.keep(result)
  })
}

///|
/// Benchmark: @mbtconv.from_map - simple object with 3 properties
test "bench: @mbtconv.from_map (simple 3 props)" (b : @bench.T) {
  b.bench(fn() {
    let result = @mbtconv.from_map({
      "name": @core.any("Alice"),
      "age": @core.any(30),
      "active": @core.any(true),
    })
    b.keep(result)
  })
}

///|
/// Benchmark: Object::new() - simple object with 3 properties
test "bench: Object::new (simple 3 props)" (b : @bench.T) {
  b.bench(fn() {
    let obj = @core.new_object()
    ffi_set(obj, "name", @core.any("Alice"))
    ffi_set(obj, "age", @core.any(30))
    ffi_set(obj, "active", @core.any(true))
    b.keep(obj)
  })
}

///|
/// Benchmark: from_json - nested object
test "bench: from_json (nested)" (b : @bench.T) {
  b.bench(fn() {
    let result = @mbtconv.from_json({
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
        "name": @core.any("Alice"),
        "age": @core.any(30),
        "address": @mbtconv.from_map({
          "city": @core.any("Tokyo"),
          "zip": @core.any("100-0001"),
        }),
      }),
      "active": @core.any(true),
    })
    b.keep(result)
  })
}

///|
/// Benchmark: Object::new() - nested object
test "bench: Object::new (nested)" (b : @bench.T) {
  b.bench(fn() {
    let address = @core.new_object()
    ffi_set(address, "city", @core.any("Tokyo"))
    ffi_set(address, "zip", @core.any("100-0001"))
    let user = @core.new_object()
    ffi_set(user, "name", @core.any("Alice"))
    ffi_set(user, "age", @core.any(30))
    ffi_set(user, "address", address)
    let obj = @core.new_object()
    ffi_set(obj, "user", user)
    ffi_set(obj, "active", @core.any(true))
    b.keep(obj)
  })
}

///|
/// Benchmark: from_json - object with array
test "bench: from_json (with array)" (b : @bench.T) {
  b.bench(fn() {
    let result = @mbtconv.from_json({
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
      "name": @core.any("Alice"),
      "tags": @core.any(["developer", "moonbit", "javascript"]),
    })
    b.keep(result)
  })
}

///|
/// Benchmark: Object::new() - object with array
test "bench: Object::new (with array)" (b : @bench.T) {
  b.bench(fn() {
    let obj = @core.new_object()
    ffi_set(obj, "name", @core.any("Alice"))
    ffi_set(obj, "tags", @core.any(["developer", "moonbit", "javascript"]))
    b.keep(obj)
  })
}

///|
/// Benchmark: from_json - large flat object (10 properties)
test "bench: from_json (10 props)" (b : @bench.T) {
  b.bench(fn() {
    let result = @mbtconv.from_json({
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
      "a": @core.any(1),
      "b": @core.any(2),
      "c": @core.any(3),
      "d": @core.any(4),
      "e": @core.any(5),
      "f": @core.any(6),
      "g": @core.any(7),
      "h": @core.any(8),
      "i": @core.any(9),
      "j": @core.any(10),
    })
    b.keep(result)
  })
}

///|
/// Benchmark: Object::new() - large flat object (10 properties)
test "bench: Object::new (10 props)" (b : @bench.T) {
  b.bench(fn() {
    let obj = @core.new_object()
    ffi_set(obj, "a", @core.any(1))
    ffi_set(obj, "b", @core.any(2))
    ffi_set(obj, "c", @core.any(3))
    ffi_set(obj, "d", @core.any(4))
    ffi_set(obj, "e", @core.any(5))
    ffi_set(obj, "f", @core.any(6))
    ffi_set(obj, "g", @core.any(7))
    ffi_set(obj, "h", @core.any(8))
    ffi_set(obj, "i", @core.any(9))
    ffi_set(obj, "j", @core.any(10))
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
  let map : Map[String, @core.Any] = {
    "name": @core.any("Alice"),
    "age": @core.any(30),
    "active": @core.any(true),
  }
  b.bench(fn() { b.keep(@mbtconv.from_map(map)) })
}
