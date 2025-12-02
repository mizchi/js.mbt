///|
/// Node Events: Basic operations

///|
async test "Node Events: EventEmitter on/emit/off" {
  let emitter = @events.EventEmitter::new()
  let mut received = 0
  let callback = (_data : @core.Any) => @js.run_async(() => {
    @core.sleep(16)
    let v : Int = @core.identity(_data)
    received += v
  })
  // emitter.
  emitter.on("vvv", callback)
  emitter.emit("vvv", 1 |> @js.any)
  emitter.emit("vvv", 2 |> @js.any)
  emitter.emit("vvv", 3 |> @js.any)
  @core.sleep(16)
  assert_eq(received, 6)
  assert_eq(emitter.listenerCount("vvv"), 1)

  // off and emit again
  emitter.off("vvv", callback)
  assert_eq(emitter.listenerCount("vvv"), 0)
  emitter.emit("vvv", () |> @js.any)
  @core.sleep(16)
  // not called
  assert_eq(received, 6)
  emitter.on("aaa", callback)
  emitter.on("bbb", callback)
  assert_eq(emitter.listenerCount("aaa"), 1)
  assert_eq(emitter.listenerCount("bbb"), 1)
  emitter.removeAllListeners()
  assert_eq(emitter.listenerCount("vvv"), 0)
  emitter.emit("vvv", 10 |> @js.any)
  @core.sleep(16)
  // not called
  assert_eq(received, 6)
}

///|
async test "Node Events: EventEmitter once" {
  let emitter = @events.EventEmitter::new()
  let mut count = 0
  emitter.once("test", _ => @js.run_async(() => {
    @core.sleep(16)
    count += 1
  }))
  emitter.emit("test", 1 |> @js.any)
  emitter.emit("test", 2 |> @js.any)
  @core.sleep(16)
  assert_eq(count, 1)
}

///|
async test "Node Events: EventEmitter eventNames" {
  let emitter = @events.EventEmitter::new()
  emitter.on("event1", _ => ())
  emitter.on("event2", _ => ())
  let names = emitter.eventNames()
  assert_eq(names.length(), 2)
}

///|
async test "Node Events: EventEmitter multiple listeners" {
  let emitter = @events.EventEmitter::new()
  let mut count1 = 0
  let mut count2 = 0
  emitter.on("test", _ => @js.run_async(() => {
    @core.sleep(16)
    count1 += 1
  }))
  emitter.on("test", _ => @js.run_async(() => {
    @core.sleep(16)
    count2 += 1
  }))
  assert_eq(emitter.listenerCount("test"), 2)
  emitter.emit("test", () |> @js.any)
  @core.sleep(16)
  assert_eq(count1, 1)
  assert_eq(count2, 1)
}

///|
async test "Node Events: EventEmitter with async handlers" {
  let emitter = @events.EventEmitter::new()
  let results = []
  emitter.on("async", data => @js.run_async(() => {
    @core.sleep(16)
    let v : Int = @core.identity(data)
    results.push(v * 2)
  }))
  emitter.emit("async", 10 |> @js.any)
  emitter.emit("async", 20 |> @js.any)
  @core.sleep(32)
  assert_eq(results.length(), 2)
  assert_eq(results[0], 20)
  assert_eq(results[1], 40)
}

///| Promise and timer coordination

///|
async test "Node Events: multiple promises concurrent" {
  let resolver1 : @core.PromiseResolvers[Int] = @core.Promise::withResolvers()
  let resolver2 : @core.PromiseResolvers[Int] = @core.Promise::withResolvers()
  let resolver3 : @core.PromiseResolvers[Int] = @core.Promise::withResolvers()
  @js.run_async(() => {
    @core.sleep(16)
    resolver1.resolve(1)
  })
  @js.run_async(() => {
    @core.sleep(16)
    resolver2.resolve(2)
  })
  @js.run_async(() => {
    @core.sleep(16)
    resolver3.resolve(3)
  })
  let r1 = resolver1.promise.wait()
  let r2 = resolver2.promise.wait()
  let r3 = resolver3.promise.wait()
  assert_eq(r1 + r2 + r3, 6)
}

///|
async test "Node Events: timer and promise coordination" {
  let mut timer_fired = false
  let mut promise_resolved = false
  let resolver : @core.PromiseResolvers[Unit] = @core.Promise::withResolvers()
  let _ = @global.set_timeout(
    () => {
      timer_fired = true
      resolver.resolve(())
    },
    16,
  )
  resolver.promise.wait()
  promise_resolved = true
  assert_true(timer_fired)
  assert_true(promise_resolved)
}

///| Advanced scenarios

///|
async test "Node Events: EventEmitter stress test" {
  let emitter = @events.EventEmitter::new()
  let mut total = 0
  emitter.on("data", data => @js.run_async(() => {
    let v : Int = @core.identity(data)
    total += v
  }))
  for i = 0; i < 10; i = i + 1 {
    emitter.emit("data", i |> @js.any)
  }
  @core.sleep(32)
  assert_eq(total, 45) // 0+1+2+...+9 = 45
}

///|
async test "Node Events: multiple EventEmitters" {
  let emitter1 = @events.EventEmitter::new()
  let emitter2 = @events.EventEmitter::new()
  let mut count1 = 0
  let mut count2 = 0
  emitter1.on("test", _ => @js.run_async(() => {
    @core.sleep(16)
    count1 += 1
  }))
  emitter2.on("test", _ => @js.run_async(() => {
    @core.sleep(16)
    count2 += 1
  }))
  emitter1.emit("test", () |> @js.any)
  emitter2.emit("test", () |> @js.any)
  @core.sleep(16)
  assert_eq(count1, 1)
  assert_eq(count2, 1)
}

///|
async test "Node Events: EventEmitter with different payload types" {
  let emitter = @events.EventEmitter::new()
  let mut int_val = 0
  let mut str_val = ""
  emitter.on("int", data => @js.run_async(() => {
    let v : Int = @core.identity(data)
    int_val = v
  }))
  emitter.on("string", data => @js.run_async(() => {
    let v : String = @core.identity(data)
    str_val = v
  }))
  emitter.emit("int", 42 |> @js.any)
  emitter.emit("string", "hello" |> @js.any)
  @core.sleep(16)
  assert_eq(int_val, 42)
  assert_eq(str_val, "hello")
}

///|
async test "Node Events: EventEmitter removeAllListeners specific event" {
  let emitter = @events.EventEmitter::new()
  let mut count = 0
  emitter.on("event1", _ => @js.run_async(() => count += 1))
  emitter.on("event2", _ => @js.run_async(() => count += 10))
  emitter.removeAllListeners()
  emitter.emit("event1", () |> @js.any)
  emitter.emit("event2", () |> @js.any)
  @core.sleep(16)
  assert_eq(count, 0)
}
