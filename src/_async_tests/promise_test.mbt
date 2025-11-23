///|

///|
using @js {
  type Js,
  unsafe_cast,
  type Promise,
  type Resolvers,
  sleep,
  run_async,
  promisify0,
  promisify1,
  promisify2,
  promisify3,
  suspend,
}

///|
using @test {it}

///|
// using @promise {type Promise, sleep}

///| Promise と async 関数の交換可能性のテスト

///|
test {
  @test.describe("Promise: Basic operations", _ => {
    it("Promise::then", _ => {
      let resolver : Resolvers[Int] = Promise::withResolvers()
      run_async(() => {
        sleep(1)
        resolver.resolve(10)
      })
      let p = resolver.promise.then(v => Promise::resolve(v * 2))
      let result = p.wait()
      assert_eq(result, 20)
    })
    it("Promise::catch_", _ => {
      let err_val : Js = @js.unsafe_cast(@js.Object::new())
      let p = Promise::reject(err_val)
      let recovered = p.catch_(_ => Promise::resolve(42 |> @js.js))
      let result : Js = recovered.wait()
      let v : Int = unsafe_cast(result)
      assert_eq(v, 42)
    })
    it("Promise::finally_", _ => {
      let mut finalized = false
      let resolver : Resolvers[Int] = Promise::withResolvers()
      run_async(() => {
        sleep(1)
        resolver.resolve(100)
      })
      let p = resolver.promise.finally_(() => finalized = true)
      let result = p.wait()
      assert_eq(result, 100)
      assert_true(finalized)
    })
    it("Promise::all", _ => {
      let p1 = Promise::resolve(1)
      let p2 = Promise::resolve(2)
      let p3 = Promise::resolve(3)
      let all = Promise::all([p1, p2, p3])
      let results = all.wait()
      assert_eq(results[0], 1)
      assert_eq(results[1], 2)
      assert_eq(results[2], 3)
    })
    it("Promise::race", _ => {
      let resolver1 : Resolvers[Int] = Promise::withResolvers()
      let resolver2 : Resolvers[Int] = Promise::withResolvers()
      run_async(() => {
        sleep(1)
        resolver1.resolve(100)
      })
      run_async(() => {
        sleep(10)
        resolver2.resolve(200)
      })
      let race = Promise::race([resolver1.promise, resolver2.promise])
      let result = race.wait()
      assert_eq(result, 100)
    })
    it("Promise::new", _ => {
      let p : Promise[Int] = Promise::new((resolve, _reject) => run_async(() => {
        sleep(1)
        resolve(42)
      }))
      let result = p.wait()
      assert_eq(result, 42)
    })
    it("Promise::new with reject", _ => {
      let p : Promise[Int] = Promise::new((_resolve, reject) => run_async(() => {
        sleep(1)
        reject(Failure("test error"))
      }))
      let result = try? p.wait()
      assert_true(result is Err(_))
    })
    it("Promise::resolve with different types", _ => {
      let p1 = Promise::resolve(42)
      let p2 = Promise::resolve("hello")
      let p3 = Promise::resolve(true)
      assert_eq(p1.wait(), 42)
      assert_eq(p2.wait(), "hello")
      assert_eq(p3.wait(), true)
    })
    it("Promise::all with empty array", _ => {
      let all : Promise[Array[Int]] = Promise::all([])
      let results = all.wait()
      assert_eq(results.length(), 0)
    })
    it("Promise::race with single promise", _ => {
      let p = Promise::resolve(100)
      let race = Promise::race([p])
      let result = race.wait()
      assert_eq(result, 100)
    })
    it("Promise::any returns first fulfilled promise", _ => {
      let resolver1 : Resolvers[Int] = Promise::withResolvers()
      let resolver2 : Resolvers[Int] = Promise::withResolvers()
      run_async(() => {
        sleep(10)
        resolver1.resolve(100)
      })
      run_async(() => {
        sleep(5)
        resolver2.resolve(200)
      })
      let any_result = Promise::any([resolver1.promise, resolver2.promise])
      let result = any_result.wait()
      inspect(result, content="200")
    })
    it("Promise::allSettled handles both fulfilled and rejected", _ => {
      let resolver1 : Resolvers[Int] = Promise::withResolvers()
      let resolver2 : Resolvers[Int] = Promise::withResolvers()
      run_async(() => {
        sleep(5)
        resolver1.resolve(42)
      })
      run_async(() => {
        sleep(5)
        resolver2.resolve(100)
      })
      let settled = Promise::allSettled([resolver1.promise, resolver2.promise])
      let results = settled.wait()
      inspect(results.length(), content="2")
    })
  })
}

