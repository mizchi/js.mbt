///|
pub using @val {
  trait Js,
  type Val,
  type Fn0,
  type Fn1,
  type Fn2,
  type Fn3,
  js,
  new_object,
  new_array,
  undefined,
  unsafe_cast,
  from_json,
}
///|
pub using @promise {
  type Promise,
  run_async,
  suspend,
  to_promise_fn0,
  to_promise_fn1,
}