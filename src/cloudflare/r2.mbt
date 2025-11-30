// Cloudflare R2 Bucket bindings

///|
#external
pub type R2Bucket

///|
pub fn R2Bucket::as_any(self : R2Bucket) -> @nostd.Any = "%identity"

///|
pub impl @js.JsImpl for R2Bucket

///|
/// Get an object from R2
pub async fn R2Bucket::get(
  self : Self,
  key : String,
  onlyIf? : R2Conditional,
  range? : R2Range,
) -> R2Object? {
  let promise : @js.Promise[R2Object?] = if onlyIf is None && range is None {
    self.call("get", [key]).cast()
  } else {
    let onlyIf_js : @js.Any? = match onlyIf {
      Some(cond) =>
        Some(
          @mbtconv.from_option_map({
            "etagMatches": cond.etagMatches.map(fn(x) { @nostd.any(x) }),
            "etagDoesNotMatch": cond.etagDoesNotMatch.map(fn(x) {
              @nostd.any(x)
            }),
            "uploadedBefore": cond.uploadedBefore.map(fn(x) {
              @nostd.identity(x)
            }),
            "uploadedAfter": cond.uploadedAfter.map(fn(x) { @nostd.identity(x) }),
          }).cast(),
        )
      None => None
    }
    let range_js : @js.Any? = match range {
      Some(r) =>
        Some(
          @mbtconv.from_option_map({
            "offset": r.offset.map(fn(x) { @nostd.any(x) }),
            "length": r.length.map(fn(x) { @nostd.any(x) }),
            "suffix": r.suffix.map(fn(x) { @nostd.any(x) }),
          }).cast(),
        )
      None => None
    }
    let opts = @mbtconv.from_option_map({
      "onlyIf": onlyIf_js.map(fn(x) { @nostd.any(x) }),
      "range": range_js.map(fn(x) { @nostd.any(x) }),
    }).cast()
    self.call2("get", key, opts).cast()
  }
  promise.wait()
}

///|
/// Get object metadata without body
pub async fn R2Bucket::head(self : Self, key : String) -> R2Object? {
  let promise : @js.Promise[R2Object?] = self.call("head", [key]).cast()
  promise.wait()
}

///|
/// Put an object into R2
pub async fn R2Bucket::put(
  self : Self,
  key : String,
  value : @js.Any,
  httpMetadata? : R2HttpMetadata,
  customMetadata? : @js.Any,
  md5? : String,
  sha1? : String,
  sha256? : String,
  sha384? : String,
  sha512? : String,
) -> R2Object {
  let promise : @js.Promise[R2Object] = if httpMetadata is None &&
    customMetadata is None &&
    md5 is None &&
    sha1 is None &&
    sha256 is None &&
    sha384 is None &&
    sha512 is None {
    self.call2("put", key, value).cast()
  } else {
    let httpMetadata_js : @nostd.Any? = match httpMetadata {
      Some(meta) => Some(@nostd.any(meta.as_any()))
      None => None
    }
    let customMetadata_js : @nostd.Any? = customMetadata.map(fn(x) {
      @nostd.any(x)
    })
    let opts = @mbtconv.from_option_map({
      "httpMetadata": httpMetadata_js,
      "customMetadata": customMetadata_js,
      "md5": md5.map(fn(x) { @nostd.any(x) }),
      "sha1": sha1.map(fn(x) { @nostd.any(x) }),
      "sha256": sha256.map(fn(x) { @nostd.any(x) }),
      "sha384": sha384.map(fn(x) { @nostd.any(x) }),
      "sha512": sha512.map(fn(x) { @nostd.any(x) }),
    }).cast()
    self.call("put", [key, value, opts]).cast()
  }
  promise.wait()
}

///|
/// Delete an object from R2
pub async fn R2Bucket::delete(self : Self, key : String) -> Unit {
  let promise : @js.Promise[Unit] = self.call("delete", [key]).cast()
  promise.wait()
}

///|
/// Delete multiple objects from R2
pub async fn R2Bucket::delete_multiple(
  self : Self,
  keys : Array[String],
) -> Unit {
  let keys_js = @js.JsArray::new()
  let mut i = 0
  while i < keys.length() {
    keys_js.call("push", [keys[i]]) |> ignore
    i = i + 1
  }
  let promise : @js.Promise[Unit] = self.call("delete", [keys_js]).cast()
  promise.wait()
}

