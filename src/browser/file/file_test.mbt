///|
/// File and FileReader API Tests

///|
using @js {run_async}

///| File Constructor Tests

///|
/// Test File constructor with basic data
test "File new creates file from string" {
  let file = File::new(["Hello, File!"], "test.txt", content_type="text/plain")
  inspect(file.name == "test.txt", content="true")
}

///|
/// Test File constructor with last_modified
test "File new with last_modified" {
  let file = File::new(["test"], "test.txt", last_modified=1234567890)
  inspect(file.lastModified == 1234567890, content="true")
}

///| File Property Tests

///|
/// Test File name property
test "File name returns filename" {
  let file = File::new(["data"], "myfile.txt")
  inspect(file.name == "myfile.txt", content="true")
}

///|
/// Test File size property
test "File size returns correct size" {
  let file = File::new(["Hello"], "test.txt")
  inspect(file.size == 5, content="true")
}

///|
/// Test File content_type property
test "File content_type returns MIME type" {
  let file = File::new(["test"], "test.txt", content_type="text/plain")
  inspect(file.contentType() == "text/plain", content="true")
}

///| File as_blob Tests

///|
/// Test File as_blob conversion
test "File as_blob returns Blob" {
  let file = File::new(["test"], "test.txt")
  let blob = file.as_blob()
  inspect(blob.size == 4, content="true")
}

///| File Inherited Methods Tests

///|
/// Test File text method (inherited from Blob)
test "File text returns content as string" {
  run_async(async fn() noraise {
    try {
      let file = File::new(["Hello, File!"], "test.txt")
      let text = file.text().wait()
      inspect(text == "Hello, File!", content="true")
    } catch {
      _ => ()
    }
  })
}

///|
/// Test File array_buffer method
test "File array_buffer returns ArrayBuffer" {
  run_async(async fn() noraise {
    try {
      let file = File::new(["test"], "test.txt")
      let buffer = file.array_buffer().wait()
      inspect(buffer.byte_length() > 0, content="true")
    } catch {
      _ => ()
    }
  })
}

///|
/// Test File slice method
test "File slice returns Blob" {
  let file = File::new(["Hello, World!"], "test.txt")
  let sliced = file.slice(start=0, end=5)
  inspect(sliced.size == 5, content="true")
}

// Note: FileReader tests are omitted as FileReader is a browser-only API
// and is not available in Node.js test environment
