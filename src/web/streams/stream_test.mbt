///|
test "ReadableStream basic properties" {
  let source = @js.Object::new()
  let stream = ReadableStream::new(source.to_js())
  assert_eq(stream.locked, false)
}

///|
test "ReadableStream get_reader locks stream" {
  let source = @js.Object::new()
  let stream = ReadableStream::new(source.to_js())
  let reader = stream.get_reader()
  defer reader.release_lock()
  assert_eq(stream.locked, true)
}

///|
test "ReadableStream tee creates two branches" {
  let source = @js.Object::new()
  let stream = ReadableStream::new(source.to_js())
  let (branch1, branch2) = stream.tee()
  assert_eq(branch1.locked, false)
  assert_eq(branch2.locked, false)
}

///|
test "WritableStream basic properties" {
  let sink = @js.Object::new()
  let stream = WritableStream::new(sink.to_js())
  assert_eq(stream.locked, false)
}

///|
test "WritableStream get_writer locks stream" {
  let sink = @js.Object::new()
  let stream = WritableStream::new(sink.to_js())
  let writer = stream.get_writer()
  defer writer.release_lock()
  assert_eq(stream.locked, true)
}

///|
test "ReadableStreamDefaultReader releaseLock unlocks stream" {
  let source = @js.Object::new()
  let stream = ReadableStream::new(source.to_js())
  let reader = stream.get_reader()
  assert_eq(stream.locked, true)
  reader.release_lock()
  assert_eq(stream.locked, false)
}

///|
test "WritableStreamDefaultWriter releaseLock unlocks stream" {
  let sink = @js.Object::new()
  let stream = WritableStream::new(sink.to_js())
  let writer = stream.get_writer()
  assert_eq(stream.locked, true)
  writer.release_lock()
  assert_eq(stream.locked, false)
}

///|
test "ReadableStream getReader alias" {
  let source = @js.Object::new()
  let stream = ReadableStream::new(source.to_js())
  let reader = stream.getReader()
  defer reader.release_lock()
  assert_eq(stream.locked, true)
}

///|
test "WritableStream getWriter alias" {
  let sink = @js.Object::new()
  let stream = WritableStream::new(sink.to_js())
  let writer = stream.getWriter()
  defer writer.release_lock()
  assert_eq(stream.locked, true)
}

///|
test "ReadableStreamDefaultReader releaseLock alias" {
  let source = @js.Object::new()
  let stream = ReadableStream::new(source.to_js())
  let reader = stream.get_reader()
  reader.releaseLock()
  assert_eq(stream.locked, false)
}

///|
test "WritableStreamDefaultWriter releaseLock alias" {
  let sink = @js.Object::new()
  let stream = WritableStream::new(sink.to_js())
  let writer = stream.get_writer()
  writer.releaseLock()
  assert_eq(stream.locked, false)
}

///|
test "TransformStream identity creates readable and writable" {
  let transform = TransformStream::new_identity()
  let readable = transform.readable
  let writable = transform.writable
  assert_eq(readable.locked, false)
  assert_eq(writable.locked, false)
}

///|
test "TransformStream with transformer" {
  let transformer = @js.Object::new()
  let transform = TransformStream::new(transformer.to_js())
  let readable = transform.readable
  let writable = transform.writable
  assert_eq(readable.locked, false)
  assert_eq(writable.locked, false)
}

///|
test "TransformStream newIdentity alias" {
  let transform = TransformStream::newIdentity()
  let readable = transform.readable
  assert_eq(readable.locked, false)
}
