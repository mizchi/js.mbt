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
/// Get the type field (always "Buffer")
pub fn BufferJSON::type_(self : BufferJSON) -> String {
  self.as_any()["type"].cast()
}

///|
/// Get the data as an array of bytes
pub fn BufferJSON::data(self : BufferJSON) -> Array[Int] {
  self.as_any()["data"].cast()
}

///|
/// Get the Buffer constructor
extern "js" fn buffer_constructor() -> @nostd.Any =
  #| () => require("node:buffer").Buffer

///|
/// Convert Buffer to @nostd.Any for FFI calls
extern "js" fn buffer_to_js_any(buf : Buffer) -> @nostd.Any =
  #| (b) => b

///|
/// Create a Buffer from a string with optional encoding
pub fn Buffer::from_string(
  str : String,
  encoding? : String = "utf-8",
) -> Buffer {
  let ctor : @nostd.Any = buffer_constructor() |> @nostd.any
  ctor._call("from", [@nostd.any(str), @nostd.any(encoding)]).cast()
}

///|
/// Create a Buffer from an array of bytes
pub fn Buffer::from_array(arr : Array[Int]) -> Buffer {
  let ctor : @nostd.Any = buffer_constructor() |> @nostd.any
  ctor._call("from", [@nostd.any(@nostd.any(arr))]).cast()
}

///|
/// Create a Buffer from an ArrayBuffer
pub fn Buffer::from_arraybuffer(
  ab : @js.ArrayBuffer,
  byte_offset? : Int = 0,
  length? : Int,
) -> Buffer {
  let ctor : @nostd.Any = buffer_constructor() |> @nostd.any
  match length {
    Some(len) =>
      ctor
      ._call("from", [@nostd.any(ab), @nostd.any(byte_offset), @nostd.any(len)])
      .cast()
    None => ctor._call("from", [@nostd.any(ab), @nostd.any(byte_offset)]).cast()
  }
}

///|
/// Create a Buffer by copying another buffer
pub fn Buffer::from_buffer(buf : Buffer) -> Buffer {
  let ctor : @nostd.Any = buffer_constructor() |> @nostd.any
  ctor._call("from", [@nostd.any(buffer_to_js_any(buf))]).cast()
}

///|
/// Allocate a new zero-filled buffer
pub fn Buffer::alloc(
  size : Int,
  fill? : @nostd.Any,
  encoding? : String = "utf-8",
) -> Buffer {
  let ctor : @nostd.Any = buffer_constructor() |> @nostd.any
  match fill {
    Some(f) =>
      ctor._call("alloc", [@nostd.any(size), f, @nostd.any(encoding)]).cast()
    None => ctor._call("alloc", [@nostd.any(size)]).cast()
  }
}

///|
/// Allocate an uninitialized buffer (faster but potentially insecure)
#alias(alloc_unsafe)
pub fn Buffer::allocUnsafe(size : Int) -> Buffer {
  let ctor : @nostd.Any = buffer_constructor() |> @nostd.any
  ctor._call("allocUnsafe", [@nostd.any(size)]).cast()
}

///|
/// Check if an object is a Buffer
#alias(is_buffer)
pub fn Buffer::isBuffer(obj : @nostd.Any) -> Bool {
  let ctor : @nostd.Any = buffer_constructor() |> @nostd.any
  ctor._call("isBuffer", [obj]).cast()
}

///|
/// Check if a string is a valid encoding
#alias(is_encoding)
pub fn Buffer::isEncoding(encoding : String) -> Bool {
  let ctor : @nostd.Any = buffer_constructor() |> @nostd.any
  ctor._call("isEncoding", [@nostd.any(encoding)]).cast()
}

///|
/// Compare two buffers
pub fn Buffer::compare(buf1 : Buffer, buf2 : Buffer) -> Int {
  let ctor : @nostd.Any = buffer_constructor() |> @nostd.any
  ctor
  ._call("compare", [
    @nostd.any(buffer_to_js_any(buf1)),
    @nostd.any(buffer_to_js_any(buf2)),
  ])
  .cast()
}

