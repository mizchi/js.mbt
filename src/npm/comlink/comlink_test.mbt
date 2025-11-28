///|
/// Comlink bindings tests
/// Note: Full Worker tests require browser/worker environment.
/// These tests verify basic API availability.

///|
test "proxy function" {
  let callback = @comlink.proxyCallback(fn(_event) { () })
  inspect(callback.to_any() |> @js.is_nullish |> not, content="true")
}

///|
test "transfer array buffer" {
  let buffer = @js.Object::new()
  let result = @comlink.transferArrayBuffer(buffer.to_any())
  inspect(result |> @js.is_nullish |> not, content="true")
}

///|
test "transfer with transferables" {
  let data = @js.Object::new()
  let result = @comlink.transfer(data.to_any(), [])
  inspect(result |> @js.is_nullish |> not, content="true")
}

///|
test "get symbols" {
  let create_ep = @comlink.createEndpointSymbol()
  inspect(create_ep |> @js.is_nullish |> not, content="true")
  let release = @comlink.releaseProxySymbol()
  inspect(release |> @js.is_nullish |> not, content="true")
  let marker = @comlink.proxyMarkerSymbol()
  inspect(marker |> @js.is_nullish |> not, content="true")
}

///|
test "get transfer handlers" {
  let handlers = @comlink.transferHandlers()
  inspect(handlers |> @js.is_nullish |> not, content="true")
}

///|
test "proxy with return value" {
  let func = @comlink.proxyFunction(fn(x) { x })
  inspect(func.to_any() |> @js.is_nullish |> not, content="true")
}
