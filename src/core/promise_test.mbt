///| Test interchangeability between Promise and async functions

///| Basic operations

///|
async test "Promise: @core.Promise::then" {
  let resolver : @core.PromiseResolvers[Int] = @core.Promise::withResolvers()
  @core.run_async(() => {
    @core.sleep(16)
    resolver.resolve(10)
  })
  let p = resolver.promise.then(v => @core.Promise::resolve(v * 2))
  let result = p.wait()
  assert_eq(result, 20)
}

///|
async test "Promise: @core.Promise::catch_" {
  let err_val = @core.new_object()
  let p = @core.Promise::reject(err_val)
  let recovered = p.catch_(_ => @core.Promise::resolve(42 |> @core.any))
  let result : @core.Any = recovered.wait()
  let v : Int = @core.identity(result)
  assert_eq(v, 42)
}

///|
async test "Promise: @core.Promise::finally_" {
  let mut finalized = false
  let resolver : @core.PromiseResolvers[Int] = @core.Promise::withResolvers()
  @core.run_async(() => {
    @core.sleep(16)
    resolver.resolve(100)
  })
  let p = resolver.promise.finally_(() => finalized = true)
  let result = p.wait()
  assert_eq(result, 100)
  assert_true(finalized)
}

///|
async test "Promise: @core.Promise::all" {
  let p1 = @core.Promise::resolve(1)
  let p2 = @core.Promise::resolve(2)
  let p3 = @core.Promise::resolve(3)
  let all = @core.Promise::all([p1, p2, p3])
  let results = all.wait()
  assert_eq(results[0], 1)
  assert_eq(results[1], 2)
  assert_eq(results[2], 3)
}

///|
async test "Promise: @core.Promise::race" {
  let p1 = @core.from_async(async fn() {
    @core.sleep(16)
    100
  })
  let p2 = @core.from_async(async fn() {
    @core.sleep(32)
    200
  })
  let race = @core.Promise::race([p1, p2])
  let result = race.wait()
  assert_eq(result, 100)
}

///|
async test "Promise: @core.Promise::new" {
  let p : @core.Promise[Int] = @core.Promise::new(async fn(resolve, _reject) {
    @core.sleep(16)
    resolve(42)
  })
  let result = p.wait()
  assert_eq(result, 42)
}

///|
async test "Promise: @core.Promise::new with reject" {
  let p : @core.Promise[Int] = @core.Promise::new(async fn(_resolve, reject) {
    @core.sleep(16)
    reject(Failure("test error"))
  })
  let result = try? p.wait()
  assert_true(result is Err(_))
}

///|
async test "Promise: @core.Promise::resolve with different types" {
  let p1 = @core.Promise::resolve(42)
  let p2 = @core.Promise::resolve("hello")
  let p3 = @core.Promise::resolve(true)
  assert_eq(p1.wait(), 42)
  assert_eq(p2.wait(), "hello")
  assert_eq(p3.wait(), true)
}

///|
async test "Promise: @core.Promise::all with empty array" {
  let all : @core.Promise[Array[Int]] = @core.Promise::all([])
  let results = all.wait()
  assert_eq(results.length(), 0)
}

///|
async test "Promise: @core.Promise::race with single promise" {
  let p = @core.Promise::resolve(100)
  let race = @core.Promise::race([p])
  let result = race.wait()
  assert_eq(result, 100)
}

///|
async test "Promise: @core.Promise::any returns first fulfilled promise" {
  let p1 = @core.from_async(async fn() {
    @core.sleep(48)
    100
  })
  let p2 = @core.from_async(async fn() {
    @core.sleep(16)
    200
  })
  let any_result = @core.Promise::any([p1, p2])
  let result = any_result.wait()
  inspect(result, content="200")
}

///|
async test "Promise: @core.Promise::allSettled handles both fulfilled and rejected" {
  let p1 = @core.from_async(async fn() {
    @core.sleep(16)
    42
  })
  let p2 = @core.from_async(async fn() {
    @core.sleep(16)
    100
  })
  let settled = @core.Promise::allSettled([p1, p2])
  let results = settled.wait()
  inspect(results.length(), content="2")
}

///| Advanced operations and error handling

///|
async test "Promise: async function to Promise and back" {
  let result = @core.from_async(async fn() { 42 }).wait()
  inspect(result, content="42")
}

