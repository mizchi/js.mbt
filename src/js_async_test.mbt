///|
/// JS Async: Timer operations

///|
async test "JS Async: setTimeout" {
  let resolver : @js.Resolvers[Bool] = @js.Promise::withResolvers()
  let _timer = @js.setTimeout(() => resolver.resolve(true), 16)
  let executed = resolver.promise.wait()
  assert_true(executed)
}

///|
async test "JS Async: clearTimeout" {
  let mut executed = false
  let timer = @js.setTimeout(() => executed = true, 16)
  defer @js.clearTimeout(timer)
  @js.clearTimeout(timer)
  @js.sleep(32)
  assert_false(executed)
}

///|
#skip
async test "JS Async: setTimeout with zero delay" {
  let mut executed = false
  let _ = @js.setTimeout(() => executed = true, 0)
  @js.sleep(60)
  assert_true(executed)
}

///|
#skip("Flaky test - setTimeout execution order not guaranteed")
async test "JS Async: multiple setTimeouts" {
  let order = []
  let resolver : @js.Resolvers[Int] = @js.Promise::withResolvers()
  let _ = @js.setTimeout(
    () => {
      order.push(1)
      if order.length() == 3 {
        resolver.resolve(3)
      }
    },
    16,
  )
  let _ = @js.setTimeout(
    () => {
      order.push(2)
      if order.length() == 3 {
        resolver.resolve(3)
      }
    },
    32,
  )
  let _ = @js.setTimeout(
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
  let timer = @js.setInterval(
    () => if not(first_execution) { first_execution = true },
    16,
  )
  defer @js.clearInterval(timer)
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
