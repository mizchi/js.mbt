///|

///|
/// Zlib compression options
pub struct ZlibOptions {
  level : Int?
  chunk_size : Int?
  mem_level : Int?
  strategy : Int?
  window_bits : Int?
}

///|
/// Create default zlib options
pub fn ZlibOptions::new() -> ZlibOptions {
  {
    level: None,
    chunk_size: None,
    mem_level: None,
    strategy: None,
    window_bits: None,
  }
}

///|
/// Convert ZlibOptions to JavaScript object
pub fn ZlibOptions::to_any(self : ZlibOptions) -> @js.Any {
  let obj = @js.Object::new()
  match self.level {
    Some(v) => obj.set("level", v)
    None => ()
  }
  match self.chunk_size {
    Some(v) => obj.set("chunkSize", v)
    None => ()
  }
  match self.mem_level {
    Some(v) => obj.set("memLevel", v)
    None => ()
  }
  match self.strategy {
    Some(v) => obj.set("strategy", v)
    None => ()
  }
  match self.window_bits {
    Some(v) => obj.set("windowBits", v)
    None => ()
  }
  obj.to_any()
}

///|
extern "js" fn ffi_gzip(
  buffer : @js.Any,
  options : @js.Any,
  callback : @js.Any,
) -> Unit =
  #| (buffer, options, callback) => {
  #|   const zlib = require('zlib');
  #|   zlib.gzip(buffer, options, callback);
  #| }

///|
/// Compress data using gzip
pub fn gzip(
  buffer : @js.Object,
  options : ZlibOptions,
  callback : (@js.Object?, @js.Object) -> Unit,
) -> Unit {
  let cb : @js.Any = @js.identity(callback)
  ffi_gzip(buffer.to_any(), options.to_any(), cb)
}

///|
extern "js" fn ffi_gunzip(
  buffer : @js.Any,
  options : @js.Any,
  callback : @js.Any,
) -> Unit =
  #| (buffer, options, callback) => {
  #|   const zlib = require('zlib');
  #|   zlib.gunzip(buffer, options, callback);
  #| }

///|
/// Decompress gzip data
pub fn gunzip(
  buffer : @js.Object,
  options : ZlibOptions,
  callback : (@js.Object?, @js.Object) -> Unit,
) -> Unit {
  let cb : @js.Any = @js.identity(callback)
  ffi_gunzip(buffer.to_any(), options.to_any(), cb)
}

///|
extern "js" fn ffi_deflate(
  buffer : @js.Any,
  options : @js.Any,
  callback : @js.Any,
) -> Unit =
  #| (buffer, options, callback) => {
  #|   const zlib = require('zlib');
  #|   zlib.deflate(buffer, options, callback);
  #| }

///|
/// Compress data using deflate
pub fn deflate(
  buffer : @js.Object,
  options : ZlibOptions,
  callback : (@js.Object?, @js.Object) -> Unit,
) -> Unit {
  let cb : @js.Any = @js.identity(callback)
  ffi_deflate(buffer.to_any(), options.to_any(), cb)
}

///|
extern "js" fn ffi_inflate(
  buffer : @js.Any,
  options : @js.Any,
  callback : @js.Any,
) -> Unit =
  #| (buffer, options, callback) => {
  #|   const zlib = require('zlib');
  #|   zlib.inflate(buffer, options, callback);
  #| }

///|
/// Decompress deflate data
pub fn inflate(
  buffer : @js.Object,
  options : ZlibOptions,
  callback : (@js.Object?, @js.Object) -> Unit,
) -> Unit {
  let cb : @js.Any = @js.identity(callback)
  ffi_inflate(buffer.to_any(), options.to_any(), cb)
}

///|
extern "js" fn ffi_brotli_compress(
  buffer : @js.Any,
  options : @js.Any,
  callback : @js.Any,
) -> Unit =
  #| (buffer, options, callback) => {
  #|   const zlib = require('zlib');
  #|   zlib.brotliCompress(buffer, options, callback);
  #| }

///|
/// Compress data using Brotli
pub fn brotli_compress(
  buffer : @js.Object,
  options : ZlibOptions,
  callback : (@js.Object?, @js.Object) -> Unit,
) -> Unit {
  let cb : @js.Any = @js.identity(callback)
  ffi_brotli_compress(buffer.to_any(), options.to_any(), cb)
}

