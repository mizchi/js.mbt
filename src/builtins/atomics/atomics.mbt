///|
/// JavaScript Atomics API
///
/// The Atomics namespace object contains static methods for carrying out atomic operations.
/// They are used with SharedArrayBuffer and ArrayBuffer objects.
///
/// MDN Reference: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Atomics

///| Core Types

///|
/// Wait result returned by wait()
pub enum AtomicsWaitResult {
  Ok
  NotEqual
  TimedOut
} derive(Eq, Show)

///| Atomic Operations

///|
/// Atomically adds a value to the value at the given position in the array.
/// Returns the old value at that index.
///
/// # Example
///
/// ```moonbit no-check
/// let sab = SharedArrayBuffer::new(1024)
/// let ta = Uint8Array::new(sab)
/// add(ta, 0, 12)  // returns 0 (the old value)
/// load(ta, 0)     // 12 (the new value)
/// ```
///
/// MDN: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Atomics/add
pub fn add(typedArray : @js.Js, index : Int, value : Int) -> Int {
  ffi_atomics_add(typedArray, index, value) |> @js.identity
}

///|
/// Atomically computes a bitwise AND with a value at the given position.
/// Returns the old value at that index.
///
/// MDN: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Atomics/and
pub fn and_(typedArray : @js.Js, index : Int, value : Int) -> Int {
  ffi_atomics_and(typedArray, index, value) |> @js.identity
}

///|
/// Atomically stores a value at the given position, if it equals the expected value.
/// Returns the old value.
///
/// # Example
///
/// ```moonbit no-check
/// let ta = Int32Array::new(sab)
/// store(ta, 0, 5)
/// compareExchange(ta, 0, 5, 12)  // returns 5
/// load(ta, 0)                     // 12
/// ```
///
/// MDN: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Atomics/compareExchange
pub fn compareExchange(
  typedArray : @js.Js,
  index : Int,
  expectedValue : Int,
  replacementValue : Int,
) -> Int {
  ffi_atomics_compare_exchange(
    typedArray, index, expectedValue, replacementValue,
  )
  |> @js.identity
}

///|
/// Atomically stores a value at the given position in the array.
/// Returns the old value.
///
/// MDN: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Atomics/exchange
pub fn exchange(typedArray : @js.Js, index : Int, value : Int) -> Int {
  ffi_atomics_exchange(typedArray, index, value) |> @js.identity
}

///|
/// Returns true if an atomic operation on arrays of the given element size
/// will be implemented using a hardware atomic operation (as opposed to a lock).
///
/// # Example
///
/// ```moonbit no-check
/// isLockFree(1)  // true
/// isLockFree(2)  // true
/// isLockFree(4)  // true
/// isLockFree(8)  // true (on 64-bit systems)
/// ```
///
/// MDN: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Atomics/isLockFree
pub fn isLockFree(size : Int) -> Bool {
  ffi_atomics_is_lock_free(size)
}

///|
/// Atomically returns the value at the given position in the array.
///
/// MDN: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Atomics/load
pub fn load(typedArray : @js.Js, index : Int) -> Int {
  ffi_atomics_load(typedArray, index) |> @js.identity
}

///|
/// Notifies agents waiting on the given index of the array.
/// Returns the number of agents that were notified.
///
/// Note: Also known as Atomics.wake() in older specifications.
///
/// # Example
///
/// ```moonbit no-check
/// notify(ia, 0, count=1)  // Notify 1 agent waiting on index 0
/// ```
///
/// MDN: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Atomics/notify
pub fn notify(typedArray : @js.Js, index : Int, count? : Int) -> Int {
  match count {
    Some(c) => ffi_atomics_notify(typedArray, index, c) |> @js.identity
    None => ffi_atomics_notify_2(typedArray, index) |> @js.identity
  }
}

///|
/// Atomically computes a bitwise OR with a value at the given position.
/// Returns the old value at that index.
///
/// MDN: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Atomics/or
pub fn or_(typedArray : @js.Js, index : Int, value : Int) -> Int {
  ffi_atomics_or(typedArray, index, value) |> @js.identity
}

///|
/// Atomically stores a value at the given position in the array.
/// Returns the value that was stored.
///
/// MDN: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Atomics/store
pub fn store(typedArray : @js.Js, index : Int, value : Int) -> Int {
  ffi_atomics_store(typedArray, index, value) |> @js.identity
}

///|
/// Atomically subtracts a value from the value at the given position.
/// Returns the old value at that index.
///
/// MDN: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Atomics/sub
pub fn sub(typedArray : @js.Js, index : Int, value : Int) -> Int {
  ffi_atomics_sub(typedArray, index, value) |> @js.identity
}

