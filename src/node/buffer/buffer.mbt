///|
#external
pub type Buffer

///|
pub fn Buffer::as_any(self : Buffer) -> @nostd.Any = "%identity"

///|
/// BufferJSON - Result of Buffer.toJSON()
/// Contains the type string "Buffer" and the data as an array of bytes
#external
pub type BufferJSON

///|
pub fn BufferJSON::as_any(self : BufferJSON) -> @nostd.Any = "%identity"

///|
pub impl @js.JsImpl for BufferJSON

///|
/// Get the type field (always "Buffer")
pub fn BufferJSON::type_(self : BufferJSON) -> String {
  self.get("type") |> @js.identity
}

///|
/// Get the data as an array of bytes
pub fn BufferJSON::data(self : BufferJSON) -> Array[Int] {
  self.get("data") |> @js.identity
}

///|
pub impl @js.JsImpl for Buffer

///|
/// Get the Buffer constructor
extern "js" fn buffer_constructor() -> @js.Any =
  #| () => require("node:buffer").Buffer

///|
/// Convert Buffer to @js.Any for FFI calls
extern "js" fn buffer_to_js_any(buf : Buffer) -> @js.Any =
  #| (b) => b

///|
/// Create a Buffer from a string with optional encoding
pub fn Buffer::from_string(
  str : String,
  encoding? : String = "utf-8",
) -> Buffer {
  let ctor = buffer_constructor()
  ctor.call2("from", str, encoding).cast()
}

///|
/// Create a Buffer from an array of bytes
pub fn Buffer::from_array(arr : Array[Int]) -> Buffer {
  let ctor = buffer_constructor()
  ctor.call1("from", @js.from_array(arr)).cast()
}

///|
/// Create a Buffer from an ArrayBuffer
pub fn Buffer::from_arraybuffer(
  ab : @js.ArrayBuffer,
  byte_offset? : Int = 0,
  length? : Int,
) -> Buffer {
  let ctor = buffer_constructor()
  match length {
    Some(len) => ctor.call("from", [ab, byte_offset, len]).cast()
    None => ctor.call2("from", ab, byte_offset).cast()
  }
}

///|
/// Create a Buffer by copying another buffer
pub fn Buffer::from_buffer(buf : Buffer) -> Buffer {
  let ctor = buffer_constructor()
  ctor.call1("from", buffer_to_js_any(buf)).cast()
}

///|
/// Allocate a new zero-filled buffer
pub fn Buffer::alloc(
  size : Int,
  fill? : &@js.JsImpl,
  encoding? : String = "utf-8",
) -> Buffer {
  let ctor = buffer_constructor()
  match fill {
    Some(f) => ctor.call("alloc", [size, f.as_any(), encoding]).cast()
    None => ctor.call1("alloc", size).cast()
  }
}

///|
/// Allocate an uninitialized buffer (faster but potentially insecure)
#alias(alloc_unsafe)
pub fn Buffer::allocUnsafe(size : Int) -> Buffer {
  let ctor = buffer_constructor()
  ctor.call1("allocUnsafe", size).cast()
}

///|
/// Check if an object is a Buffer
#alias(is_buffer)
pub fn Buffer::isBuffer(obj : &@js.JsImpl) -> Bool {
  let ctor = buffer_constructor()
  ctor.call1("isBuffer", obj.as_any()).cast()
}

///|
/// Check if a string is a valid encoding
#alias(is_encoding)
pub fn Buffer::isEncoding(encoding : String) -> Bool {
  let ctor = buffer_constructor()
  ctor.call1("isEncoding", encoding).cast()
}

///|
/// Compare two buffers
pub fn Buffer::compare(buf1 : Buffer, buf2 : Buffer) -> Int {
  let ctor = buffer_constructor()
  ctor.call2("compare", buffer_to_js_any(buf1), buffer_to_js_any(buf2)).cast()
}

