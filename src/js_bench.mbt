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
  let args : Array[Any] = [js(1), js(2), js(3), js(4), js(5)]
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
  b.bench(fn() { b.keep(arr.map(fn(x) { js(x) })) })
}

///|
/// Benchmark: to_any trait call overhead (Int)
test "bench: Int to_any conversion" (b : @bench.T) {
  b.bench(fn() { b.keep(js(42)) })
}

///|
/// Benchmark: to_any trait call overhead (String)
test "bench: String to_any conversion" (b : @bench.T) {
  b.bench(fn() { b.keep(js("hello")) })
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
    "a": js(1),
    "b": js(2),
    "c": js(3),
    "d": js(4),
    "e": js(5),
  }
  b.bench(fn() { b.keep(from_map(map)) })
}

///|
/// Benchmark: Object creation comparison - Object::new() with FFI set
test "bench: Object::new() + set (5 properties, FFI)" (b : @bench.T) {
  b.bench(fn() {
    let obj = Object::new()
    obj.set("a", js(1))
    obj.set("b", js(2))
    obj.set("c", js(3))
    obj.set("d", js(4))
    obj.set("e", js(5))
    b.keep(obj.to_any())
  })
}

///|
/// Benchmark: Object creation from Map (goes through MoonBit iteration)
test "bench: from_map vs Object::new (5 properties)" (b : @bench.T) {
  let map : Map[String, Any] = {
    "a": js(1),
    "b": js(2),
    "c": js(3),
    "d": js(4),
    "e": js(5),
  }
  b.bench(fn() { b.keep(from_map(map)) })
}

///|
/// Benchmark: Object creation from tuple array
test "bench: from_entries (5 tuples)" (b : @bench.T) {
  let entries : Array[(String, &JsImpl)] = [
    ("a", 1),
    ("b", 2),
    ("c", 3),
    ("d", 4),
    ("e", 5),
  ]
  b.bench(fn() { b.keep(from_entries(entries)) })
}

///|
/// Benchmark: Object creation from optional tuple array (all Some)
test "bench: from_entries_option (5 Some)" (b : @bench.T) {
  let entries : Array[(String, &JsImpl?)] = [
    ("a", Some(1)),
    ("b", Some(2)),
    ("c", Some(3)),
    ("d", Some(4)),
    ("e", Some(5)),
  ]
  b.bench(fn() { b.keep(from_entries_option(entries)) })
}

///|
/// Benchmark: Object creation from optional tuple array (mixed)
test "bench: from_entries_option (3 Some, 2 None)" (b : @bench.T) {
  let entries : Array[(String, &JsImpl?)] = [
    ("a", Some(1)),
    ("b", None),
    ("c", Some(3)),
    ("d", None),
    ("e", Some(5)),
  ]
  b.bench(fn() { b.keep(from_entries_option(entries)) })
}

///|
/// Benchmark: typeof_ operation
test "bench: typeof_ check" (b : @bench.T) {
  let val = js(42)
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