///|
/// List objects in the bucket
pub async fn R2Bucket::list(
  self : Self,
  limit? : Int,
  prefix? : String,
  cursor? : String,
  delimiter? : String,
  startAfter? : String,
  include_? : Array[String],
) -> R2Objects {
  let promise : @js.Promise[R2Objects] = if limit is None &&
    prefix is None &&
    cursor is None &&
    delimiter is None &&
    startAfter is None &&
    include_ is None {
    self.call0("list").cast()
  } else {
    let include_js : @nostd.Any? = match include_ {
      Some(inc) => Some(@nostd.any(@js.from_array(inc)))
      None => None
    }
    let opts = @mbtconv.from_option_map({
      "limit": limit.map(fn(x) { @nostd.any(x) }),
      "prefix": prefix.map(fn(x) { @nostd.any(x) }),
      "cursor": cursor.map(fn(x) { @nostd.any(x) }),
      "delimiter": delimiter.map(fn(x) { @nostd.any(x) }),
      "startAfter": startAfter.map(fn(x) { @nostd.any(x) }),
      "include": include_js,
    }).cast()
    self.call("list", [opts]).cast()
  }
  promise.wait()
}

///|
/// Create a multipart upload
pub async fn R2Bucket::create_multipart_upload(
  self : Self,
  key : String,
  httpMetadata? : R2HttpMetadata,
  customMetadata? : @js.Any,
  md5? : String,
  sha1? : String,
  sha256? : String,
  sha384? : String,
  sha512? : String,
) -> R2MultipartUpload {
  let promise : @js.Promise[R2MultipartUpload] = if httpMetadata is None &&
    customMetadata is None &&
    md5 is None &&
    sha1 is None &&
    sha256 is None &&
    sha384 is None &&
    sha512 is None {
    self.call("createMultipartUpload", [key]).cast()
  } else {
    let httpMetadata_js : @nostd.Any? = match httpMetadata {
      Some(meta) => Some(@nostd.any(meta.as_any()))
      None => None
    }
    let customMetadata_js : @nostd.Any? = customMetadata.map(fn(x) {
      @nostd.any(x)
    })
    let opts = @mbtconv.from_option_map({
      "httpMetadata": httpMetadata_js,
      "customMetadata": customMetadata_js,
      "md5": md5.map(fn(x) { @nostd.any(x) }),
      "sha1": sha1.map(fn(x) { @nostd.any(x) }),
      "sha256": sha256.map(fn(x) { @nostd.any(x) }),
      "sha384": sha384.map(fn(x) { @nostd.any(x) }),
      "sha512": sha512.map(fn(x) { @nostd.any(x) }),
    }).cast()
    self.call2("createMultipartUpload", key, opts).cast()
  }
  promise.wait()
}

///|
/// Resume a multipart upload
pub fn R2Bucket::resume_multipart_upload(
  self : Self,
  key : String,
  upload_id : String,
) -> R2MultipartUpload {
  self.call2("resumeMultipartUpload", key, upload_id).cast()
}

///|
/// Conditional options for R2 operations
pub(all) struct R2Conditional {
  etagMatches : String?
  etagDoesNotMatch : String?
  uploadedBefore : @date.Date?
  uploadedAfter : @date.Date?
}

///|
/// Range options for R2 get operations
pub(all) struct R2Range {
  offset : Int?
  length : Int?
  suffix : Int?
}

///|
/// HTTP metadata for R2 objects
pub(all) struct R2HttpMetadata {
  contentType : String?
  contentLanguage : String?
  contentDisposition : String?
  contentEncoding : String?
  cacheControl : String?
  cacheExpiry : @date.Date?
}

///|
pub impl @js.JsImpl for R2HttpMetadata with as_any(self) {
  @mbtconv.from_option_map({
    "contentType": self.contentType.map(fn(x) { @nostd.any(x) }),
    "contentLanguage": self.contentLanguage.map(fn(x) { @nostd.any(x) }),
    "contentDisposition": self.contentDisposition.map(fn(x) { @nostd.any(x) }),
    "contentEncoding": self.contentEncoding.map(fn(x) { @nostd.any(x) }),
    "cacheControl": self.cacheControl.map(fn(x) { @nostd.any(x) }),
    "cacheExpiry": self.cacheExpiry.map(fn(x) { @nostd.identity(x) }),
  }).cast()
}

///|
/// R2 Object type
#external
pub type R2Object

///|
pub fn R2Object::as_any(self : R2Object) -> @nostd.Any = "%identity"

///|
pub impl @js.JsImpl for R2Object

