///|
async test "timeout: completes before timeout" {
  let result = @test_utils.timeout(100, async fn() { 42 })
  inspect(result, content="42")
}

///|
async test "timeout: times out" {
  let result : Result[Int, @test_utils.TimeoutError] = try? @test_utils.timeout(
    10,
    () => {
      @core.sleep(100)
      42
    },
  )
  inspect(result is Err(_), content="true")
}

///|
async test "wait_for: completes before timeout" {
  let result = @test_utils.wait_for(timeout=100, fn(resolve) { resolve(42) })
  inspect(result, content="42")
}

///|
async test "wait_for: times out" {
  let result : Result[Int, @test_utils.TimeoutError] = try? @test_utils.wait_for(
    timeout=10,
    fn(_resolve) {
      // Never call resolve, should timeout
    },
  )
  inspect(result is Err(_), content="true")
}

///|
async test "wait_for: async callback with resolve" {
  let result = @test_utils.wait_for(timeout=100, fn(resolve) {
    // Simulate async operation using run_async
    @core.run_async(async fn() noraise {
      @core.sleep(5)
      resolve(100)
    })
  })
  inspect(result, content="100")
}

///|
async test "retry: succeeds on first attempt" {
  let mut attempts = 0
  @test_utils.retry(3, async fn() { attempts += 1 })
  inspect(attempts, content="1")
}

///|
async test "retry: succeeds after failures" {
  let mut attempts = 0
  @test_utils.retry(3, async fn() {
    attempts += 1
    if attempts < 3 {
      raise @test_utils.RetryError::new("Simulated failure")
    }
  })
  inspect(attempts, content="3")
}

///|
async test "retry: all attempts fail" {
  let result : Result[Unit, @test_utils.RetryError] = try? @test_utils.retry(
    3,
    async fn() { raise @test_utils.RetryError::new("Always fails") },
  )
  inspect(result is Err(_), content="true")
}

///|
async test "retry: with timeout per attempt" {
  let mut attempts = 0
  let result : Result[Unit, @test_utils.RetryError] = try? @test_utils.retry(
    2,
    async fn() {
      attempts += 1
      @core.sleep(100) // Will timeout
    },
    timeout=10,
  )
  inspect(result is Err(_), content="true")
  inspect(attempts, content="2")
}

///|
async test "retry: on_fail callback" {
  let failed_attempts : Array[Int] = []
  let result : Result[Unit, @test_utils.RetryError] = try? @test_utils.retry(
    3,
    async fn() { raise @test_utils.RetryError::new("Fail") },
    on_fail=fn(n) { failed_attempts.push(n) },
  )
  ignore(result)
  inspect(failed_attempts, content="[1, 2, 3]")
}

///|
async test "retry: on_success callback" {
  let mut success_called = false
  @test_utils.retry(3, async fn() { () }, on_success=fn() {
    success_called = true
  })
  inspect(success_called, content="true")
}

///|
async test "retry: cleanup callback on success" {
  let mut cleanup_called = false
  @test_utils.retry(3, async fn() { () }, cleanup=fn() { cleanup_called = true })
  inspect(cleanup_called, content="true")
}

///|
async test "retry: cleanup callback on failure" {
  let mut cleanup_called = false
  let result : Result[Unit, @test_utils.RetryError] = try? @test_utils.retry(
    2,
    async fn() { raise @test_utils.RetryError::new("Fail") },
    cleanup=fn() { cleanup_called = true },
  )
  ignore(result)
  inspect(cleanup_called, content="true")
}
