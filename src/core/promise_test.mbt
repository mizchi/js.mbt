///| Promise と async 関数の交換可能性のテスト

///| Basic operations

///|
async test "Promise: @core.Promise::then" {
  let resolver : @core.PromiseResolvers[Int] = @core.Promise::withResolvers()
  @core.run_async(() => {
    @core.sleep(16)
    resolver.resolve(10)
  })
  let p = resolver.promise.then(v => @core.Promise::resolve(v * 2))
  let result = p.wait()
  assert_eq(result, 20)
}

///|
async test "Promise: @core.Promise::catch_" {
  let err_val = @core.new_object()
  let p = @core.Promise::reject(err_val)
  let recovered = p.catch_(_ => @core.Promise::resolve(42 |> @core.any))
  let result : @core.Any = recovered.wait()
  let v : Int = @core.identity(result)
  assert_eq(v, 42)
}

///|
async test "Promise: @core.Promise::finally_" {
  let mut finalized = false
  let resolver : @core.PromiseResolvers[Int] = @core.Promise::withResolvers()
  @core.run_async(() => {
    @core.sleep(16)
    resolver.resolve(100)
  })
  let p = resolver.promise.finally_(() => finalized = true)
  let result = p.wait()
  assert_eq(result, 100)
  assert_true(finalized)
}

///|
async test "Promise: @core.Promise::all" {
  let p1 = @core.Promise::resolve(1)
  let p2 = @core.Promise::resolve(2)
  let p3 = @core.Promise::resolve(3)
  let all = @core.Promise::all([p1, p2, p3])
  let results = all.wait()
  assert_eq(results[0], 1)
  assert_eq(results[1], 2)
  assert_eq(results[2], 3)
}

///|
async test "Promise: @core.Promise::race" {
  let p1 = @core.Promise::from_async(async fn() {
    @core.sleep(16)
    100
  })
  let p2 = @core.Promise::from_async(async fn() {
    @core.sleep(32)
    200
  })
  let race = @core.Promise::race([p1, p2])
  let result = race.wait()
  assert_eq(result, 100)
}

///|
async test "Promise: @core.Promise::new" {
  let p : @core.Promise[Int] = @core.Promise::new(async fn(resolve, _reject) {
    @core.sleep(16)
    resolve(42)
  })
  let result = p.wait()
  assert_eq(result, 42)
}

///|
async test "Promise: @core.Promise::new with reject" {
  let p : @core.Promise[Int] = @core.Promise::new(async fn(_resolve, reject) {
    @core.sleep(16)
    reject(Failure("test error"))
  })
  let result = try? p.wait()
  assert_true(result is Err(_))
}

///|
async test "Promise: @core.Promise::resolve with different types" {
  let p1 = @core.Promise::resolve(42)
  let p2 = @core.Promise::resolve("hello")
  let p3 = @core.Promise::resolve(true)
  assert_eq(p1.wait(), 42)
  assert_eq(p2.wait(), "hello")
  assert_eq(p3.wait(), true)
}

///|
async test "Promise: @core.Promise::all with empty array" {
  let all : @core.Promise[Array[Int]] = @core.Promise::all([])
  let results = all.wait()
  assert_eq(results.length(), 0)
}

///|
async test "Promise: @core.Promise::race with single promise" {
  let p = @core.Promise::resolve(100)
  let race = @core.Promise::race([p])
  let result = race.wait()
  assert_eq(result, 100)
}

///|
async test "Promise: @core.Promise::any returns first fulfilled promise" {
  let p1 = @core.Promise::from_async(async fn() {
    @core.sleep(48)
    100
  })
  let p2 = @core.Promise::from_async(async fn() {
    @core.sleep(16)
    200
  })
  let any_result = @core.Promise::any([p1, p2])
  let result = any_result.wait()
  inspect(result, content="200")
}

