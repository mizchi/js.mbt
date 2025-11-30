///|
#external
pub type Buffer

///|
/// BufferJSON - Result of Buffer.toJSON()
/// Contains the type string "Buffer" and the data as an array of bytes
#external
pub type BufferJSON

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
  ctor.call1("from", buf.as_any()).cast()
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
  ctor.call2("compare", buf1.as_any(), buf2.as_any()).cast()
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
    Some(len) => buf_js.call("write", [str, offset, len, encoding]).cast()
    None => buf_js.call("write", [str, offset, encoding]).cast()
  }
}

///|
/// Create a view of a portion of the buffer
pub fn Buffer::slice(self : Self, start? : Int = 0, end? : Int) -> Buffer {
  let buf_js = self.as_any()
  match end {
    Some(e) => buf_js.call2("slice", start, e).cast()
    None => buf_js.call1("slice", start).cast()
  }
}

///|
/// Create a subarray (TypedArray-compatible view)
pub fn Buffer::subarray(self : Self, start? : Int = 0, end? : Int) -> Buffer {
  let buf_js = self.as_any()
  match end {
    Some(e) => buf_js.call2("subarray", start, e).cast()
    None => buf_js.call1("subarray", start).cast()
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
      .call("copy", [target.as_any(), target_start, source_start, se])
      .cast()
    None =>
      buf_js.call("copy", [target.as_any(), target_start, source_start]).cast()
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
    Some(e) => buf_js.call("fill", [value.as_any(), offset, e, encoding]).cast()
    None => buf_js.call2("fill", value.as_any(), offset).cast()
  }
}

///|
/// Test if this buffer equals another buffer
pub fn Buffer::equals(self : Self, other : Buffer) -> Bool {
  self.call1("equals", other.as_any()).cast()
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
  let args : Array[@js.Any] = [target.as_any(), @js.any(target_start)]
  if target_end is Some(te) {
    args.push(@js.any(te))
  }
  args.push(@js.any(source_start))
  if source_end is Some(se) {
    args.push(@js.any(se))
  }
  let compare_fn = buf_js.get("compare")
  let apply = compare_fn.get("apply")
  apply.call("call", [compare_fn, buf_js, @js.from_array(args)]).cast()
}

///|
/// Check if the buffer includes a value
pub fn Buffer::includes(
  self : Self,
  value : &@js.JsImpl,
  byte_offset? : Int = 0,
  encoding? : String = "utf-8",
) -> Bool {
  self.call("includes", [value.as_any(), byte_offset, encoding]).cast()
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
  self.call("indexOf", [value.as_any(), byte_offset, encoding]).cast()
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
      buf_js.call("lastIndexOf", [value.as_any(), offset, encoding]).cast()
    None => buf_js.call2("lastIndexOf", value.as_any(), encoding).cast()
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