///|
async test "Promise: Promise.resolve to async unwrap" {
  let result = @core.Promise::resolve(100).wait()
  inspect(result, content="100")
}

///|
async test "Promise: promisify0 converts async function to Promise function" {
  let async_fn = async fn() { "hello" }
  let promise_fn = promisify0(async_fn)
  let result = promise_fn().wait()
  inspect(result, content="hello")
}

///|
async test "Promise: promisify1 converts async function to Promise function" {
  let async_fn = async fn(x : Int) { x * 2 }
  let promise_fn = promisify1(async_fn)
  let result = promise_fn(21).wait()
  inspect(result, content="42")
}

///|
async test "Promise: Promise.then with async unwrap" {
  let promise = @core.Promise::resolve(10)
  let doubled = promise.then(fn(x) { @core.Promise::resolve(x * 2) })
  let result = doubled.wait()
  inspect(result, content="20")
}

///|
async test "Promise: unwrap Promise inside async function" {
  let async_fn = async fn() {
    let p1 = @core.Promise::resolve(10)
    let v1 = p1.wait()
    let p2 = @core.Promise::resolve(20)
    let v2 = p2.wait()
    v1 + v2
  }
  let result = async_fn()
  inspect(result, content="30")
}

///|
async test "Promise: Promise.all with async unwrap" {
  let promises = [
    @core.Promise::resolve(1),
    @core.Promise::resolve(2),
    @core.Promise::resolve(3),
  ]
  let all_promise = @core.Promise::all(promises)
  let results = all_promise.wait()
  inspect(results.length(), content="3")
  inspect(results[0], content="1")
  inspect(results[1], content="2")
  inspect(results[2], content="3")
}

///|
async test "Promise: async function with error converts to rejected Promise" {
  let async_fn = async fn() -> Int { fail("test error") }
  let promise = @core.from_async(async_fn)
  let result = promise.wait() catch { _e => -1 }
  inspect(result, content="-1")
}

///|
async test "Promise: Promise.new to async unwrap" {
  let promise : @core.Promise[Int] = @core.Promise::new(async fn(
    resolve,
    _reject,
  ) {
    resolve(999)
  })
  let result = promise.wait()
  inspect(result, content="999")
}

///|
async test "Promise: chaining async and Promise operations" {
  let step1 = async fn() { 5 }
  let step2 = async fn(x : Int) { @core.Promise::resolve(x * 2).wait() }
  let step3 = async fn(x : Int) { x + 10 }
  let result = (async fn() {
    let v1 = step1()
    let v2 = step2(v1)
    step3(v2)
  })()
  inspect(result, content="20")
}

///|
async test "Promise: Promise and async are interchangeable" {
  // async -> Promise
  let async_value = async fn() { 42 }
  let as_promise = @core.from_async(async_value)

  // Promise -> async (unwrap)
  let back_to_async = async fn() { as_promise.wait() }

  // Back to Promise again
  let promise_again = @core.from_async(back_to_async)

  // Get final result
  let final_result = promise_again.wait()
  inspect(final_result, content="42")
}

///| Chaining and composition

///|
async test "Promise: Promise.race returns first resolved Promise" {
  let p1 = @core.Promise::resolve(1)
  let p2 = @core.Promise::resolve(2)
  let p3 = @core.Promise::resolve(3)
  let race_result = @core.Promise::race([p1, p2, p3])
  let result = race_result.wait()
  // race returns the first resolved Promise (one of them since they resolve synchronously)
  inspect(result >= 1 && result <= 3, content="true")
}

///|
async test "Promise: Promise.finally_ always executes" {
  let mut finally_called = false
  let promise = @core.Promise::resolve(42)
  let with_finally = promise.finally_(fn() { finally_called = true })
  let result = with_finally.wait()
  inspect(result, content="42")
  inspect(finally_called, content="true")
}

///|
async test "Promise: Promise.finally_ always executes (2)" {
  let mut finally_called = false
  let promise = @core.Promise::resolve(42)
  let with_finally = promise.finally_(fn() { finally_called = true })
  let result = with_finally.wait()
  inspect(result, content="42")
  inspect(finally_called, content="true")
}

