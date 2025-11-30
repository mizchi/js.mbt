///|

///|
test "URLPattern constructor with string pattern" {
  let pattern = URLPattern::new("https://example.com/books/:id")
  assert_eq(pattern.protocol, "https")
  assert_eq(pattern.hostname, "example.com")
  assert_eq(pattern.pathname, "/books/:id")
}

///|
test "URLPattern test method" {
  let pattern = URLPattern::new("https://example.com/books/:id")
  assert_eq(pattern.test_url("https://example.com/books/123"), true)
  assert_eq(pattern.test_url("https://example.com/books/"), false)
  assert_eq(pattern.test_url("https://other.com/books/123"), false)
}

///|
test "URLPattern exec method" {
  let pattern = URLPattern::new("https://example.com/books/:id")
  match pattern.exec("https://example.com/books/123") {
    Some(result) => {
      assert_eq(result.pathname.input, "/books/123")
      let id : String = @nostd.identity(result.pathname.groups["id"])
      assert_eq(id, "123")
    }
    None => fail("Should match the URL")
  }
}

///|
test "URLPattern exec returns None for non-matching URL" {
  let pattern = URLPattern::new("https://example.com/books/:id")
  match pattern.exec("https://other.com/books/123") {
    Some(_) => fail("Should not match")
    None => ()
  }
}

///|
test "URLPattern with wildcard" {
  let pattern = URLPattern::new("https://example.com/*")
  assert_eq(pattern.test_url("https://example.com/any/path"), true)
  assert_eq(pattern.test_url("https://example.com/"), true)
}

///|
test "URLPattern pathname pattern" {
  let pattern = URLPattern::new("https://example.com/books/:id")
  assert_eq(pattern.pathname, "/books/:id")
}

///|
test "URLPattern with search parameter" {
  let pattern = URLPattern::new("https://example.com/search?q=:query")
  assert_eq(pattern.test_url("https://example.com/search?q=test"), true)
  match pattern.exec("https://example.com/search?q=moonbit") {
    Some(result) => {
      let query : String = @nostd.identity(result.search.groups["query"])
      assert_eq(query, "moonbit")
    }
    None => fail("Should match the URL")
  }
}

///|
test "URLPattern with hash" {
  let pattern = URLPattern::new("https://example.com/page#:section")
  assert_eq(pattern.test_url("https://example.com/page#intro"), true)
  match pattern.exec("https://example.com/page#intro") {
    Some(result) => {
      let section : String = @nostd.identity(result.hash.groups["section"])
      assert_eq(section, "intro")
    }
    None => fail("Should match the URL")
  }
}

///|
test "URLPattern protocol property" {
  let pattern = URLPattern::new("https://example.com/path")
  assert_eq(pattern.protocol, "https")
}

///|
test "URLPattern hostname property" {
  let pattern = URLPattern::new("https://example.com/path")
  assert_eq(pattern.hostname, "example.com")
}

///|
test "URLPattern pathname property" {
  let pattern = URLPattern::new(
    "https://example.com/books/:id/chapters/:chapter",
  )
  assert_eq(pattern.pathname, "/books/:id/chapters/:chapter")
}

///|
test "URLPattern multiple path parameters" {
  let pattern = URLPattern::new(
    "https://example.com/books/:bookId/chapters/:chapterId",
  )
  match pattern.exec("https://example.com/books/42/chapters/3") {
    Some(result) => {
      let book_id : String = @nostd.identity(result.pathname.groups["bookId"])
      let chapter_id : String = @nostd.identity(
        result.pathname.groups["chapterId"],
      )
      assert_eq(book_id, "42")
      assert_eq(chapter_id, "3")
    }
    None => fail("Should match the URL")
  }
}

///|
test "URLPattern with port" {
  let pattern = URLPattern::new("https://example.com:8080/path")
  assert_eq(pattern.port, "8080")
  assert_eq(pattern.test_url("https://example.com:8080/path"), true)
  assert_eq(pattern.test_url("https://example.com/path"), false)
}