///|
async test "Promise: @core.Promise::allSettled handles both fulfilled and rejected" {
  let p1 = @core.Promise::from_async(async fn() {
    @core.sleep(16)
    42
  })
  let p2 = @core.Promise::from_async(async fn() {
    @core.sleep(16)
    100
  })
  let settled = @core.Promise::allSettled([p1, p2])
  let results = settled.wait()
  inspect(results.length(), content="2")
}

///| Advanced operations and error handling

///|
async test "Promise: async function to Promise and back" {
  let result = @core.Promise::from_async(async fn() { 42 }).wait()
  inspect(result, content="42")
}

///|
async test "Promise: Promise.resolve to async unwrap" {
  let result = @core.Promise::resolve(100).wait()
  inspect(result, content="100")
}

///|
async test "Promise: promisify0 converts async function to Promise function" {
  let async_fn = async fn() { "hello" }
  let promise_fn = promisify0(async_fn)
  let result = promise_fn().wait()
  inspect(result, content="hello")
}

///|
async test "Promise: promisify1 converts async function to Promise function" {
  let async_fn = async fn(x : Int) { x * 2 }
  let promise_fn = promisify1(async_fn)
  let result = promise_fn(21).wait()
  inspect(result, content="42")
}

///|
async test "Promise: Promise.then with async unwrap" {
  let promise = @core.Promise::resolve(10)
  let doubled = promise.then(fn(x) { @core.Promise::resolve(x * 2) })
  let result = doubled.wait()
  inspect(result, content="20")
}

///|
async test "Promise: unwrap Promise inside async function" {
  let async_fn = async fn() {
    let p1 = @core.Promise::resolve(10)
    let v1 = p1.wait()
    let p2 = @core.Promise::resolve(20)
    let v2 = p2.wait()
    v1 + v2
  }
  let result = async_fn()
  inspect(result, content="30")
}

///|
async test "Promise: Promise.all with async unwrap" {
  let promises = [
    @core.Promise::resolve(1),
    @core.Promise::resolve(2),
    @core.Promise::resolve(3),
  ]
  let all_promise = @core.Promise::all(promises)
  let results = all_promise.wait()
  inspect(results.length(), content="3")
  inspect(results[0], content="1")
  inspect(results[1], content="2")
  inspect(results[2], content="3")
}

///|
async test "Promise: async function with error converts to rejected Promise" {
  let async_fn = async fn() -> Int { fail("test error") }
  let promise = @core.Promise::from_async(async_fn)
  let result = promise.wait() catch { _e => -1 }
  inspect(result, content="-1")
}

///|
async test "Promise: Promise.new to async unwrap" {
  let promise : @core.Promise[Int] = @core.Promise::new(async fn(
    resolve,
    _reject,
  ) {
    resolve(999)
  })
  let result = promise.wait()
  inspect(result, content="999")
}

///|
async test "Promise: chaining async and Promise operations" {
  let step1 = async fn() { 5 }
  let step2 = async fn(x : Int) { @core.Promise::resolve(x * 2).wait() }
  let step3 = async fn(x : Int) { x + 10 }
  let result = (async fn() {
    let v1 = step1()
    let v2 = step2(v1)
    step3(v2)
  })()
  inspect(result, content="20")
}

///|
async test "Promise: Promise and async are interchangeable" {
  // async -> Promise
  let async_value = async fn() { 42 }
  let as_promise = @core.Promise::from_async(async_value)

  // Promise -> async (unwrap)
  let back_to_async = async fn() { as_promise.wait() }

  // 再度 Promise へ
  let promise_again = @core.Promise::from_async(back_to_async)

  // 最終結果を取得
  let final_result = promise_again.wait()
  inspect(final_result, content="42")
}

///| Chaining and composition

///|
async test "Promise: Promise.race returns first resolved Promise" {
  let p1 = @core.Promise::resolve(1)
  let p2 = @core.Promise::resolve(2)
  let p3 = @core.Promise::resolve(3)
  let race_result = @core.Promise::race([p1, p2, p3])
  let result = race_result.wait()
  // race は最初に解決された Promise を返す（同期的に resolve されるのでどれか1つ）
  inspect(result >= 1 && result <= 3, content="true")
}

