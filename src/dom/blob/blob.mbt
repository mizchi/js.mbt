///|
/// Web Blob API
/// https://developer.mozilla.org/ja/docs/Web/API/Blob
#external
pub type Blob

///|
pub impl JsImpl for Blob

///|
/// Create a new Blob from array of data
extern "js" fn ffi_new_blob(data : Js, options : Js) -> Js =
  #|(data, options) => new Blob(data, options)

///|
/// Create a new Blob
pub fn Blob::new(data : Array[&JsImpl], content_type? : String) -> Blob {
  let arr = @js.JsArray::new()
  let mut i = 0
  while i < data.length() {
    arr.call("push", [data[i]]) |> ignore
    i = i + 1
  }
  ffi_new_blob(
    arr.to_js(),
    @js.from_entries_option_cast([("type", content_type)]),
  )
  |> unsafe_cast
}

///|
/// Get the size of the Blob in bytes
pub fn Blob::size(self : Self) -> Int {
  self.get("size") |> unsafe_cast
}

///|
/// Get the MIME type of the Blob
#alias(content_type)
pub fn Blob::contentType(self : Self) -> String {
  self.get("type") |> unsafe_cast
}

///|
/// Get the Blob contents as ArrayBuffer
#alias(arrayBuffer)
pub fn Blob::array_buffer(self : Self) -> Promise[ArrayBuffer] {
  self.call0("arrayBuffer") |> unsafe_cast
}

///|
/// Get the Blob contents as text
pub fn Blob::text(self : Self) -> Promise[String] {
  self.call0("text") |> unsafe_cast
}

///|
/// Create a new Blob containing a slice of this Blob
pub fn Blob::slice(
  self : Self,
  start? : Int,
  end? : Int,
  content_type? : String,
) -> Blob {
  match (start, end, content_type) {
    (None, None, None) => self.call0("slice") |> unsafe_cast
    (Some(s), None, None) => self.call("slice", [s]) |> unsafe_cast
    (Some(s), Some(e), None) => self.call2("slice", s, e) |> unsafe_cast
    (Some(s), Some(e), Some(ct)) =>
      self.call("slice", [s, e, ct]) |> unsafe_cast
    (None, Some(e), ct) =>
      match ct {
        Some(t) => self.call("slice", [0, e, t]) |> unsafe_cast
        None => self.call2("slice", 0, e) |> unsafe_cast
      }
    (Some(s), None, Some(ct)) => {
      let size = self.size()
      self.call("slice", [s, size, ct]) |> unsafe_cast
    }
    (None, None, Some(ct)) => {
      let size = self.size()
      self.call("slice", [0, size, ct]) |> unsafe_cast
    }
  }
}

///|
/// Get a ReadableStream for the Blob contents
pub fn Blob::stream(self : Self) -> ReadableStream {
  self.call0("stream") |> unsafe_cast
}
