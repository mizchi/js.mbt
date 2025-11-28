///|
/// ignore bindings tests

///|
test "ignore constructor" {
  let ig = @ignore.ignore()
  inspect(ig.to_any() |> @js.is_nullish |> not, content="true")
}

///|
test "ignore with options" {
  let ig = @ignore.ignore(ignorecase=true)
  inspect(ig.to_any() |> @js.is_nullish |> not, content="true")
}

///|
test "add single pattern" {
  let ig = @ignore.ignore()
  let _ = ig.add("*.log")
  inspect(ig.ignores("test.log"), content="true")
  inspect(ig.ignores("test.txt"), content="false")
}

///|
test "add multiple patterns" {
  let ig = @ignore.ignore()
  let _ = ig.addPatterns(["*.log", "*.tmp", "node_modules/"])
  inspect(ig.ignores("debug.log"), content="true")
  inspect(ig.ignores("cache.tmp"), content="true")
  inspect(ig.ignores("node_modules/package.json"), content="true")
  inspect(ig.ignores("src/main.js"), content="false")
}

///|
test "filter paths" {
  let ig = @ignore.ignore()
  let _ = ig.add("*.log")
  let paths = ["app.js", "error.log", "main.ts", "debug.log"]
  let filtered = ig.filter(paths)
  inspect(filtered.length(), content="2")
  inspect(filtered[0], content="app.js")
  inspect(filtered[1], content="main.ts")
}

///|
test "directory pattern" {
  let ig = @ignore.ignore()
  let _ = ig.add("build/")
  inspect(ig.ignores("build/output.js"), content="true")
  inspect(ig.ignores("src/build.js"), content="false")
}

///|
test "negation pattern" {
  let ig = @ignore.ignore()
  let _ = ig.addPatterns(["*.log", "!important.log"])
  inspect(ig.ignores("debug.log"), content="true")
  inspect(ig.ignores("important.log"), content="false")
}

///|
test "wildcard patterns" {
  let ig = @ignore.ignore()
  let _ = ig.add("**/*.test.js")
  inspect(ig.ignores("foo.test.js"), content="true")
  inspect(ig.ignores("src/bar.test.js"), content="true")
  inspect(ig.ignores("src/deep/baz.test.js"), content="true")
  inspect(ig.ignores("foo.js"), content="false")
}

///|
test "testPath method" {
  let ig = @ignore.ignore()
  let _ = ig.add("*.log")
  let result = ig.testPath("error.log")
  inspect(result.ignored(), content="true")
  inspect(result.unignored(), content="false")
}

///|
test "testPath method unignored" {
  let ig = @ignore.ignore()
  let _ = ig.addPatterns(["*.log", "!keep.log"])
  let result = ig.testPath("keep.log")
  inspect(result.ignored(), content="false")
  inspect(result.unignored(), content="true")
}

///|
test "isPathValid" {
  inspect(@ignore.isPathValid("src/main.js"), content="true")
  // Paths starting with ./ are not valid according to ignore package
  inspect(@ignore.isPathValid("relative/path"), content="true")
}

///|
test "chaining add" {
  let ig = @ignore.ignore().add("*.log").add("*.tmp").add("node_modules/")
  inspect(ig.ignores("error.log"), content="true")
  inspect(ig.ignores("cache.tmp"), content="true")
  inspect(ig.ignores("src/app.js"), content="false")
}

///|
test "gitignore content style" {
  let content = "# Comment line\n*.log\nbuild/\n!important.log"
  let ig = @ignore.ignore()
  let _ = ig.addFromContent(content)
  inspect(ig.ignores("debug.log"), content="true")
  inspect(ig.ignores("build/output.js"), content="true")
  inspect(ig.ignores("important.log"), content="false")
}
