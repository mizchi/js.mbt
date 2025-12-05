// Cloudflare R2 Bucket bindings

///|
#external
pub type R2Bucket

///|
pub fn R2Bucket::as_any(self : R2Bucket) -> @core.Any = "%identity"

///|
/// Get an object from R2
pub async fn R2Bucket::get(
  self : Self,
  key : String,
  onlyIf? : R2Conditional,
  range? : R2Range,
) -> R2Object? {
  let promise : @core.Promise[R2Object?] = if onlyIf is None && range is None {
    self.as_any()._call("get", [@core.any(key)]).cast()
  } else {
    let onlyIf_js : @core.Any? = match onlyIf {
      Some(cond) => {
        let entries : Array[(String, @core.Any)] = []
        if cond.etagMatches is Some(v) {
          entries.push(("etagMatches", @core.any(v)))
        }
        if cond.etagDoesNotMatch is Some(v) {
          entries.push(("etagDoesNotMatch", @core.any(v)))
        }
        if cond.uploadedBefore is Some(v) {
          entries.push(("uploadedBefore", @core.identity(v)))
        }
        if cond.uploadedAfter is Some(v) {
          entries.push(("uploadedAfter", @core.identity(v)))
        }
        Some(@core.from_entries(entries))
      }
      None => None
    }
    let range_js : @core.Any? = match range {
      Some(r) => {
        let entries : Array[(String, @core.Any)] = []
        if r.offset is Some(v) {
          entries.push(("offset", @core.any(v)))
        }
        if r.length is Some(v) {
          entries.push(("length", @core.any(v)))
        }
        if r.suffix is Some(v) {
          entries.push(("suffix", @core.any(v)))
        }
        Some(@core.from_entries(entries))
      }
      None => None
    }
    let entries : Array[(String, @core.Any)] = []
    if onlyIf_js is Some(v) {
      entries.push(("onlyIf", @core.any(v)))
    }
    if range_js is Some(v) {
      entries.push(("range", @core.any(v)))
    }
    let opts = @core.from_entries(entries)
    self.as_any()._call("get", [@core.any(key), opts]).cast()
  }
  promise.wait()
}

///|
/// Get object metadata without body
pub async fn R2Bucket::head(self : Self, key : String) -> R2Object? {
  let promise : @core.Promise[R2Object?] = self
    .as_any()
    ._call("head", [@core.any(key)])
    .cast()
  promise.wait()
}

///|
/// Put an object into R2
pub async fn R2Bucket::put(
  self : Self,
  key : String,
  value : @core.Any,
  httpMetadata? : R2HttpMetadata,
  customMetadata? : @core.Any,
  md5? : String,
  sha1? : String,
  sha256? : String,
  sha384? : String,
  sha512? : String,
) -> R2Object {
  let promise : @core.Promise[R2Object] = if httpMetadata is None &&
    customMetadata is None &&
    md5 is None &&
    sha1 is None &&
    sha256 is None &&
    sha384 is None &&
    sha512 is None {
    self.as_any()._call("put", [@core.any(key), @core.any(value)]).cast()
  } else {
    let httpMetadata_js : @core.Any? = match httpMetadata {
      Some(meta) => Some(@core.any(meta.as_any()))
      None => None
    }
    let customMetadata_js : @core.Any? = customMetadata.map(fn(x) {
      @core.any(x)
    })
    let entries : Array[(String, @core.Any)] = []
    if httpMetadata_js is Some(v) {
      entries.push(("httpMetadata", v))
    }
    if customMetadata_js is Some(v) {
      entries.push(("customMetadata", v))
    }
    if md5 is Some(v) {
      entries.push(("md5", @core.any(v)))
    }
    if sha1 is Some(v) {
      entries.push(("sha1", @core.any(v)))
    }
    if sha256 is Some(v) {
      entries.push(("sha256", @core.any(v)))
    }
    if sha384 is Some(v) {
      entries.push(("sha384", @core.any(v)))
    }
    if sha512 is Some(v) {
      entries.push(("sha512", @core.any(v)))
    }
    let opts = @core.from_entries(entries)
    self.as_any()._call("put", [@core.any(key), @core.any(value), opts]).cast()
  }
  promise.wait()
}

///|
/// Delete an object from R2
pub async fn R2Bucket::delete(self : Self, key : String) -> Unit {
  let promise : @core.Promise[Unit] = self
    .as_any()
    ._call("delete", [@core.any(key)])
    .cast()
  promise.wait()
}

