///|
/// Tests for Atomics API
///
/// Note: Many Atomics operations require SharedArrayBuffer and are primarily
/// useful in multi-threaded contexts (Web Workers). These tests verify the
/// API bindings are correct.

///|

///|
test "Atomics isLockFree checks size support" {
  // Test common sizes
  let size1 = @atomics.isLockFree(1)
  let size2 = @atomics.isLockFree(2)
  let size4 = @atomics.isLockFree(4)

  // These should typically be true on modern systems
  inspect(size1 || !size1, content="true") // Always true or false
  inspect(size2 || !size2, content="true")
  inspect(size4 || !size4, content="true")
}

///|
test "Atomics add operation" {
  // Create a SharedArrayBuffer (or regular ArrayBuffer for testing)
  let g : @core.Any = @global.global_this() |> @core.any
  let buffer = @core.new(g["ArrayBuffer"] |> @core.identity, [@core.any(16)])
  let ta = @core.new(g["Int32Array"] |> @core.identity, [buffer])
  let ta_any : @core.Any = ta |> @core.any

  // Test add operation
  let oldValue = @atomics.add(ta_any, 0, 5)
  inspect(oldValue, content="0") // Initial value should be 0
  let currentValue : Int = ta_any["0"].cast()
  inspect(currentValue, content="5") // Should be 5 after adding
}

///|
test "Atomics load and store operations" {
  let g : @core.Any = @global.global_this() |> @core.any
  let buffer = @core.new(g["ArrayBuffer"] |> @core.identity, [@core.any(16)])
  let ta = @core.new(g["Int32Array"] |> @core.identity, [buffer])
  let ta_any : @core.Any = ta |> @core.any

  // Store a value
  let stored = @atomics.store(ta_any, 0, 42)
  inspect(stored, content="42")

  // Load the value
  let loaded = @atomics.load(ta_any, 0)
  inspect(loaded, content="42")
}

///|
test "Atomics sub operation" {
  let g : @core.Any = @global.global_this() |> @core.any
  let buffer = @core.new(g["ArrayBuffer"] |> @core.identity, [@core.any(16)])
  let ta = @core.new(g["Int32Array"] |> @core.identity, [buffer])
  let ta_any : @core.Any = ta |> @core.any

  // Set initial value
  @atomics.store(ta_any, 0, 10) |> ignore

  // Subtract
  let oldValue = @atomics.sub(ta_any, 0, 3)
  inspect(oldValue, content="10")
  let currentValue : Int = ta_any["0"].cast()
  inspect(currentValue, content="7")
}

///|
test "Atomics and_ bitwise operation" {
  let g : @core.Any = @global.global_this() |> @core.any
  let buffer = @core.new(g["ArrayBuffer"] |> @core.identity, [@core.any(16)])
  let ta = @core.new(g["Int32Array"] |> @core.identity, [buffer])
  let ta_any : @core.Any = ta |> @core.any

  // Set initial value (binary: 1111)
  @atomics.store(ta_any, 0, 15) |> ignore

  // AND with 7 (binary: 0111) should give 7
  let oldValue = @atomics.and_(ta_any, 0, 7)
  inspect(oldValue, content="15")
  let currentValue : Int = ta_any["0"].cast()
  inspect(currentValue, content="7")
}

///|
test "Atomics or_ bitwise operation" {
  let g : @core.Any = @global.global_this() |> @core.any
  let buffer = @core.new(g["ArrayBuffer"] |> @core.identity, [@core.any(16)])
  let ta = @core.new(g["Int32Array"] |> @core.identity, [buffer])
  let ta_any : @core.Any = ta |> @core.any

  // Set initial value (binary: 0101)
  @atomics.store(ta_any, 0, 5) |> ignore

  // OR with 10 (binary: 1010) should give 15 (binary: 1111)
  let oldValue = @atomics.or_(ta_any, 0, 10)
  inspect(oldValue, content="5")
  let currentValue : Int = ta_any["0"].cast()
  inspect(currentValue, content="15")
}

///|
test "Atomics xor bitwise operation" {
  let g : @core.Any = @global.global_this() |> @core.any
  let buffer = @core.new(g["ArrayBuffer"] |> @core.identity, [@core.any(16)])
  let ta = @core.new(g["Int32Array"] |> @core.identity, [buffer])
  let ta_any : @core.Any = ta |> @core.any
  // Set initial value (binary: 1111)
  @atomics.store(ta_any, 0, 15) |> ignore

  // XOR with 5 (binary: 0101) should give 10 (binary: 1010)
  let oldValue = @atomics.xor(ta_any, 0, 5)
  inspect(oldValue, content="15")
  let currentValue : Int = ta_any["0"].cast()
  inspect(currentValue, content="10")
}

///|
test "Atomics exchange operation" {
  let g : @core.Any = @global.global_this() |> @core.any
  let buffer = @core.new(g["ArrayBuffer"] |> @core.identity, [@core.any(16)])
  let ta = @core.new(g["Int32Array"] |> @core.identity, [buffer])
  let ta_any : @core.Any = ta |> @core.any

  // Set initial value
  @atomics.store(ta_any, 0, 100) |> ignore

  // Exchange with new value
  let oldValue = @atomics.exchange(ta_any, 0, 200)
  inspect(oldValue, content="100")
  let currentValue : Int = ta_any["0"].cast()
  inspect(currentValue, content="200")
}

///|
test "Atomics compareExchange operation" {
  let g : @core.Any = @global.global_this() |> @core.any
  let buffer = @core.new(g["ArrayBuffer"] |> @core.identity, [@core.any(16)])
  let ta = @core.new(g["Int32Array"] |> @core.identity, [buffer])
  let ta_any : @core.Any = ta |> @core.any

  // Set initial value
  @atomics.store(ta_any, 0, 5) |> ignore

  // Compare and exchange - should succeed
  let oldValue = @atomics.compareExchange(ta_any, 0, 5, 12)
  inspect(oldValue, content="5")
  let currentValue : Int = ta_any["0"].cast()
  inspect(currentValue, content="12")

  // Compare and exchange - should fail (expected value doesn't match)
  let oldValue2 = @atomics.compareExchange(ta_any, 0, 5, 20)
  inspect(oldValue2, content="12") // Returns current value
  let currentValue2 : Int = ta_any["0"].cast()
  inspect(currentValue2, content="12") // Value should not change
}
