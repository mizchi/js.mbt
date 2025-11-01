///|
pub using @val {
  trait Js,
  type Val,
  js,
  new_empty_array,
  new_empty_object,
  undefined,
  unsafe_cast,
  from_json,
  log,
  from_builtin_array,
  from_builtin_map,
}

///|
pub using @async {
  type Promise,
  run_async,
  suspend,
  to_promise_fn0,
  to_promise_fn1,
  to_promise_fn2,
}
