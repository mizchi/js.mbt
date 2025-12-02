///|

///|
extern "js" fn create_readable_from_string(
  content : String,
) -> @stream.Readable =
  #| (content) => {
  #|   const { Readable } = require('node:stream');
  #|   return Readable.from([content]);
  #| }

///|
extern "js" fn create_writable_to_array() -> @core.Any =
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
extern "js" fn create_transform_uppercase() -> @stream.Transform =
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
extern "js" fn create_passthrough() -> @stream.PassThrough =
  #| () => {
  #|   const { PassThrough } = require('node:stream');
  #|   return new PassThrough();
  #| }

///|
extern "js" fn get_chunks(writable : @core.Any) -> Array[String] =
  #| (writable) => writable.chunks || []

///| @stream.Readable operations

///|
async test "Node Stream: Readable stream - read and pause/resume" {
  let readable = create_readable_from_string("Hello Stream!")
  assert_eq(readable.isPaused(), false)
  let _ = readable.pause()
  assert_eq(readable.isPaused(), true)
  let _ = readable.resume_()
  assert_eq(readable.isPaused(), false)
}

///|
async test "Node Stream: Readable stream - properties" {
  let readable = create_readable_from_string("test")
  assert_eq(readable.readable(), true)
  // Readable.from() creates object mode stream by default
  assert_eq(readable.readableObjectMode(), true)
}

///|
async test "Node Stream: Readable setEncoding" {
  let readable = create_readable_from_string("encoding test")
  let _ = readable.setEncoding("utf8")
  assert_eq(readable.readable(), true)
}

///|
async test "Node Stream: Readable unpipe" {
  let readable = create_readable_from_string("unpipe test")
  let writable : @stream.Writable = @core.identity(create_writable_to_array())
  let _ = readable.pipe(writable)
  let _ = readable.unpipe(destination=writable)
  // Stream should be unpiped
  assert_eq(readable.readable(), true)
}

///|
async test "Node Stream: Readable destroy" {
  let readable = create_readable_from_string("destroy test")
  // Destroy without error - stream will handle it
  ignore(readable.as_any()._call("destroy", []))
  @js.sleep(16)
  // After destroy, stream should be closed
  assert_eq(readable.closed(), true)
}

///| @stream.Writable operations

///|
async test "Node Stream: Writable stream - write and properties" {
  let writable : @stream.Writable = @core.identity(create_writable_to_array())
  assert_eq(writable.writable(), true)
  assert_eq(writable.writableObjectMode(), false)
  let success = writable.write(@core.any("test"))
  assert_eq(success, true)
}

///|
async test "Node Stream: Writable cork/uncork" {
  let writable_js = create_writable_to_array()
  let writable : @stream.Writable = @core.identity(writable_js)
  writable.cork()
  assert_eq(writable.writableCorked(), 1)
  let _ = writable.write(@core.any("corked1"))
  let _ = writable.write(@core.any("corked2"))
  writable.uncork()
  assert_eq(writable.writableCorked(), 0)
  @js.sleep(16)
  let chunks = get_chunks(writable_js)
  assert_eq(chunks.length(), 2)
}

///|
async test "Node Stream: Writable destroy" {
  let writable : @stream.Writable = @core.identity(create_writable_to_array())
  // Destroy without error - stream will handle it
  ignore(writable.as_any()._call("destroy", []))
  @js.sleep(16)
  assert_eq(writable.closed(), true)
}

///|
async test "Node Stream: Writable end" {
  let writable : @stream.Writable = @core.identity(create_writable_to_array())
  // Call end without chunk - use call directly
  ignore(writable.as_any()._call("end", []))
  @js.sleep(16)
  assert_eq(writable.writableEnded(), true)
}

///| Piping and transformation

///|
async test "Node Stream: pipe - Readable to Writable" {
  let readable = create_readable_from_string("Hello Pipe!")
  let writable_js = create_writable_to_array()
  let writable : @stream.Writable = @core.identity(writable_js)
  let _ = readable.pipe(writable)
  @js.sleep(16)
  let chunks = get_chunks(writable_js)
  assert_eq(chunks.length(), 1)
  assert_eq(chunks[0], "Hello Pipe!")
}

///|
async test "Node Stream: Transform stream - uppercase" {
  let readable = create_readable_from_string("hello transform")
  let transform : @stream.Readable = @core.identity(
    create_transform_uppercase(),
  )
  let writable_js = create_writable_to_array()
  let writable : @stream.Writable = @core.identity(writable_js)
  let piped : @stream.Readable = @core.identity(
    readable.pipe(@core.identity(transform)),
  )
  let _ = piped.pipe(writable)
  @js.sleep(16)
  let chunks = get_chunks(writable_js)
  assert_eq(chunks.length(), 1)
  assert_eq(chunks[0], "HELLO TRANSFORM")
}

