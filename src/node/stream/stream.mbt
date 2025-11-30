///|
/// node:stream
extern "js" fn stream_module() -> @nostd.Any =
  #| () => require("node:stream")

///|
#external
pub type Stream

///|
pub fn Stream::as_any(self : Stream) -> @nostd.Any = "%identity"

///|
pub impl @js.JsImpl for Stream

///|
#external
pub type Readable

///|
pub fn Readable::as_any(self : Readable) -> @nostd.Any = "%identity"

///|
pub impl @js.JsImpl for Readable

///|
/// Readable stream methods
pub fn Readable::read(self : Readable, size? : Int) -> @nostd.Any {
  let args : Array[@nostd.Any] = match size {
    Some(s) => [@nostd.any(s)]
    None => []
  }
  @nostd.any(self)._call("read", args)
}

///|
pub fn Readable::pause(self : Readable) -> Readable {
  @nostd.any(self)._call("pause", []).cast()
}

///|
pub fn Readable::resume_(self : Readable) -> Readable {
  @nostd.any(self)._call("resume", []).cast()
}

///|
pub fn Readable::isPaused(self : Readable) -> Bool {
  @nostd.any(self)._call("isPaused", []).cast()
}

///|
pub fn Readable::pipe(self : Readable, destination : Writable) -> Writable {
  @nostd.any(self)._call("pipe", [@nostd.any(destination)]).cast()
}

///|
pub fn Readable::unpipe(self : Readable, destination? : Writable) -> Readable {
  let args : Array[@nostd.Any] = match destination {
    Some(d) => [@nostd.any(d)]
    None => []
  }
  @nostd.any(self)._call("unpipe", args).cast()
}

///|
pub fn Readable::setEncoding(self : Readable, encoding : String) -> Readable {
  @nostd.any(self)._call("setEncoding", [@nostd.any(encoding)]).cast()
}

///|
pub fn Readable::destroy(self : Readable, error? : @nostd.Any) -> Readable {
  let args : Array[@nostd.Any] = match error {
    Some(e) => [e]
    None => []
  }
  @nostd.any(self)._call("destroy", args).cast()
}

///|
pub fn Readable::unshift(
  self : Readable,
  chunk : @nostd.Any,
  encoding? : String,
) -> Unit {
  let args : Array[@nostd.Any] = match encoding {
    Some(e) => [chunk, @nostd.any(e)]
    None => [chunk]
  }
  @nostd.any(self)._call("unshift", args) |> ignore
}

///|
/// Readable stream properties
pub fn Readable::readable(self : Readable) -> Bool {
  @nostd.any(self)["readable"].cast()
}

///|
pub fn Readable::readableEncoding(self : Readable) -> @nostd.Any {
  @nostd.any(self)["readableEncoding"]
}

///|
pub fn Readable::readableEnded(self : Readable) -> Bool {
  @nostd.any(self)["readableEnded"].cast()
}

///|
pub fn Readable::readableFlowing(self : Readable) -> @nostd.Any {
  @nostd.any(self)["readableFlowing"]
}

///|
pub fn Readable::readableHighWaterMark(self : Readable) -> Int {
  @nostd.any(self)["readableHighWaterMark"].cast()
}

///|
pub fn Readable::readableLength(self : Readable) -> Int {
  @nostd.any(self)["readableLength"].cast()
}

///|
pub fn Readable::readableObjectMode(self : Readable) -> Bool {
  @nostd.any(self)["readableObjectMode"].cast()
}

///|
pub fn Readable::closed(self : Readable) -> Bool {
  @nostd.any(self)["closed"].cast()
}

///|
pub fn Readable::errored(self : Readable) -> @nostd.Any {
  @nostd.any(self)["errored"]
}

///|
/// Web Stream conversion
pub fn Readable::toWeb(self : Readable) -> @web.ReadableStream {
  stream_module()["Readable"]._call("toWeb", [@nostd.any(self)]).cast()
}

///|
pub fn Readable::fromWeb(s : @web.ReadableStream) -> Readable {
  stream_module()["Readable"]._call("fromWeb", [@nostd.any(s)]).cast()
}

///|
pub fn Readable::from(iterable : @nostd.Any) -> Readable {
  stream_module()["Readable"]._call("from", [iterable]).cast()
}

///|
#external
pub type Writable

///|
pub fn Writable::as_any(self : Writable) -> @nostd.Any = "%identity"

///|
pub impl @js.JsImpl for Writable

///|
/// Writable stream methods
pub fn Writable::write(
  self : Writable,
  chunk : @nostd.Any,
  encoding? : String,
  callback? : @nostd.Any,
) -> Bool {
  let args : Array[@nostd.Any] = [chunk]
  if encoding is Some(e) {
    args.push(@nostd.any(e))
  } else {
    args.push(@nostd.undefined())
  }
  if callback is Some(cb) {
    args.push(cb)
  }
  @nostd.any(self)._call("write", args).cast()
}

///|
pub fn Writable::end(
  self : Writable,
  chunk? : @nostd.Any,
  encoding? : String,
  callback? : @nostd.Any,
) -> Writable {
  let args : Array[@nostd.Any] = []
  if chunk is Some(c) {
    args.push(c)
  } else {
    args.push(@nostd.undefined())
  }
  if encoding is Some(e) {
    args.push(@nostd.any(e))
  } else {
    args.push(@nostd.undefined())
  }
  if callback is Some(cb) {
    args.push(cb)
  }
  @nostd.any(self)._call("end", args).cast()
}

///|
pub fn Writable::cork(self : Writable) -> Unit {
  @nostd.any(self)._call("cork", []) |> ignore
}

