///|
/// node:stream
extern "js" fn stream_module() -> @core.Any =
  #| () => require("node:stream")

///|
#external
pub type Stream

///|
pub fn Stream::as_any(self : Stream) -> @core.Any = "%identity"

///|
#external
pub type Readable

///|
pub fn Readable::as_any(self : Readable) -> @core.Any = "%identity"

///|
/// Readable stream methods
pub fn Readable::read(self : Readable, size? : Int) -> @core.Any {
  let args : Array[@core.Any] = match size {
    Some(s) => [@core.any(s)]
    None => []
  }
  @core.any(self)._call("read", args)
}

///|
pub fn Readable::pause(self : Readable) -> Readable {
  @core.any(self)._call("pause", []).cast()
}

///|
pub fn Readable::resume_(self : Readable) -> Readable {
  @core.any(self)._call("resume", []).cast()
}

///|
pub fn Readable::isPaused(self : Readable) -> Bool {
  @core.any(self)._call("isPaused", []).cast()
}

///|
pub fn Readable::pipe(self : Readable, destination : Writable) -> Writable {
  @core.any(self)._call("pipe", [@core.any(destination)]).cast()
}

///|
pub fn Readable::unpipe(self : Readable, destination? : Writable) -> Readable {
  let args : Array[@core.Any] = match destination {
    Some(d) => [@core.any(d)]
    None => []
  }
  @core.any(self)._call("unpipe", args).cast()
}

///|
pub fn Readable::setEncoding(self : Readable, encoding : String) -> Readable {
  @core.any(self)._call("setEncoding", [@core.any(encoding)]).cast()
}

///|
pub fn Readable::destroy(self : Readable, error? : @core.Any) -> Readable {
  let args : Array[@core.Any] = match error {
    Some(e) => [e]
    None => []
  }
  @core.any(self)._call("destroy", args).cast()
}

///|
pub fn Readable::unshift(
  self : Readable,
  chunk : @core.Any,
  encoding? : String,
) -> Unit {
  let args : Array[@core.Any] = match encoding {
    Some(e) => [chunk, @core.any(e)]
    None => [chunk]
  }
  @core.any(self)._call("unshift", args) |> ignore
}

///|
/// Readable stream properties
pub fn Readable::readable(self : Readable) -> Bool {
  @core.any(self)["readable"].cast()
}

///|
pub fn Readable::readableEncoding(self : Readable) -> @core.Any {
  @core.any(self)["readableEncoding"]
}

///|
pub fn Readable::readableEnded(self : Readable) -> Bool {
  @core.any(self)["readableEnded"].cast()
}

///|
pub fn Readable::readableFlowing(self : Readable) -> @core.Any {
  @core.any(self)["readableFlowing"]
}

///|
pub fn Readable::readableHighWaterMark(self : Readable) -> Int {
  @core.any(self)["readableHighWaterMark"].cast()
}

///|
pub fn Readable::readableLength(self : Readable) -> Int {
  @core.any(self)["readableLength"].cast()
}

///|
pub fn Readable::readableObjectMode(self : Readable) -> Bool {
  @core.any(self)["readableObjectMode"].cast()
}

///|
pub fn Readable::closed(self : Readable) -> Bool {
  @core.any(self)["closed"].cast()
}

///|
pub fn Readable::errored(self : Readable) -> @core.Any {
  @core.any(self)["errored"]
}

///|
/// Web Stream conversion
pub fn Readable::toWeb(self : Readable) -> @web.ReadableStream {
  stream_module()["Readable"]._call("toWeb", [@core.any(self)]).cast()
}

///|
pub fn Readable::fromWeb(s : @web.ReadableStream) -> Readable {
  stream_module()["Readable"]._call("fromWeb", [@core.any(s)]).cast()
}

///|
pub fn Readable::from(iterable : @core.Any) -> Readable {
  stream_module()["Readable"]._call("from", [iterable]).cast()
}

///|
#external
pub type Writable

///|
pub fn Writable::as_any(self : Writable) -> @core.Any = "%identity"

///|
/// Writable stream methods
pub fn Writable::write(
  self : Writable,
  chunk : @core.Any,
  encoding? : String,
  callback? : @core.Any,
) -> Bool {
  let args : Array[@core.Any] = [chunk]
  if encoding is Some(e) {
    args.push(@core.any(e))
  } else {
    args.push(@core.undefined())
  }
  if callback is Some(cb) {
    args.push(cb)
  }
  @core.any(self)._call("write", args).cast()
}

///|
pub fn Writable::end(
  self : Writable,
  chunk? : @core.Any,
  encoding? : String,
  callback? : @core.Any,
) -> Writable {
  let args : Array[@core.Any] = []
  if chunk is Some(c) {
    args.push(c)
  } else {
    args.push(@core.undefined())
  }
  if encoding is Some(e) {
    args.push(@core.any(e))
  } else {
    args.push(@core.undefined())
  }
  if callback is Some(cb) {
    args.push(cb)
  }
  @core.any(self)._call("end", args).cast()
}

///|
pub fn Writable::cork(self : Writable) -> Unit {
  @core.any(self)._call("cork", []) |> ignore
}

///|
pub fn Writable::uncork(self : Writable) -> Unit {
  @core.any(self)._call("uncork", []) |> ignore
}

///|
pub fn Writable::destroy(self : Writable, error? : @core.Any) -> Writable {
  let args : Array[@core.Any] = match error {
    Some(e) => [e]
    None => []
  }
  @core.any(self)._call("destroy", args).cast()
}

