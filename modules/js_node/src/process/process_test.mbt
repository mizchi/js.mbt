///|
/// Test process.nextTick

///|
test "nextTick works without error" {
  nextTick(fn() { () })
}
