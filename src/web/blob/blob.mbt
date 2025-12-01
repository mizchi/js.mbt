///|
/// Web Blob API
/// https://developer.mozilla.org/ja/docs/Web/API/Blob
pub(all) struct Blob {
  size : Int
}

///|
pub fn Blob::as_any(self : Blob) -> @nostd.Any = "%identity"

///|
/// Get the content type of the Blob
#alias(content_type)
pub fn Blob::contentType(self : Self) -> String {
  self.as_any()["type"].cast()
}

///|
/// Create a new Blob from array of data
extern "js" fn ffi_new_blob(data : @nostd.Any, options : @nostd.Any) -> @nostd.Any =
  #|(data, options) => new Blob(data, options)

///|
/// Create a new Blob
pub fn Blob::new(data : Array[@nostd.Any], content_type? : String) -> Blob {
  let js_data = @js.from_array(data)
  ffi_new_blob(
    js_data,
    @mbtconv.from_option_map({
      "type": content_type.map(fn(x) { @nostd.any(x) }),
    }).cast(),
  ).cast()
}

///|
/// Get the Blob contents as ArrayBuffer
#alias(array_buffer)
pub async fn Blob::arrayBuffer(self : Self) -> @js.ArrayBuffer {
  let promise : @js.Promise[@js.ArrayBuffer] = self
    .as_any()
    ._call("arrayBuffer", [])
    .cast()
  promise.wait()
}

///|
/// Get the Blob contents as text
pub async fn Blob::text(self : Self) -> String {
  let promise : @js.Promise[String] = self.as_any()._call("text", []).cast()
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
  self.as_any()._call("stream", []).cast()
}
