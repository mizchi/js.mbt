///|
/// Test runInThisContext
test "runInThisContext basic execution" {
  let result = runInThisContext("1 + 1")
  inspect(result, content="2")
}

///|
/// Test runInThisContext with variable
test "runInThisContext with global variable" {
  let result = runInThisContext("typeof globalThis")
  inspect(result, content="object")
}

///|
/// Test runInNewContext
test "runInNewContext basic execution" {
  let result = runInNewContext("1 + 1")
  inspect(result, content="2")
}

///|
/// Test runInNewContext with context object
test "runInNewContext with context" {
  let context = @nostd.from_entries([("x", @nostd.any(42))]).cast()
  let result = runInNewContext("x * 2", contextObject=context)
  inspect(result, content="84")
}

///|
/// Test createContext
test "createContext creates context" {
  let context = createContext()
  inspect(context |> @js.typeof_, content="object")
}

///|
/// Test createContext with object
test "createContext with initial object" {
  let obj = @nostd.from_entries([("foo", @nostd.any("bar"))]).cast()
  let context = createContext(contextObject=obj)
  inspect(context |> @js.typeof_, content="object")
}

///|
/// Test isContext
test "isContext on regular object" {
  let obj = @nostd.from_entries([("foo", @nostd.any("bar"))]).cast()
  let result = isContext(obj)
  inspect(result, content="false")
}

///|
/// Test isContext on contextified object
test "isContext on contextified object" {
  let context = createContext()
  let result = isContext(context)
  inspect(result, content="true")
}

///|
/// Test runInContext
test "runInContext basic execution" {
  let context = createContext(
    contextObject=@nostd.from_entries([("x", @nostd.any(10))]).cast(),
  )
  let result = runInContext("x * 3", context)
  inspect(result, content="30")
}

///|
/// Test Script class creation
test "Script creation" {
  let script = Script::new("1 + 1")
  inspect(script |> @js.typeof_, content="object")
}

///|
/// Test Script::runInThisContext
test "Script runInThisContext" {
  let script = Script::new("2 + 3")
  let result = script.runInThisContext()
  inspect(result, content="5")
}

///|
/// Test Script::runInNewContext
test "Script runInNewContext" {
  let script = Script::new("a + b")
  let context = @nostd.from_entries([
    ("a", @nostd.any(10)),
    ("b", @nostd.any(20)),
  ]).cast()
  let result = script.runInNewContext(contextObject=context)
  inspect(result, content="30")
}

///|
/// Test Script::runInContext
test "Script runInContext" {
  let script = Script::new("x * y")
  let context = createContext(
    contextObject=@nostd.from_entries([
      ("x", @nostd.any(5)),
      ("y", @nostd.any(6)),
    ]).cast(),
  )
  let result = script.runInContext(context)
  inspect(result, content="30")
}

///|
/// Test Script can be reused
test "Script reuse" {
  let script = Script::new("value * 2")
  let ctx1 = createContext(
    contextObject=@nostd.from_entries([("value", @nostd.any(5))]).cast(),
  )
  let ctx2 = createContext(
    contextObject=@nostd.from_entries([("value", @nostd.any(10))]).cast(),
  )
  let result1 = script.runInContext(ctx1)
  let result2 = script.runInContext(ctx2)
  inspect(result1, content="10")
  inspect(result2, content="20")
}

///|
/// Test compileFunction
test "compileFunction basic" {
  let func = compileFunction("return a + b;", params=["a", "b"])
  inspect(func |> @js.typeof_, content="function")
}

///|
/// Test compileFunction execution
test "compileFunction execution" {
  let func = compileFunction("return x * 2;", params=["x"])
  let result = func.call_self([5 |> @nostd.any])
  inspect(result, content="10")
}

///|
/// Test Script sourceMapURL
test "Script sourceMapURL" {
  let script = Script::new("1 + 1")
  let url = script.sourceMapURL()
  inspect(url, content="None")
}

///|
/// Test Script cachedDataRejected
test "Script cachedDataRejected" {
  let script = Script::new("1 + 1")
  let rejected = script.cachedDataRejected()
  inspect(rejected, content="None")
}
