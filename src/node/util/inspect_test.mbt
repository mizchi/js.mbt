///|
test "util:inspect" {
  let obj = @nostd.from_entries([
    ("xxx", @nostd.any("------------------------")),
    ("a", @nostd.any(1)),
    ("b", @nostd.any([1, 2, 3])),
    ("c", @nostd.from_entries([("d", @nostd.any("hello"))])),
  ])
  let s = @util.inspect(
    obj,
    depth=2,
    colors=false,
    compact=true,
    sorted=true,
    breakLength=80,
    maxArrayLength=10,
    maxStringLength=50,
  )
  @builtin.inspect(
    s,
    content="{ a: 1, b: [ 1, 2, 3 ], c: { d: 'hello' }, xxx: '------------------------' }",
  )
}

///|
test "util:inspect with depth" {
  let nested = @nostd.from_entries([
    ("a", @nostd.from_entries([
      ("b", @nostd.from_entries([
        ("c", @nostd.from_entries([("d", @nostd.any("deep"))])),
      ])),
    ])),
  ])

  // Shallow depth
  let s1 = @util.inspect(nested, depth=1, sorted=false)
  assert_eq(s1.contains("[Object]"), true)

  // Deep depth
  let s2 = @util.inspect(nested, depth=5, sorted=false)
  assert_eq(s2.contains("deep"), true)
}

///|
test "util:inspect with colors" {
  let obj = @nostd.from_entries([
    ("num", @nostd.any(123)),
    ("str", @nostd.any("hello")),
  ])

  // Without colors
  let s1 = @util.inspect(obj, colors=false, sorted=false)
  assert_eq(s1.length() > 0, true)

  // With colors (will have ANSI codes)
  let s2 = @util.inspect(obj, colors=true, sorted=false)
  assert_eq(s2.length() > 0, true)
}
