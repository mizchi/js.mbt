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
pub async fn pipeline(streams : Array[@js.Any]) -> @stream.Stream {
  let promise : @js.Promise[@stream.Stream] = ffi_stream_promises_pipeline(
    @js.identity(streams),
  ).cast()
  promise.wait()
}

///|
pub async fn finished(stream : @js.Any) -> Unit {
  let promise : @js.Promise[Unit] = ffi_stream_promises_finished(stream).cast()
  promise.wait()
}
