///|
using @js {
  type Js,
  trait JsImpl,
  trait EventTargetImpl,
  unsafe_cast,
  safe_js,
  unsafe_option,
}

///|
using @promise {type Promise, suspend, run_async}

///|
using @blob {type Blob}

///|
using @worker {trait Transferable}
