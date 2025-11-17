///|
using @js {type Val, trait Js, js, unsafe_cast, safe_js}

///|
using @promise {sleep, run_async}

///|
using @test {it, beforeEach}

///|
fn main {
  beforeEach(() => println("before each test"))
  it("sample test", fn(_) { assert_true(true) })
  it("sample test", fn(_) { assert_true(false) })
  // beforeEach(() => @promise.sleep(1))
  it("simple test", _ => assert_eq(2 + 2, 4))
  it("lazy test", _ => {
    @promise.sleep(100)
    assert_eq(2 + 2, 4)
  })
  it("skip test", skip="skip this test", _ => assert_eq(2 + 2, 5))
  it("todo test", ctx => ctx.todo("this test is todo"))
}

///|
test {
  it("Promise::withResolvers resolve", _ => {
    let resolver : @promise.Resolvers[Int] = @promise.Promise::withResolvers()
    run_async(() => {
      sleep(0)
      resolver.resolve(42)
    })
    let v = resolver.promise.unwrap()
    assert_eq(v, 42)
  })
}

///|
test {
  it("Promise::withResolvers reject", _ => {
    let resolver : @promise.Resolvers[Int] = @promise.Promise::withResolvers()
    run_async(() => {
      sleep(1)
      resolver.reject(Failure("error occurred"))
    })
    let v = try? resolver.promise.unwrap()
    assert_true(v is Err(Failure("error occurred")))
  })
}

///|
test {
  it("EventEmitter on/emit/off", _ => {
    let emitter = @events.EventEmitter::new()
    let mut received = 0
    let callback = (_data : Val) => run_async(() => {
      sleep(1)
      let v : Int = unsafe_cast(_data)
      received += v
    })
    emitter.on("vvv", callback)
    emitter.emit("vvv", 1 |> @js.safe_js)
    emitter.emit("vvv", 2 |> @js.safe_js)
    emitter.emit("vvv", 3 |> @js.safe_js)
    sleep(16)
    assert_eq(received, 6)
    assert_eq(emitter.listenerCount("vvv"), 1)

    // off and emit again
    emitter.off("vvv", callback)
    assert_eq(emitter.listenerCount("vvv"), 0)
    emitter.emit("vvv", () |> @js.safe_js)
    sleep(16)
    // not called
    assert_eq(received, 6)
    emitter.on("aaa", callback)
    emitter.on("bbb", callback)
    assert_eq(emitter.listenerCount("aaa"), 1)
    assert_eq(emitter.listenerCount("bbb"), 1)
    emitter.removeAllListeners()
    assert_eq(emitter.listenerCount("vvv"), 0)
    emitter.emit("vvv", 10 |> @js.safe_js)
    sleep(16)
    // not called
    assert_eq(received, 6)
  })
}
