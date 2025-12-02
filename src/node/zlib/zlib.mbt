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
pub fn ZlibOptions::as_any(self : ZlibOptions) -> @core.Any {
  let obj = @core.new_object()
  match self.level {
    Some(v) => obj._set("level", v |> @core.any)
    None => ()
  }
  match self.chunk_size {
    Some(v) => obj._set("chunkSize", v |> @core.any)
    None => ()
  }
  match self.mem_level {
    Some(v) => obj._set("memLevel", v |> @core.any)
    None => ()
  }
  match self.strategy {
    Some(v) => obj._set("strategy", v |> @core.any)
    None => ()
  }
  match self.window_bits {
    Some(v) => obj._set("windowBits", v |> @core.any)
    None => ()
  }
  obj
}

///|
extern "js" fn ffi_gzip(
  buffer : @core.Any,
  options : @core.Any,
  callback : @core.Any,
) -> Unit =
  #| (buffer, options, callback) => {
  #|   const zlib = require('zlib');
  #|   zlib.gzip(buffer, options, callback);
  #| }

///|
/// Compress data using gzip
pub fn gzip(
  buffer : @core.Any,
  options : ZlibOptions,
  callback : (@core.Any?, @core.Any) -> Unit,
) -> Unit {
  let cb : @core.Any = @core.identity(callback)
  ffi_gzip(buffer, options.as_any(), cb)
}

///|
extern "js" fn ffi_gunzip(
  buffer : @core.Any,
  options : @core.Any,
  callback : @core.Any,
) -> Unit =
  #| (buffer, options, callback) => {
  #|   const zlib = require('zlib');
  #|   zlib.gunzip(buffer, options, callback);
  #| }

///|
/// Decompress gzip data
pub fn gunzip(
  buffer : @core.Any,
  options : ZlibOptions,
  callback : (@core.Any?, @core.Any) -> Unit,
) -> Unit {
  let cb : @core.Any = @core.identity(callback)
  ffi_gunzip(buffer, options.as_any(), cb)
}

///|
extern "js" fn ffi_deflate(
  buffer : @core.Any,
  options : @core.Any,
  callback : @core.Any,
) -> Unit =
  #| (buffer, options, callback) => {
  #|   const zlib = require('zlib');
  #|   zlib.deflate(buffer, options, callback);
  #| }

///|
/// Compress data using deflate
pub fn deflate(
  buffer : @core.Any,
  options : ZlibOptions,
  callback : (@core.Any?, @core.Any) -> Unit,
) -> Unit {
  let cb : @core.Any = @core.identity(callback)
  ffi_deflate(buffer, options.as_any(), cb)
}

///|
extern "js" fn ffi_inflate(
  buffer : @core.Any,
  options : @core.Any,
  callback : @core.Any,
) -> Unit =
  #| (buffer, options, callback) => {
  #|   const zlib = require('zlib');
  #|   zlib.inflate(buffer, options, callback);
  #| }

///|
/// Decompress deflate data
pub fn inflate(
  buffer : @core.Any,
  options : ZlibOptions,
  callback : (@core.Any?, @core.Any) -> Unit,
) -> Unit {
  let cb : @core.Any = @core.identity(callback)
  ffi_inflate(buffer, options.as_any(), cb)
}

///|
extern "js" fn ffi_brotli_compress(
  buffer : @core.Any,
  options : @core.Any,
  callback : @core.Any,
) -> Unit =
  #| (buffer, options, callback) => {
  #|   const zlib = require('zlib');
  #|   zlib.brotliCompress(buffer, options, callback);
  #| }

///|
/// Compress data using Brotli
pub fn brotli_compress(
  buffer : @core.Any,
  options : ZlibOptions,
  callback : (@core.Any?, @core.Any) -> Unit,
) -> Unit {
  let cb : @core.Any = @core.identity(callback)
  ffi_brotli_compress(buffer, options.as_any(), cb)
}

///|
extern "js" fn ffi_brotli_decompress(
  buffer : @core.Any,
  options : @core.Any,
  callback : @core.Any,
) -> Unit =
  #| (buffer, options, callback) => {
  #|   const zlib = require('zlib');
  #|   zlib.brotliDecompress(buffer, options, callback);
  #| }