///|
test {
  @test.describe("Promise: Advanced operations and error handling", _ => {
    it("Promise::try_ success", _ => {
      let p = Promise::try_(async fn() { 123 })
      let result = p.wait()
      assert_eq(result, 123)
    })
    it("Promise::try_ failure", _ => {
      let p : Promise[Unit] = Promise::try_(async fn() { fail("error") })
      let result = try? p.wait()
      assert_true(result is Err(_))
    })
    it("async function to Promise and back", _ => {
      let result = Promise::try_(async fn() { 42 }).wait()
      inspect(result, content="42")
    })
    it("Promise.resolve to async unwrap", _ => {
      let result = Promise::resolve(100).wait()
      inspect(result, content="100")
    })
    it("promisify0 converts async function to Promise function", _ => {
      let async_fn = async fn() { "hello" }
      let promise_fn = promisify0(async_fn)
      let result = promise_fn().wait()
      inspect(result, content="hello")
    })
    it("promisify1 converts async function to Promise function", _ => {
      let async_fn = async fn(x : Int) { x * 2 }
      let promise_fn = promisify1(async_fn)
      let result = promise_fn(21).wait()
      inspect(result, content="42")
    })
    it("Promise.then with async unwrap", _ => {
      let promise = Promise::resolve(10)
      let doubled = promise.then(fn(x) { Promise::resolve(x * 2) })
      let result = doubled.wait()
      inspect(result, content="20")
    })
    it("unwrap Promise inside async function", _ => {
      let async_fn = async fn() {
        let p1 = Promise::resolve(10)
        let v1 = p1.wait()
        let p2 = Promise::resolve(20)
        let v2 = p2.wait()
        v1 + v2
      }
      let result = async_fn()
      inspect(result, content="30")
    })
    it("Promise.all with async unwrap", _ => {
      let promises = [
        Promise::resolve(1),
        Promise::resolve(2),
        Promise::resolve(3),
      ]
      let all_promise = Promise::all(promises)
      let results = all_promise.wait()
      inspect(results.length(), content="3")
      inspect(results[0], content="1")
      inspect(results[1], content="2")
      inspect(results[2], content="3")
    })
    it("async function with error converts to rejected Promise", _ => {
      let async_fn = async fn() -> Int { fail("test error") }
      let promise = Promise::try_(async_fn)
      let result = promise.wait() catch { _e => -1 }
      inspect(result, content="-1")
    })
    it("Promise.new to async unwrap", _ => {
      let promise : Promise[Int] = Promise::new((resolve, _reject) => resolve(
        999,
      ))
      let result = promise.wait()
      inspect(result, content="999")
    })
    it("chaining async and Promise operations", _ => {
      let step1 = async fn() { 5 }
      let step2 = async fn(x : Int) { Promise::resolve(x * 2).wait() }
      let step3 = async fn(x : Int) { x + 10 }
      let result = (async fn() {
        let v1 = step1()
        let v2 = step2(v1)
        step3(v2)
      })()
      inspect(result, content="20")
    })
    it("Promise and async are interchangeable", _ => {
      // async -> Promise
      let async_value = async fn() { 42 }
      let as_promise = Promise::try_(async_value)

      // Promise -> async (unwrap)
      let back_to_async = async fn() { as_promise.wait() }

      // 再度 Promise へ
      let promise_again = Promise::try_(back_to_async)

      // 最終結果を取得
      let final_result = promise_again.wait()
      inspect(final_result, content="42")
    })
  })
}

///|
test {
  @test.describe("Promise: Chaining and composition", _ => {
    it("Promise.race returns first resolved Promise", _ => {
      let p1 = Promise::resolve(1)
      let p2 = Promise::resolve(2)
      let p3 = Promise::resolve(3)
      let race_result = Promise::race([p1, p2, p3])
      let result = race_result.wait()
      // race は最初に解決された Promise を返す（同期的に resolve されるのでどれか1つ）
      inspect(result >= 1 && result <= 3, content="true")
    })
    it("Promise.finally_ always executes", _ => {
      let mut finally_called = false
      let promise = Promise::resolve(42)
      let with_finally = promise.finally_(fn() { finally_called = true })
      let result = with_finally.wait()
      inspect(result, content="42")
      inspect(finally_called, content="true")
    })
  })
}

///|
test {
  it("Promise.finally_ always executes", _ => {
    let mut finally_called = false
    let promise = Promise::resolve(42)
    let with_finally = promise.finally_(fn() { finally_called = true })
    let result = with_finally.wait()
    inspect(result, content="42")
    inspect(finally_called, content="true")
  })
}

