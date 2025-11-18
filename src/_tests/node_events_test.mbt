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

///|
test {
  it("EventEmitter once", _ => {
    let emitter = @events.EventEmitter::new()
    let mut count = 0
    emitter.once("test", _ => run_async(() => {
      sleep(1)
      count += 1
    }))
    emitter.emit("test", 1 |> @js.safe_js)
    emitter.emit("test", 2 |> @js.safe_js)
    sleep(10)
    assert_eq(count, 1)
  })
}

///|
test {
  it("EventEmitter eventNames", _ => {
    let emitter = @events.EventEmitter::new()
    emitter.on("event1", _ => ())
    emitter.on("event2", _ => ())
    let names = emitter.eventNames()
    assert_eq(names.length(), 2)
  })
}

///|
test {
  it("EventEmitter multiple listeners", _ => {
    let emitter = @events.EventEmitter::new()
    let mut count1 = 0
    let mut count2 = 0
    emitter.on("test", _ => run_async(() => {
      sleep(1)
      count1 += 1
    }))
    emitter.on("test", _ => run_async(() => {
      sleep(1)
      count2 += 1
    }))
    assert_eq(emitter.listenerCount("test"), 2)
    emitter.emit("test", () |> @js.safe_js)
    sleep(10)
    assert_eq(count1, 1)
    assert_eq(count2, 1)
  })
}

///|
test {
  it("EventEmitter with async handlers", _ => {
    let emitter = @events.EventEmitter::new()
    let results = []
    emitter.on("async", data => run_async(() => {
      sleep(5)
      let v : Int = unsafe_cast(data)
      results.push(v * 2)
    }))
    emitter.emit("async", 10 |> @js.safe_js)
    emitter.emit("async", 20 |> @js.safe_js)
    sleep(20)
    assert_eq(results.length(), 2)
    assert_eq(results[0], 20)
    assert_eq(results[1], 40)
  })
}

///|
test {
  it("multiple promises concurrent", _ => {
    let resolver1 : @promise.Resolvers[Int] = @promise.Promise::withResolvers()
    let resolver2 : @promise.Resolvers[Int] = @promise.Promise::withResolvers()
    let resolver3 : @promise.Resolvers[Int] = @promise.Promise::withResolvers()
    run_async(() => {
      sleep(5)
      resolver1.resolve(1)
    })
    run_async(() => {
      sleep(5)
      resolver2.resolve(2)
    })
    run_async(() => {
      sleep(5)
      resolver3.resolve(3)
    })
    let r1 = resolver1.promise.unwrap()
    let r2 = resolver2.promise.unwrap()
    let r3 = resolver3.promise.unwrap()
    assert_eq(r1 + r2 + r3, 6)
  })
}

///|
test {
  it("timer and promise coordination", _ => {
    let mut timer_fired = false
    let mut promise_resolved = false
    let resolver : @promise.Resolvers[Unit] = @promise.Promise::withResolvers()
    let _ = @js.setTimeout(
      () => {
        timer_fired = true
        resolver.resolve(())
      },
      10,
    )
    resolver.promise.unwrap()
    promise_resolved = true
    assert_true(timer_fired)
    assert_true(promise_resolved)
  })
}

///|
test {
  it("EventEmitter stress test", _ => {
    let emitter = @events.EventEmitter::new()
    let mut total = 0
    emitter.on("data", data => run_async(() => {
      let v : Int = unsafe_cast(data)
      total += v
    }))
    for i = 0; i < 10; i = i + 1 {
      emitter.emit("data", i |> @js.safe_js)
    }
    sleep(20)
    assert_eq(total, 45) // 0+1+2+...+9 = 45
  })
}

///|
test {
  it("multiple EventEmitters", _ => {
    let emitter1 = @events.EventEmitter::new()
    let emitter2 = @events.EventEmitter::new()
    let mut count1 = 0
    let mut count2 = 0
    emitter1.on("test", _ => run_async(() => {
      sleep(1)
      count1 += 1
    }))
    emitter2.on("test", _ => run_async(() => {
      sleep(1)
      count2 += 1
    }))
    emitter1.emit("test", () |> @js.safe_js)
    emitter2.emit("test", () |> @js.safe_js)
    sleep(10)
    assert_eq(count1, 1)
    assert_eq(count2, 1)
  })
}

///|
test {
  it("EventEmitter with different payload types", _ => {
    let emitter = @events.EventEmitter::new()
    let mut int_val = 0
    let mut str_val = ""
    emitter.on("int", data => run_async(() => {
      let v : Int = unsafe_cast(data)
      int_val = v
    }))
    emitter.on("string", data => run_async(() => {
      let v : String = unsafe_cast(data)
      str_val = v
    }))
    emitter.emit("int", 42 |> @js.safe_js)
    emitter.emit("string", "hello" |> @js.safe_js)
    sleep(10)
    assert_eq(int_val, 42)
    assert_eq(str_val, "hello")
  })
}

///|
test {
  it("EventEmitter removeAllListeners specific event", _ => {
    let emitter = @events.EventEmitter::new()
    let mut count = 0
    emitter.on("event1", _ => run_async(() => count += 1))
    emitter.on("event2", _ => run_async(() => count += 10))
    emitter.removeAllListeners()
    emitter.emit("event1", () |> @js.safe_js)
    emitter.emit("event2", () |> @js.safe_js)
    sleep(10)
    assert_eq(count, 0)
  })
}
