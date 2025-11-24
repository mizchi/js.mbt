///|

///|

///|
/// node:stream
fn stream_module() -> @js.Js {
  @node.require("node:stream")
}

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
pub fn Readable::read(self : Readable, size? : Int) -> @js.Js {
  self.call("read", [size])
}

///|
pub fn Readable::pause(self : Readable) -> Readable {
  self.call0("pause") |> @js.identity
}

///|
pub fn Readable::resume_(self : Readable) -> Readable {
  self.call0("resume") |> @js.identity
}

///|
pub fn Readable::isPaused(self : Readable) -> Bool {
  self.call0("isPaused") |> @js.identity
}

///|
pub fn Readable::pipe(self : Readable, destination : Writable) -> Writable {
  self.call("pipe", [destination]) |> @js.identity
}

///|
pub fn Readable::unpipe(self : Readable, destination? : Writable) -> Readable {
  self.call("unpipe", [destination]) |> @js.identity
}

///|
pub fn Readable::setEncoding(self : Readable, encoding : String) -> Readable {
  self.call("setEncoding", [encoding]) |> @js.identity
}

///|
pub fn Readable::destroy(self : Readable, error? : @js.Js) -> Readable {
  self.call("destroy", [error]) |> @js.identity
}

///|
pub fn Readable::unshift(
  self : Readable,
  chunk : @js.Js,
  encoding? : String,
) -> Unit {
  ignore(self.call2("unshift", chunk, encoding))
}

///|
/// Readable stream properties
pub fn Readable::readable(self : Readable) -> Bool {
  self.get("readable") |> @js.identity
}

///|
pub fn Readable::readableEncoding(self : Readable) -> @js.Js {
  self.get("readableEncoding")
}

///|
pub fn Readable::readableEnded(self : Readable) -> Bool {
  self.get("readableEnded") |> @js.identity
}

///|
pub fn Readable::readableFlowing(self : Readable) -> @js.Js {
  self.get("readableFlowing")
}

///|
pub fn Readable::readableHighWaterMark(self : Readable) -> Int {
  self.get("readableHighWaterMark") |> @js.identity
}

///|
pub fn Readable::readableLength(self : Readable) -> Int {
  self.get("readableLength") |> @js.identity
}

///|
pub fn Readable::readableObjectMode(self : Readable) -> Bool {
  self.get("readableObjectMode") |> @js.identity
}

///|
pub fn Readable::closed(self : Readable) -> Bool {
  self.get("closed") |> @js.identity
}

///|
pub fn Readable::errored(self : Readable) -> @js.Js {
  self.get("errored")
}

///|
/// Web Stream conversion
pub fn Readable::toWeb(self : Readable) -> @web.ReadableStream {
  stream_module().get("Readable").call("toWeb", [self]) |> @js.identity
}

///|
pub fn Readable::fromWeb(s : @web.ReadableStream) -> Readable {
  stream_module().get("Readable").call("fromWeb", [s]) |> @js.identity
}

