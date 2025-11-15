///|
using @js {unsafe_cast}

///|
test "URL constructor with absolute URL" {
  let url = URL::new("https://example.com/path?query=value#hash")
  assert_eq(url.protocol(), "https:")
  assert_eq(url.hostname(), "example.com")
  assert_eq(url.pathname(), "/path")
  assert_eq(url.search(), "?query=value")
  assert_eq(url.hash(), "#hash")
}

///|
test "URL constructor with base" {
  let url = URL::new("/path", base="https://example.com")
  assert_eq(url.href(), "https://example.com/path")
  assert_eq(url.origin(), "https://example.com")
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
    Some(u) => assert_eq(u.hostname(), "example.com")
    None => fail("Should parse valid URL")
  }
  let invalid = URL::parse("not a url")
  match invalid {
    Some(_) => fail("Should not parse invalid URL")
    None => ()
  }
}

///|
test "URL properties" {
  let url = URL::new("https://user:pass@example.com:8080/path?query=value#hash")
  assert_eq(url.protocol(), "https:")
  assert_eq(url.username(), "user")
  assert_eq(url.password(), "pass")
  assert_eq(url.hostname(), "example.com")
  assert_eq(url.port(), "8080")
  assert_eq(url.host(), "example.com:8080")
  assert_eq(url.pathname(), "/path")
  assert_eq(url.search(), "?query=value")
  assert_eq(url.hash(), "#hash")
  assert_eq(url.origin(), "https://example.com:8080")
}

///|
test "URL setters" {
  let url = URL::new("https://example.com")
  url.setProtocol("http:")
  assert_eq(url.protocol(), "http:")
  url.setHostname("newhost.com")
  assert_eq(url.hostname(), "newhost.com")
  url.setPort("3000")
  assert_eq(url.port(), "3000")
  url.setPathname("/newpath")
  assert_eq(url.pathname(), "/newpath")
  url.setSearch("?new=query")
  assert_eq(url.search(), "?new=query")
  url.setHash("#newhash")
  assert_eq(url.hash(), "#newhash")
}

///|
test "URL toString and toJSON" {
  let url = URL::new("https://example.com/path?query=value")
  let str = url.toString()
  assert_eq(str, "https://example.com/path?query=value")
  assert_eq(url.toJSON(), str)
  assert_eq(url.href(), str)
}

///|
test "URL username and password" {
  let url = URL::new("https://example.com")
  url.setUsername("testuser")
  assert_eq(url.username(), "testuser")
  url.setPassword("testpass")
  assert_eq(url.password(), "testpass")
  assert_eq(url.href().contains("testuser:testpass@"), true)
}

///|
test "URLSearchParams constructor" {
  let params = URLSearchParams::new(init="foo=bar&baz=qux")
  match params.get("foo") {
    Some(v) => assert_eq(v, "bar")
    None => fail("Should have foo parameter")
  }
  match params.get("baz") {
    Some(v) => assert_eq(v, "qux")
    None => fail("Should have baz parameter")
  }
}

///|
test "URLSearchParams append and get" {
  let params = URLSearchParams::new()
  params.append("key", "value1")
  params.append("key", "value2")
  match params.get("key") {
    Some(v) => assert_eq(v, "value1") // get returns first value
    None => fail("Should have key parameter")
  }
  let all = params.getAll("key")
  assert_eq(all.length(), 2)
  assert_eq(all[0], "value1")
  assert_eq(all[1], "value2")
}

///|
test "URLSearchParams set" {
  let params = URLSearchParams::new()
  params.append("key", "value1")
  params.append("key", "value2")
  params.set("key", "newvalue")
  let all = params.getAll("key")
  assert_eq(all.length(), 1)
  assert_eq(all[0], "newvalue")
}

///|
test "URLSearchParams has" {
  let params = URLSearchParams::new(init="foo=bar&baz=qux")
  assert_eq(params.has("foo"), true)
  assert_eq(params.has("missing"), false)
}

///|
test "URLSearchParams delete" {
  let params = URLSearchParams::new(init="foo=bar&baz=qux")
  params.delete("foo")
  assert_eq(params.has("foo"), false)
  assert_eq(params.has("baz"), true)
}

///|
test "URLSearchParams toString" {
  let params = URLSearchParams::new()
  params.append("foo", "bar")
  params.append("baz", "qux")
  let str = params.toString()
  assert_eq(str, "foo=bar&baz=qux")
}

///|
test "URLSearchParams sort" {
  let params = URLSearchParams::new()
  params.append("z", "1")
  params.append("a", "2")
  params.append("m", "3")
  params.sort()
  let str = params.toString()
  assert_eq(str, "a=2&m=3&z=1")
}

///|
test "URL searchParams integration" {
  let url = URL::new("https://example.com?foo=bar")
  let params = url.searchParams()
  match params.get("foo") {
    Some(v) => assert_eq(v, "bar")
    None => fail("Should have foo parameter")
  }
  params.append("baz", "qux")
  assert_eq(url.search().contains("baz=qux"), true)
}

///|
test "URLSearchParams size" {
  let params = URLSearchParams::new()
  assert_eq(params.size(), 0)
  params.append("foo", "bar")
  assert_eq(params.size(), 1)
  params.append("baz", "qux")
  assert_eq(params.size(), 2)
  params.delete("foo")
  assert_eq(params.size(), 1)
}

///|
test "URL special characters encoding" {
  let url = URL::new("https://example.com")
  url.setPathname("/path with spaces")
  assert_eq(url.pathname(), "/path%20with%20spaces")
  url.setSearch("?key=value with spaces")
  assert_eq(url.search().contains("value%20with%20spaces"), true)
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
  assert_eq(url.protocol(), "file:")
  assert_eq(url.pathname(), "/home/user/file.txt")
}

///|
test "fileURLToPath and pathToFileURL roundtrip" {
  let original_path = "/tmp/test.txt"
  let url = pathToFileURL(original_path)
  let path = fileURLToPathFromURL(url)
  assert_eq(path, original_path)
}

///|
test "format URL" {
  let url = URL::new("https://example.com/path?query=value#hash")
  let formatted = format(url)
  assert_eq(formatted, "https://example.com/path?query=value#hash")
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