///|
pub fn Writable::setDefaultEncoding(
  self : Writable,
  encoding : String,
) -> Writable {
  @core.any(self)._call("setDefaultEncoding", [@core.any(encoding)]).cast()
}

///|
/// Writable stream properties
pub fn Writable::writable(self : Writable) -> Bool {
  @core.any(self)["writable"].cast()
}

///|
pub fn Writable::writableEnded(self : Writable) -> Bool {
  @core.any(self)["writableEnded"].cast()
}

///|
pub fn Writable::writableFinished(self : Writable) -> Bool {
  @core.any(self)["writableFinished"].cast()
}

///|
pub fn Writable::writableHighWaterMark(self : Writable) -> Int {
  @core.any(self)["writableHighWaterMark"].cast()
}

///|
pub fn Writable::writableLength(self : Writable) -> Int {
  @core.any(self)["writableLength"].cast()
}

///|
pub fn Writable::writableObjectMode(self : Writable) -> Bool {
  @core.any(self)["writableObjectMode"].cast()
}

///|
pub fn Writable::writableCorked(self : Writable) -> Int {
  @core.any(self)["writableCorked"].cast()
}

///|
pub fn Writable::closed(self : Writable) -> Bool {
  @core.any(self)["closed"].cast()
}

///|
pub fn Writable::errored(self : Writable) -> @core.Any {
  @core.any(self)["errored"]
}

///|
/// Web Stream conversion
pub fn Writable::toWeb(self : Writable) -> @web.WritableStream {
  stream_module()["Writable"]._call("toWeb", [@core.any(self)]).cast()
}

///|
pub fn Writable::fromWeb(s : @web.WritableStream) -> Writable {
  stream_module()["Writable"]._call("fromWeb", [@core.any(s)]).cast()
}

///|
#external
pub type Duplex

///|
pub fn Duplex::as_any(self : Duplex) -> @core.Any = "%identity"

///|
/// Duplex stream properties
pub fn Duplex::allowHalfOpen(self : Duplex) -> Bool {
  @core.any(self)["allowHalfOpen"].cast()
}

///|
/// Web Stream conversion
pub fn Duplex::toWeb(self : Duplex) -> @core.Any {
  stream_module()["Duplex"]._call("toWeb", [@core.any(self)])
}

///|
pub fn Duplex::fromWeb(pair : @core.Any) -> Duplex {
  stream_module()["Duplex"]._call("fromWeb", [pair]).cast()
}

///|
pub fn Duplex::from(src : @core.Any) -> Duplex {
  stream_module()["Duplex"]._call("from", [src]).cast()
}

///|
#external
pub type Transform

///|
pub fn Transform::as_any(self : Transform) -> @core.Any = "%identity"

///|
#external
pub type PassThrough

///|
pub fn PassThrough::as_any(self : PassThrough) -> @core.Any = "%identity"

///|
extern "js" fn ffi_pipeline(
  streams : @core.Any,
  callback : @core.Any?,
) -> @core.Any =
  #| (streams, callback) => {
  #|   const stream = require('node:stream');
  #|   // Check if callback is Some (object with $tag: 1)
  #|   if (callback && callback.$tag === 1) {
  #|     return stream.pipeline(...streams, callback._0);
  #|   } else {
  #|     return stream.pipeline(...streams);
  #|   }
  #| }

///|
/// Utility functions
pub fn pipeline(streams : Array[@core.Any], callback? : @core.Any) -> @core.Any {
  ffi_pipeline(@core.any(streams), callback)
}

///|
extern "js" fn ffi_finished(
  stream : @core.Any,
  callback : @core.Any?,
) -> @core.Any =
  #| (stream, callback) => {
  #|   const streamModule = require('node:stream');
  #|   // Check if callback is Some (object with $tag: 1)
  #|   if (callback && callback.$tag === 1) {
  #|     return streamModule.finished(stream, callback._0);
  #|   } else {
  #|     return streamModule.finished(stream);
  #|   }
  #| }

///|
pub fn finished(stream : @core.Any, callback? : @core.Any) -> @core.Any {
  ffi_finished(stream, callback)
}

///|
extern "js" fn ffi_compose(streams : @core.Any) -> @core.Any =
  #| (streams) => {
  #|   const stream = require('node:stream');
  #|   return stream.compose(...streams);
  #| }

///|
pub fn compose(streams : Array[@core.Any]) -> @core.Any {
  ffi_compose(@core.any(streams))
}

///|
pub fn addAbortSignal(signal : @core.Any, stream : @core.Any) -> @core.Any {
  stream_module()._call("addAbortSignal", [signal, stream])
}

///|
pub fn isErrored(stream : @core.Any) -> Bool {
  stream_module()._call("isErrored", [stream]).cast()
}

///|
pub fn isReadable(stream : @core.Any) -> Bool {
  stream_module()._call("isReadable", [stream]).cast()
}

///|
pub fn isWritable(stream : @core.Any) -> Bool {
  stream_module()._call("isWritable", [stream]).cast()
}

///|
pub fn getDefaultHighWaterMark(objectMode : Bool) -> Int {
  stream_module()
  ._call("getDefaultHighWaterMark", [@core.any(objectMode)])
  .cast()
}

///|
pub fn setDefaultHighWaterMark(objectMode : Bool, value : Int) -> Unit {
  stream_module()._call("setDefaultHighWaterMark", [
    @core.any(objectMode),
    @core.any(value),
  ])
  |> ignore
}