///|
pub fn Readable::from(iterable : @js.Js) -> Readable {
  stream_module().get("Readable").call("from", [iterable]) |> @js.identity
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
pub fn Writable::write(
  self : Writable,
  chunk : @js.Js,
  encoding? : String,
  callback? : @js.Js,
) -> Bool {
  self.call("write", [chunk, encoding, callback]) |> @js.identity
}

///|
pub fn Writable::end(
  self : Writable,
  chunk? : @js.Js,
  encoding? : String,
  callback? : @js.Js,
) -> Writable {
  self.call("end", [chunk, encoding, callback]) |> @js.identity
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
pub fn Writable::destroy(self : Writable, error? : @js.Js) -> Writable {
  self.call("destroy", [error]) |> @js.identity
}

///|
pub fn Writable::setDefaultEncoding(
  self : Writable,
  encoding : String,
) -> Writable {
  self.call("setDefaultEncoding", [encoding]) |> @js.identity
}

///|
/// Writable stream properties
pub fn Writable::writable(self : Writable) -> Bool {
  self.get("writable") |> @js.identity
}

///|
pub fn Writable::writableEnded(self : Writable) -> Bool {
  self.get("writableEnded") |> @js.identity
}

///|
pub fn Writable::writableFinished(self : Writable) -> Bool {
  self.get("writableFinished") |> @js.identity
}

///|
pub fn Writable::writableHighWaterMark(self : Writable) -> Int {
  self.get("writableHighWaterMark") |> @js.identity
}

///|
pub fn Writable::writableLength(self : Writable) -> Int {
  self.get("writableLength") |> @js.identity
}

///|
pub fn Writable::writableObjectMode(self : Writable) -> Bool {
  self.get("writableObjectMode") |> @js.identity
}

///|
pub fn Writable::writableCorked(self : Writable) -> Int {
  self.get("writableCorked") |> @js.identity
}

///|
pub fn Writable::closed(self : Writable) -> Bool {
  self.get("closed") |> @js.identity
}

///|
pub fn Writable::errored(self : Writable) -> @js.Js {
  self.get("errored")
}

///|
/// Web Stream conversion
pub fn Writable::toWeb(self : Self) -> @web.WritableStream {
  stream_module().get("Writable").call("toWeb", [self]) |> @js.identity
}

///|
pub fn Writable::fromWeb(s : @web.WritableStream) -> Writable {
  stream_module().get("Writable").call("fromWeb", [s]) |> @js.identity
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
  self.get("allowHalfOpen") |> @js.identity
}

///|
/// Web Stream conversion
pub fn Duplex::toWeb(self : Duplex) -> @js.Js {
  stream_module().get("Duplex").call("toWeb", [self])
}

///|
pub fn Duplex::fromWeb(pair : @js.Js) -> Duplex {
  stream_module().get("Duplex").call("fromWeb", [pair]) |> @js.identity
}

///|
pub fn Duplex::from(src : @js.Js) -> Duplex {
  stream_module().get("Duplex").call("from", [src]) |> @js.identity
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
extern "js" fn ffi_pipeline(streams : @js.Js, callback : @js.Js?) -> @js.Js =
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
pub fn pipeline(streams : Array[@js.Js], callback? : @js.Js) -> @js.Js {
  ffi_pipeline(@js.identity(streams), callback)
}

///|
extern "js" fn ffi_finished(stream : @js.Js, callback : @js.Js?) -> @js.Js =
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
pub fn finished(stream : @js.Js, callback? : @js.Js) -> @js.Js {
  ffi_finished(stream, callback)
}

///|
extern "js" fn ffi_compose(streams : @js.Js) -> @js.Js =
  #| (streams) => {
  #|   const stream = require('node:stream');
  #|   return stream.compose(...streams);
  #| }

///|
pub fn compose(streams : Array[@js.Js]) -> @js.Js {
  ffi_compose(@js.identity(streams))
}

///|
pub fn addAbortSignal(signal : @js.Js, stream : @js.Js) -> @js.Js {
  stream_module().call2("addAbortSignal", signal, stream)
}

///|
pub fn isErrored(stream : @js.Js) -> Bool {
  stream_module().call("isErrored", [stream]) |> @js.identity
}

///|
pub fn isReadable(stream : @js.Js) -> Bool {
  stream_module().call("isReadable", [stream]) |> @js.identity
}

///|
pub fn isWritable(stream : @js.Js) -> Bool {
  stream_module().call("isWritable", [stream]) |> @js.identity
}

///|
pub fn getDefaultHighWaterMark(objectMode : Bool) -> Int {
  stream_module().call("getDefaultHighWaterMark", [objectMode])
  |> @js.identity
}

///|
pub fn setDefaultHighWaterMark(objectMode : Bool, value : Int) -> Unit {
  ignore(stream_module().call2("setDefaultHighWaterMark", objectMode, value))
}
