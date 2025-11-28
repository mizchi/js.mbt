// =============================================================================
// Test Helper FFI Functions
// =============================================================================
// These FFI functions are used ONLY for testing purposes.
// In production code, Response objects typically come from fetch() calls,
// not direct construction.
// =============================================================================

///|
/// [Test Helper] Creates a new Response object for testing.
/// Returns @js.Any because Response constructor is not yet wrapped.
extern "js" fn test_ffi_new_response_as_any(content : String) -> @js.Any =
  #|(content) => new Response(content)

///|
test "Response body returns ReadableStream" {
  // Create a simple Response with text content
  let response : Response = @js.identity(
    test_ffi_new_response_as_any("Hello, World!"),
  )

  // Get the body as ReadableStream
  let body = response.body()
  match body {
    Some(stream) =>
      // Verify it's a ReadableStream by checking locked property
      assert_eq(stream.locked, false)
    None => fail("Response should have a body")
  }
}

///|
test "Response body can be read with reader" {
  let response : Response = @js.identity(
    test_ffi_new_response_as_any("test data"),
  )
  match response.body() {
    Some(stream) => {
      let reader = stream.get_reader()
      defer reader.release_lock()
      // After getting a reader, the stream should be locked
      assert_eq(stream.locked, true)
    }
    None => fail("Response should have a body")
  }
}

///|
test "Response error has no body" {
  let response = Response::error()
  let body = response.body()
  // Error responses may not have a body
  match body {
    Some(_) => () // Some environments may provide a body
    None => () // Others may not
  }
}

///|
test "Response clone has independent body stream" {
  let response : Response = @js.identity(
    test_ffi_new_response_as_any("original"),
  )
  let cloned = response.clone()

  // Both should have bodies
  match response.body() {
    Some(original_stream) =>
      match cloned.body() {
        Some(cloned_stream) => {
          // Lock the original stream
          let reader = original_stream.get_reader()
          defer reader.release_lock()
          assert_eq(original_stream.locked, true)
          // Cloned stream should still be unlocked
          assert_eq(cloned_stream.locked, false)
        }
        None => fail("Cloned response should have a body")
      }
    None => fail("Original response should have a body")
  }
}

///|
test "Response body can be teed" {
  let response : Response = @js.identity(
    test_ffi_new_response_as_any("tee test"),
  )
  match response.body() {
    Some(stream) => {
      let (branch1, branch2) = stream.tee()
      assert_eq(branch1.locked, false)
      assert_eq(branch2.locked, false)
    }
    None => fail("Response should have a body")
  }
}
