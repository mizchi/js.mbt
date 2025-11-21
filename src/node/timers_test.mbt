///|
/// Test setImmediate

///|
test "setImmediate returns Immediate object" {
  let immediate = setImmediate(fn() { () })
  // Just verify it returns without error
  immediate.to_js() |> ignore
}

///|
test "clearImmediate works without error" {
  let immediate = setImmediate(fn() { () })
  clearImmediate(immediate)
}
