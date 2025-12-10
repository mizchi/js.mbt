# test_utils

Test utilities for async testing with timeout support.

## Usage

### `timeout` - Wrap async functions with timeout

Use for async functions that may hang:

```moonbit
let result = @test_utils.timeout(100, async fn() { 42 })
```

### `wait_for` - Callback-based timeout

Use for callback-based APIs where exceptions can interrupt processing:

```moonbit
let result = @test_utils.wait_for(timeout=100, fn(resolve) {
  // resolve is called when the operation completes
  some_callback_api(callback=fn(value) { resolve(value) })
})
```

This is useful for testing code paths that are prone to exceptions, where `@core.suspend` alone might leave tests hanging if an error occurs before `resolve` is called.

## TimeoutError

Both functions raise `TimeoutError` if the operation doesn't complete within the specified time:

```moonbit
let result : Result[Int, @test_utils.TimeoutError] = try? @test_utils.wait_for(
  timeout=10,
  fn(_resolve) {
    // Never resolves - will timeout
  },
)
// result is Err(TimeoutError("Operation timed out after 10ms"))
```
