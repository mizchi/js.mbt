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
