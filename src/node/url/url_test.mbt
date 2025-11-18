///|
using @js {type Val, js, trait Js, unsafe_cast}

///|
using @weburl {type URL}

///|
test "URL constructor with absolute URL" {
  let url = URL::new("https://example.com/path?query=value#hash")
  assert_eq(url.protocol, "https:")
  assert_eq(url.hostname, "example.com")
  assert_eq(url.pathname, "/path")
  assert_eq(url.search, "?query=value")
  assert_eq(url.hash, "#hash")
}

///|
test "URL canParse" {
  assert_eq(URL::canParse("https://example.com"), true)
  assert_eq(URL::canParse("not a url"), false)
  assert_eq(URL::canParse("/path", base="https://example.com"), true)
}

///|
test "URL parse" {
  let url = URL::parse("https://example.com/path")
  match url {
    Some(u) => assert_eq(u.hostname, "example.com")
    None => fail("Should parse valid URL")
  }
  let invalid = URL::parse("not a url")
  match invalid {
    Some(_) => fail("Should not parse invalid URL")
    None => ()
  }
}

///|
test "fileURLToPath" {
  let file_url = "file:///home/user/file.txt"
  let path = fileURLToPath(file_url)
  assert_eq(path, "/home/user/file.txt")
}

///|
test "pathToFileURL" {
  let path = "/home/user/file.txt"
  let url = pathToFileURL(path)
  assert_eq(url.protocol, "file:")
  assert_eq(url.pathname, "/home/user/file.txt")
}

///|
test "fileURLToPath and pathToFileURL roundtrip" {
  let original_path = "/tmp/test.txt"
  let url = pathToFileURL(original_path)
  let path = fileURLToPathFromURL(url)
  assert_eq(path, original_path)
}

///|
test "urlToHttpOptions" {
  let url = URL::new("https://example.com:8080/path?query=value")
  let options = urlToHttpOptions(url)
  let protocol : String = unsafe_cast(options.get("protocol"))
  assert_eq(protocol, "https:")
  let hostname : String = unsafe_cast(options.get("hostname"))
  assert_eq(hostname, "example.com")
  // port is returned as a number in the options object
  let port : Int = unsafe_cast(options.get("port"))
  assert_eq(port, 8080)
  let pathname : String = unsafe_cast(options.get("pathname"))
  assert_eq(pathname, "/path")
}
