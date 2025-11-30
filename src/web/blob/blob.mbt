///|
/// Web Blob API
/// https://developer.mozilla.org/ja/docs/Web/API/Blob
pub(all) struct Blob {
  size : Int
}

///|
pub fn Blob::as_any(self : Blob) -> @nostd.Any = "%identity"

///|
pub impl @js.JsImpl for Blob

///|
/// Get the content type of the Blob
#alias(content_type)
pub fn Blob::contentType(self : Self) -> String {
  self.as_any()["type"].cast()
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
    arr.as_any(),
    @js.from_option_map({ "type": content_type.map(fn(x) { @js.any(x) }) }),
  ).cast()
}

///|
/// Get the Blob contents as ArrayBuffer
#alias(array_buffer)
pub async fn Blob::arrayBuffer(self : Self) -> @js.ArrayBuffer {
  let promise : @js.Promise[@js.ArrayBuffer] = self.call0("arrayBuffer").cast()
  promise.wait()
}

///|
/// Get the Blob contents as text
pub async fn Blob::text(self : Self) -> String {
  let promise : @js.Promise[String] = self.call0("text").cast()
  promise.wait()
}

///|
/// Create a new Blob containing a slice of this Blob
pub fn Blob::slice(
  self : Self,
  start? : Int,
  end? : Int,
  content_type? : String,
) -> Blob {
  let js = self.as_any()
  match (start, end, content_type) {
    (None, None, None) => js._call("slice", []).cast()
    (Some(s), None, None) => js._call("slice", [@nostd.any(s)]).cast()
    (Some(s), Some(e), None) =>
      js._call("slice", [@nostd.any(s), @nostd.any(e)]).cast()
    (Some(s), Some(e), Some(ct)) =>
      js._call("slice", [@nostd.any(s), @nostd.any(e), @nostd.any(ct)]).cast()
    (None, Some(e), ct) =>
      match ct {
        Some(t) =>
          js
          ._call("slice", [@nostd.any(0), @nostd.any(e), @nostd.any(t)])
          .cast()
        None => js._call("slice", [@nostd.any(0), @nostd.any(e)]).cast()
      }
    (Some(s), None, Some(ct)) => {
      let size = self.size
      js
      ._call("slice", [@nostd.any(s), @nostd.any(size), @nostd.any(ct)])
      .cast()
    }
    (None, None, Some(ct)) => {
      let size = self.size
      js
      ._call("slice", [@nostd.any(0), @nostd.any(size), @nostd.any(ct)])
      .cast()
    }
  }
}

///|
/// Get a ReadableStream for the Blob contents
pub fn Blob::stream(self : Self) -> @streams.ReadableStream {
  self.call0("stream").cast()
}
