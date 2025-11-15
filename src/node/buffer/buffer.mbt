///|
using @js {type Val, js, trait Js}

///|
using @arraybuffer {type ArrayBuffer, type Uint8Array}

///|
#external
pub type Buffer

///|
pub impl Js for Buffer with to_js(self) -> Val {
  self |> js
}

///|
/// Get the Buffer constructor
fn buffer_constructor() -> Val {
  @node.require("node:buffer").get("Buffer")
}

///|
/// Create a Buffer from a string with optional encoding
pub fn Buffer::from_string(
  str : String,
  encoding? : String = "utf-8",
) -> Buffer {
  let ctor = buffer_constructor()
  ctor.invoke("from", [str, encoding]).cast()
}

///|
/// Create a Buffer from an array of bytes
pub fn Buffer::from_array(arr : Array[Int]) -> Buffer {
  let ctor = buffer_constructor()
  let arr_js = @js.new_empty_array()
  let mut i = 0
  while i < arr.length() {
    arr_js.invoke("push", [arr[i]]) |> ignore
    i = i + 1
  }
  ctor.invoke("from", [arr_js]).cast()
}

///|
/// Create a Buffer from an ArrayBuffer
pub fn Buffer::from_arraybuffer(
  ab : ArrayBuffer,
  byte_offset? : Int = 0,
  length? : Int,
) -> Buffer {
  let ctor = buffer_constructor()
  match length {
    Some(len) => ctor.invoke("from", [ab, byte_offset, len]).cast()
    None => ctor.invoke("from", [ab, byte_offset]).cast()
  }
}

///|
/// Create a Buffer by copying another buffer
pub fn Buffer::from_buffer(buf : Buffer) -> Buffer {
  let ctor = buffer_constructor()
  ctor.invoke("from", [buf]).cast()
}

///|
/// Allocate a new zero-filled buffer
pub fn Buffer::alloc(
  size : Int,
  fill? : Val,
  encoding? : String = "utf-8",
) -> Buffer {
  let ctor = buffer_constructor()
  match fill {
    Some(f) => ctor.invoke("alloc", [size, f, encoding]).cast()
    None => ctor.invoke("alloc", [size]).cast()
  }
}

///|
/// Allocate an uninitialized buffer (faster but potentially insecure)
#alias(alloc_unsafe)
pub fn Buffer::allocUnsafe(size : Int) -> Buffer {
  let ctor = buffer_constructor()
  ctor.invoke("allocUnsafe", [size]).cast()
}

///|
/// Check if an object is a Buffer
#alias(is_buffer)
pub fn Buffer::isBuffer(obj : Val) -> Bool {
  let ctor = buffer_constructor()
  ctor.invoke("isBuffer", [obj]).cast()
}

///|
/// Check if a string is a valid encoding
#alias(is_encoding)
pub fn Buffer::isEncoding(encoding : String) -> Bool {
  let ctor = buffer_constructor()
  ctor.invoke("isEncoding", [encoding]).cast()
}

///|
/// Compare two buffers
pub fn Buffer::compare(buf1 : Buffer, buf2 : Buffer) -> Int {
  let ctor = buffer_constructor()
  ctor.invoke("compare", [buf1, buf2]).cast()
}

///|
/// Concatenate an array of buffers
pub fn Buffer::concat(list : Array[Buffer], total_length? : Int) -> Buffer {
  let ctor = buffer_constructor()
  let list_js = @js.new_empty_array()
  let mut i = 0
  while i < list.length() {
    list_js.invoke("push", [list[i]]) |> ignore
    i = i + 1
  }
  match total_length {
    Some(len) => ctor.invoke("concat", [list_js, len]).cast()
    None => ctor.invoke("concat", [list_js]).cast()
  }
}

///|
/// Get the byte length of a string when encoded
#alias(byte_length)
pub fn Buffer::byteLength(str : String, encoding? : String = "utf-8") -> Int {
  let ctor = buffer_constructor()
  ctor.invoke("byteLength", [str, encoding]).cast()
}

///|
/// Get the length of the buffer in bytes
pub fn Buffer::length(self : Self) -> Int {
  self.to_js().get("length").cast()
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
    Some(e) => self.to_js().invoke("toString", [encoding, start, e]).cast()
    None => self.to_js().invoke("toString", [encoding, start]).cast()
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
  let buf_js = self.to_js()
  match length {
    Some(len) => buf_js.invoke("write", [str, offset, len, encoding]).cast()
    None => buf_js.invoke("write", [str, offset, encoding]).cast()
  }
}

