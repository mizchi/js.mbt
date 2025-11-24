// Cloudflare R2 Bucket bindings

///|
#external
pub type R2Bucket

///|
pub impl @js.JsImpl for R2Bucket

///|
/// Get an object from R2
pub fn R2Bucket::get(self : Self, key : String) -> @js.Promise[R2Object?] {
  self.call("get", [key]).cast()
}

///|
/// Get an object from R2 with options
pub fn R2Bucket::get_with_options(
  self : Self,
  key : String,
  options : R2GetOptions,
) -> @js.Promise[R2Object?] {
  self.call2("get", key, options).cast()
}

///|
/// Get object metadata without body
pub fn R2Bucket::head(self : Self, key : String) -> @js.Promise[R2Object?] {
  self.call("head", [key]).cast()
}

///|
/// Put an object into R2
pub fn R2Bucket::put(
  self : Self,
  key : String,
  value : @js.Any,
) -> @js.Promise[R2Object] {
  self.call2("put", key, value).cast()
}

///|
/// Put an object into R2 with options
pub fn R2Bucket::put_with_options(
  self : Self,
  key : String,
  value : @js.Any,
  options : R2PutOptions,
) -> @js.Promise[R2Object] {
  self.call("put", [key, value, options]).cast()
}

///|
/// Delete an object from R2
pub fn R2Bucket::delete(self : Self, key : String) -> @js.Promise[Unit] {
  self.call("delete", [key]).cast()
}

///|
/// Delete multiple objects from R2
pub fn R2Bucket::delete_multiple(
  self : Self,
  keys : Array[String],
) -> @js.Promise[Unit] {
  let keys_js = @js.JsArray::new()
  let mut i = 0
  while i < keys.length() {
    keys_js.call("push", [keys[i]]) |> ignore
    i = i + 1
  }
  self.call("delete", [keys_js]).cast()
}

///|
/// List objects in the bucket
pub fn R2Bucket::list(self : Self) -> @js.Promise[R2Objects] {
  self.call0("list").cast()
}

///|
/// List objects with options
pub fn R2Bucket::list_with_options(
  self : Self,
  options : R2ListOptions,
) -> @js.Promise[R2Objects] {
  self.call("list", [options]).cast()
}

///|
/// Create a multipart upload
pub fn R2Bucket::create_multipart_upload(
  self : Self,
  key : String,
) -> @js.Promise[R2MultipartUpload] {
  self.call("createMultipartUpload", [key]).cast()
}

