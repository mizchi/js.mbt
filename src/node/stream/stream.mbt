///|
using @js {trait Js, type Val, unsafe_cast}

///|
using @events {trait EventEmitterImpl}

///|
/// node:stream
fn stream_module() -> Val {
  @node.require("node:stream")
}

///|
/// WIP
pub(open) trait StreamImpl: Js + EventEmitterImpl {
  // Define stream-specific methods here if needed
}

///|
#external
pub type Stream

///|
pub impl Js for Stream

///|
pub impl EventEmitterImpl for Stream

///|
pub impl StreamImpl for Stream

///|
#external
pub type Readable

///|
pub impl Js for Readable

///|
pub impl EventEmitterImpl for Readable

///|
pub impl StreamImpl for Readable

///|
pub fn Readable::toWeb(self : Readable) -> @web.ReadableStream {
  stream_module().get("Readable").invoke("toWeb", [self]) |> unsafe_cast
}

///|
pub fn Readable::fromWeb(s : @web.ReadableStream) -> Readable {
  stream_module().get("Readable").invoke("fromWeb", [s]) |> unsafe_cast
}

///|
#external
pub type Writable

///|
pub impl Js for Writable

///|
pub impl EventEmitterImpl for Writable

///|
pub impl StreamImpl for Writable

///|
pub fn Writable::toWeb(self : Self) -> @web.WritableStream {
  stream_module().get("Writable").invoke("toWeb", [self]) |> unsafe_cast
}

///|
pub fn Writable::fromWeb(s : @web.WritableStream) -> Writable {
  stream_module().get("Writable").invoke("fromWeb", [s]) |> unsafe_cast
}

///|
#external
pub type Duplex

///|
pub impl Js for Duplex

///|
pub impl EventEmitterImpl for Duplex

///|
pub impl StreamImpl for Duplex

///|
#external
pub type Transform

///|
pub impl Js for Transform

///|
pub impl EventEmitterImpl for Transform

///|
pub impl StreamImpl for Transform
