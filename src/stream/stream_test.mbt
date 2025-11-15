///|
test "ReadableStream basic properties" {
  let source = @js.new_empty_object()
  let stream = ReadableStream::new(source)
  assert_eq(stream.locked(), false)
}

///|
test "ReadableStream get_reader locks stream" {
  let source = @js.new_empty_object()
  let stream = ReadableStream::new(source)
  let _reader = stream.get_reader()
  assert_eq(stream.locked(), true)
}

///|
test "ReadableStream tee creates two branches" {
  let source = @js.new_empty_object()
  let stream = ReadableStream::new(source)
  let (branch1, branch2) = stream.tee()
  assert_eq(branch1.locked(), false)
  assert_eq(branch2.locked(), false)
}

///|
test "WritableStream basic properties" {
  let sink = @js.new_empty_object()
  let stream = WritableStream::new(sink)
  assert_eq(stream.locked(), false)
}

///|
test "WritableStream get_writer locks stream" {
  let sink = @js.new_empty_object()
  let stream = WritableStream::new(sink)
  let _writer = stream.get_writer()
  assert_eq(stream.locked(), true)
}

///|
test "ReadableStreamDefaultReader releaseLock unlocks stream" {
  let source = @js.new_empty_object()
  let stream = ReadableStream::new(source)
  let reader = stream.get_reader()
  assert_eq(stream.locked(), true)
  reader.release_lock()
  assert_eq(stream.locked(), false)
}

///|
test "WritableStreamDefaultWriter releaseLock unlocks stream" {
  let sink = @js.new_empty_object()
  let stream = WritableStream::new(sink)
  let writer = stream.get_writer()
  assert_eq(stream.locked(), true)
  writer.release_lock()
  assert_eq(stream.locked(), false)
}

///|
test "ReadableStream getReader alias" {
  let source = @js.new_empty_object()
  let stream = ReadableStream::new(source)
  let _reader = stream.getReader()
  assert_eq(stream.locked(), true)
}

///|
test "WritableStream getWriter alias" {
  let sink = @js.new_empty_object()
  let stream = WritableStream::new(sink)
  let _writer = stream.getWriter()
  assert_eq(stream.locked(), true)
}

///|
test "ReadableStreamDefaultReader releaseLock alias" {
  let source = @js.new_empty_object()
  let stream = ReadableStream::new(source)
  let reader = stream.get_reader()
  reader.releaseLock()
  assert_eq(stream.locked(), false)
}

///|
test "WritableStreamDefaultWriter releaseLock alias" {
  let sink = @js.new_empty_object()
  let stream = WritableStream::new(sink)
  let writer = stream.get_writer()
  writer.releaseLock()
  assert_eq(stream.locked(), false)
}
