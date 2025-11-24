///|
extern "js" fn ffi_stream_promises_pipeline(streams : @js.Js) -> @js.Js =
  #| (streams) => {
  #|   const { pipeline } = require('node:stream/promises');
  #|   return pipeline(...streams);
  #| }

///|
extern "js" fn ffi_stream_promises_finished(stream : @js.Js) -> @js.Js =
  #| (stream) => {
  #|   const { finished } = require('node:stream/promises');
  #|   return finished(stream);
  #| }

///|
pub fn pipeline(streams : Array[@js.Js]) -> @js.Promise[@stream.Stream] {
  ffi_stream_promises_pipeline(@js.identity(streams)) |> @js.identity
}

///|
pub fn finished(stream : @js.Js) -> @js.Promise[Unit] {
  ffi_stream_promises_finished(stream) |> @js.identity
}
