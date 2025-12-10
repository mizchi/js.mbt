///|
/// Node Events: Basic operations

///|
extern "js" fn set_immediate(f : () -> Unit) -> Unit =
  #| (f) => setImmediate(f)

///|
async test "Node Events: EventEmitter on/emit/off" {
  let emitter = @events.EventEmitter::new()
  let mut received = 0
  let callback = (data : @core.Any) => {
    let v : Int = @core.identity(data)
    received += v
  }
  emitter.on("vvv", callback)
  emitter.emit("vvv", 1 |> @core.any)
  emitter.emit("vvv", 2 |> @core.any)
  emitter.emit("vvv", 3 |> @core.any)
  // emit is synchronous, no need to wait
  assert_eq(received, 6)
  assert_eq(emitter.listenerCount("vvv"), 1)

  // off and emit again
  emitter.off("vvv", callback)
  assert_eq(emitter.listenerCount("vvv"), 0)
  emitter.emit("vvv", () |> @core.any)
  // not called
  assert_eq(received, 6)
  emitter.on("aaa", callback)
  emitter.on("bbb", callback)
  assert_eq(emitter.listenerCount("aaa"), 1)
  assert_eq(emitter.listenerCount("bbb"), 1)
  emitter.removeAllListeners()
  assert_eq(emitter.listenerCount("vvv"), 0)
  emitter.emit("vvv", 10 |> @core.any)
  // not called
  assert_eq(received, 6)
}

///|
async test "Node Events: EventEmitter once" {
  let emitter = @events.EventEmitter::new()
  let mut count = 0
  emitter.once("test", _ => count += 1)
  emitter.emit("test", 1 |> @core.any)
  emitter.emit("test", 2 |> @core.any)
  // once only fires once, synchronously
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
  emitter.on("test", _ => count1 += 1)
  emitter.on("test", _ => count2 += 1)
  assert_eq(emitter.listenerCount("test"), 2)
  emitter.emit("test", () |> @core.any)
  // emit is synchronous
  assert_eq(count1, 1)
  assert_eq(count2, 1)
}

///|
async test "Node Events: EventEmitter with async handlers" {
  let emitter = @events.EventEmitter::new()
  let results : Array[Int] = []
  emitter.on("async", data => {
    let v : Int = @core.identity(data)
    results.push(v * 2)
  })
  emitter.emit("async", 10 |> @core.any)
  emitter.emit("async", 20 |> @core.any)
  // emit is synchronous
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
  // Use setImmediate instead of sleep for immediate async resolution
  @core.run_async(fn() noraise { set_immediate(() => resolver1.resolve(1)) })
  @core.run_async(fn() noraise { set_immediate(() => resolver2.resolve(2)) })
  @core.run_async(fn() noraise { set_immediate(() => resolver3.resolve(3)) })
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
  // Use setImmediate (0ms) instead of setTimeout(16ms)
  set_immediate(() => {
    timer_fired = true
    resolver.resolve(())
  })
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
  emitter.on("data", data => {
    let v : Int = @core.identity(data)
    total += v
  })
  for i = 0; i < 10; i = i + 1 {
    emitter.emit("data", i |> @core.any)
  }
  // emit is synchronous
  assert_eq(total, 45) // 0+1+2+...+9 = 45
}

///|
async test "Node Events: multiple EventEmitters" {
  let emitter1 = @events.EventEmitter::new()
  let emitter2 = @events.EventEmitter::new()
  let mut count1 = 0
  let mut count2 = 0
  emitter1.on("test", _ => count1 += 1)
  emitter2.on("test", _ => count2 += 1)
  emitter1.emit("test", () |> @core.any)
  emitter2.emit("test", () |> @core.any)
  // emit is synchronous
  assert_eq(count1, 1)
  assert_eq(count2, 1)
}

///|
async test "Node Events: EventEmitter with different payload types" {
  let emitter = @events.EventEmitter::new()
  let mut int_val = 0
  let mut str_val = ""
  emitter.on("int", data => {
    let v : Int = @core.identity(data)
    int_val = v
  })
  emitter.on("string", data => {
    let v : String = @core.identity(data)
    str_val = v
  })
  emitter.emit("int", 42 |> @core.any)
  emitter.emit("string", "hello" |> @core.any)
  // emit is synchronous
  assert_eq(int_val, 42)
  assert_eq(str_val, "hello")
}

///|
async test "Node Events: EventEmitter removeAllListeners specific event" {
  let emitter = @events.EventEmitter::new()
  let mut count = 0
  emitter.on("event1", _ => count += 1)
  emitter.on("event2", _ => count += 10)
  emitter.removeAllListeners()
  emitter.emit("event1", () |> @core.any)
  emitter.emit("event2", () |> @core.any)
  // emit is synchronous, but listeners were removed
  assert_eq(count, 0)
}
