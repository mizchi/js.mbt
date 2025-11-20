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
  assert_eq(url.origin(), "https://example.com")
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
// URL::can_parse is not implemented yet
// test "URL::can_parse - valid URLs" {
//   assert_true(URL::can_parse("https://example.com"))
//   assert_true(URL::can_parse("http://localhost:3000"))
//   assert_true(URL::can_parse("/path", base="https://example.com"))
// }

///|
// test "URL::can_parse - invalid URLs" {
//   assert_false(URL::can_parse("not a url"))
//   assert_false(URL::can_parse("://invalid"))
// }

///|
// test "URL::can_parse - relative URL without base" {
//   assert_false(URL::can_parse("/relative/path"))
// }

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
  assert_eq(params.get("foo"), Some("bar"))
  assert_eq(params.get("baz"), Some("qux"))
  assert_eq(params.get("missing"), None)
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
// URL::parse is not implemented yet
// test "URL::parse - valid URL" {
//   let url = URL::parse("https://example.com/path")
//   match url {
//     Some(u) => {
//       assert_eq(u.hostname, "example.com")
//       assert_eq(u.pathname, "/path")
//     }
//     None => assert_true(false)
//   }
// }

///|
// test "URL::parse - valid URL with base" {
//   let url = URL::parse("/path", base="https://example.com")
//   match url {
//     Some(u) => assert_eq(u.href, "https://example.com/path")
//     None => assert_true(false)
//   }
// }

///|
// test "URL::parse - invalid URL returns None" {
//   let url = URL::parse("not a valid url")
//   assert_eq(url, None)
// }

///|
// test "URL::parse - relative URL without base returns None" {
//   let url = URL::parse("/relative/path")
//   assert_eq(url, None)
// }
