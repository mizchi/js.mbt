///|
extern "js" fn ffi_stream_promises_pipeline(streams : @core.Any) -> @core.Any =
  #| (streams) => {
  #|   const { pipeline } = require('node:stream/promises');
  #|   return pipeline(...streams);
  #| }

///|
#module("node:stream/promises")
extern "js" fn ffi_stream_promises_finished(stream : @core.Any) -> @core.Any = "finished"

///|
pub async fn pipeline(streams : Array[@core.Any]) -> @stream.Stream {
  let promise : @core.Promise[@stream.Stream] = ffi_stream_promises_pipeline(
    @core.identity(streams),
  ).cast()
  promise.wait()
}

///|
pub async fn finished(stream : @core.Any) -> Unit {
  let promise : @core.Promise[Unit] = ffi_stream_promises_finished(stream).cast()
  promise.wait()
}
