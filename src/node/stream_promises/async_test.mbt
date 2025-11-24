///|
let promises_pipeline = @stream_promises.pipeline

///|
let promises_finished = @stream_promises.finished

///|
extern "js" fn create_readable_from_array(
  items : Array[String],
) -> @stream.Readable =
  #| (items) => {
  #|   const { Readable } = require('node:stream');
  #|   return Readable.from(items);
  #| }

///|
extern "js" fn create_writable_to_array_promises() -> @js.Js =
  #| () => {
  #|   const { Writable } = require('node:stream');
  #|   const chunks = [];
  #|   const writable = new Writable({
  #|     write(chunk, encoding, callback) {
  #|       chunks.push(chunk.toString());
  #|       callback();
  #|     }
  #|   });
  #|   writable.chunks = chunks;
  #|   return writable;
  #| }

///|
extern "js" fn create_transform_uppercase_promises() -> @stream.Transform =
  #| () => {
  #|   const { Transform } = require('node:stream');
  #|   return new Transform({
  #|     transform(chunk, encoding, callback) {
  #|       this.push(chunk.toString().toUpperCase());
  #|       callback();
  #|     }
  #|   });
  #| }

///|
extern "js" fn create_passthrough_promises() -> @stream.PassThrough =
  #| () => {
  #|   const { PassThrough } = require('node:stream');
  #|   return new PassThrough();
  #| }

///|
extern "js" fn get_chunks_promises(writable : @js.Js) -> Array[String] =
  #| (writable) => writable.chunks || []

///| Pipeline operations

///|
async test "Node Stream Promises: pipeline with promises - basic" {
  let readable = create_readable_from_array(["hello", "world"])
  let writable_js = create_writable_to_array_promises()
  let streams : Array[@js.Js] = [readable.to_js(), writable_js]
  let promise = promises_pipeline(streams)
  ignore(promise.wait())
  let chunks = get_chunks_promises(writable_js)
  assert_eq(chunks.length(), 2)
  assert_eq(chunks[0], "hello")
  assert_eq(chunks[1], "world")
}

///|
async test "Node Stream Promises: pipeline with promises - with transform" {
  let readable = create_readable_from_array(["hello", "world"])
  let transform = create_transform_uppercase_promises()
  let writable_js = create_writable_to_array_promises()
  let streams : Array[@js.Js] = [
    readable.to_js(),
    transform.to_js(),
    writable_js,
  ]
  let promise = promises_pipeline(streams)
  ignore(promise.wait())
  let chunks = get_chunks_promises(writable_js)
  assert_eq(chunks.length(), 2)
  assert_eq(chunks[0], "HELLO")
  assert_eq(chunks[1], "WORLD")
}

///|
async test "Node Stream Promises: pipeline with promises - multiple transforms" {
  let readable = create_readable_from_array(["test", "data"])
  let transform1 = create_transform_uppercase_promises()
  let transform2 = create_passthrough_promises()
  let writable_js = create_writable_to_array_promises()
  let streams : Array[@js.Js] = [
    readable.to_js(),
    transform1.to_js(),
    transform2.to_js(),
    writable_js,
  ]
  let promise = promises_pipeline(streams)
  ignore(promise.wait())
  let chunks = get_chunks_promises(writable_js)
  assert_eq(chunks.length(), 2)
  assert_eq(chunks[0], "TEST")
  assert_eq(chunks[1], "DATA")
}

///|
async test "Node Stream Promises: pipeline with promises - async operations" {
  let resolver : @js.Resolvers[Bool] = @js.Promise::withResolvers()
  @js.run_async(fn() {
    let readable = create_readable_from_array(["async", "test"])
    let transform = create_transform_uppercase_promises()
    let writable_js = create_writable_to_array_promises()
    let streams : Array[@js.Js] = [
      readable.to_js(),
      transform.to_js(),
      writable_js,
    ]
    let promise = promises_pipeline(streams)
    let result = promise.wait() catch { _ => @js.unsafe_cast(()) }
    ignore(result)
    let chunks = get_chunks_promises(writable_js)
    let success = chunks.length() == 2 &&
      chunks[0] == "ASYNC" &&
      chunks[1] == "TEST"
    resolver.resolve(success)
  })
  let result = resolver.promise.wait()
  assert_eq(result, true)
}

///|
async test "Node Stream Promises: pipeline with promises - successful completion" {
  // Test that pipeline promise resolves successfully
  let readable = create_readable_from_array(["test", "data"])
  let writable_js = create_writable_to_array_promises()
  let streams : Array[@js.Js] = [readable.to_js(), writable_js]
  let promise = promises_pipeline(streams)
  // Use then to verify completion
  let resolved = promise.then(fn(_) { @js.Promise::resolve(true) })
  let success = resolved.wait()
  assert_eq(success, true)
  let chunks = get_chunks_promises(writable_js)
  assert_eq(chunks.length(), 2)
}

///|
async test "Node Stream Promises: pipeline with promises - then chain" {
  let readable = create_readable_from_array(["chain", "test"])
  let writable_js = create_writable_to_array_promises()
  let streams : Array[@js.Js] = [readable.to_js(), writable_js]
  let promise = promises_pipeline(streams)
  let result_promise = promise.then(fn(_) {
    let chunks = get_chunks_promises(writable_js)
    @js.Promise::resolve(chunks.length())
  })
  let count = result_promise.wait()
  assert_eq(count, 2)
}

///|
async test "Node Stream Promises: pipeline with promises - large data" {
  let items = Array::make(100, "")
  let mut i = 0
  while i < 100 {
    items[i] = "item\{i}"
    i = i + 1
  }
  let readable = create_readable_from_array(items)
  let writable_js = create_writable_to_array_promises()
  let streams : Array[@js.Js] = [readable.to_js(), writable_js]
  let promise = promises_pipeline(streams)
  ignore(promise.wait())
  let chunks = get_chunks_promises(writable_js)
  assert_eq(chunks.length(), 100)
  assert_eq(chunks[0], "item0")
  assert_eq(chunks[99], "item99")
}

///| Finished operations

///|
async test "Node Stream Promises: finished with promises - writable" {
  let writable_js = create_writable_to_array_promises()
  let writable : @stream.Writable = @js.unsafe_cast(writable_js)
  // Write some data
  let _ = writable.write(@js.unsafe_cast("test"))
  // End the stream
  ignore(writable.to_js().call0("end"))
  // Wait for finish
  let promise = promises_finished(writable_js)
  promise.wait()
  assert_eq(writable.writableFinished(), true)
}

///|
async test "Node Stream Promises: finished with promises - readable" {
  let readable = create_readable_from_array(["item"])
  // Consume the stream
  let _ = readable.read()
  let _ = readable.read()
  // Wait for end
  let promise = promises_finished(readable.to_js())
  promise.wait()
  assert_eq(readable.readableEnded(), true)
}

///|
async test "Node Stream Promises: finished with promises - multiple streams" {
  let writable1_js = create_writable_to_array_promises()
  let writable1 : @stream.Writable = @js.unsafe_cast(writable1_js)
  let writable2_js = create_writable_to_array_promises()
  let writable2 : @stream.Writable = @js.unsafe_cast(writable2_js)
  // End both streams
  ignore(writable1.to_js().call0("end"))
  ignore(writable2.to_js().call0("end"))
  // Wait for both to finish
  let promise1 = promises_finished(writable1_js)
  let promise2 = promises_finished(writable2_js)
  promise1.wait()
  promise2.wait()
  assert_eq(writable1.writableFinished(), true)
  assert_eq(writable2.writableFinished(), true)
}
