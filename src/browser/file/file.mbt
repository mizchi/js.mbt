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
pub fn File::as_any(self : File) -> @nostd.Any = "%identity"

///|
/// Get the content type of the File
#alias(content_type)
pub fn File::contentType(self : Self) -> String {
  self.as_any()["type"].cast()
}

///|
/// Create a new File from FFI
extern "js" fn ffi_new_file(
  data : @nostd.Any,
  filename : @nostd.Any,
  options : @nostd.Any,
) -> @nostd.Any =
  #|(data, filename, options) => new File(data, filename, options)

///|
/// Create a new File
pub fn File::new(
  data : Array[String],
  filename : String,
  content_type? : String,
  last_modified? : Int,
) -> File {
  ffi_new_file(
    @nostd.any(data),
    filename |> @js.any,
    @mbtconv.from_option_map({
      "type": content_type.map(fn(x) { @nostd.any(x) }),
      "lastModified": last_modified.map(fn(x) { @nostd.any(x) }),
    }).cast(),
  )
  |> @nostd.identity
}

///|
/// Cast File to Blob
pub fn File::as_blob(self : Self) -> @blob.Blob {
  self.as_any() |> @nostd.identity
}

///|
/// Get the file contents as ArrayBuffer (inherited from Blob)
#alias(array_buffer)
pub async fn File::arrayBuffer(self : Self) -> @js.ArrayBuffer {
  let promise : @js.Promise[@js.ArrayBuffer] = self
    .as_any()
    ._call("arrayBuffer", [])
    .cast()
  promise.wait()
}

///|
/// Get the file contents as text (inherited from Blob)
pub async fn File::text(self : Self) -> String {
  let promise : @js.Promise[String] = self.as_any()._call("text", []).cast()
  promise.wait()
}

///|
/// Create a new File containing a slice of this File (inherited from Blob)
pub fn File::slice(self : Self, start? : Int, end? : Int) -> @blob.Blob {
  let js = self.as_any()
  match (start, end) {
    (None, None) => js._call("slice", []).cast()
    (Some(s), None) => js._call("slice", [@nostd.any(s)]).cast()
    (Some(s), Some(e)) =>
      js._call("slice", [@nostd.any(s), @nostd.any(e)]).cast()
    (None, Some(e)) => js._call("slice", [@nostd.any(0), @nostd.any(e)]).cast()
  }
}

///| FileReader

///|
/// FileReader allows reading file contents asynchronously
pub(all) struct FileReader {
  readyState : Int
  result : @js.Nullable[@nostd.Any]
  error : @js.Nullable[@nostd.Any]
}

///|
pub fn FileReader::as_any(self : FileReader) -> @nostd.Any = "%identity"

///|
/// Create a new FileReader
extern "js" fn ffi_new_file_reader() -> @nostd.Any =
  #|() => new FileReader()

///|
/// Create a new FileReader
pub fn FileReader::new() -> FileReader {
  ffi_new_file_reader() |> @nostd.identity
}

///|
/// Read file as ArrayBuffer
#alias(read_as_array_buffer)
pub fn FileReader::readAsArrayBuffer(self : Self, blob : @blob.Blob) -> Unit {
  self.as_any()._call("readAsArrayBuffer", [@nostd.any(blob)]) |> ignore
}

///|
/// Read file as text with optional encoding
#alias(read_as_text)
pub fn FileReader::readAsText(
  self : Self,
  blob : @blob.Blob,
  encoding? : String,
) -> Unit {
  let js = self.as_any()
  match encoding {
    Some(enc) =>
      js._call("readAsText", [@nostd.any(blob), @nostd.any(enc)]) |> ignore
    None => js._call("readAsText", [@nostd.any(blob)]) |> ignore
  }
}

///|
/// Read file as Data URL
#alias(read_as_data_url)
pub fn FileReader::readAsDataURL(self : Self, blob : @blob.Blob) -> Unit {
  self.as_any()._call("readAsDataURL", [@nostd.any(blob)]) |> ignore
}

///|
/// Abort the read operation
pub fn FileReader::abort(self : Self) -> Unit {
  self.as_any()._call("abort", []) |> ignore
}

///|
/// Set onload event handler
pub fn FileReader::set_onload(
  self : Self,
  callback : (@nostd.Any) -> Unit noraise,
) -> Unit {
  self.as_any()["onload"] = @nostd.any(callback)
}

///|
/// Set onerror event handler
pub fn FileReader::set_onerror(
  self : Self,
  callback : (@nostd.Any) -> Unit noraise,
) -> Unit {
  self.as_any()["onerror"] = @nostd.any(callback)
}

///|
/// Set onloadend event handler
pub fn FileReader::set_onloadend(
  self : Self,
  callback : (@nostd.Any) -> Unit noraise,
) -> Unit {
  self.as_any()["onloadend"] = @nostd.any(callback)
}
