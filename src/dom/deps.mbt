///|
using @js {
  type Js,
  trait JsImpl,
  unsafe_cast,
  js,
  unsafe_option,
}

///|
using @event {trait EventTargetImpl}

///|
using @promise {type Promise, suspend, run_async}

///|
using @blob {type Blob}

///|
using @worker {trait Transferable}