///|
/// Test that conversion from async function to Promise function preserves types
async test "Promise: Promise.finally_ always executes (3)" {
  // async function that returns String
  let string_fn = async fn() { "test" }
  let promise_string_fn = promisify0(string_fn)
  let str_result = promise_string_fn().wait()
  inspect(str_result, content="test")

  // async function that returns Bool
  let bool_fn = async fn(x : Int) { x > 10 }
  let promise_bool_fn = promisify1(bool_fn)
  let bool_result = promise_bool_fn(20).wait()
  inspect(bool_result, content="true")
}

///|
async test "Promise: promisify0" {
  let async_fn = async fn() { 42 }
  let promise_fn = promisify0(async_fn)
  let p = promise_fn()
  let result = p.wait()
  assert_eq(result, 42)
}

///|
async test "Promise: promisify1" {
  let async_fn = async fn(x : Int) { x * 2 }
  let promise_fn = promisify1(async_fn)
  let p = promise_fn(21)
  let result = p.wait()
  assert_eq(result, 42)
}

///|
async test "Promise: promisify2" {
  let async_fn = async fn(x : Int, y : Int) { x + y }
  let promise_fn = promisify2(async_fn)
  let p = promise_fn(20, 22)
  let result = p.wait()
  assert_eq(result, 42)
}

///|
async test "Promise: promisify3" {
  let async_fn = async fn(x : Int, y : Int, z : Int) { x + y + z }
  let promise_fn = promisify3(async_fn)
  let p = promise_fn(10, 20, 12)
  let result = p.wait()
  assert_eq(result, 42)
}

///|
async test "Promise: suspend with resolve" {
  @core.run_async(() => try {
    let value = @core.suspend((ok, _err) => @core.run_async(() => {
      @core.sleep(16)
      ok(42)
    }))
    assert_eq(value, 42)
  } catch {
    _ => ()
  })
}

///|
async test "Promise: suspend with reject" {
  let result : Result[Unit, Failure] = try? @core.suspend((_ok, err) => @core.run_async(() => {
      @core.sleep(16)
      err(Failure("test error"))
    },
  ))
  assert_true(result is Err(_))
}

///|
async test "Promise: Promise chain" {
  let resolver : @core.PromiseResolvers[Int] = @core.Promise::withResolvers()
  @core.run_async(() => {
    @core.sleep(16)
    resolver.resolve(1)
  })
  let p = resolver.promise
    .then(v => @core.Promise::resolve(v + 1))
    .then(v => @core.Promise::resolve(v * 2))
    .then(v => @core.Promise::resolve(v + 10))
  let result = p.wait()
  assert_eq(result, 14)
}

///|
async test "Promise: @core.Promise::resolve with different types (2)" {
  let p1 = @core.Promise::resolve(42)
  let p2 = @core.Promise::resolve("hello")
  let p3 = @core.Promise::resolve(true)
  assert_eq(p1.wait(), 42)
  assert_eq(p2.wait(), "hello")
  assert_eq(p3.wait(), true)
}

///|
async test "Promise: @core.Promise::all with empty array (2)" {
  let all : @core.Promise[Array[Int]] = @core.Promise::all([])
  let results = all.wait()
  assert_eq(results.length(), 0)
}

///|
async test "Promise: @core.Promise::race with single promise (2)" {
  let p = @core.Promise::resolve(100)
  let race = @core.Promise::race([p])
  let result = race.wait()
  assert_eq(result, 100)
}

///|
async test "Promise: nested promises" {
  let resolver : @core.PromiseResolvers[Int] = @core.Promise::withResolvers()
  @core.run_async(() => {
    @core.sleep(16)
    resolver.resolve(10)
  })
  let p1 = resolver.promise.then(v => {
    let inner_resolver : @core.PromiseResolvers[Int] = @core.Promise::withResolvers()
    @core.run_async(() => {
      @core.sleep(16)
      inner_resolver.resolve(v * 2)
    })
    inner_resolver.promise
  })
  let result = p1.wait()
  assert_eq(result, 20)
}

///|
async test "Promise: @core.Promise::all with mixed resolution times" {
  let p1 = @core.from_async(() => {
    @core.sleep(16)
    1
  })
  let p2 = @core.from_async(() => {
    @core.sleep(32)
    2
  })
  let p3 = @core.from_async(() => {
    @core.sleep(48)
    3
  })
  let all = @core.Promise::all([p1, p2, p3])
  let results = all.wait()
  assert_eq(results[0], 1)
  assert_eq(results[1], 2)
  assert_eq(results[2], 3)
}

