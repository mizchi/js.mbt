///|
using @js {trait Js, type Val, unsafe_cast}

///|
using @events {trait EventEmitterImpl}

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
pub type ReadableStream

///|
pub impl Js for ReadableStream

///|
pub impl EventEmitterImpl for ReadableStream

///|
pub impl StreamImpl for ReadableStream

///|
#external
pub type WritableStream

///|
pub impl Js for WritableStream

///|
pub impl EventEmitterImpl for WritableStream

///|
pub impl StreamImpl for WritableStream
