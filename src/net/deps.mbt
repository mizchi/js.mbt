///|
using @async {type Promise, run_async}

///|
using @js {
  type Val,
  type AbortSignal,
  trait Js,
  js,
  new_empty_object,
  log,
  to_option,
  unsafe_cast,
}