///|
/// Delete multiple objects from R2
pub async fn R2Bucket::delete_multiple(
  self : Self,
  keys : Array[String],
) -> Unit {
  let keys_js = @core.new_array()
  let mut i = 0
  while i < keys.length() {
    @core.any(keys_js)._call("push", [@core.any(keys[i])]) |> ignore
    i = i + 1
  }
  let promise : @core.Promise[Unit] = self
    .as_any()
    ._call("delete", [@core.any(keys_js)])
    .cast()
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
  let promise : @core.Promise[R2Objects] = if limit is None &&
    prefix is None &&
    cursor is None &&
    delimiter is None &&
    startAfter is None &&
    include_ is None {
    self.as_any()._call("list", []).cast()
  } else {
    let include_js : @core.Any? = match include_ {
      Some(inc) => Some(@core.any(@core.any(inc)))
      None => None
    }
    let entries : Array[(String, @core.Any)] = []
    if limit is Some(v) {
      entries.push(("limit", @core.any(v)))
    }
    if prefix is Some(v) {
      entries.push(("prefix", @core.any(v)))
    }
    if cursor is Some(v) {
      entries.push(("cursor", @core.any(v)))
    }
    if delimiter is Some(v) {
      entries.push(("delimiter", @core.any(v)))
    }
    if startAfter is Some(v) {
      entries.push(("startAfter", @core.any(v)))
    }
    if include_js is Some(v) {
      entries.push(("include", v))
    }
    let opts = @core.from_entries(entries)
    self.as_any()._call("list", [opts]).cast()
  }
  promise.wait()
}

