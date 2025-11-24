///|
extern "js" fn ffi_stream_promises_pipeline(streams : @js.Any) -> @js.Any =
  #| (streams) => {
  #|   const { pipeline } = require('node:stream/promises');
  #|   return pipeline(...streams);
  #| }

///|
extern "js" fn ffi_stream_promises_finished(stream : @js.Any) -> @js.Any =
  #| (stream) => {
  #|   const { finished } = require('node:stream/promises');
  #|   return finished(stream);
  #| }

///|
pub fn pipeline(streams : Array[@js.Any]) -> @js.Promise[@stream.Stream] {
  ffi_stream_promises_pipeline(@js.identity(streams)).cast()
}

///|
pub fn finished(stream : @js.Any) -> @js.Promise[Unit] {
  ffi_stream_promises_finished(stream).cast()
}
