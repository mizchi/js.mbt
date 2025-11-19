///|
using @node_stream {
  type Readable,
  type Writable,
  type Duplex,
  type PassThrough,
  type Transform,
  pipeline,
  finished,
}

///|
extern "js" fn create_readable_from_string(content : String) -> Readable =
  #| (content) => {
  #|   const { Readable } = require('node:stream');
  #|   return Readable.from([content]);
  #| }

///|
extern "js" fn create_writable_to_array() -> Js =
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
extern "js" fn create_transform_uppercase() -> Transform =
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
extern "js" fn create_passthrough() -> PassThrough =
  #| () => {
  #|   const { PassThrough } = require('node:stream');
  #|   return new PassThrough();
  #| }

///|
extern "js" fn get_chunks(writable : Js) -> Array[String] =
  #| (writable) => writable.chunks || []

///|
test {
  it("Readable stream - read and pause/resume", _ => {
    let readable = create_readable_from_string("Hello Stream!")
    assert_eq(readable.isPaused(), false)
    let _ = readable.pause()
    assert_eq(readable.isPaused(), true)
    let _ = readable.resume_()
    assert_eq(readable.isPaused(), false)
  })
}

///|
test {
  it("Readable stream - properties", _ => {
    let readable = create_readable_from_string("test")
    assert_eq(readable.readable(), true)
    // Readable.from() creates object mode stream by default
    assert_eq(readable.readableObjectMode(), true)
  })
}

///|
test {
  it("Writable stream - write and properties", _ => {
    let writable : Writable = unsafe_cast(create_writable_to_array())
    assert_eq(writable.writable(), true)
    assert_eq(writable.writableObjectMode(), false)
    let success = writable.write(@js.unsafe_cast("test"))
    assert_eq(success, true)
  })
}

///|
test {
  it("pipe - Readable to Writable", _ => {
    let readable = create_readable_from_string("Hello Pipe!")
    let writable_js = create_writable_to_array()
    let writable : Writable = unsafe_cast(writable_js)
    let _ = readable.pipe(writable)
    sleep(10)
    let chunks = get_chunks(writable_js)
    assert_eq(chunks.length(), 1)
    assert_eq(chunks[0], "Hello Pipe!")
  })
}

///|
test {
  it("Transform stream - uppercase", _ => {
    let readable = create_readable_from_string("hello transform")
    let transform : Readable = unsafe_cast(create_transform_uppercase())
    let writable_js = create_writable_to_array()
    let writable : Writable = unsafe_cast(writable_js)
    let piped : Readable = unsafe_cast(readable.pipe(unsafe_cast(transform)))
    let _ = piped.pipe(writable)
    sleep(10)
    let chunks = get_chunks(writable_js)
    assert_eq(chunks.length(), 1)
    assert_eq(chunks[0], "HELLO TRANSFORM")
  })
}

///|
test {
  it("PassThrough stream", _ => {
    let readable = create_readable_from_string("passthrough test")
    let passthrough : Readable = unsafe_cast(create_passthrough())
    let writable_js = create_writable_to_array()
    let writable : Writable = unsafe_cast(writable_js)
    let piped : Readable = unsafe_cast(readable.pipe(unsafe_cast(passthrough)))
    let _ = piped.pipe(writable)
    sleep(10)
    let chunks = get_chunks(writable_js)
    assert_eq(chunks.length(), 1)
    assert_eq(chunks[0], "passthrough test")
  })
}

///|
test {
  it("pipeline - multiple streams", _ => {
    let readable = create_readable_from_string("pipeline test")
    let transform = create_transform_uppercase()
    let writable_js = create_writable_to_array()
    let writable : Writable = unsafe_cast(writable_js)
    // Use pipe instead of pipeline for streams without callback
    let piped : Readable = unsafe_cast(readable.pipe(unsafe_cast(transform)))
    let _ = piped.pipe(writable)
    sleep(10)
    let chunks = get_chunks(writable_js)
    assert_eq(chunks.length(), 1)
    assert_eq(chunks[0], "PIPELINE TEST")
  })
}

///|
test {
  it("pipeline with callback", _ => {
    let mut callback_called = false
    let readable = create_readable_from_string("callback test")
    let writable_js = create_writable_to_array()
    let writable : Writable = unsafe_cast(writable_js)
    let callback : @js.Js = @js.unsafe_cast(fn(err : @js.Js) -> Unit {
      callback_called = true
      ignore(err)
    })
    let _ = pipeline(
      [@js.unsafe_cast(readable), @js.unsafe_cast(writable)],
      callback~,
    )
    sleep(20)
    assert_eq(callback_called, true)
    let chunks = get_chunks(writable_js)
    assert_eq(chunks[0], "callback test")
  })
}