///|
/// Decompress Brotli data
pub fn brotli_decompress(
  buffer : @core.Any,
  options : ZlibOptions,
  callback : (@core.Any?, @core.Any) -> Unit,
) -> Unit {
  let cb : @core.Any = @core.identity(callback)
  ffi_brotli_decompress(buffer, options.as_any(), cb)
}

///|
extern "js" fn ffi_unzip(
  buffer : @core.Any,
  options : @core.Any,
  callback : @core.Any,
) -> Unit =
  #| (buffer, options, callback) => {
  #|   const zlib = require('zlib');
  #|   zlib.unzip(buffer, options, callback);
  #| }

///|
/// Decompress data with auto-detection
pub fn unzip(
  buffer : @core.Any,
  options : ZlibOptions,
  callback : (@core.Any?, @core.Any) -> Unit,
) -> Unit {
  let cb : @core.Any = @core.identity(callback)
  ffi_unzip(buffer, options.as_any(), cb)
}

///|
/// Gzip compression stream
#external
pub type Gzip

///|
pub fn Gzip::as_any(self : Gzip) -> @core.Any = "%identity"

///|
extern "js" fn ffi_create_gzip(options : @core.Any) -> Gzip =
  #| (options) => {
  #|   const zlib = require('zlib');
  #|   return zlib.createGzip(options);
  #| }

///|
/// Create a Gzip compression stream
pub fn create_gzip(options : ZlibOptions) -> Gzip {
  ffi_create_gzip(options.as_any())
}

///|
/// Gunzip decompression stream
#external
pub type Gunzip

///|
pub fn Gunzip::as_any(self : Gunzip) -> @core.Any = "%identity"

///|
extern "js" fn ffi_create_gunzip(options : @core.Any) -> Gunzip =
  #| (options) => {
  #|   const zlib = require('zlib');
  #|   return zlib.createGunzip(options);
  #| }

///|
/// Create a Gunzip decompression stream
pub fn create_gunzip(options : ZlibOptions) -> Gunzip {
  ffi_create_gunzip(options.as_any())
}

///|
/// Deflate compression stream
#external
pub type Deflate

///|
pub fn Deflate::as_any(self : Deflate) -> @core.Any = "%identity"

///|
extern "js" fn ffi_create_deflate(options : @core.Any) -> Deflate =
  #| (options) => {
  #|   const zlib = require('zlib');
  #|   return zlib.createDeflate(options);
  #| }

///|
/// Create a Deflate compression stream
pub fn create_deflate(options : ZlibOptions) -> Deflate {
  ffi_create_deflate(options.as_any())
}

///|
/// Inflate decompression stream
#external
pub type Inflate

///|
pub fn Inflate::as_any(self : Inflate) -> @core.Any = "%identity"

///|
extern "js" fn ffi_create_inflate(options : @core.Any) -> Inflate =
  #| (options) => {
  #|   const zlib = require('zlib');
  #|   return zlib.createInflate(options);
  #| }

///|
/// Create an Inflate decompression stream
pub fn create_inflate(options : ZlibOptions) -> Inflate {
  ffi_create_inflate(options.as_any())
}

///|
/// Brotli compression stream
#external
pub type BrotliCompress

///|
pub fn BrotliCompress::as_any(self : BrotliCompress) -> @core.Any = "%identity"

///|
extern "js" fn ffi_create_brotli_compress(
  options : @core.Any,
) -> BrotliCompress =
  #| (options) => {
  #|   const zlib = require('zlib');
  #|   return zlib.createBrotliCompress(options);
  #| }

///|
/// Create a Brotli compression stream
pub fn create_brotli_compress(options : ZlibOptions) -> BrotliCompress {
  ffi_create_brotli_compress(options.as_any())
}

///|
/// Brotli decompression stream
#external
pub type BrotliDecompress

///|
pub fn BrotliDecompress::as_any(self : BrotliDecompress) -> @core.Any = "%identity"

///|
extern "js" fn ffi_create_brotli_decompress(
  options : @core.Any,
) -> BrotliDecompress =
  #| (options) => {
  #|   const zlib = require('zlib');
  #|   return zlib.createBrotliDecompress(options);
  #| }

///|
/// Create a Brotli decompression stream
pub fn create_brotli_decompress(options : ZlibOptions) -> BrotliDecompress {
  ffi_create_brotli_decompress(options.as_any())
}
