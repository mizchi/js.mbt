///|
#skip("history not available in JSDOM")
test "history global function returns History" {
  let h = history()
  assert_true(@js.is_object(h.to_js()))
}

///|
#skip("history not available in JSDOM")
test "History::length returns non-negative number" {
  let h = history()
  assert_true(h.length >= 0)
}

///|
#skip("history not available in JSDOM")
test "History::state can be accessed" {
  let h = history()
  let _ = h.state
  // Just verify it doesn't throw
  assert_true(true)
}

///|
#skip("history not available in JSDOM")
test "History::pushState and replaceState work" {
  let h = history()
  let state = @js.Object::new().to_js()
  h.pushState(state, "")
  h.replaceState(state, "")
  assert_true(true)
}

///|
#skip("history not available in JSDOM")
test "History::scrollRestoration can be accessed" {
  let h = history()
  let _ = h.scrollRestoration
  // Just verify it doesn't throw
  assert_true(true)
}

///|
#skip("history not available in JSDOM")
test "History::scrollRestoration can be set" {
  let h = history()
  h.scrollRestoration = "manual"
  assert_true(true)
}
