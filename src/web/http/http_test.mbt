///|
/// Response body async reading tests

// =============================================================================
// Test Helper FFI Functions
// =============================================================================
// These FFI functions are used ONLY for testing purposes.
// They provide functionality that is either:
// 1. Not yet wrapped in the library's public API
// 2. Needed to create test fixtures (like Response objects)
//
// In production code, you would typically receive Response objects from
// fetch() or other Web APIs, not construct them directly.
// =============================================================================

///|
/// [Test Helper] Creates a new Response object with the given content.
/// In real applications, Response objects come from fetch() or similar APIs.
extern "js" fn test_ffi_new_response(content : String) -> Response =
  #|(content) => new Response(content)

///|
async test "Response: read body as text" {
  let response = test_ffi_new_response("Hello, async world!")

  // Read body as text
  let text_result : @js.Any = response.to_any().call0("text")
  let text_promise : @js.Promise[String] = @js.identity(text_result)
  let text = text_promise.wait()
  assert_eq(text, "Hello, async world!")
}

///|
async test "Response: read body as JSON" {
  let json_str = "{\"name\":\"test\",\"value\":42}"
  let response = test_ffi_new_response(json_str)

  // Read body as JSON
  let json_result : @js.Any = response.to_any().call0("json")
  let json_promise : @js.Promise[@js.Any] = @js.identity(json_result)
  let json_obj = json_promise.wait()
  let name : String = @js.identity(json_obj.get("name"))
  let value : Int = @js.identity(json_obj.get("value"))
  assert_eq(name, "test")
  assert_eq(value, 42)
}

///|
async test "Response: read body stream chunk by chunk" {
  let response = test_ffi_new_response("chunk1chunk2chunk3")
  let body = response.body()
  match body {
    Some(stream) => {
      let reader = stream.get_reader()
      defer reader.release_lock()
      let chunks : Array[String] = []

      // Read all chunks
      let mut done = false
      while not(done) {
        let result : @js.Any = reader.to_any().call0("read")
        let promise : @js.Promise[@js.Any] = @js.identity(result)
        let data = promise.wait()
        done = @js.identity(data.get("done"))
        if not(done) {
          // Decode Uint8Array to string using TextDecoder from @encoding
          let value : @typedarray.Uint8Array = data.get("value").cast()
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
  let response = test_ffi_new_response("original content")
  let cloned = response.clone()

  // Read original
  let text1_result : @js.Any = response.to_any().call0("text")
  let text1_promise : @js.Promise[String] = @js.identity(text1_result)
  let text1 = text1_promise.wait()

  // Read cloned
  let text2_result : @js.Any = cloned.to_any().call0("text")
  let text2_promise : @js.Promise[String] = @js.identity(text2_result)
  let text2 = text2_promise.wait()
  assert_eq(text1, "original content")
  assert_eq(text2, "original content")
}

///|
async test "Response: read body multiple times fails after first read" {
  let response = test_ffi_new_response("single read")

  // First read succeeds
  let text1_result : @js.Any = response.to_any().call0("text")
  let text1_promise : @js.Promise[String] = @js.identity(text1_result)
  let text1 = text1_promise.wait()
  assert_eq(text1, "single read")

  // Second read should fail (body already consumed)
  // We can verify this by checking bodyUsed property
  let body_used : Bool = @js.identity(response.to_any().get("bodyUsed"))
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
  let response = test_ffi_new_response(large_content)
  let text_result : @js.Any = response.to_any().call0("text")
  let text_promise : @js.Promise[String] = @js.identity(text_result)
  let text = text_promise.wait()
  assert_eq(text, large_content)
  assert_true(text.length() > 500)
}

///|
async test "Response: body stream with defer cleanup" {
  let response = test_ffi_new_response("test cleanup")
  let body = response.body()
  match body {
    Some(stream) => {
      let reader = stream.get_reader()
      defer reader.release_lock()

      // Verify stream is locked
      assert_eq(stream.locked, true)

      // Read one chunk
      let result : @js.Any = reader.to_any().call0("read")
      let promise : @js.Promise[@js.Any] = @js.identity(result)
      let _data = promise.wait()

      // defer will automatically call release_lock
    }
    None => fail("Response should have a body")
  }
}

///|
async test "Response: arrayBuffer method" {
  let response = test_ffi_new_response("buffer test")
  let buffer_result : @js.Any = response.to_any().call0("arrayBuffer")
  let buffer_promise : @js.Promise[@js.Any] = @js.identity(buffer_result)
  let buffer = buffer_promise.wait()

  // Verify we got an ArrayBuffer
  let buffer_type = @js.typeof_(buffer)
  assert_eq(buffer_type, "object")

  // Get byte length
  let byte_length : Int = @js.identity(buffer.get("byteLength"))
  assert_true(byte_length > 0)
}

///|
async test "Response: blob method" {
  let response = test_ffi_new_response("blob content")
  let blob_result : @js.Any = response.to_any().call0("blob")
  let blob_promise : @js.Promise[@js.Any] = @js.identity(blob_result)
  let blob = blob_promise.wait()

  // Verify we got a Blob
  let blob_type = @js.typeof_(blob)
  assert_eq(blob_type, "object")

  // Get blob size
  let size : Int = @js.identity(blob.get("size"))
  assert_true(size > 0)
}
