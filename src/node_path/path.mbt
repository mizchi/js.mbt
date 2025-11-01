pub(all) struct NodePath {
  join: (String, String) -> String
  dirname: (String) -> String
  basename: (String) -> String
  extname: (String) -> String
  isAbsolute: (String) -> Bool
}

pub fn NodePath::require() -> NodePath {
  @module.require("node:path").cast()
}

test "node:path join and dirname" {
  let { join, dirname, .. } = NodePath::require()
  let path = join("foo", "bar/baz.txt")
  assert_eq(path, "foo/bar/baz.txt")
  let dir = dirname(path)
  assert_eq(dir, "foo/bar")
}