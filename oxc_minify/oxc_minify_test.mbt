///|
test "minify - basic" {
  let input = "const   x   =   1   +   2;"
  let output = minify(input)
  // oxc-minify does constant folding: 1+2 -> 3
  assert_eq(output, "const x=3;")
}

///|
test "minify_sync - with filename" {
  let input = "function hello() { return 'world'; }"
  let result = minify_sync("test.js", input)
  assert_true(result.code.length() < input.length())
  assert_eq(result.errors.length(), 0)
}

///|
test "minify - removes whitespace" {
  let input = "const    a    =    1    ;"
  let output = minify(input)
  assert_true(not(output.contains("    ")))
}

///|
test "minify - preserves semantics" {
  let input = "function add(a, b) { return a + b; }"
  let output = minify(input)
  // Function should still be defined
  assert_true(output.contains("return"))
}
