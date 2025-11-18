///|
test "node:path join" {
  let path = join(["foo", "bar", "baz.txt"])
  assert_eq(path, "foo/bar/baz.txt")
  let path2 = join(["foo", "/bar", "baz"])
  assert_eq(path2, "foo/bar/baz")
  let path3 = join(["foo", "bar/", "baz"])
  assert_eq(path3, "foo/bar/baz")
}

///|
test "node:path dirname" {
  let dir = dirname("foo/bar/baz.txt")
  assert_eq(dir, "foo/bar")
  let dir2 = dirname("/foo/bar")
  assert_eq(dir2, "/foo")
  let dir3 = dirname("foo.txt")
  assert_eq(dir3, ".")
}

///|
test "node:path basename" {
  let name = basename("foo/bar/baz.txt")
  assert_eq(name, "baz.txt")
  let name2 = basename("foo/bar/baz.txt", suffix=".txt")
  assert_eq(name2, "baz")
  let name3 = basename("/foo/bar/")
  assert_eq(name3, "bar")
}

///|
test "node:path extname" {
  let ext = extname("foo/bar/baz.txt")
  assert_eq(ext, ".txt")
  let ext2 = extname("foo/bar/baz")
  assert_eq(ext2, "")
  let ext3 = extname("foo/bar/.hidden")
  assert_eq(ext3, "")
  let ext4 = extname("foo/bar/file.min.js")
  assert_eq(ext4, ".js")
}

///|
test "node:path isAbsolute" {
  assert_eq(isAbsolute("/foo/bar"), true)
  assert_eq(isAbsolute("foo/bar"), false)
  assert_eq(isAbsolute("./foo"), false)
  assert_eq(isAbsolute("../foo"), false)
}

///|
test "node:path normalize" {
  let norm1 = normalize("foo/bar//baz")
  assert_eq(norm1, "foo/bar/baz")
  let norm2 = normalize("foo/bar/../baz")
  assert_eq(norm2, "foo/baz")
  let norm3 = normalize("foo/./bar")
  assert_eq(norm3, "foo/bar")
  let norm4 = normalize("foo/../bar")
  assert_eq(norm4, "bar")
}

///|
test "node:path resolve" {
  // resolve is platform-dependent, so we test basic behavior
  let resolved = resolve(["/foo", "bar", "baz"])
  assert_eq(resolved.contains("/foo/bar/baz"), true)
  let resolved2 = resolve(["foo", "bar"])
  assert_eq(resolved2.contains("foo/bar"), true)
}

///|
test "node:path relative" {
  let rel = relative("/data/orandea/test/aaa", "/data/orandea/impl/bbb")
  assert_eq(rel, "../../impl/bbb")
  let rel2 = relative("/foo/bar", "/foo/bar/baz")
  assert_eq(rel2, "baz")
  let rel3 = relative("/foo/bar/baz", "/foo/bar")
  assert_eq(rel3, "..")
}

///|
test "node:path parse and format" {
  let parsed = parse("/home/user/dir/file.txt")
  assert_eq(parsed.root, "/")
  assert_eq(parsed.dir, "/home/user/dir")
  assert_eq(parsed.base, "file.txt")
  assert_eq(parsed.ext, ".txt")
  assert_eq(parsed.name, "file")
  let formatted = format(parsed)
  assert_eq(formatted, "/home/user/dir/file.txt")
}

///|
test "node:path ParsedPath::new" {
  let formatted = format({
    root: "/",
    dir: "/home/user",
    base: "file.txt",
    ext: ".txt",
    name: "file",
  })
  assert_eq(formatted, "/home/user/file.txt")
}

///|
test "node:path delimiter" {
  let delim = delimiter()
  // On Unix it's ':', on Windows it's ';'
  assert_eq(delim.length() > 0, true)
}

///|
test "node:path sep" {
  let separator = sep()
  // On Unix it's '/', on Windows it's '\\'
  assert_eq(separator.length() > 0, true)
}

///|
test "node:path toNamespacedPath" {
  // This is mainly for Windows, but should work on all platforms
  let namespaced = toNamespacedPath("/foo/bar")
  assert_eq(namespaced.length() > 0, true)
}

///|
test "node:path matchesGlob" {
  assert_eq(matchesGlob("foo/bar/baz.txt", "**/*.txt"), true)
  assert_eq(matchesGlob("foo/bar/baz.js", "**/*.txt"), false)
  assert_eq(matchesGlob("foo/bar.txt", "*.txt"), false) // doesn't match subdirs
  assert_eq(matchesGlob("bar.txt", "*.txt"), true)
}

///|
test "node:path complex scenarios" {
  // Test combining multiple operations
  let path1 = join(["foo", "bar", "baz.txt"])
  let dir = dirname(path1)
  let base = basename(path1)
  assert_eq(dir, "foo/bar")
  assert_eq(base, "baz.txt")
  let normalized = normalize(join(["foo", "./bar", "../baz"]))
  assert_eq(normalized, "foo/baz")
  let parsed = parse("/home/user/file.min.js")
  assert_eq(parsed.name, "file.min")
  assert_eq(parsed.ext, ".js")
}