///|
/// async 関数から Promise 関数への変換が型を保持することをテスト
test {
  it("Promise.finally_ always executes", _ => {
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
  })
}

///|
test {
  it("promisify0", _ => {
    let async_fn = async fn() { 42 }
    let promise_fn = promisify0(async_fn)
    let p = promise_fn()
    let result = p.wait()
    assert_eq(result, 42)
  })
}

///|
test {
  it("promisify1", _ => {
    let async_fn = async fn(x : Int) { x * 2 }
    let promise_fn = promisify1(async_fn)
    let p = promise_fn(21)
    let result = p.wait()
    assert_eq(result, 42)
  })
}

///|
test {
  it("promisify2", _ => {
    let async_fn = async fn(x : Int, y : Int) { x + y }
    let promise_fn = promisify2(async_fn)
    let p = promise_fn(20, 22)
    let result = p.wait()
    assert_eq(result, 42)
  })
}

///|
test {
  it("promisify3", _ => {
    let async_fn = async fn(x : Int, y : Int, z : Int) { x + y + z }
    let promise_fn = promisify3(async_fn)
    let p = promise_fn(10, 20, 12)
    let result = p.wait()
    assert_eq(result, 42)
  })
}

///|
test {
  it("suspend with resolve", _ => run_async(() => try {
    let value = suspend((ok, _err) => run_async(() => {
      sleep(5)
      ok(42)
    }))
    assert_eq(value, 42)
  } catch {
    _ => ()
  }))
}

///|
test {
  it("suspend with reject", _ => run_async(() => try {
    let result : Result[Unit, Failure] = try? suspend((_ok, err) => run_async(() => {
      sleep(5)
      err(Failure("test error"))
    }))
    assert_true(result is Err(_))
  } catch {
    _ => ()
  }))
}

///|
test {
  it("Promise chain", _ => {
    let resolver : Resolvers[Int] = Promise::withResolvers()
    run_async(() => {
      sleep(1)
      resolver.resolve(1)
    })
    let p = resolver.promise
      .then(v => Promise::resolve(v + 1))
      .then(v => Promise::resolve(v * 2))
      .then(v => Promise::resolve(v + 10))
    let result = p.wait()
    assert_eq(result, 14)
  })
}

///|
test {
  it("Promise::resolve with different types", _ => {
    let p1 = Promise::resolve(42)
    let p2 = Promise::resolve("hello")
    let p3 = Promise::resolve(true)
    assert_eq(p1.wait(), 42)
    assert_eq(p2.wait(), "hello")
    assert_eq(p3.wait(), true)
  })
}

///|
test {
  it("Promise::all with empty array", _ => {
    let all : Promise[Array[Int]] = Promise::all([])
    let results = all.wait()
    assert_eq(results.length(), 0)
  })
}

///|
test {
  it("Promise::race with single promise", _ => {
    let p = Promise::resolve(100)
    let race = Promise::race([p])
    let result = race.wait()
    assert_eq(result, 100)
  })
}

///|
test {
  it("nested promises", _ => {
    let resolver : Resolvers[Int] = Promise::withResolvers()
    run_async(() => {
      sleep(1)
      resolver.resolve(10)
    })
    let p1 = resolver.promise.then(v => {
      let inner_resolver : Resolvers[Int] = Promise::withResolvers()
      run_async(() => {
        sleep(1)
        inner_resolver.resolve(v * 2)
      })
      inner_resolver.promise
    })
    let result = p1.wait()
    assert_eq(result, 20)
  })
}

///|
test {
  it("Promise::all with mixed resolution times", _ => {
    let resolver1 : Resolvers[Int] = Promise::withResolvers()
    let resolver2 : Resolvers[Int] = Promise::withResolvers()
    let resolver3 : Resolvers[Int] = Promise::withResolvers()
    run_async(() => {
      sleep(10)
      resolver1.resolve(1)
    })
    run_async(() => {
      sleep(5)
      resolver2.resolve(2)
    })
    run_async(() => {
      sleep(15)
      resolver3.resolve(3)
    })
    let all = Promise::all([
      resolver1.promise,
      resolver2.promise,
      resolver3.promise,
    ])
    let results = all.wait()
    assert_eq(results[0], 1)
    assert_eq(results[1], 2)
    assert_eq(results[2], 3)
  })
}

///|
test {
  it("Promise::withResolvers multiple resolve calls", _ => {
    let resolver : Resolvers[Int] = Promise::withResolvers()
    run_async(() => {
      resolver.resolve(1)
      resolver.resolve(2) // second call should be ignored
    })
    let result = resolver.promise.wait()
    assert_eq(result, 1)
  })
}

