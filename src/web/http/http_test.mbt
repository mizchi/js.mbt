///|
/// Response body async reading tests

///|
async test "Response: read body as text" {
  let response = Response::new(body="Hello, async world!")

  // Read body as text
  let text_result : @core.Any = response.as_any()._call("text", [])
  let text_promise : @js.Promise[String] = text_result.cast()
  let text = text_promise.wait()
  assert_eq(text, "Hello, async world!")
}

///|
async test "Response: read body as JSON" {
  let json_str = "{\"name\":\"test\",\"value\":42}"
  let response = Response::new(body=json_str)

  // Read body as JSON
  let json_result : @core.Any = response.as_any()._call("json", [])
  let json_promise : @js.Promise[@core.Any] = json_result.cast()
  let json_obj = json_promise.wait()
  let name : String = @core.identity(json_obj._get("name"))
  let value : Int = @core.identity(json_obj._get("value"))
  assert_eq(name, "test")
  assert_eq(value, 42)
}

///|
async test "Response: read body stream chunk by chunk" {
  let response = Response::new(body="chunk1chunk2chunk3")
  let body = response.body()
  match body {
    Some(stream) => {
      let reader = stream.get_reader()
      defer reader.release_lock()
      let chunks : Array[String] = []

      // Read all chunks
      let mut done = false
      while not(done) {
        let result : @core.Any = reader.as_any()._call("read", [])
        let promise : @js.Promise[@core.Any] = result.cast()
        let data = promise.wait()
        done = @core.identity(data._get("done"))
        if not(done) {
          // Decode Uint8Array to string using TextDecoder from @encoding
          let value : @typedarray.Uint8Array = data._get("value").cast()
          let decoder = @encoding.TextDecoder::new()
          let text = decoder.decode(value)
          chunks.push(text)
        }
      }

      // Verify we got content
      assert_true(chunks.length() > 0)
    }
    None => fail("Response should have a body")
  }
}

///|
async test "Response: clone and read both bodies" {
  let response = Response::new(body="original content")
  let cloned = response.clone()

  // Read original
  let text1_result : @core.Any = response.as_any()._call("text", [])
  let text1_promise : @js.Promise[String] = text1_result.cast()
  let text1 = text1_promise.wait()

  // Read cloned
  let text2_result : @core.Any = cloned.as_any()._call("text", [])
  let text2_promise : @js.Promise[String] = text2_result.cast()
  let text2 = text2_promise.wait()
  assert_eq(text1, "original content")
  assert_eq(text2, "original content")
}

///|
async test "Response: read body multiple times fails after first read" {
  let response = Response::new(body="single read")

  // First read succeeds
  let text1_result : @core.Any = response.as_any()._call("text", [])
  let text1_promise : @js.Promise[String] = text1_result.cast()
  let text1 = text1_promise.wait()
  assert_eq(text1, "single read")

  // Second read should fail (body already consumed)
  // We can verify this by checking bodyUsed property
  let body_used : Bool = response.as_any()["bodyUsed"].cast()
  assert_eq(body_used, true)
}

///|
async test "Response: read large body in chunks" {
  // Create a larger response
  let mut large_content = ""
  let mut i = 0
  while i < 100 {
    large_content = large_content + "data\{i},"
    i = i + 1
  }
  let response = Response::new(body=large_content)
  let text_result : @core.Any = response.as_any()._call("text", [])
  let text_promise : @js.Promise[String] = text_result.cast()
  let text = text_promise.wait()
  assert_eq(text, large_content)
  assert_true(text.length() > 500)
}

///|
async test "Response: body stream with defer cleanup" {
  let response = Response::new(body="test cleanup")
  let body = response.body()
  match body {
    Some(stream) => {
      let reader = stream.get_reader()
      defer reader.release_lock()

      // Verify stream is locked
      assert_eq(stream.locked(), true)

      // Read one chunk
      let result : @core.Any = reader.as_any()._call("read", [])
      let promise : @js.Promise[@core.Any] = result.cast()
      let _data = promise.wait()

      // defer will automatically call release_lock
    }
    None => fail("Response should have a body")
  }
}

///|
async test "Response: arrayBuffer method" {
  let response = Response::new(body="buffer test")
  let buffer_result : @core.Any = response.as_any()._call("arrayBuffer", [])
  let buffer_promise : @js.Promise[@core.Any] = buffer_result.cast()
  let buffer = buffer_promise.wait()

  // Verify we got an ArrayBuffer
  let buffer_type = @core.typeof_(buffer)
  assert_eq(buffer_type, "object")

  // Get byte length
  let byte_length : Int = @core.identity(buffer._get("byteLength"))
  assert_true(byte_length > 0)
}

///|
async test "Response: blob method" {
  let response = Response::new(body="blob content")
  let blob_result : @core.Any = response.as_any()._call("blob", [])
  let blob_promise : @js.Promise[@core.Any] = blob_result.cast()
  let blob = blob_promise.wait()

  // Verify we got a Blob
  let blob_type = @core.typeof_(blob)
  assert_eq(blob_type, "object")

  // Get blob size
  let size : Int = @core.identity(blob._get("size"))
  assert_true(size > 0)
}