///|
/// Create a multipart upload with options
pub fn R2Bucket::create_multipart_upload_with_options(
  self : Self,
  key : String,
  options : R2PutOptions,
) -> @js.Promise[R2MultipartUpload] {
  self.call2("createMultipartUpload", key, options).cast()
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
/// Options for R2 get operations
pub(all) struct R2GetOptions {
  onlyIf : R2Conditional?
  range : R2Range?
}

///|
pub impl @js.JsImpl for R2GetOptions with to_any(self) {
  let onlyIf_js : @js.Any? = match self.onlyIf {
    Some(cond) =>
      Some(
        @js.from_entries_option([
          ("etagMatches", cond.etagMatches.map(fn(x) { x as &@js.JsImpl })),
          (
            "etagDoesNotMatch",
            cond.etagDoesNotMatch.map(fn(x) { x as &@js.JsImpl }),
          ),
          (
            "uploadedBefore",
            cond.uploadedBefore.map(fn(x) { x as &@js.JsImpl }),
          ),
          ("uploadedAfter", cond.uploadedAfter.map(fn(x) { x as &@js.JsImpl })),
        ]),
      )
    None => None
  }
  let range_js : @js.Any? = match self.range {
    Some(r) =>
      Some(
        @js.from_entries_option([
          ("offset", r.offset.map(fn(x) { x as &@js.JsImpl })),
          ("length", r.length.map(fn(x) { x as &@js.JsImpl })),
          ("suffix", r.suffix.map(fn(x) { x as &@js.JsImpl })),
        ]),
      )
    None => None
  }
  @js.from_entries_option([
    ("onlyIf", onlyIf_js.map(fn(x) { x as &@js.JsImpl })),
    ("range", range_js.map(fn(x) { x as &@js.JsImpl })),
  ])
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
/// Options for R2 put operations
pub(all) struct R2PutOptions {
  httpMetadata : R2HttpMetadata?
  customMetadata : @js.Any?
  md5 : String?
  sha1 : String?
  sha256 : String?
  sha384 : String?
  sha512 : String?
}

///|
pub impl @js.JsImpl for R2PutOptions with to_any(self) {
  let httpMetadata_js : @js.Any? = match self.httpMetadata {
    Some(meta) => Some(meta.to_any())
    None => None
  }
  @js.from_entries_option([
    ("httpMetadata", httpMetadata_js.map(fn(x) { x as &@js.JsImpl })),
    ("customMetadata", self.customMetadata.map(fn(x) { x as &@js.JsImpl })),
    ("md5", self.md5.map(fn(x) { x as &@js.JsImpl })),
    ("sha1", self.sha1.map(fn(x) { x as &@js.JsImpl })),
    ("sha256", self.sha256.map(fn(x) { x as &@js.JsImpl })),
    ("sha384", self.sha384.map(fn(x) { x as &@js.JsImpl })),
    ("sha512", self.sha512.map(fn(x) { x as &@js.JsImpl })),
  ])
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
pub impl @js.JsImpl for R2HttpMetadata with to_any(self) {
  @js.from_entries_option([
    ("contentType", self.contentType.map(fn(x) { x as &@js.JsImpl })),
    ("contentLanguage", self.contentLanguage.map(fn(x) { x as &@js.JsImpl })),
    (
      "contentDisposition",
      self.contentDisposition.map(fn(x) { x as &@js.JsImpl }),
    ),
    ("contentEncoding", self.contentEncoding.map(fn(x) { x as &@js.JsImpl })),
    ("cacheControl", self.cacheControl.map(fn(x) { x as &@js.JsImpl })),
    ("cacheExpiry", self.cacheExpiry.map(fn(x) { x as &@js.JsImpl })),
  ])
}

///|
/// Options for R2 list operations
pub(all) struct R2ListOptions {
  limit : Int?
  prefix : String?
  cursor : String?
  delimiter : String?
  startAfter : String?
  include_ : Array[String]?
}

///|
pub impl @js.JsImpl for R2ListOptions with to_any(self) {
  let include_js : @js.Any? = match self.include_ {
    Some(inc) => Some(@js.from_array(inc))
    None => None
  }
  @js.from_entries_option([
    ("limit", self.limit.map(fn(x) { x as &@js.JsImpl })),
    ("prefix", self.prefix.map(fn(x) { x as &@js.JsImpl })),
    ("cursor", self.cursor.map(fn(x) { x as &@js.JsImpl })),
    ("delimiter", self.delimiter.map(fn(x) { x as &@js.JsImpl })),
    ("startAfter", self.startAfter.map(fn(x) { x as &@js.JsImpl })),
    ("include", include_js.map(fn(x) { x as &@js.JsImpl })),
  ])
}

///|
/// R2 Object type
#external
pub type R2Object

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
pub fn R2Object::array_buffer(self : Self) -> @js.Promise[@js.ArrayBuffer] {
  self.call0("arrayBuffer").cast()
}

///|
/// Get object body as text
pub fn R2Object::text(self : Self) -> @js.Promise[String] {
  self.call0("text").cast()
}

///|
/// Get object body as JSON
pub fn R2Object::json(self : Self) -> @js.Promise[@js.Any] {
  self.call0("json").cast()
}

///|
/// Get object body as blob
pub fn R2Object::blob(self : Self) -> @js.Promise[@blob.Blob] {
  self.call0("blob").cast()
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
pub impl @js.JsImpl for R2Objects

///|
/// R2 Multipart Upload
#external
pub type R2MultipartUpload

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
pub fn R2MultipartUpload::upload_part(
  self : Self,
  part_number : Int,
  value : @js.Any,
) -> @js.Promise[R2UploadedPart] {
  self.call2("uploadPart", part_number, value).cast()
}

///|
/// Abort the multipart upload
pub fn R2MultipartUpload::abort(self : Self) -> @js.Promise[Unit] {
  self.call0("abort").cast()
}

///|
/// Complete the multipart upload
pub fn R2MultipartUpload::complete(
  self : Self,
  parts : Array[R2UploadedPart],
) -> @js.Promise[R2Object] {
  let parts_js = @js.JsArray::new()
  let mut i = 0
  while i < parts.length() {
    parts_js.call("push", [parts[i]]) |> ignore
    i = i + 1
  }
  self.call("complete", [parts_js]).cast()
}

///|
/// Uploaded part information
pub(all) struct R2UploadedPart {
  partNumber : Int
  etag : String
}

///|
pub impl @js.JsImpl for R2UploadedPart with to_any(self) {
  @js.from_entries([("partNumber", self.partNumber), ("etag", self.etag)])
}
