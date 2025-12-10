///|
async test "minify simple code" {
  let code = "function add(a, b) { return a + b; }"
  let result = @terser.minify(code)
  // Minified code should be shorter
  assert_true(result.code.length() < code.length())
  // Should still be valid JS (contains return)
  assert_true(result.code.contains("return"))
}

///|
async test "minify with source map" {
  let code = "function hello() { console.log('hello'); }"
  let options = @terser.MinifyOptions::{
    ..@terser.MinifyOptions::default(),
    sourceMap: true,
  }
  let result = @terser.minify(code, options~)
  assert_true(result.code.length() < code.length())
  assert_true(result.map is Some(_))
}

///|
async test "minify without mangle" {
  let code = "function myLongFunctionName() { return 42; }"
  let options = @terser.MinifyOptions::{
    ..@terser.MinifyOptions::default(),
    mangle: false,
  }
  let result = @terser.minify(code, options~)
  // Function name should be preserved
  assert_true(result.code.contains("myLongFunctionName"))
}

///|
test "minify_sync" {
  let code = "function subtract(x, y) { return x - y; }"
  let result = @terser.minify_sync(code)
  assert_true(result.code.length() < code.length())
}

///|
async test "minify_simple" {
  let code = "const x = 1; const y = 2; console.log(x + y);"
  let minified = @terser.minify_simple(code)
  assert_true(minified.length() < code.length())
}