///|
async test "Node Stream: PassThrough stream" {
  let readable = create_readable_from_string("passthrough test")
  let passthrough : @stream.Readable = @core.identity(create_passthrough())
  let writable_js = create_writable_to_array()
  let writable : @stream.Writable = @core.identity(writable_js)
  let piped : @stream.Readable = @core.identity(
    readable.pipe(@core.identity(passthrough)),
  )
  let _ = piped.pipe(writable)
  @js.sleep(16)
  let chunks = get_chunks(writable_js)
  assert_eq(chunks.length(), 1)
  assert_eq(chunks[0], "passthrough test")
}

///|
async test "Node Stream: multiple transforms in pipeline" {
  let readable = create_readable_from_string("multi transform")
  let transform1 = create_transform_uppercase()
  let transform2 = create_passthrough()
  let writable_js = create_writable_to_array()
  let writable : @stream.Writable = @core.identity(writable_js)
  // Use pipe instead of pipeline for multiple streams without callback
  let piped1 : @stream.Readable = @core.identity(
    readable.pipe(@core.identity(transform1)),
  )
  let piped2 : @stream.Readable = @core.identity(
    piped1.pipe(@core.identity(transform2)),
  )
  let _ = piped2.pipe(writable)
  @js.sleep(16)
  let chunks = get_chunks(writable_js)
  assert_eq(chunks.length(), 1)
  assert_eq(chunks[0], "MULTI TRANSFORM")
}

///|
async test "Node Stream: stream properties after operations" {
  let readable = create_readable_from_string("props test")
  let writable_js = create_writable_to_array()
  let writable : @stream.Writable = @core.identity(writable_js)
  let _ = readable.pipe(writable)
  @js.sleep(16)
  assert_eq(readable.readableEnded(), true)
  assert_eq(writable.writableFinished(), true)
}

///| Pipeline and completion

///|
async test "Node Stream: pipeline - multiple streams" {
  let readable = create_readable_from_string("pipeline test")
  let transform = create_transform_uppercase()
  let writable_js = create_writable_to_array()
  let writable : @stream.Writable = @core.identity(writable_js)
  // Use pipe instead of pipeline for streams without callback
  let piped : @stream.Readable = @core.identity(
    readable.pipe(@core.identity(transform)),
  )
  let _ = piped.pipe(writable)
  @js.sleep(16)
  let chunks = get_chunks(writable_js)
  assert_eq(chunks.length(), 1)
  assert_eq(chunks[0], "PIPELINE TEST")
}

///|
async test "Node Stream: pipeline with callback" {
  let mut callback_called = false
  let readable = create_readable_from_string("callback test")
  let writable_js = create_writable_to_array()
  let writable : @stream.Writable = @core.identity(writable_js)
  let callback : @core.Any = @core.any(
    @js.from_fn1(fn(err : @core.Any) -> Unit {
      callback_called = true
      ignore(err)
    }),
  )
  let _ = @stream.pipeline([readable.as_any(), writable.as_any()], callback~)
  @js.sleep(32)
  assert_eq(callback_called, true)
  let chunks = get_chunks(writable_js)
  assert_eq(chunks[0], "callback test")
}

///|
async test "Node Stream: finished - stream completion" {
  let mut finished_called = false
  let readable = create_readable_from_string("finished test")
  let writable_js = create_writable_to_array()
  let writable : @stream.Writable = @core.identity(writable_js)
  let callback : @core.Any = @core.any(
    @js.from_fn1(fn(err : @core.Any) -> Unit {
      finished_called = true
      ignore(err)
    }),
  )
  let _ = readable.pipe(writable)
  let _ = @stream.finished(writable.as_any(), callback~)
  @js.sleep(32)
  assert_eq(finished_called, true)
}

///|
async test "Node Stream: async pipeline with Promise" {
  let resolver : @js.PromiseResolvers[Bool] = @js.Promise::withResolvers()
  @js.run_async(fn() {
    let readable = create_readable_from_string("async test")
    let transform = create_transform_uppercase()
    let writable_js = create_writable_to_array()
    let writable : @stream.Writable = @core.identity(writable_js)
    let callback : @core.Any = @core.any(
      @js.from_fn1(fn(err : @core.Any) -> Unit {
        ignore(err)
        let chunks = get_chunks(writable_js)
        let success = chunks.length() == 1 && chunks[0] == "ASYNC TEST"
        resolver.resolve(success)
      }),
    )
    let _ = @stream.pipeline(
      [readable.as_any(), transform.as_any(), writable.as_any()],
      callback~,
    )

  })
  let result = resolver.promise.wait()
  assert_eq(result, true)
}