///|
/// Create a view of a portion of the buffer
pub fn Buffer::slice(self : Self, start? : Int = 0, end? : Int) -> Buffer {
  let buf_js = self.to_js()
  match end {
    Some(e) => buf_js.invoke("slice", [start, e]).cast()
    None => buf_js.invoke("slice", [start]).cast()
  }
}

///|
/// Create a subarray (TypedArray-compatible view)
pub fn Buffer::subarray(self : Self, start? : Int = 0, end? : Int) -> Buffer {
  let buf_js = self.to_js()
  match end {
    Some(e) => buf_js.invoke("subarray", [start, e]).cast()
    None => buf_js.invoke("subarray", [start]).cast()
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
  let buf_js = self.to_js()
  match source_end {
    Some(se) =>
      buf_js.invoke("copy", [target, target_start, source_start, se]).cast()
    None => buf_js.invoke("copy", [target, target_start, source_start]).cast()
  }
}

///|
/// Fill the buffer with a value
pub fn Buffer::fill(
  self : Self,
  value : Val,
  offset? : Int = 0,
  end? : Int,
  encoding? : String = "utf-8",
) -> Buffer {
  let buf_js = self.to_js()
  match end {
    Some(e) => buf_js.invoke("fill", [value, offset, e, encoding]).cast()
    None => buf_js.invoke("fill", [value, offset]).cast()
  }
}

///|
/// Test if this buffer equals another buffer
pub fn Buffer::equals(self : Self, other : Buffer) -> Bool {
  self.to_js().invoke("equals", [other]).cast()
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
  let buf_js = self.to_js()
  let args = @js.new_empty_array()
  args.invoke("push", [target]) |> ignore
  args.invoke("push", [target_start]) |> ignore
  match target_end {
    Some(te) => args.invoke("push", [te]) |> ignore
    None => ()
  }
  args.invoke("push", [source_start]) |> ignore
  match source_end {
    Some(se) => args.invoke("push", [se]) |> ignore
    None => ()
  }
  let compare_fn = buf_js.get("compare")
  let apply = compare_fn.get("apply")
  apply.invoke("call", [compare_fn, buf_js, args]).cast()
}

///|
/// Check if the buffer includes a value
pub fn Buffer::includes(
  self : Self,
  value : Val,
  byte_offset? : Int = 0,
  encoding? : String = "utf-8",
) -> Bool {
  self.to_js().invoke("includes", [value, byte_offset, encoding]).cast()
}

///|
/// Find the index of a value in the buffer
#alias(index_of)
pub fn Buffer::indexOf(
  self : Self,
  value : Val,
  byte_offset? : Int = 0,
  encoding? : String = "utf-8",
) -> Int {
  self.to_js().invoke("indexOf", [value, byte_offset, encoding]).cast()
}

///|
/// Find the last index of a value in the buffer
#alias(last_index_of)
pub fn Buffer::lastIndexOf(
  self : Self,
  value : Val,
  byte_offset? : Int,
  encoding? : String = "utf-8",
) -> Int {
  let buf_js = self.to_js()
  match byte_offset {
    Some(offset) =>
      buf_js.invoke("lastIndexOf", [value, offset, encoding]).cast()
    None => buf_js.invoke("lastIndexOf", [value, encoding]).cast()
  }
}

///|
extern "js" fn ffi_get_index(obj : Val, index : Int) -> Val =
  #|(obj, i) => obj[i]

///|
extern "js" fn ffi_set_index(obj : Val, index : Int, value : Val) -> Unit =
  #|(obj, i, v) => { obj[i] = v }

///|
/// Get a byte at a specific index
pub fn Buffer::get(self : Self, index : Int) -> Int {
  ffi_get_index(self.to_js(), index).cast()
}

///|
/// Set a byte at a specific index
pub fn Buffer::set(self : Self, index : Int, value : Int) -> Unit {
  ffi_set_index(self.to_js(), index, js(value))
}

///|
/// Get the underlying ArrayBuffer
pub fn Buffer::buffer(self : Self) -> ArrayBuffer {
  self.to_js().get("buffer").cast()
}

///|
/// Get the byte offset in the underlying ArrayBuffer
#alias(byte_offset)
pub fn Buffer::byteOffset(self : Self) -> Int {
  self.to_js().get("byteOffset").cast()
}

///|
/// Convert buffer to JSON representation
#alias(to_json)
pub fn Buffer::toJSON(self : Self) -> Val {
  self.to_js().invoke("toJSON", [])
}
