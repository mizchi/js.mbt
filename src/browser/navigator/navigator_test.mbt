///|
#skip("navigator not available in JSDOM")
test "navigator global function returns Navigator" {
  let nav = navigator()
  assert_true(@js.is_object(nav.to_js()))
}

///|
#skip("navigator not available in JSDOM")
test "Navigator::userAgent returns string" {
  let nav = navigator()
  let ua = nav.userAgent
  assert_true(ua.length() > 0)
}

///|
#skip("navigator not available in JSDOM")
test "Navigator::onLine returns boolean" {
  let nav = navigator()
  let _ = nav.onLine
  // Just verify it doesn't throw
  assert_true(true)
}

///|
#skip("navigator not available in JSDOM")
test "Navigator::language returns string" {
  let nav = navigator()
  let lang = nav.language
  assert_true(lang.length() > 0)
}

///|
#skip("navigator not available in JSDOM")
test "Navigator::languages returns Js" {
  let nav = navigator()
  let langs = nav.languages
  assert_true(@js.is_array(langs))
}

///|
#skip("navigator not available in JSDOM")
test "Navigator::platform returns string" {
  let nav = navigator()
  let platform = nav.platform
  assert_true(platform.length() >= 0)
}

///|
#skip("navigator not available in JSDOM")
test "Navigator::hardwareConcurrency returns positive number" {
  let nav = navigator()
  let cores = nav.hardwareConcurrency
  assert_true(cores > 0)
}

///|
#skip("navigator not available in JSDOM")
test "Navigator::cookieEnabled returns boolean" {
  let nav = navigator()
  let _ = nav.cookieEnabled
  // Just verify it doesn't throw
  assert_true(true)
}
