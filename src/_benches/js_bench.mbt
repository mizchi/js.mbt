///| Micro-benchmarks for mizchi/js FFI operations
// This benchmark tests the overhead of FFI calls and type conversions

///|
// Helper: Create a simple JavaScript function for testing
extern "js" fn ffi_create_test_function() -> @js.Any =
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
fn get_test_obj() -> @js.Any {
  ffi_create_test_function()
}

///|
/// Benchmark: Direct method call (baseline)
test "bench: direct method call (call0)" (b : @bench.T) {
  let obj = get_test_obj()
  b.bench(fn() { b.keep(obj.call0("noop")) })
}

///|
/// Benchmark: call0 through JsImpl trait
test "bench: JsImpl call0 method" (b : @bench.T) {
  let obj = get_test_obj()
  b.bench(fn() { b.keep(obj.call0("noop")) })
}

///|
/// Benchmark: call1 with Int argument (needs as_any conversion)
test "bench: call1 with Int (as_any conversion)" (b : @bench.T) {
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
/// Benchmark: call_self with array argument
test "bench: call_self with array" (b : @bench.T) {
  let obj = get_test_obj()
  let sum_fn = obj.get("sum")
  let arr = @js.from_array([1, 2, 3, 4, 5])
  b.bench(fn() { b.keep(sum_fn.call_self([arr])) })
}

///|
/// Benchmark: Object creation
test "bench: Object::new()" (b : @bench.T) {
  b.bench(fn() { b.keep(@js.Object::new().as_any()) })
}

///|
/// Benchmark: Object set operation
test "bench: Object set (single property)" (b : @bench.T) {
  b.bench(fn() {
    let obj = @js.Object::new()
    obj.set("value", 42)
    b.keep(obj.as_any())
  })
}

///|
/// Benchmark: Object set multiple properties
test "bench: Object set (5 properties)" (b : @bench.T) {
  b.bench(fn() {
    let obj = @js.Object::new()
    obj.set("a", 1)
    obj.set("b", 2)
    obj.set("c", 3)
    obj.set("d", 4)
    obj.set("e", 5)
    b.keep(obj.as_any())
  })
}

///|
/// Benchmark: Object get operation
test "bench: Object get" (b : @bench.T) {
  let obj = @js.Object::new()
  obj.set("value", 42)
  b.bench(fn() { b.keep(obj.get("value")) })
}

///|
/// Benchmark: Array creation with from_array
test "bench: from_array (5 Ints)" (b : @bench.T) {
  let arr = [1, 2, 3, 4, 5]
  b.bench(fn() { b.keep(@js.from_array(arr)) })
}

///|
/// Benchmark: Array creation with direct map
test "bench: Array map as_any (5 Ints)" (b : @bench.T) {
  let arr = [1, 2, 3, 4, 5]
  b.bench(fn() { b.keep(arr.map(fn(x) { @js.any(x) })) })
}

///|
/// Benchmark: as_any trait call overhead (Int)
test "bench: Int as_any conversion" (b : @bench.T) {
  b.bench(fn() { b.keep(@js.any(42)) })
}

///|
/// Benchmark: as_any trait call overhead (String)
test "bench: String as_any conversion" (b : @bench.T) {
  b.bench(fn() { b.keep(@js.any("hello")) })
}

///|
/// Benchmark: identity (no conversion, baseline)
test "bench: identity Int to Js" (b : @bench.T) {
  b.bench(fn() {
    let result : @js.Any = @js.identity(42)
    b.keep(result)
  })
}

///|
/// Benchmark: typeof_ operation
test "bench: typeof_ check" (b : @bench.T) {
  let val = @js.any(42)
  b.bench(fn() { b.keep(@js.typeof_(val)) })
}

///|
/// Benchmark: is_array check
test "bench: is_array check" (b : @bench.T) {
  let arr = @js.from_array([1, 2, 3])
  b.bench(fn() { b.keep(@js.is_array(arr)) })
}

///|
/// Benchmark: Object::keys operation
test "bench: Object::keys" (b : @bench.T) {
  let obj = @js.Object::new()
  obj.set("a", 1)
  obj.set("b", 2)
  obj.set("c", 3)
  obj.set("d", 4)
  obj.set("e", 5)
  b.bench(fn() { b.keep(@js.Object::keys(obj)) })
}

///|
/// Benchmark: Complex nested object creation (realistic workload)
test "bench: create nested object (realistic)" (b : @bench.T) {
  b.bench(fn() {
    let user = @js.Object::new()
    user.set("name", "Alice")
    user.set("age", 30)
    let address = @js.Object::new()
    address.set("city", "Tokyo")
    address.set("zip", "100-0001")
    user.set("address", address)
    let tags = @js.from_array(["developer", "moonbit", "javascript"])
    user.set("tags", tags)
    b.keep(user.as_any())
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
// Object Creation Comparison: Object::new() benchmarks
// =============================================================================

///|
/// Benchmark: Object::new() - simple object with 3 properties
test "bench: Object::new (simple 3 props)" (b : @bench.T) {
  b.bench(fn() {
    let obj = @js.Object::new()
    obj.set("name", "Alice")
    obj.set("age", 30)
    obj.set("active", true)
    b.keep(obj.as_any())
  })
}

///|
/// Benchmark: Object::new() - nested object
test "bench: Object::new (nested)" (b : @bench.T) {
  b.bench(fn() {
    let address = @js.Object::new()
    address.set("city", "Tokyo")
    address.set("zip", "100-0001")
    let user = @js.Object::new()
    user.set("name", "Alice")
    user.set("age", 30)
    user.set("address", address.as_any())
    let obj = @js.Object::new()
    obj.set("user", user.as_any())
    obj.set("active", true)
    b.keep(obj.as_any())
  })
}

///|
/// Benchmark: Object::new() - object with array
test "bench: Object::new (with array)" (b : @bench.T) {
  b.bench(fn() {
    let obj = @js.Object::new()
    obj.set("name", "Alice")
    obj.set("tags", @js.from_array(["developer", "moonbit", "javascript"]))
    b.keep(obj.as_any())
  })
}

///|
/// Benchmark: Object::new() - large flat object (10 properties)
test "bench: Object::new (10 props)" (b : @bench.T) {
  b.bench(fn() {
    let obj = @js.Object::new()
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
    b.keep(obj.as_any())
  })
}

// =============================================================================
// @mbtconv Conversion Benchmarks - These use @nostd.Any
// =============================================================================

///|
/// Benchmark: from_map with @mbtconv (uses @nostd.Any)
test "bench: @mbtconv.from_map (3 props)" (b : @bench.T) {
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
/// Benchmark: from_option_map with @mbtconv (uses @nostd.Any)
test "bench: @mbtconv.from_option_map (mixed)" (b : @bench.T) {
  b.bench(fn() {
    let result = @mbtconv.from_option_map({
      "name": Some(@nostd.any("Alice")),
      "age": Some(@nostd.any(30)),
      "missing": None,
    })
    b.keep(result)
  })
}

///|
/// Benchmark: from_json with @mbtconv
test "bench: @mbtconv.from_json (simple)" (b : @bench.T) {
  let json : Json = { "name": "Alice", "age": 30 }
  b.bench(fn() {
    let result = @mbtconv.from_json(json)
    b.keep(result)
  })
}

///|
/// Benchmark: @nostd.any conversion
test "bench: @nostd.any Int" (b : @bench.T) {
  b.bench(fn() { b.keep(@nostd.any(42)) })
}

///|
/// Benchmark: @nostd.any String conversion
test "bench: @nostd.any String" (b : @bench.T) {
  b.bench(fn() { b.keep(@nostd.any("hello")) })
}
