// https://developer.mozilla.org/en-US/docs/Web/API/File
// Web File API

///|
/// File represents a file object, extending Blob
#external
pub type File

///|
pub impl JsImpl for File

///|
/// Create a new File from FFI
extern "js" fn ffi_new_file(data : Js, filename : Js, options : Js) -> Js =
  #|(data, filename, options) => new File(data, filename, options)

///|
/// Create a new File
pub fn File::new(
  data : Array[&JsImpl],
  filename : String,
  content_type? : String,
  last_modified? : Int,
) -> File {
  let arr = @js.JsArray::new()
  let mut i = 0
  while i < data.length() {
    arr.call("push", [data[i].to_js()]) |> ignore
    i = i + 1
  }
  unsafe_cast(
    ffi_new_file(
      arr.to_js(),
      filename |> js,
      @js.from_entries_option([
        ("type", content_type.map(fn(x) { x })),
        ("lastModified", last_modified.map(fn(x) { x })),
      ]),
    ),
  )
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
  self.call("arrayBuffer", []) |> unsafe_cast
}

///|
/// Get the file contents as text (inherited from Blob)
pub fn File::text(self : Self) -> Promise[String] {
  self.call("text", []) |> unsafe_cast
}

///|
/// Create a new File containing a slice of this File (inherited from Blob)
pub fn File::slice(self : Self, start? : Int, end? : Int) -> Blob {
  match (start, end) {
    (None, None) => self.call("slice", []) |> unsafe_cast
    (Some(s), None) => self.call("slice", [s]) |> unsafe_cast
    (Some(s), Some(e)) => self.call("slice", [s, e]) |> unsafe_cast
    (None, Some(e)) => self.call("slice", [0, e]) |> unsafe_cast
  }
}

///| FileReader

///|
/// FileReader allows reading file contents asynchronously
#external
pub type FileReader

///|
pub impl JsImpl for FileReader

///|
/// Create a new FileReader
extern "js" fn ffi_new_file_reader() -> Js =
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
pub fn FileReader::result(self : Self) -> Js? {
  self.get("result") |> @js.unsafe_cast_option()
}

///|
/// Get the error if read failed
pub fn FileReader::error(self : Self) -> Js? {
  self.get("error") |> @js.unsafe_cast_option()
}

///|
/// Read file as ArrayBuffer
#alias(readAsArrayBuffer)
pub fn FileReader::read_as_array_buffer(self : Self, blob : Blob) -> Unit {
  self.call("readAsArrayBuffer", [blob.to_js()]) |> ignore
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
    Some(enc) => self.call("readAsText", [blob, enc]) |> ignore
    None => self.call("readAsText", [blob.to_js()]) |> ignore
  }
}

///|
/// Read file as Data URL
#alias(readAsDataURL)
pub fn FileReader::read_as_data_url(self : Self, blob : Blob) -> Unit {
  self.call("readAsDataURL", [blob.to_js()]) |> ignore
}

///|
/// Abort the read operation
pub fn FileReader::abort(self : Self) -> Unit {
  self.call("abort", []) |> ignore
}

///|
/// Set onload event handler
pub fn FileReader::set_onload(
  self : Self,
  callback : (Js) -> Unit noraise,
) -> Unit {
  self.set("onload", @js.unsafe_cast(callback))
}

///|
/// Set onerror event handler
pub fn FileReader::set_onerror(
  self : Self,
  callback : (Js) -> Unit noraise,
) -> Unit {
  self.set("onerror", @js.unsafe_cast(callback))
}

///|
/// Set onloadend event handler
pub fn FileReader::set_onloadend(
  self : Self,
  callback : (Js) -> Unit noraise,
) -> Unit {
  self.set("onloadend", @js.unsafe_cast(callback))
}
