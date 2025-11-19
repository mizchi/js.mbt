///|
let promises_pipeline = @stream_promises.pipeline

///|
let promises_finished = @stream_promises.finished

///|
extern "js" fn create_readable_from_array(
  items : Array[String],
) -> @node_stream.Readable =
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
extern "js" fn create_transform_uppercase_promises() -> @node_stream.Transform =
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
extern "js" fn create_passthrough_promises() -> @node_stream.PassThrough =
  #| () => {
  #|   const { PassThrough } = require('node:stream');
  #|   return new PassThrough();
  #| }

///|
extern "js" fn get_chunks_promises(writable : @js.Js) -> Array[String] =
  #| (writable) => writable.chunks || []

///|
test {
  it("pipeline with promises - basic", _ => {
    let readable = create_readable_from_array(["hello", "world"])
    let writable_js = create_writable_to_array_promises()
    let streams : Array[@js.Js] = [readable.to_js(), writable_js]
    let promise = promises_pipeline(streams)
    ignore(promise.unwrap())
    let chunks = get_chunks_promises(writable_js)
    assert_eq(chunks.length(), 2)
    assert_eq(chunks[0], "hello")
    assert_eq(chunks[1], "world")
  })
}

///|
test {
  it("pipeline with promises - with transform", _ => {
    let readable = create_readable_from_array(["hello", "world"])
    let transform = create_transform_uppercase_promises()
    let writable_js = create_writable_to_array_promises()
    let streams : Array[@js.Js] = [
      readable.to_js(),
      transform.to_js(),
      writable_js,
    ]
    let promise = promises_pipeline(streams)
    ignore(promise.unwrap())
    let chunks = get_chunks_promises(writable_js)
    assert_eq(chunks.length(), 2)
    assert_eq(chunks[0], "HELLO")
    assert_eq(chunks[1], "WORLD")
  })
}

///|
test {
  it("pipeline with promises - multiple transforms", _ => {
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
    ignore(promise.unwrap())
    let chunks = get_chunks_promises(writable_js)
    assert_eq(chunks.length(), 2)
    assert_eq(chunks[0], "TEST")
    assert_eq(chunks[1], "DATA")
  })
}

///|
test {
  it("finished with promises - writable", _ => {
    let writable_js = create_writable_to_array_promises()
    let writable : @node_stream.Writable = @js.unsafe_cast(writable_js)
    // Write some data
    let _ = writable.write(@js.unsafe_cast("test"))
    // End the stream
    ignore(writable.to_js().invoke("end", []))
    // Wait for finish
    let promise = promises_finished(writable_js)
    promise.unwrap()
    assert_eq(writable.writableFinished(), true)
  })
}

///|
test {
  it("finished with promises - readable", _ => {
    let readable = create_readable_from_array(["item"])
    // Consume the stream
    let _ = readable.read()
    let _ = readable.read()
    // Wait for end
    let promise = promises_finished(readable.to_js())
    promise.unwrap()
    assert_eq(readable.readableEnded(), true)
  })
}

///|
test {
  it("pipeline with promises - async operations", _ => {
    let resolver : @promise.Resolvers[Bool] = @promise.Promise::withResolvers()
    run_async(fn() {
      let readable = create_readable_from_array(["async", "test"])
      let transform = create_transform_uppercase_promises()
      let writable_js = create_writable_to_array_promises()
      let streams : Array[@js.Js] = [
        readable.to_js(),
        transform.to_js(),
        writable_js,
      ]
      let promise = promises_pipeline(streams)
      let result = promise.unwrap() catch { _ => @js.unsafe_cast(()) }
      ignore(result)
      let chunks = get_chunks_promises(writable_js)
      let success = chunks.length() == 2 &&
        chunks[0] == "ASYNC" &&
        chunks[1] == "TEST"
      resolver.resolve(success)
    })
    let result = resolver.promise.unwrap()
    assert_eq(result, true)
  })
}

///|
test {
  it("pipeline with promises - successful completion", _ => {
    // Test that pipeline promise resolves successfully
    let readable = create_readable_from_array(["test", "data"])
    let writable_js = create_writable_to_array_promises()
    let streams : Array[@js.Js] = [readable.to_js(), writable_js]
    let promise = promises_pipeline(streams)
    // Use then to verify completion
    let resolved = promise.then(fn(_) { @promise.Promise::resolve(true) })
    let success = resolved.unwrap()
    assert_eq(success, true)
    let chunks = get_chunks_promises(writable_js)
    assert_eq(chunks.length(), 2)
  })
}

///|
test {
  it("pipeline with promises - then chain", _ => {
    let readable = create_readable_from_array(["chain", "test"])
    let writable_js = create_writable_to_array_promises()
    let streams : Array[@js.Js] = [readable.to_js(), writable_js]
    let promise = promises_pipeline(streams)
    let result_promise = promise.then(fn(_) {
      let chunks = get_chunks_promises(writable_js)
      @promise.Promise::resolve(chunks.length())
    })
    let count = result_promise.unwrap()
    assert_eq(count, 2)
  })
}

///|
test {
  it("finished with promises - multiple streams", _ => {
    let writable1_js = create_writable_to_array_promises()
    let writable1 : @node_stream.Writable = @js.unsafe_cast(writable1_js)
    let writable2_js = create_writable_to_array_promises()
    let writable2 : @node_stream.Writable = @js.unsafe_cast(writable2_js)
    // End both streams
    ignore(writable1.to_js().invoke("end", []))
    ignore(writable2.to_js().invoke("end", []))
    // Wait for both to finish
    let promise1 = promises_finished(writable1_js)
    let promise2 = promises_finished(writable2_js)
    promise1.unwrap()
    promise2.unwrap()
    assert_eq(writable1.writableFinished(), true)
    assert_eq(writable2.writableFinished(), true)
  })
}

///|
test {
  it("pipeline with promises - large data", _ => {
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
    ignore(promise.unwrap())
    let chunks = get_chunks_promises(writable_js)
    assert_eq(chunks.length(), 100)
    assert_eq(chunks[0], "item0")
    assert_eq(chunks[99], "item99")
  })
}
