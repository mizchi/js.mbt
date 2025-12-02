///|
/// Web Blob API
/// https://developer.mozilla.org/ja/docs/Web/API/Blob
pub(all) struct Blob {
  size : Int
}

///|
pub fn Blob::as_any(self : Blob) -> @core.Any = "%identity"

///|
/// Get the content type of the Blob
#alias(content_type)
pub fn Blob::contentType(self : Self) -> String {
  self.as_any()["type"].cast()
}

///|
/// Create a new Blob from array of data
extern "js" fn ffi_new_blob(data : @core.Any, options : @core.Any) -> @core.Any =
  #|(data, options) => new Blob(data, options)

///|
/// Create a new Blob
pub fn Blob::new(data : Array[@core.Any], content_type? : String) -> Blob {
  let js_data = @core.any(data)
  ffi_new_blob(
    @core.any(js_data),
    @mbtconv.from_option_map({
      "type": content_type.map(fn(x) { @core.any(x) }),
    }).cast(),
  ).cast()
}

///|
/// Get the Blob contents as ArrayBuffer
#alias(array_buffer)
pub async fn Blob::arrayBuffer(self : Self) -> @arraybuffer.ArrayBuffer {
  let promise : @js.Promise[@arraybuffer.ArrayBuffer] = self
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
    (Some(s), None, None) => js._call("slice", [@core.any(s)]).cast()
    (Some(s), Some(e), None) =>
      js._call("slice", [@core.any(s), @core.any(e)]).cast()
    (Some(s), Some(e), Some(ct)) =>
      js._call("slice", [@core.any(s), @core.any(e), @core.any(ct)]).cast()
    (None, Some(e), ct) =>
      match ct {
        Some(t) =>
          js._call("slice", [@core.any(0), @core.any(e), @core.any(t)]).cast()
        None => js._call("slice", [@core.any(0), @core.any(e)]).cast()
      }
    (Some(s), None, Some(ct)) => {
      let size = self.size
      js._call("slice", [@core.any(s), @core.any(size), @core.any(ct)]).cast()
    }
    (None, None, Some(ct)) => {
      let size = self.size
      js._call("slice", [@core.any(0), @core.any(size), @core.any(ct)]).cast()
    }
  }
}

///|
/// Get a ReadableStream for the Blob contents
pub fn Blob::stream(self : Self) -> @streams.ReadableStream {
  self.as_any()._call("stream", []).cast()
}
