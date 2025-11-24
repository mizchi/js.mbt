///|
#external
pub type Buffer

///|
pub impl @js.JsImpl for Buffer

///|
/// Get the Buffer constructor
fn buffer_constructor() -> @js.Js {
  @node.require("node:buffer").get("Buffer")
}

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
  let arr_js = @js.JsArray::new()
  let mut i = 0
  while i < arr.length() {
    arr_js.call("push", [arr[i]]) |> ignore
    i = i + 1
  }
  ctor.call("from", [arr_js]).cast()
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
  ctor.call("from", [buf.to_js()]).cast()
}

///|
/// Allocate a new zero-filled buffer
pub fn Buffer::alloc(
  size : Int,
  fill? : @js.Js,
  encoding? : String = "utf-8",
) -> Buffer {
  let ctor = buffer_constructor()
  match fill {
    Some(f) => ctor.call("alloc", [size, f, encoding]).cast()
    None => ctor.call("alloc", [size]).cast()
  }
}

///|
/// Allocate an uninitialized buffer (faster but potentially insecure)
#alias(alloc_unsafe)
pub fn Buffer::allocUnsafe(size : Int) -> Buffer {
  let ctor = buffer_constructor()
  ctor.call("allocUnsafe", [size]).cast()
}

///|
/// Check if an object is a Buffer
#alias(is_buffer)
pub fn Buffer::isBuffer(obj : &@js.JsImpl) -> Bool {
  let ctor = buffer_constructor()
  ctor.call("isBuffer", [obj.to_js()]).cast()
}

///|
/// Check if a string is a valid encoding
#alias(is_encoding)
pub fn Buffer::isEncoding(encoding : String) -> Bool {
  let ctor = buffer_constructor()
  ctor.call("isEncoding", [encoding]).cast()
}

///|
/// Compare two buffers
pub fn Buffer::compare(buf1 : Buffer, buf2 : Buffer) -> Int {
  let ctor = buffer_constructor()
  ctor.call2("compare", buf1.to_js(), buf2.to_js()).cast()
}

///|
/// Concatenate an array of buffers
pub fn Buffer::concat(list : Array[Buffer], total_length? : Int) -> Buffer {
  let ctor = buffer_constructor()
  let list_js = @js.JsArray::new()
  let mut i = 0
  while i < list.length() {
    list_js.call("push", [list[i]]) |> ignore
    i = i + 1
  }
  match total_length {
    Some(len) => ctor.call2("concat", list_js, len).cast()
    None => ctor.call("concat", [list_js]).cast()
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
  let buf_js = self.to_js()
  match length {
    Some(len) => buf_js.call("write", [str, offset, len, encoding]).cast()
    None => buf_js.call("write", [str, offset, encoding]).cast()
  }
}

///|
/// Create a view of a portion of the buffer
pub fn Buffer::slice(self : Self, start? : Int = 0, end? : Int) -> Buffer {
  let buf_js = self.to_js()
  match end {
    Some(e) => buf_js.call2("slice", start, e).cast()
    None => buf_js.call("slice", [start]).cast()
  }
}

///|
/// Create a subarray (TypedArray-compatible view)
pub fn Buffer::subarray(self : Self, start? : Int = 0, end? : Int) -> Buffer {
  let buf_js = self.to_js()
  match end {
    Some(e) => buf_js.call2("subarray", start, e).cast()
    None => buf_js.call("subarray", [start]).cast()
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
      buf_js
      .call("copy", [target.to_js(), target_start, source_start, se])
      .cast()
    None =>
      buf_js.call("copy", [target.to_js(), target_start, source_start]).cast()
  }
}

///|
/// Fill the buffer with a value
pub fn Buffer::fill(
  self : Self,
  value : @js.Js,
  offset? : Int = 0,
  end? : Int,
  encoding? : String = "utf-8",
) -> Buffer {
  let buf_js = self.to_js()
  match end {
    Some(e) => buf_js.call("fill", [value, offset, e, encoding]).cast()
    None => buf_js.call2("fill", value, offset).cast()
  }
}

///|
/// Test if this buffer equals another buffer
pub fn Buffer::equals(self : Self, other : Buffer) -> Bool {
  self.call("equals", [other.to_js()]).cast()
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
  let args = @js.JsArray::new()
  args.call("push", [target.to_js()]) |> ignore
  args.call("push", [target_start]) |> ignore
  match target_end {
    Some(te) => args.call("push", [te]) |> ignore
    None => ()
  }
  args.call("push", [source_start]) |> ignore
  match source_end {
    Some(se) => args.call("push", [se]) |> ignore
    None => ()
  }
  let compare_fn = buf_js.get("compare")
  let apply = compare_fn.get("apply")
  apply.call("call", [compare_fn, buf_js, args]).cast()
}

///|
/// Check if the buffer includes a value
pub fn Buffer::includes(
  self : Self,
  value : @js.Js,
  byte_offset? : Int = 0,
  encoding? : String = "utf-8",
) -> Bool {
  self.call("includes", [value, byte_offset, encoding]).cast()
}

///|
/// Find the index of a value in the buffer
#alias(index_of)
pub fn Buffer::indexOf(
  self : Self,
  value : @js.Js,
  byte_offset? : Int = 0,
  encoding? : String = "utf-8",
) -> Int {
  self.call("indexOf", [value, byte_offset, encoding]).cast()
}

///|
/// Find the last index of a value in the buffer
#alias(last_index_of)
pub fn Buffer::lastIndexOf(
  self : Self,
  value : @js.Js,
  byte_offset? : Int,
  encoding? : String = "utf-8",
) -> Int {
  let buf_js = self.to_js()
  match byte_offset {
    Some(offset) => buf_js.call("lastIndexOf", [value, offset, encoding]).cast()
    None => buf_js.call2("lastIndexOf", value, encoding).cast()
  }
}

///|
// extern "js" fn ffi_get_index(obj : @js.Js, index : Int) -> Js =
//   #|(obj, i) => obj[i]

// ///|
// extern "js" fn ffi_set_index(obj : @js.Js, index : Int, value : @js.Js) -> Unit =
//   #|(obj, i, v) => { obj[i] = v }

///|
/// Get a byte at a specific index
// pub fn Buffer::get(self : Self, index : Int) -> Int {
//   ffi_get_index(self.to_js(), index).cast()
// }

// ///|
// /// Set a byte at a specific index
// pub fn Buffer::set(self : Self, index : Int, value : Int) -> Unit {
//   ffi_set_index(self.to_js(), index, js(value))
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
pub fn Buffer::toJSON(self : Self) -> @js.Js {
  self.call0("toJSON")
}
