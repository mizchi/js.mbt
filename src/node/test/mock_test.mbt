///|

///|
test "mock.fn creates spy function" {
  let m = mock()
  let spy = m.fn_()

  // Call the spy
  spy._invoke([@core.any(1), @core.any(2), @core.any(3)]) |> ignore
  spy._invoke([@core.any("test")]) |> ignore

  // Check call count
  let ctx = get_mock_context(spy)
  inspect(ctx.callCount(), content="2")
}

///|
test "mock.method mocks object method" {
  let m = mock()
  let obj = @core.Object::new()
  obj._set("getValue", @js.from_fn0(fn() { 42 }))

  // Mock the method to return different value
  let obj_js : @core.Any = @core.identity(obj)
  m.method_(obj_js, "getValue", implementation=@js.from_fn0(fn() { 100 }))
  |> ignore
  let result : Int = @core.identity(obj._call("getValue", []))
  inspect(result, content="100")
  m.restoreAll()
}

///|
test "mock.fn with implementation" {
  let m = mock()
  let spy = m.fn_(
    implementation=@js.from_fn1(fn(x : @core.Any) {
      let n : Int = @core.identity(x)
      n * 2
    }),
  )
  let result : Int = @core.identity(spy._invoke([@core.any(5)]))
  inspect(result, content="10")
  let ctx = get_mock_context(spy)
  inspect(ctx.callCount(), content="1")
}

///|
test "mock.fn with both original and implementation" {
  let m = mock()
  let original_fn = @js.from_fn1(fn(x : @core.Any) {
    let n : Int = @core.identity(x)
    n + 1
  })
  let implementation_fn = @js.from_fn1(fn(x : @core.Any) {
    let n : Int = @core.identity(x)
    n * 2
  })
  let spy = m.fn_(original=original_fn, implementation=implementation_fn)
  let result : Int = @core.identity(spy._invoke([@core.any(5)]))
  inspect(result, content="10")
}

///|
test "mock.method without implementation" {
  let m = mock()
  let obj = @core.Object::new()
  obj._set("getValue", @js.from_fn0(fn() { 42 }))

  // Mock the method without implementation (spy on original)
  let obj_js : @core.Any = @core.identity(obj)
  m.method_(obj_js, "getValue") |> ignore
  let result : Int = @core.identity(obj._call("getValue", []))
  inspect(result, content="42")
  m.restoreAll()
}
