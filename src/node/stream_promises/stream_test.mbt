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
extern "js" fn create_writable_to_array_promises() -> @js.Any =
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
extern "js" fn get_chunks_promises(writable : @js.Any) -> Array[String] =
  #| (writable) => writable.chunks || []

///| Pipeline operations

///|
async test "Node Stream Promises: pipeline with promises - basic" {
  let readable = create_readable_from_array(["hello", "world"])
  let writable_js = create_writable_to_array_promises()
  let streams : Array[@js.Any] = [readable.as_any(), writable_js]
  ignore(promises_pipeline(streams))
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
  let streams : Array[@js.Any] = [
    readable.as_any(),
    transform.as_any(),
    writable_js,
  ]
  ignore(promises_pipeline(streams))
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
  let streams : Array[@js.Any] = [
    readable.as_any(),
    transform1.as_any(),
    transform2.as_any(),
    writable_js,
  ]
  ignore(promises_pipeline(streams))
  let chunks = get_chunks_promises(writable_js)
  assert_eq(chunks.length(), 2)
  assert_eq(chunks[0], "TEST")
  assert_eq(chunks[1], "DATA")
}

///|
async test "Node Stream Promises: pipeline with promises - async operations" {
  let readable = create_readable_from_array(["async", "test"])
  let transform = create_transform_uppercase_promises()
  let writable_js = create_writable_to_array_promises()
  let streams : Array[@js.Any] = [
    readable.as_any(),
    transform.as_any(),
    writable_js,
  ]
  ignore(promises_pipeline(streams))
  let chunks = get_chunks_promises(writable_js)
  assert_eq(chunks.length(), 2)
  assert_eq(chunks[0], "ASYNC")
  assert_eq(chunks[1], "TEST")
}

///|
async test "Node Stream Promises: pipeline with promises - successful completion" {
  let readable = create_readable_from_array(["test", "data"])
  let writable_js = create_writable_to_array_promises()
  let streams : Array[@js.Any] = [readable.as_any(), writable_js]
  let _stream = promises_pipeline(streams)
  let chunks = get_chunks_promises(writable_js)
  assert_eq(chunks.length(), 2)
}

///|
async test "Node Stream Promises: pipeline with promises - then chain" {
  let readable = create_readable_from_array(["chain", "test"])
  let writable_js = create_writable_to_array_promises()
  let streams : Array[@js.Any] = [readable.as_any(), writable_js]
  ignore(promises_pipeline(streams))
  let chunks = get_chunks_promises(writable_js)
  assert_eq(chunks.length(), 2)
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
  let streams : Array[@js.Any] = [readable.as_any(), writable_js]
  ignore(promises_pipeline(streams))
  let chunks = get_chunks_promises(writable_js)
  assert_eq(chunks.length(), 100)
  assert_eq(chunks[0], "item0")
  assert_eq(chunks[99], "item99")
}

///| Finished operations

///|
async test "Node Stream Promises: finished with promises - writable" {
  let writable_js = create_writable_to_array_promises()
  let writable : @stream.Writable = @js.identity(writable_js)
  // Write some data
  let _ = writable.write("test")
  // End the stream
  ignore(writable.as_any().call0("end"))
  // Wait for finish
  promises_finished(writable_js)
  assert_eq(writable.writableFinished(), true)
}

///|
async test "Node Stream Promises: finished with promises - readable" {
  let readable = create_readable_from_array(["item"])
  // Consume the stream
  let _ = readable.read()
  let _ = readable.read()
  // Wait for end
  promises_finished(readable.as_any())
  assert_eq(readable.readableEnded(), true)
}

///|
async test "Node Stream Promises: finished with promises - multiple streams" {
  let writable1_js = create_writable_to_array_promises()
  let writable1 : @stream.Writable = @js.identity(writable1_js)
  let writable2_js = create_writable_to_array_promises()
  let writable2 : @stream.Writable = @js.identity(writable2_js)
  // End both streams
  ignore(writable1.as_any().call0("end"))
  ignore(writable2.as_any().call0("end"))
  // Wait for both to finish
  promises_finished(writable1_js)
  promises_finished(writable2_js)
  assert_eq(writable1.writableFinished(), true)
  assert_eq(writable2.writableFinished(), true)
}
