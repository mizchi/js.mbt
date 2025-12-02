///|

///|
test "mock.fn creates spy function" {
  let m = mock()
  let spy = m.fn_()

  // Call the spy
  spy.call_self([@nostd.any(1), @nostd.any(2), @nostd.any(3)]) |> ignore
  spy.call_self([@nostd.any("test")]) |> ignore

  // Check call count
  let ctx = get_mock_context(spy)
  inspect(ctx.callCount(), content="2")
}

///|
test "mock.method mocks object method" {
  let m = mock()
  let obj = @nostd.Object::new()
  obj._set("getValue", @js.from_fn0(fn() { 42 }))

  // Mock the method to return different value
  let obj_js : @nostd.Any = @nostd.identity(obj)
  m.method_(obj_js, "getValue", implementation=@js.from_fn0(fn() { 100 }))
  |> ignore
  let result : Int = @nostd.identity(obj.call0("getValue"))
  inspect(result, content="100")
  m.restoreAll()
}

///|
test "mock.fn with implementation" {
  let m = mock()
  let spy = m.fn_(
    implementation=@js.from_fn1(fn(x : @nostd.Any) {
      let n : Int = @nostd.identity(x)
      n * 2
    }),
  )
  let result : Int = @nostd.identity(spy.call_self([@nostd.any(5)]))
  inspect(result, content="10")
  let ctx = get_mock_context(spy)
  inspect(ctx.callCount(), content="1")
}

///|
test "mock.fn with both original and implementation" {
  let m = mock()
  let original_fn = @js.from_fn1(fn(x : @nostd.Any) {
    let n : Int = @nostd.identity(x)
    n + 1
  })
  let implementation_fn = @js.from_fn1(fn(x : @nostd.Any) {
    let n : Int = @nostd.identity(x)
    n * 2
  })
  let spy = m.fn_(original=original_fn, implementation=implementation_fn)
  let result : Int = @nostd.identity(spy.call_self([@nostd.any(5)]))
  inspect(result, content="10")
}

///|
test "mock.method without implementation" {
  let m = mock()
  let obj = @nostd.Object::new()
  obj._set("getValue", @js.from_fn0(fn() { 42 }))

  // Mock the method without implementation (spy on original)
  let obj_js : @nostd.Any = @nostd.identity(obj)
  m.method_(obj_js, "getValue") |> ignore
  let result : Int = @nostd.identity(obj.call0("getValue"))
  inspect(result, content="42")
  m.restoreAll()
}
