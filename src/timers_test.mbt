///| Timers tests

///|
test "setTimeout and clearTimeout" {
  let timer = setTimeout(fn() { () }, 100)
  clearTimeout(timer)
  // Timer created and cleared successfully
}

///|
test "setInterval and clearInterval" {
  let timer = setInterval(fn() { () }, 100)
  clearInterval(timer)
  // Interval created and cleared successfully
}
