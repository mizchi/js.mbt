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
    "key": "v" |> @js.js,
    "name": "alice" |> @js.js,
    "verbose": true |> @js.js,
    "help": true |> @js.js,
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