///|
pub fn Writable::uncork(self : Writable) -> Unit {
  @nostd.any(self)._call("uncork", []) |> ignore
}

///|
pub fn Writable::destroy(self : Writable, error? : @nostd.Any) -> Writable {
  let args : Array[@nostd.Any] = match error {
    Some(e) => [e]
    None => []
  }
  @nostd.any(self)._call("destroy", args).cast()
}

///|
pub fn Writable::setDefaultEncoding(
  self : Writable,
  encoding : String,
) -> Writable {
  @nostd.any(self)._call("setDefaultEncoding", [@nostd.any(encoding)]).cast()
}

///|
/// Writable stream properties
pub fn Writable::writable(self : Writable) -> Bool {
  @nostd.any(self)["writable"].cast()
}

///|
pub fn Writable::writableEnded(self : Writable) -> Bool {
  @nostd.any(self)["writableEnded"].cast()
}

///|
pub fn Writable::writableFinished(self : Writable) -> Bool {
  @nostd.any(self)["writableFinished"].cast()
}

///|
pub fn Writable::writableHighWaterMark(self : Writable) -> Int {
  @nostd.any(self)["writableHighWaterMark"].cast()
}

///|
pub fn Writable::writableLength(self : Writable) -> Int {
  @nostd.any(self)["writableLength"].cast()
}

///|
pub fn Writable::writableObjectMode(self : Writable) -> Bool {
  @nostd.any(self)["writableObjectMode"].cast()
}

///|
pub fn Writable::writableCorked(self : Writable) -> Int {
  @nostd.any(self)["writableCorked"].cast()
}

///|
pub fn Writable::closed(self : Writable) -> Bool {
  @nostd.any(self)["closed"].cast()
}

///|
pub fn Writable::errored(self : Writable) -> @nostd.Any {
  @nostd.any(self)["errored"]
}

///|
/// Web Stream conversion
pub fn Writable::toWeb(self : Writable) -> @web.WritableStream {
  stream_module()["Writable"]._call("toWeb", [@nostd.any(self)]).cast()
}

///|
pub fn Writable::fromWeb(s : @web.WritableStream) -> Writable {
  stream_module()["Writable"]._call("fromWeb", [@nostd.any(s)]).cast()
}

///|
#external
pub type Duplex

///|
pub fn Duplex::as_any(self : Duplex) -> @nostd.Any = "%identity"

///|
pub impl @js.JsImpl for Duplex

///|
/// Duplex stream properties
pub fn Duplex::allowHalfOpen(self : Duplex) -> Bool {
  @nostd.any(self)["allowHalfOpen"].cast()
}

///|
/// Web Stream conversion
pub fn Duplex::toWeb(self : Duplex) -> @nostd.Any {
  stream_module()["Duplex"]._call("toWeb", [@nostd.any(self)])
}

///|
pub fn Duplex::fromWeb(pair : @nostd.Any) -> Duplex {
  stream_module()["Duplex"]._call("fromWeb", [pair]).cast()
}

///|
pub fn Duplex::from(src : @nostd.Any) -> Duplex {
  stream_module()["Duplex"]._call("from", [src]).cast()
}

///|
#external
pub type Transform

///|
pub fn Transform::as_any(self : Transform) -> @nostd.Any = "%identity"

///|
pub impl @js.JsImpl for Transform

///|
#external
pub type PassThrough

///|
pub fn PassThrough::as_any(self : PassThrough) -> @nostd.Any = "%identity"

///|
pub impl @js.JsImpl for PassThrough

///|
extern "js" fn ffi_pipeline(
  streams : @nostd.Any,
  callback : @nostd.Any?,
) -> @nostd.Any =
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
pub fn pipeline(
  streams : Array[@nostd.Any],
  callback? : @nostd.Any,
) -> @nostd.Any {
  ffi_pipeline(@nostd.any(streams), callback)
}

///|
extern "js" fn ffi_finished(
  stream : @nostd.Any,
  callback : @nostd.Any?,
) -> @nostd.Any =
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
pub fn finished(stream : @nostd.Any, callback? : @nostd.Any) -> @nostd.Any {
  ffi_finished(stream, callback)
}

///|
extern "js" fn ffi_compose(streams : @nostd.Any) -> @nostd.Any =
  #| (streams) => {
  #|   const stream = require('node:stream');
  #|   return stream.compose(...streams);
  #| }

///|
pub fn compose(streams : Array[@nostd.Any]) -> @nostd.Any {
  ffi_compose(@nostd.any(streams))
}

///|
pub fn addAbortSignal(signal : @nostd.Any, stream : @nostd.Any) -> @nostd.Any {
  stream_module()._call("addAbortSignal", [signal, stream])
}

///|
pub fn isErrored(stream : @nostd.Any) -> Bool {
  stream_module()._call("isErrored", [stream]).cast()
}

///|
pub fn isReadable(stream : @nostd.Any) -> Bool {
  stream_module()._call("isReadable", [stream]).cast()
}

///|
pub fn isWritable(stream : @nostd.Any) -> Bool {
  stream_module()._call("isWritable", [stream]).cast()
}

///|
pub fn getDefaultHighWaterMark(objectMode : Bool) -> Int {
  stream_module()
  ._call("getDefaultHighWaterMark", [@nostd.any(objectMode)])
  .cast()
}

///|
pub fn setDefaultHighWaterMark(objectMode : Bool, value : Int) -> Unit {
  stream_module()._call("setDefaultHighWaterMark", [
    @nostd.any(objectMode),
    @nostd.any(value),
  ])
  |> ignore
}
