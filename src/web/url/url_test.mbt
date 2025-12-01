///|
test "URL::new - basic URL parsing" {
  let url = URL::new("https://example.com/path")
  assert_eq(url.protocol, "https:")
  assert_eq(url.hostname, "example.com")
  assert_eq(url.pathname, "/path")
  assert_eq(url.href, "https://example.com/path")
}

///|
test "URL::new - with base URL" {
  let url = URL::new("/path", base="https://example.com")
  assert_eq(url.href, "https://example.com/path")
  assert_eq(url.origin, "https://example.com")
}

///|
test "URL::new - with query string" {
  let url = URL::new("https://example.com/path?foo=bar&baz=qux")
  assert_eq(url.search, "?foo=bar&baz=qux")
  assert_eq(url.pathname, "/path")
}

///|
test "URL::new - with hash" {
  let url = URL::new("https://example.com/path#section")
  assert_eq(url.hash, "#section")
  assert_eq(url.pathname, "/path")
}

///|
test "URL::new - with port" {
  let url = URL::new("https://example.com:8080/path")
  assert_eq(url.port, "8080")
  assert_eq(url.host, "example.com:8080")
  assert_eq(url.hostname, "example.com")
}

///|
test "URL::new - with username and password" {
  let url = URL::new("https://user:pass@example.com/path")
  assert_eq(url.username, "user")
  assert_eq(url.password, "pass")
}

///|
test "URL::new - complete URL" {
  let url = URL::new(
    "https://user:pass@example.com:8080/path?query=value#fragment",
  )
  assert_eq(url.protocol, "https:")
  assert_eq(url.username, "user")
  assert_eq(url.password, "pass")
  assert_eq(url.hostname, "example.com")
  assert_eq(url.port, "8080")
  assert_eq(url.pathname, "/path")
  assert_eq(url.search, "?query=value")
  assert_eq(url.hash, "#fragment")
}

///|
test "URL - origin property" {
  let url1 = URL::new("https://example.com:8080/path")
  assert_eq(url1.origin, "https://example.com:8080")
  let url2 = URL::new("http://localhost/test")
  assert_eq(url2.origin, "http://localhost")
}

///|
test "URL - searchParams integration" {
  let url = URL::new("https://example.com?foo=bar&baz=qux")
  let params = url.searchParams
  assert_eq(params._get("foo"), Some("bar"))
  assert_eq(params._get("baz"), Some("qux"))
  assert_eq(params._get("missing"), None)
}

///|
test "URL - different protocols" {
  let http = URL::new("http://example.com")
  assert_eq(http.protocol, "http:")
  let https = URL::new("https://example.com")
  assert_eq(https.protocol, "https:")
  let ftp = URL::new("ftp://example.com")
  assert_eq(ftp.protocol, "ftp:")
}

///|
test "URL - empty components" {
  let url = URL::new("https://example.com")
  assert_eq(url.pathname, "/")
  assert_eq(url.search, "")
  assert_eq(url.hash, "")
  assert_eq(url.username, "")
  assert_eq(url.password, "")
  assert_eq(url.port, "")
}

///|
test "URL - IPv6 hostname" {
  let url = URL::new("http://[::1]:8080/path")
  assert_eq(url.hostname, "[::1]")
  assert_eq(url.port, "8080")
  assert_eq(url.host, "[::1]:8080")
}

///|
test "URL - encoded characters" {
  let url = URL::new(
    "https://example.com/path%20with%20spaces?query=hello%20world",
  )
  assert_eq(url.pathname, "/path%20with%20spaces")
  assert_eq(url.search, "?query=hello%20world")
}

///|
test "URL - trailing slash" {
  let url1 = URL::new("https://example.com")
  let url2 = URL::new("https://example.com/")
  assert_eq(url1.pathname, "/")
  assert_eq(url2.pathname, "/")
}

///|
test "URL::to_string - returns href" {
  let url = URL::new(
    "https://user:pass@example.com:8080/path?query=value#fragment",
  )
  let str = url.to_string()
  assert_eq(str, "https://user:pass@example.com:8080/path?query=value#fragment")
}

///|
test "URL::to_json - returns serialized URL" {
  let url = URL::new("https://example.com/path")
  let json = url.to_json()
  assert_eq(json, "https://example.com/path")
}

///|
test "URL::new - throws on invalid URL" {
  let result = try? URL::new("not a valid url")
  match result {
    Err(_) => assert_true(true)
    Ok(_) => fail("Expected URL::new to throw on invalid URL")
  }
}

///|
test "URL::new - throws on invalid base URL" {
  let result = try? URL::new("/path", base="not a valid base")
  match result {
    Err(_) => assert_true(true)
    Ok(_) => fail("Expected URL::new to throw on invalid base URL")
  }
}
