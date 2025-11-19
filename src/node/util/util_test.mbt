///|
using @js {js}

///|
test "util:inspect" {
  let util = Util::require()
  let obj : Json = {
    "xxx": "------------------------",
    "a": 1,
    "b": [1, 2, 3],
    "c": { "d": "hello" },
  }
  let s = util.inspect(
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
  let util = Util::require()
  let nested : Json = { "a": { "b": { "c": { "d": "deep" } } } }

  // Shallow depth
  let s1 = util.inspect(@js.from_builtin_json(nested), depth=1, sorted=false)
  assert_eq(s1.contains("[Object]"), true)

  // Deep depth
  let s2 = util.inspect(@js.from_builtin_json(nested), depth=5, sorted=false)
  assert_eq(s2.contains("deep"), true)
}

///|
test "util:inspect with colors" {
  let util = Util::require()
  let obj : Json = { "num": 123, "str": "hello" }

  // Without colors
  let s1 = util.inspect(@js.from_builtin_json(obj), colors=false, sorted=false)
  assert_eq(s1.length() > 0, true)

  // With colors (will have ANSI codes)
  let s2 = util.inspect(@js.from_builtin_json(obj), colors=true, sorted=false)
  assert_eq(s2.length() > 0, true)
}

///|
test "util:inspect_" {
  let simple : Json = { "x": 1, "y": 2 }
  let result = inspect_(
    @js.from_builtin_json(simple),
    depth=2,
    colors=false,
    sorted=false,
  )
  assert_eq(result.contains("x"), true)
  assert_eq(result.contains("1"), true)
}

///|
test "parse_args" {
  let res = parseArgs(
    args=[
      "--name", "alice", "--verbose", "-k", "v", "-h", "file1.txt", "file2.txt",
    ],
    options=[
      String(key="key", short="k", multiple=false, default=None),
      String(key="name", short="n", multiple=false, default=None),
      Boolean(key="verbose", short="v"),
      Boolean(key="help", short="h"),
    ],
    allow_positionals=true,
  )
  assert_eq(res.values, {
    "key": "v" |> js,
    "name": "alice" |> js,
    "verbose": true |> js,
    "help": true |> js,
  })
  assert_eq(res.positionals, ["file1.txt", "file2.txt"])
}

///|
test "parse_args with empty options" {
  let res = parseArgs(
    args=["file1.txt", "file2.txt"],
    options=[],
    allow_positionals=true,
  )
  assert_eq(res.values.is_empty(), true)
  assert_eq(res.positionals, ["file1.txt", "file2.txt"])
}
