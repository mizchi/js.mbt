// https://developer.mozilla.org/en-US/docs/Web/API/Blob
// Web Blob API

///|
#external
pub type Blob

///|
pub impl Js for Blob

///|
/// Create a new Blob from array of data
extern "js" fn ffi_new_blob(data : Val, options : Val) -> Val =
  #|(data, options) => new Blob(data, options)

///|
/// Create a new Blob
pub fn Blob::new(data : Array[&Js], content_type? : String) -> Blob {
  let arr = @js.JsArray::new()
  let mut i = 0
  while i < data.length() {
    arr.invoke("push", [data[i]]) |> ignore
    i = i + 1
  }
  let options = @js.Object::new()
  match content_type {
    Some(t) => options.set("type", t)
    None => ()
  }
  ffi_new_blob(arr.to_js(), options.to_js()) |> unsafe_cast
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
  unsafe_cast(self.get("type"))
}

///|
/// Get the Blob contents as ArrayBuffer
#alias(arrayBuffer)
pub fn Blob::array_buffer(self : Self) -> Promise[ArrayBuffer] {
  self.invoke("arrayBuffer", []) |> unsafe_cast
}

///|
/// Get the Blob contents as text
pub fn Blob::text(self : Self) -> Promise[String] {
  self.invoke("text", []) |> unsafe_cast
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
    (None, None, None) => self.invoke("slice", []) |> unsafe_cast
    (Some(s), None, None) => self.invoke("slice", [s]) |> unsafe_cast
    (Some(s), Some(e), None) => self.invoke("slice", [s, e]) |> unsafe_cast
    (Some(s), Some(e), Some(ct)) =>
      self.invoke("slice", [s, e, ct]) |> unsafe_cast
    (None, Some(e), ct) =>
      match ct {
        Some(t) => self.invoke("slice", [0, e, t]) |> unsafe_cast
        None => self.invoke("slice", [0, e]) |> unsafe_cast
      }
    (Some(s), None, Some(ct)) => {
      let size = self.size()
      self.invoke("slice", [s, size, ct]) |> unsafe_cast
    }
    (None, None, Some(ct)) => {
      let size = self.size()
      self.invoke("slice", [0, size, ct]) |> unsafe_cast
    }
  }
}

///|
/// Get a ReadableStream for the Blob contents
pub fn Blob::stream(self : Self) -> ReadableStream {
  self.invoke("stream", []) |> unsafe_cast
}
