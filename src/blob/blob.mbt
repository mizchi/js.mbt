// https://developer.mozilla.org/en-US/docs/Web/API/Blob
// Web Blob API

///|
#external
pub type Blob

///|
pub impl Js for Blob with to_js(self) -> Val {
  self |> js
}

///|
/// Create a new Blob from array of data
extern "js" fn ffi_new_blob(data : Val, options : Val) -> Val =
  #|(data, options) => new Blob(data, options)

///|
/// Create a new Blob
pub fn Blob::new(data : Array[&Js], content_type? : String) -> Blob {
  let arr = @js.new_empty_array()
  let mut i = 0
  while i < data.length() {
    arr.invoke("push", [data[i].to_js()]) |> ignore
    i = i + 1
  }
  let options = @js.new_empty_object()
  match content_type {
    Some(t) => options.set("type", t)
    None => ()
  }
  unsafe_cast(ffi_new_blob(arr, options))
}

///|
/// Get the size of the Blob in bytes
pub fn Blob::size(self : Self) -> Int {
  unsafe_cast(self.to_js().get("size"))
}

///|
/// Get the MIME type of the Blob
pub fn Blob::content_type(self : Self) -> String {
  unsafe_cast(self.to_js().get("type"))
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
    (Some(s), None, None) => self.invoke("slice", [s |> js]) |> unsafe_cast
    (Some(s), Some(e), None) =>
      self.invoke("slice", [s |> js, e |> js]) |> unsafe_cast
    (Some(s), Some(e), Some(ct)) =>
      self.invoke("slice", [s |> js, e |> js, ct |> js]) |> unsafe_cast
    (None, Some(e), ct) =>
      match ct {
        Some(t) =>
          self.invoke("slice", [0 |> js, e |> js, t |> js]) |> unsafe_cast
        None => self.invoke("slice", [0 |> js, e |> js]) |> unsafe_cast
      }
    (Some(s), None, Some(ct)) => {
      let size = self.size()
      self.invoke("slice", [s |> js, size |> js, ct |> js]) |> unsafe_cast
    }
    (None, None, Some(ct)) => {
      let size = self.size()
      self.invoke("slice", [0 |> js, size |> js, ct |> js]) |> unsafe_cast
    }
  }
}

///|
/// Get a ReadableStream for the Blob contents
pub fn Blob::stream(self : Self) -> ReadableStream {
  self.invoke("stream", []) |> unsafe_cast
}
