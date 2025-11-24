// https://developer.mozilla.org/en-US/docs/Web/API/File
// Web File API

///|
/// File represents a file object, extending Blob
pub(all) struct File {
  name : String
  lastModified : Int
  size : Int
}

///|
pub impl @js.JsImpl for File

///|
/// Get the content type of the File
#alias(content_type)
pub fn File::contentType(self : Self) -> String {
  self.to_js().get("type").cast()
}

///|
/// Create a new File from FFI
extern "js" fn ffi_new_file(
  data : @js.Js,
  filename : @js.Js,
  options : @js.Js,
) -> @js.Js =
  #|(data, filename, options) => new File(data, filename, options)

///|
/// Create a new File
pub fn File::new(
  data : Array[&@js.JsImpl],
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
  ffi_new_file(
    arr.to_js(),
    filename |> @js.js,
    @js.from_entries_option([
      ("type", content_type.map(x => x)),
      ("lastModified", last_modified.map(x => x)),
    ]),
  )
  |> @js.identity
}

///|
/// Cast File to Blob
pub fn File::as_blob(self : Self) -> @blob.Blob {
  self.to_js() |> @js.identity
}

///|
/// Get the file contents as ArrayBuffer (inherited from Blob)
#alias(arrayBuffer)
pub fn File::array_buffer(self : Self) -> @js.Promise[@js.ArrayBuffer] {
  self.to_js().call0("arrayBuffer") |> @js.identity
}

///|
/// Get the file contents as text (inherited from Blob)
pub fn File::text(self : Self) -> @js.Promise[String] {
  self.to_js().call0("text") |> @js.identity
}

///|
/// Create a new File containing a slice of this File (inherited from Blob)
pub fn File::slice(self : Self, start? : Int, end? : Int) -> @blob.Blob {
  let js = self.to_js()
  match (start, end) {
    (None, None) => js.call0("slice") |> @js.identity
    (Some(s), None) => js.call("slice", [s]).cast()
    (Some(s), Some(e)) => js.call2("slice", s, e) |> @js.identity
    (None, Some(e)) => js.call2("slice", 0, e) |> @js.identity
  }
}

///| FileReader

///|
/// FileReader allows reading file contents asynchronously
pub(all) struct FileReader {
  readyState : Int
  result : @js.Nullable[@js.Js]
  error : @js.Nullable[@js.Js]
}

///|
pub impl @js.JsImpl for FileReader

///|
/// Create a new FileReader
extern "js" fn ffi_new_file_reader() -> @js.Js =
  #|() => new FileReader()

///|
/// Create a new FileReader
pub fn FileReader::new() -> FileReader {
  ffi_new_file_reader() |> @js.identity
}

///|
/// Read file as ArrayBuffer
#alias(readAsArrayBuffer)
pub fn FileReader::read_as_array_buffer(self : Self, blob : @blob.Blob) -> Unit {
  self.to_js().call("readAsArrayBuffer", [blob.to_js()]) |> ignore
}

///|
/// Read file as text with optional encoding
#alias(readAsText)
pub fn FileReader::read_as_text(
  self : Self,
  blob : @blob.Blob,
  encoding? : String,
) -> Unit {
  let js = self.to_js()
  match encoding {
    Some(enc) => js.call2("readAsText", blob, enc) |> ignore
    None => js.call("readAsText", [blob.to_js()]) |> ignore
  }
}

///|
/// Read file as Data URL
#alias(readAsDataURL)
pub fn FileReader::read_as_data_url(self : Self, blob : @blob.Blob) -> Unit {
  self.to_js().call("readAsDataURL", [blob.to_js()]) |> ignore
}

///|
/// Abort the read operation
pub fn FileReader::abort(self : Self) -> Unit {
  self.to_js().call0("abort") |> ignore
}

///|
/// Set onload event handler
pub fn FileReader::set_onload(
  self : Self,
  callback : (@js.Js) -> Unit noraise,
) -> Unit {
  self.to_js().set("onload", callback |> @js.identity)
}

///|
/// Set onerror event handler
pub fn FileReader::set_onerror(
  self : Self,
  callback : (@js.Js) -> Unit noraise,
) -> Unit {
  self.to_js().set("onerror", callback |> @js.identity)
}

///|
/// Set onloadend event handler
pub fn FileReader::set_onloadend(
  self : Self,
  callback : (@js.Js) -> Unit noraise,
) -> Unit {
  self.to_js().set("onloadend", callback |> @js.identity)
}