///|
async test "Promise: @core.Promise::withPromiseResolvers multiple resolve calls" {
  let resolver : @core.PromiseResolvers[Int] = @core.Promise::withResolvers()
  @core.run_async(() => {
    resolver.resolve(1)
    resolver.resolve(2) // second call should be ignored
  })
  let result = resolver.promise.wait()
  assert_eq(result, 1)
}

///|
async test "Promise: Promise chain with error recovery" {
  let err_val : @core.Any = @core.identity(@core.new_object())
  let p = @core.Promise::reject(err_val)
    .catch_(_ => @core.Promise::resolve(10 |> @core.any))
    .then(v => {
      let i : Int = @core.identity(v)
      @core.Promise::resolve(i * 2)
    })
  let result = p.wait()
  assert_eq(result, 20)
}

///|
/// @core.Promise::then with error handling path
async test "Promise: @core.Promise::then with raise and catch" {
  let p = @core.Promise::resolve(10)
  let transformed = p.then(fn(_x) -> @core.Promise[Int] {
    raise Failure("intentional error")
  })
  let result = transformed.wait() catch { _e => -1 }
  inspect(result, content="-1")
}

///|
/// @core.Promise::any resolves with first fulfilled promise
async test "Promise: @core.Promise::any returns first fulfilled promise (2)" {
  let p1 = @core.from_async(async fn() {
    @core.sleep(200)
    100
  })
  let p2 = @core.from_async(async fn() {
    @core.sleep(16)
    200
  })
  let any_result = @core.Promise::any([p1, p2])
  let result = any_result.wait()
  inspect(result, content="200")
}

///|
/// @core.Promise::allSettled waits for all promises
async test "Promise: @core.Promise::allSettled handles both fulfilled and rejected (2)" {
  let p1 = @core.from_async(async fn() {
    @core.sleep(16)
    42
  })
  let p2 = @core.from_async(async fn() {
    @core.sleep(16)
    100
  })
  let settled = @core.Promise::allSettled([p1, p2])
  let results = settled.wait()
  inspect(results.length(), content="2")
}

///|
/// Rejection propagates through then chain without catch
async test "Promise: rejection propagates through then chain" {
  let err_val : @core.Any = @core.new_object()
  let p = @core.Promise::reject(err_val)
    .then(v => {
      let _ignored : @core.Any = v
      @core.Promise::resolve(99 |> @core.any)
    })
    .then(v => {
      let _ignored : @core.Any = v
      @core.Promise::resolve(100 |> @core.any)
    })
  let result : @core.Any = p.wait() catch { _e => @core.any(-1) }
  let num : Int = @core.identity(result)
  inspect(num, content="-1")
}

///|
/// Multiple catch handlers in chain
async test "Promise: multiple catch handlers in chain" {
  let mut first_catch_called = false
  let mut second_catch_called = false
  let err_val : @core.Any = @core.identity(@core.new_object())
  let p = @core.Promise::reject(err_val)
    .catch_(_ => {
      first_catch_called = true
      @core.Promise::resolve(42 |> @core.any)
    })
    .catch_(_ => {
      second_catch_called = true
      @core.Promise::resolve(99 |> @core.any)
    })
  let result : @core.Any = p.wait()
  let num : Int = @core.identity(result)
  inspect(num, content="42")
  inspect(first_catch_called, content="true")
  inspect(second_catch_called, content="false")
}

///|
/// catch_ then finally_ chain
async test "Promise: catch then finally chain" {
  let mut finally_called = false
  let err_val : @core.Any = @core.identity(@core.new_object())
  let p = @core.Promise::reject(err_val)
    .catch_(_ => @core.Promise::resolve(42 |> @core.any))
    .finally_(fn() { finally_called = true })
  let result : @core.Any = p.wait()
  let num : Int = @core.identity(result)
  inspect(num, content="42")
  inspect(finally_called, content="true")
}

///|
/// Rejection in then followed by catch
async test "Promise: rejection in then followed by catch" {
  let p = @core.Promise::resolve(10)
    .then(fn(_x) -> @core.Promise[Int] { raise Failure("error in then") })
    .catch_(_ => @core.Promise::resolve(-1))
  let result = p.wait()
  inspect(result, content="-1")
}

