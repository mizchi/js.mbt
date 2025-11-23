///|
test {
  @test.describe("JS Async: Timer operations", _ => {
    @test.it("setTimeout", _ => {
      let mut executed = false
      let _timer = @js.setTimeout(() => executed = true, 10)
      @js.sleep(20)
      assert_true(executed)
    })
    @test.it("clearTimeout", _ => {
      let mut executed = false
      let timer = @js.setTimeout(() => executed = true, 10)
      @js.clearTimeout(timer)
      @js.sleep(20)
      assert_false(executed)
    })
    @test.it("setTimeout with zero delay", _ => {
      let mut executed = false
      let _ = @js.setTimeout(() => executed = true, 0)
      @js.sleep(1)
      assert_true(executed)
    })
    @test.it("multiple setTimeouts", _ => {
      let order = []
      let _ = @js.setTimeout(() => order.push(1), 10)
      let _ = @js.setTimeout(() => order.push(2), 5)
      let _ = @js.setTimeout(() => order.push(3), 15)
      @js.sleep(25)
      assert_eq(order.length(), 3)
      assert_eq(order[0], 2) // 5ms
      assert_eq(order[1], 1) // 10ms
      assert_eq(order[2], 3) // 15ms
    })
    @test.it("setInterval immediate execution", _ => {
      let mut first_execution = false
      let timer = @js.setInterval(
        () => if not(first_execution) { first_execution = true },
        5,
      )
      @js.sleep(10)
      @js.clearInterval(timer)
      assert_true(first_execution)
    })
    @test.it("sleep with very short duration", _ => {
      @js.sleep(1)
      // Just verify sleep completes without error
      assert_true(true)
    })
  })
}

///|
test {
  @test.describe("JS Async: Async operations", _ => {
    @test.it("sleep multiple times", _ => {
      let mut count = 0
      @js.sleep(5)
      count += 1
      @js.sleep(5)
      count += 1
      @js.sleep(5)
      count += 1
      assert_eq(count, 3)
    })
    @test.it("nested run_async", _ => {
      let mut outer = false
      let mut inner = false
      @js.run_async(() => {
        @js.sleep(5)
        outer = true
        @js.run_async(() => {
          @js.sleep(5)
          inner = true
        })
      })
      @js.sleep(20)
      assert_true(outer)
      assert_true(inner)
    })
    @test.it("run_async with multiple sleep calls", _ => {
      let checkpoints = []
      @js.run_async(() => {
        checkpoints.push(1)
        @js.sleep(5)
        checkpoints.push(2)
        @js.sleep(5)
        checkpoints.push(3)
      })
      @js.sleep(32)
      assert_eq(checkpoints.length(), 3)
      assert_eq(checkpoints[0], 1)
      assert_eq(checkpoints[1], 2)
      assert_eq(checkpoints[2], 3)
    })
  })
}

///|
test {
  @test.describe("JS Async: EventEmitter", _ => it(
    "EventEmitter listenerCount for non-existent event",
    _ => {
      let emitter = @events.EventEmitter::new()
      assert_eq(emitter.listenerCount("nonexistent"), 0)
    },
  ))
}
