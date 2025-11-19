///|
using @js {type Js, unsafe_cast}

///|
using @stream {type Readable, type Stream, type Writable, trait StreamImpl}

///|
extern "js" fn ffi_stream_promises_pipeline(streams : Js) -> Js =
  #| (streams) => {
  #|   const { pipeline } = require('node:stream/promises');
  #|   return pipeline(...streams);
  #| }

///|
extern "js" fn ffi_stream_promises_finished(stream : Js) -> Js =
  #| (stream) => {
  #|   const { finished } = require('node:stream/promises');
  #|   return finished(stream);
  #| }

///|
pub fn pipeline(streams : Array[Js]) -> @promise.Promise[Stream] {
  ffi_stream_promises_pipeline(unsafe_cast(streams)) |> unsafe_cast
}

///|
pub fn finished(stream : Js) -> @promise.Promise[Unit] {
  ffi_stream_promises_finished(stream) |> unsafe_cast
}