///|
/// Concatenate an array of buffers
pub fn Buffer::concat(list : Array[Buffer], total_length? : Int) -> Buffer {
  let ctor : @nostd.Any = buffer_constructor() |> @nostd.any
  let list_js = @nostd.any(list)
  match total_length {
    Some(len) =>
      ctor._call("concat", [@nostd.any(list_js), @nostd.any(len)]).cast()
    None => ctor._call("concat", [@nostd.any(list_js)]).cast()
  }
}

///|
/// Get the byte length of a string when encoded
#alias(byte_length)
pub fn Buffer::byteLength(str : String, encoding? : String = "utf-8") -> Int {
  let ctor : @nostd.Any = buffer_constructor() |> @nostd.any
  ctor._call("byteLength", [@nostd.any(str), @nostd.any(encoding)]).cast()
}

///|
/// Get the length of the buffer in bytes
pub fn Buffer::length(self : Self) -> Int {
  self.as_any()["length"].cast()
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
  let self_any = self.as_any()
  match end {
    Some(e) =>
      self_any
      ._call("toString", [
        @nostd.any(encoding),
        @nostd.any(start),
        @nostd.any(e),
      ])
      .cast()
    None =>
      self_any
      ._call("toString", [@nostd.any(encoding), @nostd.any(start)])
      .cast()
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
  value : @nostd.Any,
  offset? : Int = 0,
  end? : Int,
  encoding? : String = "utf-8",
) -> Buffer {
  let buf_js = self.as_any()
  match end {
    Some(e) =>
      buf_js
      ._call("fill", [
        value,
        @nostd.any(offset),
        @nostd.any(e),
        @nostd.any(encoding),
      ])
      .cast()
    None => buf_js._call("fill", [value, @nostd.any(offset)]).cast()
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
  // Build args as @nostd.Any array for @nostd.any compatibility
  let args : Array[@nostd.Any] = [
    target.as_any().cast(),
    @nostd.any(target_start),
  ]
  if target_end is Some(te) {
    args.push(@nostd.any(te))
  }
  args.push(@nostd.any(source_start))
  if source_end is Some(se) {
    args.push(@nostd.any(se))
  }
  let compare_fn = buf_js["compare"]
  let apply = compare_fn["apply"]
  apply._call("call", [compare_fn, buf_js, @nostd.any(@nostd.any(args))]).cast()
}

///|
/// Check if the buffer includes a value
pub fn Buffer::includes(
  self : Self,
  value : @nostd.Any,
  byte_offset? : Int = 0,
  encoding? : String = "utf-8",
) -> Bool {
  self
  .as_any()
  ._call("includes", [value, @nostd.any(byte_offset), @nostd.any(encoding)])
  .cast()
}

///|
/// Find the index of a value in the buffer
#alias(index_of)
pub fn Buffer::indexOf(
  self : Self,
  value : @nostd.Any,
  byte_offset? : Int = 0,
  encoding? : String = "utf-8",
) -> Int {
  self
  .as_any()
  ._call("indexOf", [value, @nostd.any(byte_offset), @nostd.any(encoding)])
  .cast()
}

///|
/// Find the last index of a value in the buffer
#alias(last_index_of)
pub fn Buffer::lastIndexOf(
  self : Self,
  value : @nostd.Any,
  byte_offset? : Int,
  encoding? : String = "utf-8",
) -> Int {
  let buf_js = self.as_any()
  match byte_offset {
    Some(offset) =>
      buf_js
      ._call("lastIndexOf", [value, @nostd.any(offset), @nostd.any(encoding)])
      .cast()
    None => buf_js._call("lastIndexOf", [value, @nostd.any(encoding)]).cast()
  }
}

///|
// extern "js" fn ffi_get_index(obj : @nostd.Any, index : Int) -> Js =
//   #|(obj, i) => obj[i]

// ///|
// extern "js" fn ffi_set_index(obj : @nostd.Any, index : Int, value : @nostd.Any) -> Unit =
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
  self.as_any()["buffer"].cast()
}

///|
/// Get the byte offset in the underlying ArrayBuffer
#alias(byte_offset)
pub fn Buffer::byteOffset(self : Self) -> Int {
  self.as_any()["byteOffset"].cast()
}

///|
/// Convert buffer to JSON representation
#alias(to_json)
pub fn Buffer::toJSON(self : Self) -> BufferJSON {
  self.as_any()._call("toJSON", []).cast()
}
