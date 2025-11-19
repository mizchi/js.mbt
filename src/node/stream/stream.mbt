///|
using @js {trait JsImpl, type Js, unsafe_cast}

///|
using @events {trait EventEmitterImpl}

///|
/// node:stream
fn stream_module() -> Js {
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
/// Readable stream methods
pub fn Readable::read(self : Readable, size? : Int) -> Js {
  self.invoke("read", [size])
}

///|
pub fn Readable::pause(self : Readable) -> Readable {
  self.invoke("pause", []) |> unsafe_cast
}

///|
pub fn Readable::resume_(self : Readable) -> Readable {
  self.invoke("resume", []) |> unsafe_cast
}

///|
pub fn Readable::isPaused(self : Readable) -> Bool {
  self.invoke("isPaused", []) |> unsafe_cast
}

///|
pub fn Readable::pipe(self : Readable, destination : Writable) -> Writable {
  self.invoke("pipe", [destination]) |> unsafe_cast
}

///|
pub fn Readable::unpipe(self : Readable, destination? : Writable) -> Readable {
  self.invoke("unpipe", [destination]) |> unsafe_cast
}

///|
pub fn Readable::setEncoding(self : Readable, encoding : String) -> Readable {
  self.invoke("setEncoding", [encoding]) |> unsafe_cast
}

///|
pub fn Readable::destroy(self : Readable, error? : Js) -> Readable {
  self.invoke("destroy", [error]) |> unsafe_cast
}

///|
pub fn Readable::unshift(
  self : Readable,
  chunk : Js,
  encoding? : String,
) -> Unit {
  ignore(self.invoke("unshift", [chunk, encoding]))
}

///|
/// Readable stream properties
pub fn Readable::readable(self : Readable) -> Bool {
  self.get("readable") |> unsafe_cast
}

///|
pub fn Readable::readableEncoding(self : Readable) -> Js {
  self.get("readableEncoding")
}

///|
pub fn Readable::readableEnded(self : Readable) -> Bool {
  self.get("readableEnded") |> unsafe_cast
}

///|
pub fn Readable::readableFlowing(self : Readable) -> Js {
  self.get("readableFlowing")
}

///|
pub fn Readable::readableHighWaterMark(self : Readable) -> Int {
  self.get("readableHighWaterMark") |> unsafe_cast
}

///|
pub fn Readable::readableLength(self : Readable) -> Int {
  self.get("readableLength") |> unsafe_cast
}

///|
pub fn Readable::readableObjectMode(self : Readable) -> Bool {
  self.get("readableObjectMode") |> unsafe_cast
}

///|
pub fn Readable::closed(self : Readable) -> Bool {
  self.get("closed") |> unsafe_cast
}

///|
pub fn Readable::errored(self : Readable) -> Js {
  self.get("errored")
}

///|
/// Web Stream conversion
pub fn Readable::toWeb(self : Readable) -> @web.ReadableStream {
  stream_module().get("Readable").invoke("toWeb", [self]) |> unsafe_cast
}

///|
pub fn Readable::fromWeb(s : @web.ReadableStream) -> Readable {
  stream_module().get("Readable").invoke("fromWeb", [s]) |> unsafe_cast
}

///|
pub fn Readable::from(iterable : Js) -> Readable {
  stream_module().get("Readable").invoke("from", [iterable]) |> unsafe_cast
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
/// Writable stream methods
pub fn Writable::write(
  self : Writable,
  chunk : Js,
  encoding? : String,
  callback? : Js,
) -> Bool {
  self.invoke("write", [chunk, encoding, callback]) |> unsafe_cast
}

///|
pub fn Writable::end(
  self : Writable,
  chunk? : Js,
  encoding? : String,
  callback? : Js,
) -> Writable {
  self.invoke("end", [chunk, encoding, callback]) |> unsafe_cast
}

///|
pub fn Writable::cork(self : Writable) -> Unit {
  ignore(self.invoke("cork", []))
}

///|
pub fn Writable::uncork(self : Writable) -> Unit {
  ignore(self.invoke("uncork", []))
}

///|
pub fn Writable::destroy(self : Writable, error? : Js) -> Writable {
  self.invoke("destroy", [error]) |> unsafe_cast
}

///|
pub fn Writable::setDefaultEncoding(
  self : Writable,
  encoding : String,
) -> Writable {
  self.invoke("setDefaultEncoding", [encoding]) |> unsafe_cast
}

///|
/// Writable stream properties
pub fn Writable::writable(self : Writable) -> Bool {
  self.get("writable") |> unsafe_cast
}

///|
pub fn Writable::writableEnded(self : Writable) -> Bool {
  self.get("writableEnded") |> unsafe_cast
}

///|
pub fn Writable::writableFinished(self : Writable) -> Bool {
  self.get("writableFinished") |> unsafe_cast
}

///|
pub fn Writable::writableHighWaterMark(self : Writable) -> Int {
  self.get("writableHighWaterMark") |> unsafe_cast
}

///|
pub fn Writable::writableLength(self : Writable) -> Int {
  self.get("writableLength") |> unsafe_cast
}

///|
pub fn Writable::writableObjectMode(self : Writable) -> Bool {
  self.get("writableObjectMode") |> unsafe_cast
}

///|
pub fn Writable::writableCorked(self : Writable) -> Int {
  self.get("writableCorked") |> unsafe_cast
}

///|
pub fn Writable::closed(self : Writable) -> Bool {
  self.get("closed") |> unsafe_cast
}

///|
pub fn Writable::errored(self : Writable) -> Js {
  self.get("errored")
}

///|
/// Web Stream conversion
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
/// Duplex stream properties
pub fn Duplex::allowHalfOpen(self : Duplex) -> Bool {
  self.get("allowHalfOpen") |> unsafe_cast
}

///|
/// Web Stream conversion
pub fn Duplex::toWeb(self : Duplex) -> Js {
  stream_module().get("Duplex").invoke("toWeb", [self])
}

///|
pub fn Duplex::fromWeb(pair : Js) -> Duplex {
  stream_module().get("Duplex").invoke("fromWeb", [pair]) |> unsafe_cast
}

///|
pub fn Duplex::from(src : Js) -> Duplex {
  stream_module().get("Duplex").invoke("from", [src]) |> unsafe_cast
}

///|
#external
pub type Transform

///|
pub impl JsImpl for Transform

///|
pub impl EventEmitterImpl for Transform

///|
pub impl StreamImpl for Transform

///|
#external
pub type PassThrough

///|
pub impl JsImpl for PassThrough

///|
pub impl EventEmitterImpl for PassThrough

///|
pub impl StreamImpl for PassThrough

///|
extern "js" fn ffi_pipeline(streams : Js, callback : Js?) -> Js =
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
pub fn pipeline(streams : Array[Js], callback? : Js) -> Js {
  ffi_pipeline(unsafe_cast(streams), callback)
}

///|
extern "js" fn ffi_finished(stream : Js, callback : Js?) -> Js =
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
pub fn finished(stream : Js, callback? : Js) -> Js {
  ffi_finished(stream, callback)
}

///|
extern "js" fn ffi_compose(streams : Js) -> Js =
  #| (streams) => {
  #|   const stream = require('node:stream');
  #|   return stream.compose(...streams);
  #| }

///|
pub fn compose(streams : Array[Js]) -> Js {
  ffi_compose(unsafe_cast(streams))
}

///|
pub fn addAbortSignal(signal : Js, stream : Js) -> Js {
  stream_module().invoke("addAbortSignal", [signal, stream])
}

///|
pub fn isErrored(stream : Js) -> Bool {
  stream_module().invoke("isErrored", [stream]) |> unsafe_cast
}

///|
pub fn isReadable(stream : Js) -> Bool {
  stream_module().invoke("isReadable", [stream]) |> unsafe_cast
}

///|
pub fn isWritable(stream : Js) -> Bool {
  stream_module().invoke("isWritable", [stream]) |> unsafe_cast
}

///|
pub fn getDefaultHighWaterMark(objectMode : Bool) -> Int {
  stream_module().invoke("getDefaultHighWaterMark", [objectMode]) |> unsafe_cast
}

///|
pub fn setDefaultHighWaterMark(objectMode : Bool, value : Int) -> Unit {
  ignore(stream_module().invoke("setDefaultHighWaterMark", [objectMode, value]))
}