///|
/// Concatenate an array of buffers
pub fn Buffer::concat(list : Array[Buffer], total_length? : Int) -> Buffer {
  let ctor = buffer_constructor()
  let list_js = @js.from_array(list)
  match total_length {
    Some(len) => ctor.call2("concat", list_js, len).cast()
    None => ctor.call1("concat", list_js).cast()
  }
}

///|
/// Get the byte length of a string when encoded
#alias(byte_length)
pub fn Buffer::byteLength(str : String, encoding? : String = "utf-8") -> Int {
  let ctor = buffer_constructor()
  ctor.call2("byteLength", str, encoding).cast()
}

///|
/// Get the length of the buffer in bytes
pub fn Buffer::length(self : Self) -> Int {
  self.get("length").cast()
}

///|
/// Convert buffer to string with optional encoding and range
#alias(to_string)
pub fn Buffer::toString(
  self : Self,
  encoding? : String = "utf-8",
  start? : Int = 0,
  end? : Int,
) -> String {
  match end {
    Some(e) => self.call("toString", [encoding, start, e]).cast()
    None => self.call2("toString", encoding, start).cast()
  }
}

///|
/// Write a string to the buffer
pub fn Buffer::write(
  self : Self,
  str : String,
  offset? : Int = 0,
  length? : Int,
  encoding? : String = "utf-8",
) -> Int {
  let buf_js = self.as_any()
  match length {
    Some(len) =>
      buf_js
      ._call("write", [
        @nostd.any(str),
        @nostd.any(offset),
        @nostd.any(len),
        @nostd.any(encoding),
      ])
      .cast()
    None =>
      buf_js
      ._call("write", [
        @nostd.any(str),
        @nostd.any(offset),
        @nostd.any(encoding),
      ])
      .cast()
  }
}

///|
/// Create a view of a portion of the buffer
pub fn Buffer::slice(self : Self, start? : Int = 0, end? : Int) -> Buffer {
  let buf_js = self.as_any()
  match end {
    Some(e) => buf_js._call("slice", [@nostd.any(start), @nostd.any(e)]).cast()
    None => buf_js._call("slice", [@nostd.any(start)]).cast()
  }
}

///|
/// Create a subarray (TypedArray-compatible view)
pub fn Buffer::subarray(self : Self, start? : Int = 0, end? : Int) -> Buffer {
  let buf_js = self.as_any()
  match end {
    Some(e) =>
      buf_js._call("subarray", [@nostd.any(start), @nostd.any(e)]).cast()
    None => buf_js._call("subarray", [@nostd.any(start)]).cast()
  }
}

///|
/// Copy data from this buffer to a target buffer
pub fn Buffer::copy(
  self : Self,
  target : Buffer,
  target_start? : Int = 0,
  source_start? : Int = 0,
  source_end? : Int,
) -> Int {
  let buf_js = self.as_any()
  match source_end {
    Some(se) =>
      buf_js
      ._call("copy", [
        target.as_any(),
        @nostd.any(target_start),
        @nostd.any(source_start),
        @nostd.any(se),
      ])
      .cast()
    None =>
      buf_js
      ._call("copy", [
        target.as_any(),
        @nostd.any(target_start),
        @nostd.any(source_start),
      ])
      .cast()
  }
}

///|
/// Fill the buffer with a value
pub fn Buffer::fill(
  self : Self,
  value : &@js.JsImpl,
  offset? : Int = 0,
  end? : Int,
  encoding? : String = "utf-8",
) -> Buffer {
  let buf_js = self.as_any()
  match end {
    Some(e) =>
      buf_js
      ._call("fill", [
        @nostd.any(value.as_any()),
        @nostd.any(offset),
        @nostd.any(e),
        @nostd.any(encoding),
      ])
      .cast()
    None =>
      buf_js
      ._call("fill", [@nostd.any(value.as_any()), @nostd.any(offset)])
      .cast()
  }
}

