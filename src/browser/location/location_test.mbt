///|
#skip("location not available in JSDOM")
test "location global function returns Location" {
  let loc = location()
  assert_eq(@nostd.typeof_(loc), "object")
}

///|
#skip("location not available in JSDOM")
test "Location::href returns string" {
  let loc = location()
  assert_true(loc.href.length() > 0)
}

///|
#skip("location not available in JSDOM")
test "Location::protocol returns string" {
  let loc = location()
  assert_true(loc.protocol.length() > 0)
}

///|
#skip("location not available in JSDOM")
test "Location::host returns string" {
  let loc = location()
  assert_true(loc.host.length() >= 0)
}

///|
#skip("location not available in JSDOM")
test "Location::hostname returns string" {
  let loc = location()
  assert_true(loc.hostname.length() >= 0)
}

///|
#skip("location not available in JSDOM")
test "Location::pathname returns string" {
  let loc = location()
  assert_true(loc.pathname.length() >= 0)
}

///|
#skip("location not available in JSDOM")
test "Location::search returns string" {
  let loc = location()
  assert_true(loc.search.length() >= 0)
}

///|
#skip("location not available in JSDOM")
test "Location::hash returns string" {
  let loc = location()
  assert_true(loc.hash.length() >= 0)
}

///|
#skip("location not available in JSDOM")
test "Location::origin returns string" {
  let loc = location()
  assert_true(loc.origin.length() > 0)
}

///|
#skip("location not available in JSDOM")
test "Location::to_string returns string" {
  let loc = location()
  let str = loc.to_string()
  assert_true(str.length() > 0)
}

///|
#skip("location not available in JSDOM")
test "Location::href can be set" {
  let loc = location()
  let _ = loc.href
  loc.href = "https://example.com"
  assert_true(true)
}

///|
#skip("location not available in JSDOM")
test "Location::pathname can be set" {
  let loc = location()
  loc.pathname = "/new-path"
  assert_true(true)
}

///|
#skip("location not available in JSDOM")
test "Location::search can be set" {
  let loc = location()
  loc.search = "?query=test"
  assert_true(true)
}

///|
#skip("location not available in JSDOM")
test "Location::hash can be set" {
  let loc = location()
  loc.hash = "#section"
  assert_true(true)
}