///|
/// Verifies that the given position in the array still contains a value
/// and sleeps awaiting or times out.
/// Returns Ok, NotEqual, or TimedOut.
///
/// Note: This operation is only allowed in workers, not on the main thread.
///
/// # Example
///
/// ```moonbit no-check
/// let result = wait(ia, 0, 0, timeout=1000)
/// match result {
///   Ok => println("Woken up")
///   NotEqual => println("Value changed")
///   TimedOut => println("Timed out")
/// }
/// ```
///
/// MDN: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Atomics/wait
pub fn wait(
  typedArray : @js.Js,
  index : Int,
  value : Int,
  timeout? : Int,
) -> AtomicsWaitResult {
  let result = match timeout {
    Some(t) => ffi_atomics_wait(typedArray, index, value, t)
    None => ffi_atomics_wait_3(typedArray, index, value)
  }
  let result_str : String = @js.identity(result)
  match result_str {
    "ok" => AtomicsWaitResult::Ok
    "not-equal" => AtomicsWaitResult::NotEqual
    "timed-out" => AtomicsWaitResult::TimedOut
    _ => AtomicsWaitResult::Ok // fallback
  }
}

///|
/// Atomically computes a bitwise XOR with a value at the given position.
/// Returns the old value at that index.
///
/// MDN: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Atomics/xor
pub fn xor(typedArray : @js.Js, index : Int, value : Int) -> Int {
  ffi_atomics_xor(typedArray, index, value) |> @js.identity
}

///| FFI Bindings

///|
extern "js" fn ffi_atomics_add(
  typedArray : @js.Js,
  index : Int,
  value : Int,
) -> @js.Js =
  #| (typedArray, index, value) => Atomics.add(typedArray, index, value)

///|
extern "js" fn ffi_atomics_and(
  typedArray : @js.Js,
  index : Int,
  value : Int,
) -> @js.Js =
  #| (typedArray, index, value) => Atomics.and(typedArray, index, value)

///|
extern "js" fn ffi_atomics_compare_exchange(
  typedArray : @js.Js,
  index : Int,
  expectedValue : Int,
  replacementValue : Int,
) -> @js.Js =
  #| (typedArray, index, expectedValue, replacementValue) => Atomics.compareExchange(typedArray, index, expectedValue, replacementValue)

///|
extern "js" fn ffi_atomics_exchange(
  typedArray : @js.Js,
  index : Int,
  value : Int,
) -> @js.Js =
  #| (typedArray, index, value) => Atomics.exchange(typedArray, index, value)

///|
extern "js" fn ffi_atomics_is_lock_free(size : Int) -> Bool =
  #| (size) => Atomics.isLockFree(size)

///|
extern "js" fn ffi_atomics_load(typedArray : @js.Js, index : Int) -> @js.Js =
  #| (typedArray, index) => Atomics.load(typedArray, index)

///|
extern "js" fn ffi_atomics_notify(
  typedArray : @js.Js,
  index : Int,
  count : Int,
) -> @js.Js =
  #| (typedArray, index, count) => Atomics.notify(typedArray, index, count)

///|
extern "js" fn ffi_atomics_notify_2(typedArray : @js.Js, index : Int) -> @js.Js =
  #| (typedArray, index) => Atomics.notify(typedArray, index)

///|
extern "js" fn ffi_atomics_or(
  typedArray : @js.Js,
  index : Int,
  value : Int,
) -> @js.Js =
  #| (typedArray, index, value) => Atomics.or(typedArray, index, value)

///|
extern "js" fn ffi_atomics_store(
  typedArray : @js.Js,
  index : Int,
  value : Int,
) -> @js.Js =
  #| (typedArray, index, value) => Atomics.store(typedArray, index, value)

///|
extern "js" fn ffi_atomics_sub(
  typedArray : @js.Js,
  index : Int,
  value : Int,
) -> @js.Js =
  #| (typedArray, index, value) => Atomics.sub(typedArray, index, value)

///|
extern "js" fn ffi_atomics_wait(
  typedArray : @js.Js,
  index : Int,
  value : Int,
  timeout : Int,
) -> @js.Js =
  #| (typedArray, index, value, timeout) => Atomics.wait(typedArray, index, value, timeout)

///|
extern "js" fn ffi_atomics_wait_3(
  typedArray : @js.Js,
  index : Int,
  value : Int,
) -> @js.Js =
  #| (typedArray, index, value) => Atomics.wait(typedArray, index, value)

///|
extern "js" fn ffi_atomics_xor(
  typedArray : @js.Js,
  index : Int,
  value : Int,
) -> @js.Js =
  #| (typedArray, index, value) => Atomics.xor(typedArray, index, value)
