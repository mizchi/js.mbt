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

### `retry` - Retry async functions with timeout

Use for flaky operations that may fail intermittently:

```moonbit
// Basic retry
@test_utils.retry(3, async fn() {
  // Operation that may fail
})

// With timeout per attempt
@test_utils.retry(3, async fn() {
  // Operation that may hang
}, timeout=100)

// With callbacks
@test_utils.retry(
  3,
  async fn() { /* ... */ },
  on_fail=fn(attempt) { println("Attempt \{attempt} failed") },
  on_success=fn() { println("Success!") },
  cleanup=fn() { println("Done (always called)") },
)
```

Parameters:
- `n`: Maximum number of retry attempts
- `f`: The async function to retry
- `timeout?`: Optional timeout per attempt in milliseconds
- `total_timeout?`: Optional total timeout for all attempts in milliseconds
- `on_fail?`: Called on each failure with attempt number
- `on_success?`: Called on success
- `cleanup?`: Called after all attempts (always, whether success or failure)

Raises `RetryError` if all attempts fail (exception or timeout).

## jsdom

For browser testing, use `global_jsdom_register()` to set up a global jsdom environment:

```moonbit
@test_utils.global_jsdom_register()
```
