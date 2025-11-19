///|
using @js {js}

///|
test "util:inspect" {
  let obj : Json = {
    "xxx": "------------------------",
    "a": 1,
    "b": [1, 2, 3],
    "c": { "d": "hello" },
  }
  let s = @util.inspect(
    @js.from_builtin_json(obj),
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
  let nested : Json = { "a": { "b": { "c": { "d": "deep" } } } }

  // Shallow depth
  let s1 = @util.inspect(@js.from_builtin_json(nested), depth=1, sorted=false)
  assert_eq(s1.contains("[Object]"), true)

  // Deep depth
  let s2 = @util.inspect(@js.from_builtin_json(nested), depth=5, sorted=false)
  assert_eq(s2.contains("deep"), true)
}

///|
test "util:inspect with colors" {
  let obj : Json = { "num": 123, "str": "hello" }

  // Without colors
  let s1 = @util.inspect(@js.from_builtin_json(obj), colors=false, sorted=false)
  assert_eq(s1.length() > 0, true)

  // With colors (will have ANSI codes)
  let s2 = @util.inspect(@js.from_builtin_json(obj), colors=true, sorted=false)
  assert_eq(s2.length() > 0, true)
}