///|
test {
  it("finished - stream completion", _ => {
    let mut finished_called = false
    let readable = create_readable_from_string("finished test")
    let writable_js = create_writable_to_array()
    let writable : Writable = unsafe_cast(writable_js)
    let callback : @js.Js = @js.unsafe_cast(fn(err : @js.Js) -> Unit {
      finished_called = true
      ignore(err)
    })
    let _ = readable.pipe(writable)
    let _ = finished(@js.unsafe_cast(writable), callback~)
    sleep(20)
    assert_eq(finished_called, true)
  })
}

///|
test {
  it("Readable setEncoding", _ => {
    let readable = create_readable_from_string("encoding test")
    let _ = readable.setEncoding("utf8")
    assert_eq(readable.readable(), true)
  })
}

///|
test {
  it("Writable cork/uncork", _ => {
    let writable_js = create_writable_to_array()
    let writable : Writable = unsafe_cast(writable_js)
    writable.cork()
    assert_eq(writable.writableCorked(), 1)
    let _ = writable.write(@js.unsafe_cast("corked1"))
    let _ = writable.write(@js.unsafe_cast("corked2"))
    writable.uncork()
    assert_eq(writable.writableCorked(), 0)
    sleep(10)
    let chunks = get_chunks(writable_js)
    assert_eq(chunks.length(), 2)
  })
}

///|
test {
  it("Readable unpipe", _ => {
    let readable = create_readable_from_string("unpipe test")
    let writable : Writable = unsafe_cast(create_writable_to_array())
    let _ = readable.pipe(writable)
    let _ = readable.unpipe(destination=writable)
    // Stream should be unpiped
    assert_eq(readable.readable(), true)
  })
}

///|
test {
  it("async pipeline with Promise", _ => {
    let resolver : @promise.Resolvers[Bool] = @promise.Promise::withResolvers()
    run_async(fn() {
      let readable = create_readable_from_string("async test")
      let transform = create_transform_uppercase()
      let writable_js = create_writable_to_array()
      let writable : Writable = unsafe_cast(writable_js)
      let callback : @js.Js = @js.unsafe_cast(fn(err : @js.Js) -> Unit {
        ignore(err)
        let chunks = get_chunks(writable_js)
        let success = chunks.length() == 1 && chunks[0] == "ASYNC TEST"
        resolver.resolve(success)
      })
      let _ = pipeline(
        [
          @js.unsafe_cast(readable),
          @js.unsafe_cast(transform),
          @js.unsafe_cast(writable),
        ],
        callback~,
      )

    })
    let result = resolver.promise.unwrap()
    assert_eq(result, true)
  })
}

///|
test {
  it("Readable destroy", _ => {
    let readable = create_readable_from_string("destroy test")
    // Destroy without error - stream will handle it
    ignore(readable.to_js().call0("destroy"))
    sleep(5)
    // After destroy, stream should be closed
    assert_eq(readable.closed(), true)
  })
}

///|
test {
  it("Writable destroy", _ => {
    let writable : Writable = unsafe_cast(create_writable_to_array())
    // Destroy without error - stream will handle it
    ignore(writable.to_js().call0("destroy"))
    sleep(5)
    assert_eq(writable.closed(), true)
  })
}

///|
test {
  it("Writable end", _ => {
    let writable : Writable = unsafe_cast(create_writable_to_array())
    // Call end without chunk - use call directly
    ignore(writable.to_js().call0("end"))
    sleep(5)
    assert_eq(writable.writableEnded(), true)
  })
}

///|
test {
  it("multiple transforms in pipeline", _ => {
    let readable = create_readable_from_string("multi transform")
    let transform1 = create_transform_uppercase()
    let transform2 = create_passthrough()
    let writable_js = create_writable_to_array()
    let writable : Writable = unsafe_cast(writable_js)
    // Use pipe instead of pipeline for multiple streams without callback
    let piped1 : Readable = unsafe_cast(readable.pipe(unsafe_cast(transform1)))
    let piped2 : Readable = unsafe_cast(piped1.pipe(unsafe_cast(transform2)))
    let _ = piped2.pipe(writable)
    sleep(15)
    let chunks = get_chunks(writable_js)
    assert_eq(chunks.length(), 1)
    assert_eq(chunks[0], "MULTI TRANSFORM")
  })
}

///|
test {
  it("stream properties after operations", _ => {
    let readable = create_readable_from_string("props test")
    let writable_js = create_writable_to_array()
    let writable : Writable = unsafe_cast(writable_js)
    let _ = readable.pipe(writable)
    sleep(10)
    assert_eq(readable.readableEnded(), true)
    assert_eq(writable.writableFinished(), true)
  })
}
