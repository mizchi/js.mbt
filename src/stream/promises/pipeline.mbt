///|
using @js {type Js, unsafe_cast}

///|
using @stream {type Readable, type Stream, type Writable, trait StreamImpl}

///|
pub fn readable_promises() -> @js.Js {
  @node.require("stream/promises")
}

///|
pub fn pipeline(streams : Array[&StreamImpl]) -> @promise.Promise[Stream] {
  let args = streams.map(fn(s) { s.to_js() }) |> unsafe_cast
  readable_promises().invoke("pipeline", args) |> unsafe_cast
}
