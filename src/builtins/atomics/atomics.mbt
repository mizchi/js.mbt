///|
/// JavaScript Atomics API
///
/// The Atomics namespace object contains static methods for carrying out atomic operations.
/// They are used with SharedArrayBuffer and ArrayBuffer objects.
///
/// MDN Reference: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Atomics

///| Core Types

///|
/// JavaScript Atomics namespace object
#external
pub type Atomics

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
/// Atomics::add(ta, 0, 12)  // returns 0 (the old value)
/// Atomics::load(ta, 0)     // 12 (the new value)
/// ```
///
/// MDN: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Atomics/add
pub fn Atomics::add(typedArray : @core.Any, index : Int, value : Int) -> Int {
  ffi_atomics_add(typedArray, index, value).cast()
}

///|
/// Atomically computes a bitwise AND with a value at the given position.
/// Returns the old value at that index.
///
/// MDN: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Atomics/and
pub fn Atomics::and_(typedArray : @core.Any, index : Int, value : Int) -> Int {
  ffi_atomics_and(typedArray, index, value).cast()
}

///|
/// Atomically stores a value at the given position, if it equals the expected value.
/// Returns the old value.
///
/// # Example
///
/// ```moonbit no-check
/// let ta = Int32Array::new(sab)
/// Atomics::store(ta, 0, 5)
/// Atomics::compareExchange(ta, 0, 5, 12)  // returns 5
/// Atomics::load(ta, 0)                     // 12
/// ```
///
/// MDN: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Atomics/compareExchange
pub fn Atomics::compareExchange(
  typedArray : @core.Any,
  index : Int,
  expectedValue : Int,
  replacementValue : Int,
) -> Int {
  ffi_atomics_compare_exchange(
    typedArray, index, expectedValue, replacementValue,
  ).cast()
}

///|
/// Atomically stores a value at the given position in the array.
/// Returns the old value.
///
/// MDN: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Atomics/exchange
pub fn Atomics::exchange(
  typedArray : @core.Any,
  index : Int,
  value : Int,
) -> Int {
  ffi_atomics_exchange(typedArray, index, value).cast()
}

///|
/// Returns true if an atomic operation on arrays of the given element size
/// will be implemented using a hardware atomic operation (as opposed to a lock).
///
/// # Example
///
/// ```moonbit no-check
/// Atomics::isLockFree(1)  // true
/// Atomics::isLockFree(2)  // true
/// Atomics::isLockFree(4)  // true
/// Atomics::isLockFree(8)  // true (on 64-bit systems)
/// ```
///
/// MDN: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Atomics/isLockFree
pub fn Atomics::isLockFree(size : Int) -> Bool {
  ffi_atomics_is_lock_free(size)
}