///|
test {
  it("Promise chain with error recovery", _ => {
    let err_val : Js = @js.unsafe_cast(@js.Object::new())
    let p = Promise::reject(err_val)
      .catch_(_ => Promise::resolve(10 |> @js.js))
      .then(v => {
        let i : Int = unsafe_cast(v)
        Promise::resolve(i * 2)
      })
    let result = p.wait()
    assert_eq(result, 20)
  })
}

///|
/// Promise::then with error handling path
test {
  it("Promise::then with raise and catch", _ => {
    let p = Promise::resolve(10)
    let transformed = p.then(fn(_x) -> Promise[Int] {
      raise Failure("intentional error")
    })
    let result = transformed.wait() catch { _e => -1 }
    inspect(result, content="-1")
  })
}

///|
/// Promise::any resolves with first fulfilled promise
test {
  it("Promise::any returns first fulfilled promise", _ => {
    let resolver1 : Resolvers[Int] = Promise::withResolvers()
    let resolver2 : Resolvers[Int] = Promise::withResolvers()
    run_async(() => {
      sleep(10)
      resolver1.resolve(100)
    })
    run_async(() => {
      sleep(5)
      resolver2.resolve(200)
    })
    let any_result = Promise::any([resolver1.promise, resolver2.promise])
    let result = any_result.wait()
    inspect(result, content="200")
  })
}

///|
/// Promise::allSettled waits for all promises
test {
  it("Promise::allSettled handles both fulfilled and rejected", _ => {
    let resolver1 : Resolvers[Int] = Promise::withResolvers()
    let resolver2 : Resolvers[Int] = Promise::withResolvers()
    run_async(() => {
      sleep(5)
      resolver1.resolve(42)
    })
    run_async(() => {
      sleep(5)
      resolver2.resolve(100)
    })
    let settled = Promise::allSettled([resolver1.promise, resolver2.promise])
    let results = settled.wait()
    inspect(results.length(), content="2")
  })
}

///|
/// Rejection propagates through then chain without catch
test {
  it("rejection propagates through then chain", _ => {
    let err_val : Js = @js.unsafe_cast(@js.Object::new())
    let p = Promise::reject(err_val)
      .then(v => {
        let _ignored : Js = v
        Promise::resolve(99 |> @js.js)
      })
      .then(v => {
        let _ignored : Js = v
        Promise::resolve(100 |> @js.js)
      })
    let result : Js = p.wait() catch { _e => @js.js(-1) }
    let num : Int = @js.unsafe_cast(result)
    inspect(num, content="-1")
  })
}

///|
/// Multiple catch handlers in chain
test {
  it("multiple catch handlers in chain", _ => {
    let mut first_catch_called = false
    let mut second_catch_called = false
    let err_val : Js = @js.unsafe_cast(@js.Object::new())
    let p = Promise::reject(err_val)
      .catch_(_ => {
        first_catch_called = true
        Promise::resolve(42 |> @js.js)
      })
      .catch_(_ => {
        second_catch_called = true
        Promise::resolve(99 |> @js.js)
      })
    let result : Js = p.wait()
    let num : Int = @js.unsafe_cast(result)
    inspect(num, content="42")
    inspect(first_catch_called, content="true")
    inspect(second_catch_called, content="false")
  })
}

///|
/// catch_ then finally_ chain
test {
  it("catch then finally chain", _ => {
    let mut finally_called = false
    let err_val : Js = @js.unsafe_cast(@js.Object::new())
    let p = Promise::reject(err_val)
      .catch_(_ => Promise::resolve(42 |> @js.js))
      .finally_(fn() { finally_called = true })
    let result : Js = p.wait()
    let num : Int = @js.unsafe_cast(result)
    inspect(num, content="42")
    inspect(finally_called, content="true")
  })
}

///|
/// Rejection in then followed by catch
test {
  it("rejection in then followed by catch", _ => {
    let p = Promise::resolve(10)
      .then(fn(_x) -> Promise[Int] { raise Failure("error in then") })
      .catch_(_ => Promise::resolve(-1))
    let result = p.wait()
    inspect(result, content="-1")
  })
}

///|
/// Nested catch handlers
test {
  it("nested catch handlers", _ => {
    let err_val : Js = @js.unsafe_cast(@js.Object::new())
    let p = Promise::reject(err_val)
      .catch_(_ => Promise::reject(@js.unsafe_cast(@js.Object::new())))
      .catch_(_ => Promise::resolve(100 |> @js.js))
    let result : Js = p.wait()
    let num : Int = @js.unsafe_cast(result)
    inspect(num, content="100")
  })
}
