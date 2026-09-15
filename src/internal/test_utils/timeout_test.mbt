///|
async test "timeout: completes before timeout" {
  let result = @test_utils.timeout(100, () => 42)
  inspect(result, content="42")
}

///|
async test "timeout: times out" {
  try
    @test_utils.timeout(10, () => {
      @core.sleep(100)
      42
    })
  catch {
    _ => ()
  } noraise {
    _ => fail("expected timeout to raise")
  }
}

///|
async test "wait_for: completes before timeout" {
  let result = @test_utils.wait_for(timeout=100, fn(resolve) { resolve(42) })
  inspect(result, content="42")
}

///|
async test "wait_for: times out" {
  try
    @test_utils.wait_for(timeout=10, fn(_resolve : (Int) -> Unit) {
      // Never call resolve, should timeout
    })
  catch {
    _ => ()
  } noraise {
    _ => fail("expected wait_for to raise")
  }
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
  @test_utils.retry(3, () => attempts += 1)
  inspect(attempts, content="1")
}

///|
async test "retry: succeeds after failures" {
  let mut attempts = 0
  @test_utils.retry(3, () => {
    attempts += 1
    if attempts < 3 {
      raise @test_utils.RetryError::new("Simulated failure")
    }
  })
  inspect(attempts, content="3")
}

///|
async test "retry: all attempts fail" {
  try
    @test_utils.retry(3, () => raise @test_utils.RetryError::new("Always fails"))
  catch {
    _ => ()
  } noraise {
    _ => fail("expected retry to raise")
  }
}

///|
async test "retry: with timeout per attempt" {
  let mut attempts = 0
  try
    @test_utils.retry(
      2,
      async fn() {
        attempts += 1
        @core.sleep(100) // Will timeout
      },
      timeout=10,
    )
  catch {
    _ => ()
  } noraise {
    _ => fail("expected retry to raise")
  }
  inspect(attempts, content="2")
}

///|
async test "retry: on_fail callback" {
  let failed_attempts : Array[Int] = []
  try
    @test_utils.retry(3, () => raise @test_utils.RetryError::new("Fail"), on_fail=fn(
      n,
    ) {
      failed_attempts.push(n)
    })
  catch {
    _ => ()
  } noraise {
    _ => fail("expected retry to raise")
  }
  debug_inspect(failed_attempts, content="[1, 2, 3]")
}

///|
async test "retry: on_success callback" {
  let mut success_called = false
  @test_utils.retry(3, () => (), on_success=fn() { success_called = true })
  inspect(success_called, content="true")
}

///|
async test "retry: cleanup callback on success" {
  let mut cleanup_called = false
  @test_utils.retry(3, () => (), cleanup=fn() { cleanup_called = true })
  inspect(cleanup_called, content="true")
}

///|
async test "retry: cleanup callback on failure" {
  let mut cleanup_called = false
  try
    @test_utils.retry(2, () => raise @test_utils.RetryError::new("Fail"), cleanup=fn() {
      cleanup_called = true
    })
  catch {
    _ => ()
  } noraise {
    _ => fail("expected retry to raise")
  }
  inspect(cleanup_called, content="true")
}
