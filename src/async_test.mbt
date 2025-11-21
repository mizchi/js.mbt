///|
/// Test that promisify0 creates a Promise
test "promisify0 creates a Promise" {
  async fn test_fn0() -> Int {
    42
  }

  let promise_fn = promisify0(test_fn0)
  let promise = promise_fn()
  // Verify that a Promise was created by checking if it's a JS object
  let js_val : Js = unsafe_cast(promise)
  inspect(typeof_(js_val), content="object")
}

///|
/// Test that promisify1 creates a Promise
test "promisify1 creates a Promise" {
  async fn test_fn1(x : Int) -> Int {
    x * 2
  }

  let promise_fn = promisify1(test_fn1)
  let promise = promise_fn(21)
  let js_val : Js = unsafe_cast(promise)
  inspect(typeof_(js_val), content="object")
}

///|
/// Test that promisify2 creates a Promise
test "promisify2 creates a Promise" {
  async fn test_fn2(x : Int, y : Int) -> Int {
    x + y
  }

  let promise_fn = promisify2(test_fn2)
  let promise = promise_fn(10, 32)
  let js_val : Js = unsafe_cast(promise)
  inspect(typeof_(js_val), content="object")
}

///|
/// Test that promisify3 creates a Promise
test "promisify3 creates a Promise" {
  async fn test_fn3(x : Int, y : Int, z : Int) -> Int {
    x + y + z
  }

  let promise_fn = promisify3(test_fn3)
  let promise = promise_fn(10, 20, 12)
  let js_val : Js = unsafe_cast(promise)
  inspect(typeof_(js_val), content="object")
}
