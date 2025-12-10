///|
/// Comlink bindings tests
/// Note: Full Worker tests require browser/worker environment.
/// These tests verify basic API availability.

///|
test "proxy function" {
  let callback = @comlink.proxyCallback(fn(_event) { () })
  inspect(@core.is_nullish(callback.as_any()) |> not, content="true")
}

///|
test "transfer array buffer" {
  let buffer = @core.new_object()
  let result = @comlink.transferArrayBuffer(@core.any(buffer))
  inspect(result |> @core.is_nullish |> not, content="true")
}

///|
test "transfer with transferables" {
  let data = @core.new_object()
  let result = @comlink.transfer(@core.any(data), [])
  inspect(result |> @core.is_nullish |> not, content="true")
}

///|
test "get symbols" {
  let create_ep = @comlink.createEndpointSymbol()
  inspect(create_ep |> @core.is_nullish |> not, content="true")
  let release = @comlink.releaseProxySymbol()
  inspect(release |> @core.is_nullish |> not, content="true")
  let marker = @comlink.proxyMarkerSymbol()
  inspect(marker |> @core.is_nullish |> not, content="true")
}

///|
test "get transfer handlers" {
  let handlers = @comlink.transferHandlers()
  inspect(handlers |> @core.is_nullish |> not, content="true")
}

///|
test "proxy with return value" {
  let func = @comlink.proxyFunction(fn(x) { x })
  inspect(@core.is_nullish(func.as_any()) |> not, content="true")
}
