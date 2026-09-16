///|
/// Basic test for TrustedTypePolicyOptions
test "TrustedTypePolicyOptions::new creates default options" {
  let options = TrustedTypePolicyOptions()
  assert_true(options.create_html is None)
}

///|
/// Test TrustedTypePolicyOptions with create_html function
test "TrustedTypePolicyOptions::new with create_html" {
  let escape_fn = fn(s : String) -> String { s.replace(old="<", new="&lt;") }
  let options = TrustedTypePolicyOptions(create_html=Some(escape_fn))
  assert_false(options.create_html is None)
}

// The types below (`TrustedTypePolicyFactory`, `TrustedTypePolicy`,
// `TrustedHTML`, ...) are opaque handles onto JS objects. They used to be
// declared as zero-field structs, which MoonBit treats as zero-sized: the
// value was erased when a function returned one, so every accessor here saw
// `undefined`. They are `#external` types now, and these tests pin that down.
// There is no real `window.trustedTypes` under `moon test`, so a stand-in
// factory stands in for it.

///|
/// A stand-in for the `trustedTypes` factory: `createPolicy` returns a policy
/// whose `createHTML` wraps the input.
extern "js" fn stub_factory() -> @core.Any =
  #| () => ({
  #|   createPolicy: (name, opts) => ({
  #|     name,
  #|     createHTML: (s) => ({ toString: () => (opts.createHTML ? opts.createHTML(s) : s) }),
  #|   }),
  #|   emptyHTML: { toString: () => "" },
  #| })

///|
test "policy handles survive being returned from a function" {
  let factory : TrustedTypePolicyFactory = stub_factory().cast()
  let policy = factory.createPolicy("my-policy", TrustedTypePolicyOptions())
  // before the fix `policy` was undefined and this threw
  assert_eq(policy.name(), "my-policy")
  let html = policy.createHTML("<b>hi</b>")
  assert_eq(html.to_string(), "<b>hi</b>")
}

///|
test "policy options are applied when creating HTML" {
  let factory : TrustedTypePolicyFactory = stub_factory().cast()
  let policy = factory.createPolicy(
    "escaping",
    TrustedTypePolicyOptions(create_html=Some(s => "safe(" + s + ")")),
  )
  assert_eq(policy.createHTML("<script>").to_string(), "safe(<script>)")
}

///|
test "emptyHTML round-trips as a handle" {
  let factory : TrustedTypePolicyFactory = stub_factory().cast()
  assert_eq(factory.emptyHTML().to_string(), "")
}
