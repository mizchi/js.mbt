///|
/// Basic test for TrustedTypePolicyOptions
test "TrustedTypePolicyOptions::new creates default options" {
  let options = TrustedTypePolicyOptions::new()
  assert_true(options.create_html is None)
}

///|
/// Test TrustedTypePolicyOptions with create_html function
test "TrustedTypePolicyOptions::new with create_html" {
  let escape_fn = fn(s : String) -> String { s.replace(old="<", new="&lt;") }
  let options = TrustedTypePolicyOptions::new(create_html=Some(escape_fn))
  assert_false(options.create_html is None)
}
