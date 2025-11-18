// https://developer.mozilla.org/en-US/docs/Web/API/File
// Web File API

///|
/// File represents a file object, extending Blob
#external
pub type File

///|
pub impl Js for File

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
  let arr = @js.JsArray::new()
  let mut i = 0
  while i < data.length() {
    arr.invoke("push", [data[i].to_js()]) |> ignore
    i = i + 1
  }
  let options = @js.Object::new()
  match content_type {
    Some(t) => options.set("type", t)
    None => ()
  }
  match last_modified {
    Some(lm) => options.set("lastModified", lm)
    None => ()
  }
  unsafe_cast(ffi_new_file(arr.to_js(), filename |> js, options.to_js()))
}

///|
/// Get the filename
pub fn File::name(self : Self) -> String {
  unsafe_cast(self.get("name"))
}

///|
/// Get the last modified timestamp in milliseconds
#alias(lastModified)
pub fn File::last_modified(self : Self) -> Int {
  unsafe_cast(self.get("lastModified"))
}

///|
/// Get the size of the file in bytes (inherited from Blob)
pub fn File::size(self : Self) -> Int {
  unsafe_cast(self.get("size"))
}

///|
/// Get the MIME type of the file (inherited from Blob)
#alias(content_type)
pub fn File::contentType(self : Self) -> String {
  unsafe_cast(self.get("type"))
}

///|
/// Cast File to Blob
pub fn File::as_blob(self : Self) -> Blob {
  unsafe_cast(self.to_js())
}

///|
/// Get the file contents as ArrayBuffer (inherited from Blob)
#alias(arrayBuffer)
pub fn File::array_buffer(self : Self) -> Promise[ArrayBuffer] {
  self.invoke("arrayBuffer", []) |> unsafe_cast
}

///|
/// Get the file contents as text (inherited from Blob)
pub fn File::text(self : Self) -> Promise[String] {
  self.invoke("text", []) |> unsafe_cast
}

///|
/// Create a new File containing a slice of this File (inherited from Blob)
pub fn File::slice(self : Self, start? : Int, end? : Int) -> Blob {
  match (start, end) {
    (None, None) => self.invoke("slice", []) |> unsafe_cast
    (Some(s), None) => self.invoke("slice", [s |> js]) |> unsafe_cast
    (Some(s), Some(e)) =>
      self.invoke("slice", [s |> js, e |> js]) |> unsafe_cast
    (None, Some(e)) => self.invoke("slice", [0 |> js, e |> js]) |> unsafe_cast
  }
}

///| FileReader

///|
/// FileReader allows reading file contents asynchronously
#external
pub type FileReader

///|
pub impl Js for FileReader

///|
/// Create a new FileReader
extern "js" fn ffi_new_file_reader() -> Val =
  #|() => new FileReader()

///|
/// Create a new FileReader
pub fn FileReader::new() -> FileReader {
  unsafe_cast(ffi_new_file_reader())
}

///|
/// Get the ready state (0=EMPTY, 1=LOADING, 2=DONE)
#alias(readyState)
pub fn FileReader::ready_state(self : Self) -> Int {
  unsafe_cast(self.get("readyState"))
}

///|
/// Get the result after reading completes
pub fn FileReader::result(self : Self) -> Val? {
  self.get("result") |> unsafe_option()
}

///|
/// Get the error if read failed
pub fn FileReader::error(self : Self) -> Val? {
  self.get("error") |> unsafe_option()
}

///|
/// Read file as ArrayBuffer
#alias(readAsArrayBuffer)
pub fn FileReader::read_as_array_buffer(self : Self, blob : Blob) -> Unit {
  self.invoke("readAsArrayBuffer", [blob.to_js()]) |> ignore
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
    Some(enc) => self.invoke("readAsText", [blob.to_js(), enc |> js]) |> ignore
    None => self.invoke("readAsText", [blob.to_js()]) |> ignore
  }
}

///|
/// Read file as Data URL
#alias(readAsDataURL)
pub fn FileReader::read_as_data_url(self : Self, blob : Blob) -> Unit {
  self.invoke("readAsDataURL", [blob.to_js()]) |> ignore
}

///|
/// Abort the read operation
pub fn FileReader::abort(self : Self) -> Unit {
  self.invoke("abort", []) |> ignore
}

///|
/// Set onload event handler
pub fn FileReader::set_onload(
  self : Self,
  callback : (Val) -> Unit noraise,
) -> Unit {
  self.set("onload", @js.unsafe_cast(callback))
}

///|
/// Set onerror event handler
pub fn FileReader::set_onerror(
  self : Self,
  callback : (Val) -> Unit noraise,
) -> Unit {
  self.set("onerror", @js.unsafe_cast(callback))
}

///|
/// Set onloadend event handler
pub fn FileReader::set_onloadend(
  self : Self,
  callback : (Val) -> Unit noraise,
) -> Unit {
  self.set("onloadend", @js.unsafe_cast(callback))
}
