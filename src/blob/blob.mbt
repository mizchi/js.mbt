// https://developer.mozilla.org/en-US/docs/Web/API/Blob
// Web Blob API

///|
using @js {type Val, trait Js, js, unsafe_cast}

///|
using @async {type Promise}

///|
using @arraybuffer {type ArrayBuffer}

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
    arr.call_method("push", [data[i].to_js()]) |> ignore
    i = i + 1
  }
  let options = @js.new_empty_object()
  match content_type {
    Some(t) => options.set("type", t)
    None => ()
  }
  ffi_new_blob(arr, options).cast()
}

///|
/// Get the size of the Blob in bytes
pub fn Blob::size(self : Self) -> Int {
  self.to_js().get("size").cast()
}

///|
/// Get the MIME type of the Blob
pub fn Blob::content_type(self : Self) -> String {
  self.to_js().get("type").cast()
}

///|
/// Get the Blob contents as ArrayBuffer
#alias(arrayBuffer)
pub fn Blob::array_buffer(self : Self) -> Promise[ArrayBuffer] {
  self.to_js().call_method("arrayBuffer", []).cast()
}

///|
/// Get the Blob contents as text
pub fn Blob::text(self : Self) -> Promise[String] {
  self.to_js().call_method("text", []).cast()
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
    (None, None, None) => self.to_js().call_method("slice", []).cast()
    (Some(s), None, None) => self.to_js().call_method("slice", [s |> js]).cast()
    (Some(s), Some(e), None) =>
      self.to_js().call_method("slice", [s |> js, e |> js]).cast()
    (Some(s), Some(e), Some(ct)) =>
      self.to_js().call_method("slice", [s |> js, e |> js, ct |> js]).cast()
    (None, Some(e), ct) =>
      match ct {
        Some(t) =>
          self.to_js().call_method("slice", [0 |> js, e |> js, t |> js]).cast()
        None => self.to_js().call_method("slice", [0 |> js, e |> js]).cast()
      }
    (Some(s), None, Some(ct)) => {
      let size = self.size()
      self.to_js().call_method("slice", [s |> js, size |> js, ct |> js]).cast()
    }
    (None, None, Some(ct)) => {
      let size = self.size()
      self.to_js().call_method("slice", [0 |> js, size |> js, ct |> js]).cast()
    }
  }
}

///|
/// Get a ReadableStream for the Blob contents
pub fn Blob::stream(self : Self) -> Val {
  self.to_js().call_method("stream", [])
}
