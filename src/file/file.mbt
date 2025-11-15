// https://developer.mozilla.org/en-US/docs/Web/API/File
// Web File API

///|
using @js {type Val, trait Js, js}

///|
using @blob {type Blob}

///|
using @async {type Promise}

///|
using @arraybuffer {type ArrayBuffer}

///|
/// File represents a file object, extending Blob
#external
pub type File

///|
pub impl Js for File with to_js(self) -> Val {
  self |> js
}

///|
/// Create a new File from FFI
extern "js" fn ffi_new_file(data : Val, filename : Val, options : Val) -> Val =
  #|(data, filename, options) => new File(data, filename, options)

///|
/// Create a new File
pub fn File::new(
  data : Array[&Js],
  filename : String,
  content_type? : String,
  last_modified? : Int,
) -> File {
  let arr = @js.new_empty_array()
  let mut i = 0
  while i < data.length() {
    arr.call_method("push", [data[i].to_js()]) |> ignore
    i = i + 1
  }
  let options = @js.new_empty_object()
  match content_type {
    Some(t) => options.set("type", t)
    None => ()
  }
  match last_modified {
    Some(lm) => options.set("lastModified", lm)
    None => ()
  }
  ffi_new_file(arr, filename |> js, options).cast()
}

///|
/// Get the filename
pub fn File::name(self : Self) -> String {
  self.to_js().get("name").cast()
}

///|
/// Get the last modified timestamp in milliseconds
#alias(lastModified)
pub fn File::last_modified(self : Self) -> Int {
  self.to_js().get("lastModified").cast()
}

///|
/// Get the size of the file in bytes (inherited from Blob)
pub fn File::size(self : Self) -> Int {
  self.to_js().get("size").cast()
}

///|
/// Get the MIME type of the file (inherited from Blob)
pub fn File::content_type(self : Self) -> String {
  self.to_js().get("type").cast()
}

///|
/// Cast File to Blob
pub fn File::as_blob(self : Self) -> Blob {
  self.to_js().cast()
}

///|
/// Get the file contents as ArrayBuffer (inherited from Blob)
#alias(arrayBuffer)
pub fn File::array_buffer(self : Self) -> Promise[ArrayBuffer] {
  self.to_js().call_method("arrayBuffer", []).cast()
}

///|
/// Get the file contents as text (inherited from Blob)
pub fn File::text(self : Self) -> Promise[String] {
  self.to_js().call_method("text", []).cast()
}

///|
/// Create a new File containing a slice of this File (inherited from Blob)
pub fn File::slice(self : Self, start? : Int, end? : Int) -> Blob {
  match (start, end) {
    (None, None) => self.to_js().call_method("slice", []).cast()
    (Some(s), None) => self.to_js().call_method("slice", [s |> js]).cast()
    (Some(s), Some(e)) =>
      self.to_js().call_method("slice", [s |> js, e |> js]).cast()
    (None, Some(e)) =>
      self.to_js().call_method("slice", [0 |> js, e |> js]).cast()
  }
}

///| FileReader

///|
/// FileReader allows reading file contents asynchronously
#external
pub type FileReader

///|
pub impl Js for FileReader with to_js(self) -> Val {
  self |> js
}

///|
/// Create a new FileReader
extern "js" fn ffi_new_file_reader() -> Val =
  #|() => new FileReader()

///|
/// Create a new FileReader
pub fn FileReader::new() -> FileReader {
  ffi_new_file_reader().cast()
}

///|
/// Get the ready state (0=EMPTY, 1=LOADING, 2=DONE)
#alias(readyState)
pub fn FileReader::ready_state(self : Self) -> Int {
  self.to_js().get("readyState").cast()
}

///|
/// Get the result after reading completes
pub fn FileReader::result(self : Self) -> Val? {
  self.to_js().get("result").cast_option()
}

///|
/// Get the error if read failed
pub fn FileReader::error(self : Self) -> Val? {
  self.to_js().get("error").cast_option()
}

///|
/// Read file as ArrayBuffer
#alias(readAsArrayBuffer)
pub fn FileReader::read_as_array_buffer(self : Self, blob : Blob) -> Unit {
  self.to_js().call_method("readAsArrayBuffer", [blob.to_js()]) |> ignore
}

///|
/// Read file as text with optional encoding
#alias(readAsText)
pub fn FileReader::read_as_text(
  self : Self,
  blob : Blob,
  encoding? : String,
) -> Unit {
  match encoding {
    Some(enc) =>
      self.to_js().call_method("readAsText", [blob.to_js(), enc |> js])
      |> ignore
    None => self.to_js().call_method("readAsText", [blob.to_js()]) |> ignore
  }
}

///|
/// Read file as Data URL
#alias(readAsDataURL)
pub fn FileReader::read_as_data_url(self : Self, blob : Blob) -> Unit {
  self.to_js().call_method("readAsDataURL", [blob.to_js()]) |> ignore
}

///|
/// Abort the read operation
pub fn FileReader::abort(self : Self) -> Unit {
  self.to_js().call_method("abort", []) |> ignore
}

///|
/// Set onload event handler
pub fn FileReader::set_onload(
  self : Self,
  callback : (Val) -> Unit noraise,
) -> Unit {
  self.to_js().set("onload", @js.unsafe_cast(callback))
}

///|
/// Set onerror event handler
pub fn FileReader::set_onerror(
  self : Self,
  callback : (Val) -> Unit noraise,
) -> Unit {
  self.to_js().set("onerror", @js.unsafe_cast(callback))
}

///|
/// Set onloadend event handler
pub fn FileReader::set_onloadend(
  self : Self,
  callback : (Val) -> Unit noraise,
) -> Unit {
  self.to_js().set("onloadend", @js.unsafe_cast(callback))
}
