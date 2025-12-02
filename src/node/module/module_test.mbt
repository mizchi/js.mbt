///|
/// Node.js module API Tests

///| builtin_modules Tests

///|
/// Test builtin_modules returns array of module names
test "builtin_modules returns array" {
  let modules = builtinModules()
  inspect(modules.length() > 0, content="true")
}

///|
/// Test builtin_modules contains known core modules
test "builtin_modules contains fs" {
  let modules = builtinModules()
  let has_fs = modules.contains("fs")
  inspect(has_fs, content="true")
}

///| is_builtin Tests

///|
/// Test is_builtin returns true for core modules
test "is_builtin returns true for fs" {
  let result = isBuiltin("fs")
  inspect(result, content="true")
}

///|
/// Test is_builtin returns true for node: prefixed modules
test "is_builtin returns true for node:fs" {
  let result = isBuiltin("node:fs")
  inspect(result, content="true")
}

///|
/// Test is_builtin returns false for non-core modules
test "is_builtin returns false for non-core modules" {
  let result = isBuiltin("express")
  inspect(result == false, content="true")
}

///| createRequire Tests

///|
/// Test createRequire creates a require function
test "createRequire returns function" {
  let require_fn = createRequire("/tmp/test.js")
  let type_of = require_fn |> @nostd.typeof_()
  inspect(type_of == "function", content="true")
}

///| Compile Cache Tests

///|
/// Test enableCompileCache can be called
test "enableCompileCache API exists" {
  enableCompileCache()
  inspect(true, content="true")
}

///|
/// Test flushCompileCache can be called
test "flushCompileCache API exists" {
  flushCompileCache()
  inspect(true, content="true")
}

///|
/// Test getCompileCacheDir returns optional string
test "getCompileCacheDir API exists" {
  let _dir = getCompileCacheDir()
  inspect(true, content="true")
}

///| syncBuiltinESMExports Tests

///|
/// Test syncBuiltinESMExports can be called
test "syncBuiltinESMExports API exists" {
  syncBuiltinESMExports()
  inspect(true, content="true")
}

///| SourceMap Tests

///|
/// Test findSourceMap returns optional SourceMap
test "findSourceMap API exists" {
  let _source_map = findSourceMap("/nonexistent.js")
  inspect(true, content="true")
}

///| stripTypeScriptTypes Tests

///|
/// Test stripTypeScriptTypes removes type annotations (default strip mode)
test "stripTypeScriptTypes basic strip" {
  let ts_code = "const x: number = 42;"
  let js_code = stripTypeScriptTypes(ts_code)
  inspect(js_code.contains(": number") == false, content="true")
}

///|
/// Test stripTypeScriptTypes with interface
test "stripTypeScriptTypes removes interface" {
  let ts_code = "interface Foo { name: string; }"
  let js_code = stripTypeScriptTypes(ts_code)
  inspect(js_code.contains("interface") == false, content="true")
}

///|
/// Test stripTypeScriptTypes with explicit strip mode
test "stripTypeScriptTypes with strip mode" {
  let ts_code = "function greet(name: string): void { console.log(name); }"
  let js_code = stripTypeScriptTypes(ts_code, mode="strip")
  inspect(js_code.contains(": string") == false, content="true")
  inspect(js_code.contains(": void") == false, content="true")
}

///|
/// Test stripTypeScriptTypes with transform mode
test "stripTypeScriptTypes with transform mode" {
  let ts_code = "enum Color { Red, Green, Blue }"
  let js_code = stripTypeScriptTypes(ts_code, mode="transform")
  // transform mode should convert enum to JavaScript
  inspect(js_code.length() > 0, content="true")
}

///|
/// Test stripTypeScriptTypes preserves runtime code
test "stripTypeScriptTypes preserves code" {
  let ts_code = "const x: number = 42; console.log(x);"
  let js_code = stripTypeScriptTypes(ts_code)
  inspect(js_code.contains("42"), content="true")
  inspect(js_code.contains("console.log"), content="true")
}
