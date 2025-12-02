///| Micro-benchmarks for mizchi/js FFI operations
// This benchmark tests the overhead of FFI calls and type conversions

///|
// Helper: Create a simple JavaScript function for testing
extern "js" fn ffi_create_test_function() -> @nostd.Any =
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
fn get_test_obj() -> @nostd.Any {
  ffi_create_test_function()
}

///|
/// Benchmark: Direct method call (baseline)
test "bench: direct method call (_call)" (b : @bench.T) {
  let obj = @nostd.any(get_test_obj())
  b.bench(fn() { b.keep(obj._call("noop", [])) })
}

///|
/// Benchmark: _call with Int argument
test "bench: _call with Int" (b : @bench.T) {
  let obj = @nostd.any(get_test_obj())
  b.bench(fn() { b.keep(obj._call("identity", [@nostd.any(42)])) })
}

///|
/// Benchmark: _call with two Int arguments
test "bench: _call with two Ints" (b : @bench.T) {
  let obj = @nostd.any(get_test_obj())
  b.bench(fn() { b.keep(obj._call("add", [@nostd.any(10), @nostd.any(20)])) })
}

///|
/// Benchmark: _call with array argument
test "bench: _call with array" (b : @bench.T) {
  let obj = @nostd.any(get_test_obj())
  let sum_fn = obj["sum"]
  let arr = @js.from_array([1, 2, 3, 4, 5])
  b.bench(fn() { b.keep(sum_fn._invoke([@nostd.any(arr)])) })
}

///|
/// Benchmark: Object creation
test "bench: Object::new()" (b : @bench.T) {
  b.bench(fn() { b.keep(@nostd.Object::new()) })
}

///|
/// Benchmark: Object set operation
test "bench: Object set (single property)" (b : @bench.T) {
  b.bench(fn() {
    let obj = @nostd.Object::new()
    @nostd.any(obj)._set("value", @nostd.any(42))
    b.keep(obj)
  })
}

///|
/// Benchmark: Object set multiple properties
test "bench: Object set (5 properties)" (b : @bench.T) {
  b.bench(fn() {
    let obj = @nostd.Object::new()
    let o = @nostd.any(obj)
    o._set("a", @nostd.any(1))
    o._set("b", @nostd.any(2))
    o._set("c", @nostd.any(3))
    o._set("d", @nostd.any(4))
    o._set("e", @nostd.any(5))
    b.keep(obj)
  })
}

///|
/// Benchmark: Object get operation
test "bench: Object get" (b : @bench.T) {
  let obj = @nostd.Object::new()
  @nostd.any(obj)._set("value", @nostd.any(42))
  b.bench(fn() { b.keep(@nostd.any(obj)["value"]) })
}

///|
/// Benchmark: Array creation with from_array
test "bench: from_array (5 Ints)" (b : @bench.T) {
  let arr = [1, 2, 3, 4, 5]
  b.bench(fn() { b.keep(@js.from_array(arr)) })
}

///|
/// Benchmark: any conversion
test "bench: any conversion" (b : @bench.T) {
  b.bench(fn() { b.keep(@nostd.any(42)) })
}

///|
/// Benchmark: typeof_ operation
test "bench: typeof_ check" (b : @bench.T) {
  let val = @nostd.any(42)
  b.bench(fn() { b.keep(@nostd.typeof_(val)) })
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
  let obj = @nostd.Object::new()
  let o = @nostd.any(obj)
  o._set("a", @nostd.any(1))
  o._set("b", @nostd.any(2))
  o._set("c", @nostd.any(3))
  b.bench(fn() { b.keep(@js.Object::keys(o)) })
}
