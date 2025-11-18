///|
using @js {trait JsImpl, type Val, unsafe_cast}

///|
using @events {trait EventEmitterImpl}

///|
/// node:stream
fn stream_module() -> Val {
  @node.require("node:stream")
}

///|
/// WIP
pub(open) trait StreamImpl: JsImpl + EventEmitterImpl {
  // Define stream-specific methods here if needed
}

///|
#external
pub type Stream

///|
pub impl JsImpl for Stream

///|
pub impl EventEmitterImpl for Stream

///|
pub impl StreamImpl for Stream

///|
#external
pub type Readable

///|
pub impl JsImpl for Readable

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
pub impl JsImpl for Writable

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
pub impl JsImpl for Duplex

///|
pub impl EventEmitterImpl for Duplex

///|
pub impl StreamImpl for Duplex

///|
#external
pub type Transform

///|
pub impl JsImpl for Transform

///|
pub impl EventEmitterImpl for Transform

///|
pub impl StreamImpl for Transform
