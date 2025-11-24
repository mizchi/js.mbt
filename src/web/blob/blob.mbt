///|
/// Web Blob API
/// https://developer.mozilla.org/ja/docs/Web/API/Blob
pub(all) struct Blob {
  size : Int
}

///|
pub impl @js.JsImpl for Blob

///|
/// Get the content type of the Blob
#alias(content_type)
pub fn Blob::contentType(self : Self) -> String {
  self.to_js().get("type").cast()
}

///|
/// Create a new Blob from array of data
extern "js" fn ffi_new_blob(data : @js.Any, options : @js.Any) -> @js.Any =
  #|(data, options) => new Blob(data, options)

///|
/// Create a new Blob
pub fn Blob::new(data : Array[&@js.JsImpl], content_type? : String) -> Blob {
  let arr = @js.JsArray::new()
  let mut i = 0
  while i < data.length() {
    arr.call("push", [data[i]]) |> ignore
    i = i + 1
  }
  ffi_new_blob(
    arr.to_js(),
    @js.from_entries_option_cast([("type", content_type)]),
  ).cast()
}

///|
/// Get the Blob contents as ArrayBuffer
#alias(arrayBuffer)
pub fn Blob::array_buffer(self : Self) -> @js.Promise[@js.ArrayBuffer] {
  self.to_js().call0("arrayBuffer").cast()
}

///|
/// Get the Blob contents as text
pub fn Blob::text(self : Self) -> @js.Promise[String] {
  self.to_js().call0("text").cast()
}

///|
/// Create a new Blob containing a slice of this Blob
pub fn Blob::slice(
  self : Self,
  start? : Int,
  end? : Int,
  content_type? : String,
) -> Blob {
  let js = self.to_js()
  match (start, end, content_type) {
    (None, None, None) => js.call0("slice").cast()
    (Some(s), None, None) => js.call("slice", [s]).cast()
    (Some(s), Some(e), None) => js.call2("slice", s, e).cast()
    (Some(s), Some(e), Some(ct)) => js.call("slice", [s, e, ct]).cast()
    (None, Some(e), ct) =>
      match ct {
        Some(t) => js.call("slice", [0, e, t]).cast()
        None => js.call2("slice", 0, e).cast()
      }
    (Some(s), None, Some(ct)) => {
      let size = self.size
      js.call("slice", [s, size, ct]).cast()
    }
    (None, None, Some(ct)) => {
      let size = self.size
      js.call("slice", [0, size, ct]).cast()
    }
  }
}

///|
/// Get a ReadableStream for the Blob contents
pub fn Blob::stream(self : Self) -> @streams.ReadableStream {
  self.to_js().call0("stream").cast()
}