///|
/// Test if this buffer equals another buffer
pub fn Buffer::equals(self : Self, other : Buffer) -> Bool {
  self.as_any()._call("equals", [other.as_any()]).cast()
}

///|
/// Compare this buffer with another buffer
pub fn Buffer::compare_with(
  self : Self,
  target : Buffer,
  target_start? : Int = 0,
  target_end? : Int,
  source_start? : Int = 0,
  source_end? : Int,
) -> Int {
  let buf_js = self.as_any()
  // Build args as @js.Any array for @js.from_array compatibility
  let args : Array[@js.Any] = [target.as_any().cast(), @js.any(target_start)]
  if target_end is Some(te) {
    args.push(@js.any(te))
  }
  args.push(@js.any(source_start))
  if source_end is Some(se) {
    args.push(@js.any(se))
  }
  let compare_fn = buf_js["compare"]
  let apply = compare_fn["apply"]
  apply
  ._call("call", [compare_fn, buf_js, @nostd.any(@js.from_array(args))])
  .cast()
}

///|
/// Check if the buffer includes a value
pub fn Buffer::includes(
  self : Self,
  value : &@js.JsImpl,
  byte_offset? : Int = 0,
  encoding? : String = "utf-8",
) -> Bool {
  self
  .as_any()
  ._call("includes", [
    @nostd.any(value.as_any()),
    @nostd.any(byte_offset),
    @nostd.any(encoding),
  ])
  .cast()
}

///|
/// Find the index of a value in the buffer
#alias(index_of)
pub fn Buffer::indexOf(
  self : Self,
  value : &@js.JsImpl,
  byte_offset? : Int = 0,
  encoding? : String = "utf-8",
) -> Int {
  self
  .as_any()
  ._call("indexOf", [
    @nostd.any(value.as_any()),
    @nostd.any(byte_offset),
    @nostd.any(encoding),
  ])
  .cast()
}

///|
/// Find the last index of a value in the buffer
#alias(last_index_of)
pub fn Buffer::lastIndexOf(
  self : Self,
  value : &@js.JsImpl,
  byte_offset? : Int,
  encoding? : String = "utf-8",
) -> Int {
  let buf_js = self.as_any()
  match byte_offset {
    Some(offset) =>
      buf_js
      ._call("lastIndexOf", [
        @nostd.any(value.as_any()),
        @nostd.any(offset),
        @nostd.any(encoding),
      ])
      .cast()
    None =>
      buf_js
      ._call("lastIndexOf", [@nostd.any(value.as_any()), @nostd.any(encoding)])
      .cast()
  }
}

///|
// extern "js" fn ffi_get_index(obj : @js.Any, index : Int) -> Js =
//   #|(obj, i) => obj[i]

// ///|
// extern "js" fn ffi_set_index(obj : @js.Any, index : Int, value : @js.Any) -> Unit =
//   #|(obj, i, v) => { obj[i] = v }

///|
/// Get a byte at a specific index
// pub fn Buffer::get(self : Self, index : Int) -> Int {
//   ffi_get_index(self.as_any(), index).cast()
// }

// ///|
// /// Set a byte at a specific index
// pub fn Buffer::set(self : Self, index : Int, value : Int) -> Unit {
//   ffi_set_index(self.as_any(), index, js(value))
// }

///|
/// Get the underlying ArrayBuffer
pub fn Buffer::buffer(self : Self) -> @js.ArrayBuffer {
  self.get("buffer").cast()
}

///|
/// Get the byte offset in the underlying ArrayBuffer
#alias(byte_offset)
pub fn Buffer::byteOffset(self : Self) -> Int {
  self.get("byteOffset").cast()
}

///|
/// Convert buffer to JSON representation
#alias(to_json)
pub fn Buffer::toJSON(self : Self) -> BufferJSON {
  self.call0("toJSON").cast()
}
