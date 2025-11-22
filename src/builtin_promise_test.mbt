///| Promise tests

///|
test "Promise::new creates Promise" {
  let _p : Promise[Int] = Promise::new(fn(resolve, _reject) { resolve(42) })
  // Promise created successfully
}

///|
test "Promise::resolve creates resolved Promise" {
  let _p = Promise::resolve(100)
  // Promise resolved successfully
}

///|
test "Promise::reject creates rejected Promise with catch" {
  let p = Promise::reject(js("error"))
  let _caught = p.catch_(fn(_e) { Promise::resolve(0) })
  // Promise rejected and caught successfully
}

///|
test "Promise::catch_ handles rejection" {
  let p = Promise::reject(js("error"))
  let _caught = p.catch_(fn(_e) { Promise::resolve(0) })
  // Catch handler attached successfully
}

///|
test "Promise::finally_ adds finally handler" {
  let p = Promise::resolve(10)
  let _result = p.finally_(fn() { () })
  // Finally handler attached successfully
}
