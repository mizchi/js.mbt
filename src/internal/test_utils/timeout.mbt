///|
pub suberror TimeoutError {
  TimeoutError(String)
}

///|
pub suberror RetryError {
  RetryError(String)
}

///|
pub fn TimeoutError::to_string(self : TimeoutError) -> String {
  let TimeoutError(msg) = self
  msg
}

///|
pub fn RetryError::to_string(self : RetryError) -> String {
  let RetryError(msg) = self
  msg
}

///|
/// Create a RetryError (for testing purposes)
pub fn RetryError::new(msg : String) -> RetryError {
  RetryError(msg)
}

///|
extern "js" fn ffi_set_timeout(f : () -> Unit, ms : Int) -> Int =
  #| (f, ms) => setTimeout(f, ms)

///|
extern "js" fn ffi_clear_timeout(id : Int) -> Unit =
  #| (id) => clearTimeout(id)

///|
pub async fn[T] timeout(ms : Int, f : async () -> T) -> T raise TimeoutError {
  let result : Ref[T?] = { val: None }
  let timed_out : Ref[Bool] = { val: false }
  let completed : Ref[Bool] = { val: false }

  // Race between timeout and the async function
  @core.suspend(fn(resolve, reject) {
    // Set up timeout
    let timeout_id = ffi_set_timeout(
      () => {
        if not(completed.val) {
          timed_out.val = true
          reject(TimeoutError("Operation timed out after \{ms}ms"))
        }
      },
      ms,
    )

    // Run the async function
    @core.run_async(async fn() noraise {
      try {
        let r = f()
        if not(timed_out.val) {
          completed.val = true
          ffi_clear_timeout(timeout_id)
          result.val = Some(r)
          resolve(())
        }
      } catch {
        _ => ()
      }
    })
  })
  match result.val {
    Some(r) => r
    None => raise TimeoutError("Operation timed out after \{ms}ms")
  }
}

///|
pub async fn[T] wait_for(
  timeout~ : Int,
  f : ((T) -> Unit) -> Unit,
) -> T raise TimeoutError {
  let result : Ref[T?] = { val: None }
  let timed_out : Ref[Bool] = { val: false }
  let completed : Ref[Bool] = { val: false }
  @core.suspend(fn(resolve, reject) {
    // Set up timeout
    let timeout_id = ffi_set_timeout(
      () => {
        if not(completed.val) {
          timed_out.val = true
          reject(TimeoutError("Operation timed out after \{timeout}ms"))
        }
      },
      timeout,
    )

    // Create resolve callback for user
    let user_resolve = fn(value : T) {
      if not(timed_out.val) {
        completed.val = true
        ffi_clear_timeout(timeout_id)
        result.val = Some(value)
        resolve(())
      }
    }

    // Call user function with resolve callback
    f(user_resolve)
  })
  match result.val {
    Some(r) => r
    None => raise TimeoutError("Operation timed out after \{timeout}ms")
  }
}

///|
/// Retry an async function up to `n` times until it succeeds.
///
/// Parameters:
/// - `n`: Maximum number of retry attempts
/// - `f`: The async function to retry
/// - `timeout`: Optional timeout per attempt in milliseconds
/// - `total_timeout`: Optional total timeout for all attempts in milliseconds
/// - `on_fail`: Optional callback called on each failure with attempt number
/// - `on_success`: Optional callback called on success
/// - `cleanup`: Optional callback called after all attempts (always, success or failure)
///
/// Raises `RetryError` if all attempts fail.
pub async fn retry(
  n : Int,
  f : async () -> Unit,
  timeout? : Int,
  total_timeout? : Int,
  on_fail? : (Int) -> Unit,
  on_success? : () -> Unit,
  cleanup? : () -> Unit,
) -> Unit raise RetryError {
  let start_time = ffi_now()
  let mut last_error : String = "Unknown error"
  for attempt = 1; attempt <= n; attempt = attempt + 1 {
    // Check total timeout
    if total_timeout is Some(total_ms) {
      let elapsed = ffi_now() - start_time
      if elapsed >= total_ms.to_double() {
        if cleanup is Some(cb) {
          cb()
        }
        raise RetryError(
          "Total timeout exceeded after \{attempt - 1} attempts (\{total_ms}ms)",
        )
      }
    }

    // Try to run f with optional timeout
    let success = match timeout {
      Some(ms) => {
        let result : Result[Unit, TimeoutError] = try? run_with_timeout(ms, f)
        match result {
          Ok(_) => true
          Err(e) => {
            last_error = e.to_string()
            false
          }
        }
      }
      None => {
        let result : Result[Unit, Error] = try? f()
        match result {
          Ok(_) => true
          Err(e) => {
            last_error = e.to_string()
            false
          }
        }
      }
    }
    if success {
      if on_success is Some(cb) {
        cb()
      }
      if cleanup is Some(cb) {
        cb()
      }
      return
    }

    // Call on_fail callback
    if on_fail is Some(cb) {
      cb(attempt)
    }
  }

  // All attempts failed
  if cleanup is Some(cb) {
    cb()
  }
  raise RetryError("All \{n} retry attempts failed. Last error: \{last_error}")
}

///|
extern "js" fn ffi_now() -> Double =
  #| () => Date.now()

///|
/// Internal helper to avoid name collision with `timeout` parameter
async fn run_with_timeout(
  ms : Int,
  f : async () -> Unit,
) -> Unit raise TimeoutError {
  timeout(ms, f)
}
