///|
pub suberror TimeoutError String

///|
pub fn TimeoutError::to_string(self : TimeoutError) -> String {
  let TimeoutError(msg) = self
  msg
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
      () => if not(completed.val) {
        timed_out.val = true
        reject(TimeoutError("Operation timed out after \{ms}ms"))
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
      () => if not(completed.val) {
        timed_out.val = true
        reject(TimeoutError("Operation timed out after \{timeout}ms"))
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