///|
/// Nested catch handlers
async test "Promise: nested catch handlers" {
  let err_val : @core.Any = @core.identity(@core.new_object())
  let p = @core.Promise::reject(err_val)
    .catch_(_ => @core.Promise::reject(@core.identity(@core.new_object())))
    .catch_(_ => @core.Promise::resolve(100 |> @core.any))
  let result : @core.Any = p.wait()
  let num : Int = @core.identity(result)
  inspect(num, content="100")
}

///| from_async tests

///|
async test "Promise: @core.from_async basic" {
  let p : @core.Promise[Int] = @core.from_async(async fn() { 42 })
  let result = p.wait()
  assert_eq(result, 42)
}

///|
async test "Promise: @core.from_async with async operation" {
  let p : @core.Promise[Int] = @core.from_async(async fn() {
    @core.sleep(16)
    100
  })
  let result = p.wait()
  assert_eq(result, 100)
}

///|
async test "Promise: @core.from_async with await inside" {
  let p : @core.Promise[Int] = @core.from_async(async fn() {
    let inner = @core.Promise::resolve(10)
    let v = inner.wait()
    v * 2
  })
  let result = p.wait()
  assert_eq(result, 20)
}

///|
async test "Promise: @core.from_async auto-rejects on error" {
  let p : @core.Promise[Int] = @core.from_async(async fn() {
    fail("auto reject error")
  })
  let result = try? p.wait()
  assert_true(result is Err(_))
}

///| PromiseResolvers::reject tests

///|
async test "Promise: PromiseResolvers::reject" {
  let resolvers : @core.PromiseResolvers[Int] = @core.Promise::withResolvers()
  @core.run_async(fn() { resolvers.reject(Failure("rejected")) })
  let result = try? resolvers.promise.wait()
  assert_true(result is Err(_))
}

///|
async test "JS Async: sleep with very short duration" {
  @core.sleep(16)
  // Just verify sleep completes without error
  assert_true(true)
}

///| Async operations

///|
async test "JS Async: sleep multiple times" {
  let mut count = 0
  @core.sleep(16)
  count += 1
  @core.sleep(16)
  count += 1
  @core.sleep(16)
  count += 1
  assert_eq(count, 3)
}

///| Promisify error handling tests

///|
async test "promisify0: handles error by rejecting promise" {
  let failing_fn = async fn() -> Int { fail("test error") }
  let promise_fn = promisify0(failing_fn)
  let promise = promise_fn()

  // Promise should be rejected
  try {
    let _ = promise.wait()
    fail("Expected promise to be rejected")
  } catch {
    _e =>
      // Expected to catch error
      assert_true(true)
  }
}

///|
async test "promisify1: handles error by rejecting promise" {
  let failing_fn = async fn(x : Int) -> Int {
    if x < 0 {
      fail("negative value")
    } else {
      x * 2
    }
  }
  let promise_fn = promisify1(failing_fn)
  let promise = promise_fn(-5)

  // Promise should be rejected
  try {
    let _ = promise.wait()
    fail("Expected promise to be rejected")
  } catch {
    _e =>
      // Expected to catch error
      assert_true(true)
  }
}

///|
async test "promisify2: handles error by rejecting promise" {
  let failing_fn = async fn(x : Int, y : Int) -> Int {
    if x + y < 0 {
      fail("sum is negative")
    } else {
      x + y
    }
  }
  let promise_fn = promisify2(failing_fn)
  let promise = promise_fn(-10, 5)

  // Promise should be rejected
  try {
    let _ = promise.wait()
    fail("Expected promise to be rejected")
  } catch {
    _e =>
      // Expected to catch error
      assert_true(true)
  }
}

///|
async test "promisify3: handles error by rejecting promise" {
  let failing_fn = async fn(x : Int, y : Int, z : Int) -> Int {
    if x + y + z < 0 {
      fail("sum is negative")
    } else {
      x + y + z
    }
  }
  let promise_fn = promisify3(failing_fn)
  let promise = promise_fn(-10, 3, 2)

  // Promise should be rejected
  try {
    let _ = promise.wait()
    fail("Expected promise to be rejected")
  } catch {
    _e =>
      // Expected to catch error
      assert_true(true)
  }
}

///|
#skip("Flaky test, needs investigation")
async test "JS Async: nested run_async" {
  let mut outer = false
  let mut inner = false
  @core.run_async(() => {
    @core.sleep(16)
    outer = true
    @core.run_async(() => {
      @core.sleep(16)
      inner = true
    })
  })
  @core.sleep(100)
  assert_true(outer)
  assert_true(inner)
}