///|
extern "js" fn ffi_brotli_decompress(
  buffer : @js.Any,
  options : @js.Any,
  callback : @js.Any,
) -> Unit =
  #| (buffer, options, callback) => {
  #|   const zlib = require('zlib');
  #|   zlib.brotliDecompress(buffer, options, callback);
  #| }

///|
/// Decompress Brotli data
pub fn brotli_decompress(
  buffer : @js.Object,
  options : ZlibOptions,
  callback : (@js.Object?, @js.Object) -> Unit,
) -> Unit {
  let cb : @js.Any = @js.identity(callback)
  ffi_brotli_decompress(buffer.to_any(), options.to_any(), cb)
}

///|
extern "js" fn ffi_unzip(
  buffer : @js.Any,
  options : @js.Any,
  callback : @js.Any,
) -> Unit =
  #| (buffer, options, callback) => {
  #|   const zlib = require('zlib');
  #|   zlib.unzip(buffer, options, callback);
  #| }

///|
/// Decompress data with auto-detection
pub fn unzip(
  buffer : @js.Object,
  options : ZlibOptions,
  callback : (@js.Object?, @js.Object) -> Unit,
) -> Unit {
  let cb : @js.Any = @js.identity(callback)
  ffi_unzip(buffer.to_any(), options.to_any(), cb)
}

///|
/// Gzip compression stream
#external
pub type Gzip

///|
pub impl @js.JsImpl for Gzip

///|
extern "js" fn ffi_create_gzip(options : @js.Any) -> Gzip =
  #| (options) => {
  #|   const zlib = require('zlib');
  #|   return zlib.createGzip(options);
  #| }

///|
/// Create a Gzip compression stream
pub fn create_gzip(options : ZlibOptions) -> Gzip {
  ffi_create_gzip(options.to_any())
}

///|
/// Gunzip decompression stream
#external
pub type Gunzip

///|
pub impl @js.JsImpl for Gunzip

///|
extern "js" fn ffi_create_gunzip(options : @js.Any) -> Gunzip =
  #| (options) => {
  #|   const zlib = require('zlib');
  #|   return zlib.createGunzip(options);
  #| }

///|
/// Create a Gunzip decompression stream
pub fn create_gunzip(options : ZlibOptions) -> Gunzip {
  ffi_create_gunzip(options.to_any())
}

///|
/// Deflate compression stream
#external
pub type Deflate

///|
pub impl @js.JsImpl for Deflate

///|
extern "js" fn ffi_create_deflate(options : @js.Any) -> Deflate =
  #| (options) => {
  #|   const zlib = require('zlib');
  #|   return zlib.createDeflate(options);
  #| }

///|
/// Create a Deflate compression stream
pub fn create_deflate(options : ZlibOptions) -> Deflate {
  ffi_create_deflate(options.to_any())
}

///|
/// Inflate decompression stream
#external
pub type Inflate

///|
pub impl @js.JsImpl for Inflate

///|
extern "js" fn ffi_create_inflate(options : @js.Any) -> Inflate =
  #| (options) => {
  #|   const zlib = require('zlib');
  #|   return zlib.createInflate(options);
  #| }

///|
/// Create an Inflate decompression stream
pub fn create_inflate(options : ZlibOptions) -> Inflate {
  ffi_create_inflate(options.to_any())
}

///|
/// Brotli compression stream
#external
pub type BrotliCompress

///|
pub impl @js.JsImpl for BrotliCompress

///|
extern "js" fn ffi_create_brotli_compress(options : @js.Any) -> BrotliCompress =
  #| (options) => {
  #|   const zlib = require('zlib');
  #|   return zlib.createBrotliCompress(options);
  #| }

///|
/// Create a Brotli compression stream
pub fn create_brotli_compress(options : ZlibOptions) -> BrotliCompress {
  ffi_create_brotli_compress(options.to_any())
}

///|
/// Brotli decompression stream
#external
pub type BrotliDecompress

///|
pub impl @js.JsImpl for BrotliDecompress

///|
extern "js" fn ffi_create_brotli_decompress(
  options : @js.Any,
) -> BrotliDecompress =
  #| (options) => {
  #|   const zlib = require('zlib');
  #|   return zlib.createBrotliDecompress(options);
  #| }

///|
/// Create a Brotli decompression stream
pub fn create_brotli_decompress(options : ZlibOptions) -> BrotliDecompress {
  ffi_create_brotli_decompress(options.to_any())
}