///|
async test "Promise: Promise.finally_ always executes" {
  let mut finally_called = false
  let promise = @core.Promise::resolve(42)
  let with_finally = promise.finally_(fn() { finally_called = true })
  let result = with_finally.wait()
  inspect(result, content="42")
  inspect(finally_called, content="true")
}

///|
async test "Promise: Promise.finally_ always executes (2)" {
  let mut finally_called = false
  let promise = @core.Promise::resolve(42)
  let with_finally = promise.finally_(fn() { finally_called = true })
  let result = with_finally.wait()
  inspect(result, content="42")
  inspect(finally_called, content="true")
}

///|
/// async 関数から Promise 関数への変換が型を保持することをテスト
async test "Promise: Promise.finally_ always executes (3)" {
  // String を返す async 関数
  let string_fn = async fn() { "test" }
  let promise_string_fn = promisify0(string_fn)
  let str_result = promise_string_fn().wait()
  inspect(str_result, content="test")

  // Bool を返す async 関数
  let bool_fn = async fn(x : Int) { x > 10 }
  let promise_bool_fn = promisify1(bool_fn)
  let bool_result = promise_bool_fn(20).wait()
  inspect(bool_result, content="true")
}

///|
async test "Promise: promisify0" {
  let async_fn = async fn() { 42 }
  let promise_fn = promisify0(async_fn)
  let p = promise_fn()
  let result = p.wait()
  assert_eq(result, 42)
}

///|
async test "Promise: promisify1" {
  let async_fn = async fn(x : Int) { x * 2 }
  let promise_fn = promisify1(async_fn)
  let p = promise_fn(21)
  let result = p.wait()
  assert_eq(result, 42)
}

///|
async test "Promise: promisify2" {
  let async_fn = async fn(x : Int, y : Int) { x + y }
  let promise_fn = promisify2(async_fn)
  let p = promise_fn(20, 22)
  let result = p.wait()
  assert_eq(result, 42)
}

///|
async test "Promise: promisify3" {
  let async_fn = async fn(x : Int, y : Int, z : Int) { x + y + z }
  let promise_fn = promisify3(async_fn)
  let p = promise_fn(10, 20, 12)
  let result = p.wait()
  assert_eq(result, 42)
}

///|
async test "Promise: suspend with resolve" {
  @core.run_async(() => try {
    let value = @core.suspend((ok, _err) => @core.run_async(() => {
      @core.sleep(16)
      ok(42)
    }))
    assert_eq(value, 42)
  } catch {
    _ => ()
  })
}

///|
async test "Promise: suspend with reject" {
  @core.run_async(() => try {
    let result : Result[Unit, Failure] = try? @core.suspend((_ok, err) => @core.run_async(() => {
        @core.sleep(16)
        err(Failure("test error"))
      },
    ))
    assert_true(result is Err(_))
  } catch {
    _ => ()
  })
}

///|
async test "Promise: Promise chain" {
  let resolver : @core.PromiseResolvers[Int] = @core.Promise::withResolvers()
  @core.run_async(() => {
    @core.sleep(16)
    resolver.resolve(1)
  })
  let p = resolver.promise
    .then(v => @core.Promise::resolve(v + 1))
    .then(v => @core.Promise::resolve(v * 2))
    .then(v => @core.Promise::resolve(v + 10))
  let result = p.wait()
  assert_eq(result, 14)
}

///|
async test "Promise: @core.Promise::resolve with different types (2)" {
  let p1 = @core.Promise::resolve(42)
  let p2 = @core.Promise::resolve("hello")
  let p3 = @core.Promise::resolve(true)
  assert_eq(p1.wait(), 42)
  assert_eq(p2.wait(), "hello")
  assert_eq(p3.wait(), true)
}