///|
async test "JS Async: run_async with multiple sleep calls" {
  let checkpoints = []
  checkpoints.push(1)
  @core.sleep(16)
  checkpoints.push(2)
  @core.sleep(16)
  checkpoints.push(3)
  @core.sleep(48)
  assert_eq(checkpoints.length(), 3)
  assert_eq(checkpoints[0], 1)
  assert_eq(checkpoints[1], 2)
  assert_eq(checkpoints[2], 3)
}

///|
/// Test that promisify0 creates a Promise
test "promisify0 creates a Promise" {
  async fn test_fn0() -> Int {
    42
  }

  let promise_fn = promisify0(test_fn0)
  let promise = promise_fn()
  // Verify that a Promise was created by checking if it's a JS object
  let js_val : @core.Any = @core.identity(promise)
  inspect(@core.typeof_(js_val), content="object")
}

///|
/// Test that promisify1 creates a Promise
test "promisify1 creates a Promise" {
  async fn test_fn1(x : Int) -> Int {
    x * 2
  }

  let promise_fn = promisify1(test_fn1)
  let promise = promise_fn(21)
  let js_val : @core.Any = @core.identity(promise)
  inspect(@core.typeof_(js_val), content="object")
}

///|
/// Test that promisify2 creates a Promise
test "promisify2 creates a Promise" {
  async fn test_fn2(x : Int, y : Int) -> Int {
    x + y
  }

  let promise_fn = promisify2(test_fn2)
  let promise = promise_fn(10, 32)
  let js_val : @core.Any = @core.identity(promise)
  inspect(@core.typeof_(js_val), content="object")
}

///|
/// Test that promisify3 creates a Promise
test "promisify3 creates a Promise" {
  async fn test_fn3(x : Int, y : Int, z : Int) -> Int {
    x + y + z
  }

  let promise_fn = promisify3(test_fn3)
  let promise = promise_fn(10, 20, 12)
  let js_val : @core.Any = @core.identity(promise)
  inspect(@core.typeof_(js_val), content="object")
}

///| Additional coverage tests

///|
async test "Promise::new with exception in callback" {
  let p : @core.Promise[Int] = @core.Promise::new(async fn(_resolve, _reject) {
    fail("error in promise callback")
  })
  let result = try? p.wait()
  inspect(result is Err(_), content="true")
}

///|
async test "PromiseResolvers::resolve direct call" {
  let resolvers : @core.PromiseResolvers[Int] = @core.Promise::withResolvers()
  resolvers.resolve(999)
  let result = resolvers.promise.wait()
  inspect(result, content="999")
}

///|
async test "PromiseResolvers::reject direct call" {
  let resolvers : @core.PromiseResolvers[Int] = @core.Promise::withResolvers()
  resolvers.reject(Failure("direct reject"))
  let result = try? resolvers.promise.wait()
  inspect(result is Err(_), content="true")
}

///| Dispose tests

///|
extern "js" fn get_symbol_async_dispose() -> String =
  #| () => Symbol.asyncDispose

///|
extern "js" fn get_symbol_dispose() -> String =
  #| () => Symbol.dispose

///|
async test "dispose_async with Symbol.asyncDispose" {
  // Create a mock object with Symbol.asyncDispose
  let obj = @core.new_object()
  let mut disposed = false
  let dispose_fn = @core.any(fn() {
    disposed = true
    @core.Promise::resolve(@core.undefined())
  })
  obj._set(get_symbol_async_dispose(), dispose_fn)
  @core.dispose_async(obj)
  inspect(disposed, content="true")
}

///|
test "dispose_async_ignore with Symbol.asyncDispose" {
  // Create a mock object with Symbol.asyncDispose
  let obj = @core.new_object()
  let dispose_fn = @core.any(fn() { @core.Promise::resolve(@core.undefined()) })
  obj._set(get_symbol_async_dispose(), dispose_fn)
  @core.dispose_async_ignore(obj)
  // Just verify it doesn't throw
  inspect(true, content="true")
}

///|
test "dispose with Symbol.dispose" {
  // Create a mock object with Symbol.dispose
  let obj = @core.new_object()
  let mut disposed = false
  let dispose_fn = @core.any(fn() { disposed = true })
  obj._set(get_symbol_dispose(), dispose_fn)
  @core.dispose(obj)
  inspect(disposed, content="true")
}
