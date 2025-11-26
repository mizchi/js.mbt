///|
/// node:stream
extern "js" fn stream_module() -> @js.Any =
  #| () => require("node:stream")

///|
/// WIP
pub(open) trait StreamImpl: @js.JsImpl + @events.EventEmitterImpl {}
// Define stream-specific methods here if needed

///|
#external
pub type Stream

///|
pub impl @js.JsImpl for Stream

///|
pub impl @events.EventEmitterImpl for Stream

///|
pub impl StreamImpl for Stream

///|
#external
pub type Readable

///|
pub impl @js.JsImpl for Readable

///|
pub impl @events.EventEmitterImpl for Readable

///|
pub impl StreamImpl for Readable

///|
/// Readable stream methods
pub fn Readable::read(self : Readable, size? : Int) -> @js.Any {
  self.call("read", [size])
}

///|
pub fn Readable::pause(self : Readable) -> Readable {
  self.call0("pause").cast()
}

///|
pub fn Readable::resume_(self : Readable) -> Readable {
  self.call0("resume").cast()
}

///|
pub fn Readable::isPaused(self : Readable) -> Bool {
  self.call0("isPaused").cast()
}

///|
pub fn Readable::pipe(self : Readable, destination : Writable) -> Writable {
  self.call("pipe", [destination]).cast()
}

///|
pub fn Readable::unpipe(self : Readable, destination? : Writable) -> Readable {
  self.call("unpipe", [destination]).cast()
}

///|
pub fn Readable::setEncoding(self : Readable, encoding : String) -> Readable {
  self.call("setEncoding", [encoding]).cast()
}

///|
pub fn Readable::destroy(self : Readable, error? : @js.Any) -> Readable {
  self.call("destroy", [error]).cast()
}

///|
pub fn Readable::unshift(
  self : Readable,
  chunk : &@js.JsImpl,
  encoding? : String,
) -> Unit {
  ignore(self.call2("unshift", chunk.to_any(), encoding))
}

///|
/// Readable stream properties
pub fn Readable::readable(self : Readable) -> Bool {
  self.get("readable").cast()
}

///|
pub fn Readable::readableEncoding(self : Readable) -> @js.Any {
  self.get("readableEncoding")
}

///|
pub fn Readable::readableEnded(self : Readable) -> Bool {
  self.get("readableEnded").cast()
}

///|
pub fn Readable::readableFlowing(self : Readable) -> @js.Any {
  self.get("readableFlowing")
}

///|
pub fn Readable::readableHighWaterMark(self : Readable) -> Int {
  self.get("readableHighWaterMark").cast()
}

///|
pub fn Readable::readableLength(self : Readable) -> Int {
  self.get("readableLength").cast()
}

///|
pub fn Readable::readableObjectMode(self : Readable) -> Bool {
  self.get("readableObjectMode").cast()
}

///|
pub fn Readable::closed(self : Readable) -> Bool {
  self.get("closed").cast()
}

///|
pub fn Readable::errored(self : Readable) -> @js.Any {
  self.get("errored")
}

///|
/// Web Stream conversion
pub fn Readable::toWeb(self : Readable) -> @web.ReadableStream {
  stream_module().get("Readable").call("toWeb", [self]).cast()
}

///|
pub fn Readable::fromWeb(s : @web.ReadableStream) -> Readable {
  stream_module().get("Readable").call("fromWeb", [s]).cast()
}

///|
pub fn Readable::from(iterable : &@js.JsImpl) -> Readable {
  stream_module().get("Readable").call("from", [iterable.to_any()]).cast()
}

///|
#external
pub type Writable

///|
pub impl @js.JsImpl for Writable

///|
pub impl @events.EventEmitterImpl for Writable

///|
pub impl StreamImpl for Writable

///|
/// Writable stream methods
pub fn[T : @js.JsImpl] Writable::write(
  self : Writable,
  chunk : T,
  encoding? : String,
  callback? : @js.Any,
) -> Bool {
  self.call("write", [chunk.to_any(), encoding, callback]).cast()
}

///|
pub fn[T : @js.JsImpl] Writable::end(
  self : Writable,
  chunk? : T,
  encoding? : String,
  callback? : @js.Any,
) -> Writable {
  let chunk_any : @js.Any = match chunk {
    Some(c) => c.to_any()
    None => @js.undefined()
  }
  self.call("end", [chunk_any, encoding, callback]).cast()
}

///|
pub fn Writable::cork(self : Writable) -> Unit {
  ignore(self.call0("cork"))
}

///|
pub fn Writable::uncork(self : Writable) -> Unit {
  ignore(self.call0("uncork"))
}

///|
pub fn Writable::destroy(self : Writable, error? : @js.Any) -> Writable {
  self.call("destroy", [error]).cast()
}