///|
/// Atomically returns the value at the given position in the array.
///
/// MDN: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Atomics/load
pub fn Atomics::load(typedArray : @core.Any, index : Int) -> Int {
  ffi_atomics_load(typedArray, index).cast()
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
/// Atomics::notify(ia, 0, count=1)  // Notify 1 agent waiting on index 0
/// ```
///
/// MDN: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Atomics/notify
pub fn Atomics::notify(
  typedArray : @core.Any,
  index : Int,
  count? : Int,
) -> Int {
  match count {
    Some(c) => ffi_atomics_notify(typedArray, index, c).cast()
    None => ffi_atomics_notify_2(typedArray, index).cast()
  }
}

///|
/// Atomically computes a bitwise OR with a value at the given position.
/// Returns the old value at that index.
///
/// MDN: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Atomics/or
pub fn Atomics::or_(typedArray : @core.Any, index : Int, value : Int) -> Int {
  ffi_atomics_or(typedArray, index, value).cast()
}

///|
/// Atomically stores a value at the given position in the array.
/// Returns the value that was stored.
///
/// MDN: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Atomics/store
pub fn Atomics::store(typedArray : @core.Any, index : Int, value : Int) -> Int {
  ffi_atomics_store(typedArray, index, value).cast()
}

///|
/// Atomically subtracts a value from the value at the given position.
/// Returns the old value at that index.
///
/// MDN: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Atomics/sub
pub fn Atomics::sub(typedArray : @core.Any, index : Int, value : Int) -> Int {
  ffi_atomics_sub(typedArray, index, value).cast()
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
/// let result = Atomics::wait(ia, 0, 0, timeout=1000)
/// match result {
///   Ok => println("Woken up")
///   NotEqual => println("Value changed")
///   TimedOut => println("Timed out")
/// }
/// ```
///
/// MDN: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Atomics/wait
pub fn Atomics::wait(
  typedArray : @core.Any,
  index : Int,
  value : Int,
  timeout? : Int,
) -> AtomicsWaitResult {
  let result = match timeout {
    Some(t) => ffi_atomics_wait(typedArray, index, value, t)
    None => ffi_atomics_wait_3(typedArray, index, value)
  }
  let result_str : String = @core.identity(result)
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
pub fn Atomics::xor(typedArray : @core.Any, index : Int, value : Int) -> Int {
  ffi_atomics_xor(typedArray, index, value).cast()
}

///| FFI Bindings

///|
extern "js" fn ffi_atomics_add(
  typedArray : @core.Any,
  index : Int,
  value : Int,
) -> @core.Any =
  #| (typedArray, index, value) => Atomics.add(typedArray, index, value)

///|
extern "js" fn ffi_atomics_and(
  typedArray : @core.Any,
  index : Int,
  value : Int,
) -> @core.Any =
  #| (typedArray, index, value) => Atomics.and(typedArray, index, value)

///|
extern "js" fn ffi_atomics_compare_exchange(
  typedArray : @core.Any,
  index : Int,
  expectedValue : Int,
  replacementValue : Int,
) -> @core.Any =
  #| (typedArray, index, expectedValue, replacementValue) => Atomics.compareExchange(typedArray, index, expectedValue, replacementValue)

///|
extern "js" fn ffi_atomics_exchange(
  typedArray : @core.Any,
  index : Int,
  value : Int,
) -> @core.Any =
  #| (typedArray, index, value) => Atomics.exchange(typedArray, index, value)

///|
extern "js" fn ffi_atomics_is_lock_free(size : Int) -> Bool =
  #| (size) => Atomics.isLockFree(size)

///|
extern "js" fn ffi_atomics_load(
  typedArray : @core.Any,
  index : Int,
) -> @core.Any =
  #| (typedArray, index) => Atomics.load(typedArray, index)

///|
extern "js" fn ffi_atomics_notify(
  typedArray : @core.Any,
  index : Int,
  count : Int,
) -> @core.Any =
  #| (typedArray, index, count) => Atomics.notify(typedArray, index, count)

///|
extern "js" fn ffi_atomics_notify_2(
  typedArray : @core.Any,
  index : Int,
) -> @core.Any =
  #| (typedArray, index) => Atomics.notify(typedArray, index)

///|
extern "js" fn ffi_atomics_or(
  typedArray : @core.Any,
  index : Int,
  value : Int,
) -> @core.Any =
  #| (typedArray, index, value) => Atomics.or(typedArray, index, value)

///|
extern "js" fn ffi_atomics_store(
  typedArray : @core.Any,
  index : Int,
  value : Int,
) -> @core.Any =
  #| (typedArray, index, value) => Atomics.store(typedArray, index, value)

///|
extern "js" fn ffi_atomics_sub(
  typedArray : @core.Any,
  index : Int,
  value : Int,
) -> @core.Any =
  #| (typedArray, index, value) => Atomics.sub(typedArray, index, value)

///|
extern "js" fn ffi_atomics_wait(
  typedArray : @core.Any,
  index : Int,
  value : Int,
  timeout : Int,
) -> @core.Any =
  #| (typedArray, index, value, timeout) => Atomics.wait(typedArray, index, value, timeout)

///|
extern "js" fn ffi_atomics_wait_3(
  typedArray : @core.Any,
  index : Int,
  value : Int,
) -> @core.Any =
  #| (typedArray, index, value) => Atomics.wait(typedArray, index, value)

///|
extern "js" fn ffi_atomics_xor(
  typedArray : @core.Any,
  index : Int,
  value : Int,
) -> @core.Any =
  #| (typedArray, index, value) => Atomics.xor(typedArray, index, value)
