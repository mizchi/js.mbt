///|
/// Test setImmediate

///|
test "setImmediate returns Immediate object" {
  let immediate = setImmediate(fn() { () })
  // Just verify it returns without error
  immediate.to_any() |> ignore
}

///|
test "clearImmediate works without error" {
  let immediate = setImmediate(fn() { () })
  clearImmediate(immediate)
}