///|
pub fn Writable::setDefaultEncoding(
  self : Writable,
  encoding : String,
) -> Writable {
  self.call("setDefaultEncoding", [encoding]).cast()
}

///|
/// Writable stream properties
pub fn Writable::writable(self : Writable) -> Bool {
  self.get("writable").cast()
}

///|
pub fn Writable::writableEnded(self : Writable) -> Bool {
  self.get("writableEnded").cast()
}

///|
pub fn Writable::writableFinished(self : Writable) -> Bool {
  self.get("writableFinished").cast()
}

///|
pub fn Writable::writableHighWaterMark(self : Writable) -> Int {
  self.get("writableHighWaterMark").cast()
}

///|
pub fn Writable::writableLength(self : Writable) -> Int {
  self.get("writableLength").cast()
}

///|
pub fn Writable::writableObjectMode(self : Writable) -> Bool {
  self.get("writableObjectMode").cast()
}

///|
pub fn Writable::writableCorked(self : Writable) -> Int {
  self.get("writableCorked").cast()
}

///|
pub fn Writable::closed(self : Writable) -> Bool {
  self.get("closed").cast()
}

///|
pub fn Writable::errored(self : Writable) -> @js.Any {
  self.get("errored")
}

///|
/// Web Stream conversion
pub fn Writable::toWeb(self : Self) -> @web.WritableStream {
  stream_module().get("Writable").call("toWeb", [self]).cast()
}

///|
pub fn Writable::fromWeb(s : @web.WritableStream) -> Writable {
  stream_module().get("Writable").call("fromWeb", [s]).cast()
}

///|
#external
pub type Duplex

///|
pub impl @js.JsImpl for Duplex

///|
pub impl @events.EventEmitterImpl for Duplex

///|
pub impl StreamImpl for Duplex

///|
/// Duplex stream properties
pub fn Duplex::allowHalfOpen(self : Duplex) -> Bool {
  self.get("allowHalfOpen").cast()
}

///|
/// Web Stream conversion
pub fn Duplex::toWeb(self : Duplex) -> @js.Any {
  stream_module().get("Duplex").call("toWeb", [self])
}

///|
pub fn Duplex::fromWeb(pair : &@js.JsImpl) -> Duplex {
  stream_module().get("Duplex").call("fromWeb", [pair.to_any()]).cast()
}

///|
pub fn Duplex::from(src : &@js.JsImpl) -> Duplex {
  stream_module().get("Duplex").call("from", [src.to_any()]).cast()
}

///|
#external
pub type Transform

///|
pub impl @js.JsImpl for Transform

///|
pub impl @events.EventEmitterImpl for Transform

///|
pub impl StreamImpl for Transform

///|
#external
pub type PassThrough

///|
pub impl @js.JsImpl for PassThrough

///|
pub impl @events.EventEmitterImpl for PassThrough

///|
pub impl StreamImpl for PassThrough

///|
extern "js" fn ffi_pipeline(streams : @js.Any, callback : @js.Any?) -> @js.Any =
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
pub fn pipeline(streams : Array[@js.Any], callback? : @js.Any) -> @js.Any {
  ffi_pipeline(@js.identity(streams), callback)
}

///|
extern "js" fn ffi_finished(stream : @js.Any, callback : @js.Any?) -> @js.Any =
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
pub fn finished(stream : @js.Any, callback? : @js.Any) -> @js.Any {
  ffi_finished(stream, callback)
}

///|
extern "js" fn ffi_compose(streams : @js.Any) -> @js.Any =
  #| (streams) => {
  #|   const stream = require('node:stream');
  #|   return stream.compose(...streams);
  #| }

///|
pub fn compose(streams : Array[@js.Any]) -> @js.Any {
  ffi_compose(@js.identity(streams))
}

///|
pub fn addAbortSignal(signal : &@js.JsImpl, stream : &@js.JsImpl) -> @js.Any {
  stream_module().call2("addAbortSignal", signal.to_any(), stream.to_any())
}

///|
pub fn isErrored(stream : &StreamImpl) -> Bool {
  stream_module().call("isErrored", [stream]).cast()
}

///|
pub fn isReadable(stream : &StreamImpl) -> Bool {
  stream_module().call("isReadable", [stream]).cast()
}

///|
pub fn isWritable(stream : &StreamImpl) -> Bool {
  stream_module().call("isWritable", [stream]).cast()
}

///|
pub fn getDefaultHighWaterMark(objectMode : Bool) -> Int {
  stream_module().call("getDefaultHighWaterMark", [objectMode]).cast()
}

///|
pub fn setDefaultHighWaterMark(objectMode : Bool, value : Int) -> Unit {
  ignore(stream_module().call2("setDefaultHighWaterMark", objectMode, value))
}