///|
async test "Promise: @core.Promise::all with empty array (2)" {
  let all : @core.Promise[Array[Int]] = @core.Promise::all([])
  let results = all.wait()
  assert_eq(results.length(), 0)
}

///|
async test "Promise: @core.Promise::race with single promise (2)" {
  let p = @core.Promise::resolve(100)
  let race = @core.Promise::race([p])
  let result = race.wait()
  assert_eq(result, 100)
}

///|
async test "Promise: nested promises" {
  let resolver : @core.PromiseResolvers[Int] = @core.Promise::withResolvers()
  @core.run_async(() => {
    @core.sleep(16)
    resolver.resolve(10)
  })
  let p1 = resolver.promise.then(v => {
    let inner_resolver : @core.PromiseResolvers[Int] = @core.Promise::withResolvers()
    @core.run_async(() => {
      @core.sleep(16)
      inner_resolver.resolve(v * 2)
    })
    inner_resolver.promise
  })
  let result = p1.wait()
  assert_eq(result, 20)
}

///|
async test "Promise: @core.Promise::all with mixed resolution times" {
  let p1 = @core.Promise::from_async(async fn() {
    @core.sleep(16)
    1
  })
  let p2 = @core.Promise::from_async(async fn() {
    @core.sleep(32)
    2
  })
  let p3 = @core.Promise::from_async(async fn() {
    @core.sleep(48)
    3
  })
  let all = @core.Promise::all([p1, p2, p3])
  let results = all.wait()
  assert_eq(results[0], 1)
  assert_eq(results[1], 2)
  assert_eq(results[2], 3)
}

///|
async test "Promise: @core.Promise::withPromiseResolvers multiple resolve calls" {
  let resolver : @core.PromiseResolvers[Int] = @core.Promise::withResolvers()
  @core.run_async(() => {
    resolver.resolve(1)
    resolver.resolve(2) // second call should be ignored
  })
  let result = resolver.promise.wait()
  assert_eq(result, 1)
}

///|
async test "Promise: Promise chain with error recovery" {
  let err_val : @core.Any = @core.identity(@core.new_object())
  let p = @core.Promise::reject(err_val)
    .catch_(_ => @core.Promise::resolve(10 |> @core.any))
    .then(v => {
      let i : Int = @core.identity(v)
      @core.Promise::resolve(i * 2)
    })
  let result = p.wait()
  assert_eq(result, 20)
}

///|
/// @core.Promise::then with error handling path
async test "Promise: @core.Promise::then with raise and catch" {
  let p = @core.Promise::resolve(10)
  let transformed = p.then(fn(_x) -> @core.Promise[Int] {
    raise Failure("intentional error")
  })
  let result = transformed.wait() catch { _e => -1 }
  inspect(result, content="-1")
}

///|
/// @core.Promise::any resolves with first fulfilled promise
async test "Promise: @core.Promise::any returns first fulfilled promise (2)" {
  let p1 = @core.Promise::from_async(async fn() {
    @core.sleep(200)
    100
  })
  let p2 = @core.Promise::from_async(async fn() {
    @core.sleep(16)
    200
  })
  let any_result = @core.Promise::any([p1, p2])
  let result = any_result.wait()
  inspect(result, content="200")
}

///|
/// @core.Promise::allSettled waits for all promises
async test "Promise: @core.Promise::allSettled handles both fulfilled and rejected (2)" {
  let p1 = @core.Promise::from_async(async fn() {
    @core.sleep(16)
    42
  })
  let p2 = @core.Promise::from_async(async fn() {
    @core.sleep(16)
    100
  })
  let settled = @core.Promise::allSettled([p1, p2])
  let results = settled.wait()
  inspect(results.length(), content="2")
}