///|
/// Get object key
pub fn R2Object::key(self : Self) -> String {
  self.get("key").cast()
}

///|
/// Get object version
pub fn R2Object::version(self : Self) -> String {
  self.get("version").cast()
}

///|
/// Get object size
pub fn R2Object::size(self : Self) -> Int {
  self.get("size").cast()
}

///|
/// Get object etag
pub fn R2Object::etag(self : Self) -> String {
  self.get("etag").cast()
}

///|
/// Get object HTTP metadata
pub fn R2Object::http_metadata(self : Self) -> @js.Any {
  self.get("httpMetadata")
}

///|
/// Get object custom metadata
pub fn R2Object::custom_metadata(self : Self) -> @js.Any {
  self.get("customMetadata")
}

///|
/// Get object uploaded time
pub fn R2Object::uploaded(self : Self) -> @js.Any {
  self.get("uploaded")
}

///|
/// Get object body as ArrayBuffer
pub async fn R2Object::array_buffer(self : Self) -> @js.ArrayBuffer {
  let promise : @js.Promise[@js.ArrayBuffer] = self.call0("arrayBuffer").cast()
  promise.wait()
}

///|
/// Get object body as text
pub async fn R2Object::text(self : Self) -> String {
  let promise : @js.Promise[String] = self.call0("text").cast()
  promise.wait()
}

///|
/// Get object body as JSON
pub async fn R2Object::json(self : Self) -> @js.Any {
  let promise : @js.Promise[@js.Any] = self.call0("json").cast()
  promise.wait()
}

///|
/// Get object body as blob
pub async fn R2Object::blob(self : Self) -> @blob.Blob {
  let promise : @js.Promise[@blob.Blob] = self.call0("blob").cast()
  promise.wait()
}

///|
/// Get object body as ReadableStream
pub fn R2Object::body(self : Self) -> @streams.ReadableStream {
  self.get("body").cast()
}

///|
/// Get object body used status
pub fn R2Object::body_used(self : Self) -> Bool {
  self.get("bodyUsed").cast()
}

///|
/// Write object to a writable stream
pub fn R2Object::write_http_metadata(self : Self, headers : @js.Any) -> Unit {
  self.call("writeHttpMetadata", [headers]).cast()
}

///|
/// Result of list operation
pub(all) struct R2Objects {
  objects : Array[R2Object]
  truncated : Bool
  cursor : String?
  delimitedPrefixes : Array[String]
}

///|
pub fn R2Objects::as_any(self : R2Objects) -> @nostd.Any = "%identity"

///|
pub impl @js.JsImpl for R2Objects

///|
/// R2 Multipart Upload
#external
pub type R2MultipartUpload

///|
pub fn R2MultipartUpload::as_any(self : R2MultipartUpload) -> @nostd.Any = "%identity"

///|
pub impl @js.JsImpl for R2MultipartUpload

///|
/// Get upload key
pub fn R2MultipartUpload::key(self : Self) -> String {
  self.get("key").cast()
}

///|
/// Get upload ID
pub fn R2MultipartUpload::uploadId(self : Self) -> String {
  self.get("uploadId").cast()
}

///|
/// Upload a part
pub async fn R2MultipartUpload::upload_part(
  self : Self,
  part_number : Int,
  value : @js.Any,
) -> R2UploadedPart {
  let promise : @js.Promise[R2UploadedPart] = self
    .call2("uploadPart", part_number, value)
    .cast()
  promise.wait()
}

///|
/// Abort the multipart upload
pub async fn R2MultipartUpload::abort(self : Self) -> Unit {
  let promise : @js.Promise[Unit] = self.call0("abort").cast()
  promise.wait()
}

///|
/// Complete the multipart upload
pub async fn R2MultipartUpload::complete(
  self : Self,
  parts : Array[R2UploadedPart],
) -> R2Object {
  let parts_js = @js.JsArray::new()
  let mut i = 0
  while i < parts.length() {
    parts_js.call("push", [parts[i]]) |> ignore
    i = i + 1
  }
  let promise : @js.Promise[R2Object] = self.call("complete", [parts_js]).cast()
  promise.wait()
}

///|
/// Uploaded part information
pub(all) struct R2UploadedPart {
  partNumber : Int
  etag : String
}

///|
pub impl @js.JsImpl for R2UploadedPart with as_any(self) {
  @mbtconv.from_map({
    "partNumber": @nostd.any(self.partNumber),
    "etag": @nostd.any(self.etag),
  }).cast()
}
