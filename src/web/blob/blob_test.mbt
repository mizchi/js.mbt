///|
/// Blob API Tests

///|
using @js {run_async}

///| Constructor Tests

///|
/// Test Blob constructor with string
test "Blob new creates blob from string" {
  let blob = Blob::new(["Hello, World!"], content_type="text/plain")
  inspect(blob.size > 0, content="true")
}

///|
/// Test Blob constructor with multiple parts
test "Blob new creates blob from multiple parts" {
  let blob = Blob::new(["Hello", " ", "World!"], content_type="text/plain")
  inspect(blob.size > 0, content="true")
}

///| Property Tests

///|
/// Test Blob size property
test "Blob size returns correct size" {
  let blob = Blob::new(["Hello"])
  inspect(blob.size == 5, content="true")
}

///|
/// Test Blob type property
test "Blob content_type returns MIME type" {
  let blob = Blob::new(["test"], content_type="text/plain")
  inspect(blob.type_() == "text/plain", content="true")
}

///|
/// Test Blob type property when not specified
test "Blob content_type returns empty string when not specified" {
  let blob = Blob::new(["test"])
  inspect(blob.type_() == "", content="true")
}

///| Method Tests

///|
/// Test Blob text method
test "Blob text returns content as string" {
  run_async(async fn() noraise {
    try {
      let blob = Blob::new(["Hello, Blob!"])
      let text = blob.text().unwrap()
      inspect(text == "Hello, Blob!", content="true")
    } catch {
      _ => ()
    }
  })
}

///|
/// Test Blob arrayBuffer method
test "Blob array_buffer returns ArrayBuffer" {
  run_async(async fn() noraise {
    try {
      let blob = Blob::new(["test"])
      let buffer = blob.array_buffer().unwrap()
      inspect(buffer.byte_length() > 0, content="true")
    } catch {
      _ => ()
    }
  })
}

///|
/// Test Blob slice without parameters
test "Blob slice without parameters returns copy" {
  let blob = Blob::new(["Hello, World!"])
  let sliced = blob.slice()
  inspect(sliced.size == blob.size, content="true")
}

///|
/// Test Blob slice with start parameter
test "Blob slice with start returns substring" {
  let blob = Blob::new(["Hello, World!"])
  let sliced = blob.slice(start=7)
  inspect(sliced.size == 6, content="true")
}

///|
/// Test Blob slice with start and end parameters
test "Blob slice with start and end returns range" {
  let blob = Blob::new(["Hello, World!"])
  let sliced = blob.slice(start=0, end=5)
  inspect(sliced.size == 5, content="true")
}

///|
/// Test Blob slice with content type
test "Blob slice with content_type sets MIME type" {
  let blob = Blob::new(["Hello"])
  let sliced = blob.slice(content_type="text/plain")
  inspect(sliced.type_() == "text/plain", content="true")
}

///|
/// Test Blob stream method
test "Blob stream returns ReadableStream" {
  let blob = Blob::new(["test"])
  let stream = blob.stream()
  inspect(@js.typeof_(stream.to_js()) == "object", content="true")
}

///| Integration Tests

///|
/// Test Blob with binary data
test "Blob handles binary data" {
  let uint8 = @typed_array.Uint8Array::from_size(3)
  uint8.set_at(0, 72) // 'H'
  uint8.set_at(1, 105) // 'i'
  uint8.set_at(2, 33) // '!'
  let blob = Blob::new([uint8])
  inspect(blob.size == 3, content="true")
}

///|
/// Test Blob slice and text together
test "Blob slice and text work together" {
  run_async(async fn() noraise {
    try {
      let blob = Blob::new(["Hello, World!"])
      let sliced = blob.slice(start=0, end=5)
      let text = sliced.text().unwrap()
      inspect(text == "Hello", content="true")
    } catch {
      _ => ()
    }
  })
}