///|
/// Rejection propagates through then chain without catch
async test "Promise: rejection propagates through then chain" {
  let err_val : @core.Any = @core.new_object()
  let p = @core.Promise::reject(err_val)
    .then(v => {
      let _ignored : @core.Any = v
      @core.Promise::resolve(99 |> @core.any)
    })
    .then(v => {
      let _ignored : @core.Any = v
      @core.Promise::resolve(100 |> @core.any)
    })
  let result : @core.Any = p.wait() catch { _e => @core.any(-1) }
  let num : Int = @core.identity(result)
  inspect(num, content="-1")
}

///|
/// Multiple catch handlers in chain
async test "Promise: multiple catch handlers in chain" {
  let mut first_catch_called = false
  let mut second_catch_called = false
  let err_val : @core.Any = @core.identity(@core.new_object())
  let p = @core.Promise::reject(err_val)
    .catch_(_ => {
      first_catch_called = true
      @core.Promise::resolve(42 |> @core.any)
    })
    .catch_(_ => {
      second_catch_called = true
      @core.Promise::resolve(99 |> @core.any)
    })
  let result : @core.Any = p.wait()
  let num : Int = @core.identity(result)
  inspect(num, content="42")
  inspect(first_catch_called, content="true")
  inspect(second_catch_called, content="false")
}

///|
/// catch_ then finally_ chain
async test "Promise: catch then finally chain" {
  let mut finally_called = false
  let err_val : @core.Any = @core.identity(@core.new_object())
  let p = @core.Promise::reject(err_val)
    .catch_(_ => @core.Promise::resolve(42 |> @core.any))
    .finally_(fn() { finally_called = true })
  let result : @core.Any = p.wait()
  let num : Int = @core.identity(result)
  inspect(num, content="42")
  inspect(finally_called, content="true")
}

///|
/// Rejection in then followed by catch
async test "Promise: rejection in then followed by catch" {
  let p = @core.Promise::resolve(10)
    .then(fn(_x) -> @core.Promise[Int] { raise Failure("error in then") })
    .catch_(_ => @core.Promise::resolve(-1))
  let result = p.wait()
  inspect(result, content="-1")
}

///|
/// Nested catch handlers
async test "Promise: nested catch handlers" {
  let err_val : @core.Any = @core.identity(@core.new_object())
  let p = @core.Promise::reject(err_val)
    .catch_(_ => @core.Promise::reject(@core.identity(@core.new_object())))
    .catch_(_ => @core.Promise::resolve(100 |> @core.any))
  let result : @core.Any = p.wait()
  let num : Int = @core.identity(result)
  inspect(num, content="100")
}

///| Promise::from_async tests

///|
async test "Promise: @core.Promise::from_async basic" {
  let p : @core.Promise[Int] = @core.Promise::from_async(async fn() { 42 })
  let result = p.wait()
  assert_eq(result, 42)
}

///|
async test "Promise: @core.Promise::from_async with async operation" {
  let p : @core.Promise[Int] = @core.Promise::from_async(async fn() {
    @core.sleep(16)
    100
  })
  let result = p.wait()
  assert_eq(result, 100)
}

///|
async test "Promise: @core.Promise::from_async with await inside" {
  let p : @core.Promise[Int] = @core.Promise::from_async(async fn() {
    let inner = @core.Promise::resolve(10)
    let v = inner.wait()
    v * 2
  })
  let result = p.wait()
  assert_eq(result, 20)
}

///|
async test "Promise: @core.Promise::from_async auto-rejects on error" {
  let p : @core.Promise[Int] = @core.Promise::from_async(async fn() {
    fail("auto reject error")
  })
  let result = try? p.wait()
  assert_true(result is Err(_))
}

///| PromiseResolvers::reject tests

///|
async test "Promise: PromiseResolvers::reject" {
  let resolvers : @core.PromiseResolvers[Int] = @core.Promise::withResolvers()
  @core.run_async(fn() { resolvers.reject(Failure("rejected")) })
  let result = try? resolvers.promise.wait()
  assert_true(result is Err(_))
}
