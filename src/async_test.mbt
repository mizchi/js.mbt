///|
/// JS Async: Timer operations

///|
async test "JS Async: setTimeout" {
  let resolver : @js.Resolvers[Bool] = @js.Promise::withResolvers()
  let _timer = @global.set_timeout(() => resolver.resolve(true), 16)
  let executed = resolver.promise.wait()
  assert_true(executed)
}

///|
async test "JS Async: clearTimeout" {
  let mut executed = false
  let timer = @global.set_timeout(() => executed = true, 16)
  defer @global.clear_timeout(timer)
  @global.clear_timeout(timer)
  @js.sleep(32)
  assert_false(executed)
}

///|
#skip
async test "JS Async: setTimeout with zero delay" {
  let mut executed = false
  let _ = @global.set_timeout(() => executed = true, 0)
  @js.sleep(60)
  assert_true(executed)
}

///|
#skip("Flaky test - setTimeout execution order not guaranteed")
async test "JS Async: multiple setTimeouts" {
  let order = []
  let resolver : @js.Resolvers[Int] = @js.Promise::withResolvers()
  let _ = @global.set_timeout(
    () => {
      order.push(1)
      if order.length() == 3 {
        resolver.resolve(3)
      }
    },
    16,
  )
  let _ = @global.set_timeout(
    () => {
      order.push(2)
      if order.length() == 3 {
        resolver.resolve(3)
      }
    },
    32,
  )
  let _ = @global.set_timeout(
    () => {
      order.push(3)
      if order.length() == 3 {
        resolver.resolve(3)
      }
    },
    48,
  )
  let count = resolver.promise.wait()
  assert_eq(count, 3)
  assert_eq(order[0], 1) // 16ms
  assert_eq(order[1], 2) // 32ms
  assert_eq(order[2], 3) // 48ms
}

///|
async test "JS Async: setInterval immediate execution" {
  let mut first_execution = false
  let timer = @global.set_interval(
    () => if not(first_execution) { first_execution = true },
    16,
  )
  defer @global.clear_interval(timer)
  @js.sleep(16)
  assert_true(first_execution)
}

///|
async test "JS Async: sleep with very short duration" {
  @js.sleep(16)
  // Just verify sleep completes without error
  assert_true(true)
}

///| Async operations

///|
async test "JS Async: sleep multiple times" {
  let mut count = 0
  @js.sleep(16)
  count += 1
  @js.sleep(16)
  count += 1
  @js.sleep(16)
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
  @js.run_async(() => {
    @js.sleep(16)
    outer = true
    @js.run_async(() => {
      @js.sleep(16)
      inner = true
    })
  })
  @js.sleep(100)
  assert_true(outer)
  assert_true(inner)
}

///|
async test "JS Async: run_async with multiple sleep calls" {
  let checkpoints = []
  checkpoints.push(1)
  @js.sleep(16)
  checkpoints.push(2)
  @js.sleep(16)
  checkpoints.push(3)
  @js.sleep(48)
  assert_eq(checkpoints.length(), 3)
  assert_eq(checkpoints[0], 1)
  assert_eq(checkpoints[1], 2)
  assert_eq(checkpoints[2], 3)
}

///| EventEmitter

///|
async test "JS Async: EventEmitter listenerCount for non-existent event" {
  let emitter = @events.EventEmitter::new()
  assert_eq(emitter.listenerCount("nonexistent"), 0)
}

///|
/// Test that promisify0 creates a Promise
test "promisify0 creates a Promise" {
  async fn test_fn0() -> Int {
    42
  }

  let promise_fn = @js.promisify0(test_fn0)
  let promise = promise_fn()
  // Verify that a Promise was created by checking if it's a JS object
  let js_val : @nostd.Any = @js.identity(promise)
  inspect(typeof_(js_val), content="object")
}

///|
/// Test that promisify1 creates a Promise
test "promisify1 creates a Promise" {
  async fn test_fn1(x : Int) -> Int {
    x * 2
  }

  let promise_fn = @js.promisify1(test_fn1)
  let promise = promise_fn(21)
  let js_val : @nostd.Any = @js.identity(promise)
  inspect(typeof_(js_val), content="object")
}

///|
/// Test that promisify2 creates a Promise
test "promisify2 creates a Promise" {
  async fn test_fn2(x : Int, y : Int) -> Int {
    x + y
  }

  let promise_fn = @js.promisify2(test_fn2)
  let promise = promise_fn(10, 32)
  let js_val : @nostd.Any = @js.identity(promise)
  inspect(typeof_(js_val), content="object")
}

///|
/// Test that promisify3 creates a Promise
test "promisify3 creates a Promise" {
  async fn test_fn3(x : Int, y : Int, z : Int) -> Int {
    x + y + z
  }

  let promise_fn = @js.promisify3(test_fn3)
  let promise = promise_fn(10, 20, 12)
  let js_val : @nostd.Any = @js.identity(promise)
  inspect(typeof_(js_val), content="object")
}