///|
/// Create a multipart upload
pub async fn R2Bucket::create_multipart_upload(
  self : Self,
  key : String,
  httpMetadata? : R2HttpMetadata,
  customMetadata? : @core.Any,
  md5? : String,
  sha1? : String,
  sha256? : String,
  sha384? : String,
  sha512? : String,
) -> R2MultipartUpload {
  let promise : @core.Promise[R2MultipartUpload] = if httpMetadata is None &&
    customMetadata is None &&
    md5 is None &&
    sha1 is None &&
    sha256 is None &&
    sha384 is None &&
    sha512 is None {
    self.as_any()._call("createMultipartUpload", [@core.any(key)]).cast()
  } else {
    let httpMetadata_js : @core.Any? = match httpMetadata {
      Some(meta) => Some(@core.any(meta.as_any()))
      None => None
    }
    let customMetadata_js : @core.Any? = customMetadata.map(fn(x) {
      @core.any(x)
    })
    let entries : Array[(String, @core.Any)] = []
    if httpMetadata_js is Some(v) {
      entries.push(("httpMetadata", v))
    }
    if customMetadata_js is Some(v) {
      entries.push(("customMetadata", v))
    }
    if md5 is Some(v) {
      entries.push(("md5", @core.any(v)))
    }
    if sha1 is Some(v) {
      entries.push(("sha1", @core.any(v)))
    }
    if sha256 is Some(v) {
      entries.push(("sha256", @core.any(v)))
    }
    if sha384 is Some(v) {
      entries.push(("sha384", @core.any(v)))
    }
    if sha512 is Some(v) {
      entries.push(("sha512", @core.any(v)))
    }
    let opts = @core.from_entries(entries)
    self.as_any()._call("createMultipartUpload", [@core.any(key), opts]).cast()
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
  self
  .as_any()
  ._call("resumeMultipartUpload", [@core.any(key), @core.any(upload_id)])
  .cast()
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
pub fn R2HttpMetadata::as_any(self : R2HttpMetadata) -> @core.Any {
  let entries : Array[(String, @core.Any)] = []
  if self.contentType is Some(v) {
    entries.push(("contentType", @core.any(v)))
  }
  if self.contentLanguage is Some(v) {
    entries.push(("contentLanguage", @core.any(v)))
  }
  if self.contentDisposition is Some(v) {
    entries.push(("contentDisposition", @core.any(v)))
  }
  if self.contentEncoding is Some(v) {
    entries.push(("contentEncoding", @core.any(v)))
  }
  if self.cacheControl is Some(v) {
    entries.push(("cacheControl", @core.any(v)))
  }
  if self.cacheExpiry is Some(v) {
    entries.push(("cacheExpiry", @core.identity(v)))
  }
  @core.from_entries(entries)
}

///|
/// R2 Object type
#external
pub type R2Object

///|
pub fn R2Object::as_any(self : R2Object) -> @core.Any = "%identity"

///|
/// Get object key
pub fn R2Object::key(self : Self) -> String {
  self.as_any()["key"].cast()
}

///|
/// Get object version
pub fn R2Object::version(self : Self) -> String {
  self.as_any()["version"].cast()
}

///|
/// Get object size
pub fn R2Object::size(self : Self) -> Int {
  self.as_any()["size"].cast()
}

///|
/// Get object etag
pub fn R2Object::etag(self : Self) -> String {
  self.as_any()["etag"].cast()
}

///|
/// Get object HTTP metadata
pub fn R2Object::http_metadata(self : Self) -> @core.Any {
  self.as_any()["httpMetadata"].cast()
}

///|
/// Get object custom metadata
pub fn R2Object::custom_metadata(self : Self) -> @core.Any {
  self.as_any()["customMetadata"].cast()
}

///|
/// Get object uploaded time
pub fn R2Object::uploaded(self : Self) -> @core.Any {
  self.as_any()["uploaded"].cast()
}

///|
/// Get object body as ArrayBuffer
pub async fn R2Object::array_buffer(self : Self) -> @arraybuffer.ArrayBuffer {
  let promise : @core.Promise[@arraybuffer.ArrayBuffer] = self
    .as_any()
    ._call("arrayBuffer", [])
    .cast()
  promise.wait()
}

///|
/// Get object body as text
pub async fn R2Object::text(self : Self) -> String {
  let promise : @core.Promise[String] = self.as_any()._call("text", []).cast()
  promise.wait()
}

///|
/// Get object body as JSON
pub async fn R2Object::json(self : Self) -> @core.Any {
  let promise : @core.Promise[@core.Any] = self
    .as_any()
    ._call("json", [])
    .cast()
  promise.wait()
}

///|
/// Get object body as blob
pub async fn R2Object::blob(self : Self) -> @blob.Blob {
  let promise : @core.Promise[@blob.Blob] = self
    .as_any()
    ._call("blob", [])
    .cast()
  promise.wait()
}

///|
/// Get object body as ReadableStream
pub fn R2Object::body(self : Self) -> @streams.ReadableStream {
  self.as_any()["body"].cast()
}

///|
/// Get object body used status
pub fn R2Object::body_used(self : Self) -> Bool {
  self.as_any()["bodyUsed"].cast()
}

///|
/// Write object to a writable stream
pub fn R2Object::write_http_metadata(self : Self, headers : @core.Any) -> Unit {
  self.as_any()._call("writeHttpMetadata", [@core.any(headers)]).cast()
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
pub fn R2Objects::as_any(self : R2Objects) -> @core.Any = "%identity"

///|
/// R2 Multipart Upload
#external
pub type R2MultipartUpload

///|
pub fn R2MultipartUpload::as_any(self : R2MultipartUpload) -> @core.Any = "%identity"

///|
/// Get upload key
pub fn R2MultipartUpload::key(self : Self) -> String {
  self.as_any()["key"].cast()
}

///|
/// Get upload ID
pub fn R2MultipartUpload::uploadId(self : Self) -> String {
  self.as_any()["uploadId"].cast()
}

///|
/// Upload a part
pub async fn R2MultipartUpload::upload_part(
  self : Self,
  part_number : Int,
  value : @core.Any,
) -> R2UploadedPart {
  let promise : @core.Promise[R2UploadedPart] = self
    .as_any()
    ._call("uploadPart", [@core.any(part_number), @core.any(value)])
    .cast()
  promise.wait()
}

///|
/// Abort the multipart upload
pub async fn R2MultipartUpload::abort(self : Self) -> Unit {
  let promise : @core.Promise[Unit] = self.as_any()._call("abort", []).cast()
  promise.wait()
}

///|
/// Complete the multipart upload
pub async fn R2MultipartUpload::complete(
  self : Self,
  parts : Array[R2UploadedPart],
) -> R2Object {
  let parts_js = @core.new_array()
  let mut i = 0
  while i < parts.length() {
    @core.any(parts_js)._call("push", [@core.any(parts[i].as_any())]) |> ignore
    i = i + 1
  }
  let promise : @core.Promise[R2Object] = self
    .as_any()
    ._call("complete", [@core.any(parts_js)])
    .cast()
  promise.wait()
}

///|
/// Uploaded part information
pub(all) struct R2UploadedPart {
  partNumber : Int
  etag : String
}

///|
pub fn R2UploadedPart::as_any(self : R2UploadedPart) -> @core.Any {
  @core.from_entries([
    ("partNumber", @core.any(self.partNumber)),
    ("etag", @core.any(self.etag)),
  ])
}
