// Cloudflare R2 Bucket bindings

///|
#external
pub type R2Bucket

///|
pub impl JsImpl for R2Bucket

///|
/// Get an object from R2
pub fn R2Bucket::get(self : Self, key : String) -> Promise[R2Object?] {
  self.call("get", [key]) |> unsafe_cast
}

///|
/// Get an object from R2 with options
pub fn R2Bucket::get_with_options(
  self : Self,
  key : String,
  options : R2GetOptions,
) -> Promise[R2Object?] {
  self.call("get", [key, options]) |> unsafe_cast
}

///|
/// Get object metadata without body
pub fn R2Bucket::head(self : Self, key : String) -> Promise[R2Object?] {
  self.call("head", [key]) |> unsafe_cast
}

///|
/// Put an object into R2
pub fn R2Bucket::put(
  self : Self,
  key : String,
  value : Js,
) -> Promise[R2Object] {
  self.call("put", [key, value]) |> unsafe_cast
}

///|
/// Put an object into R2 with options
pub fn R2Bucket::put_with_options(
  self : Self,
  key : String,
  value : Js,
  options : R2PutOptions,
) -> Promise[R2Object] {
  self.call("put", [key, value, options]) |> unsafe_cast
}

///|
/// Delete an object from R2
pub fn R2Bucket::delete(self : Self, key : String) -> Promise[Unit] {
  self.call("delete", [key]) |> unsafe_cast
}

///|
/// Delete multiple objects from R2
pub fn R2Bucket::delete_multiple(
  self : Self,
  keys : Array[String],
) -> Promise[Unit] {
  let keys_js = @js.JsArray::new()
  let mut i = 0
  while i < keys.length() {
    keys_js.call("push", [keys[i]]) |> ignore
    i = i + 1
  }
  self.call("delete", [keys_js]) |> unsafe_cast
}

///|
/// List objects in the bucket
pub fn R2Bucket::list(self : Self) -> Promise[R2Objects] {
  self.call("list", []) |> unsafe_cast
}

///|
/// List objects with options
pub fn R2Bucket::list_with_options(
  self : Self,
  options : R2ListOptions,
) -> Promise[R2Objects] {
  self.call("list", [options]) |> unsafe_cast
}

///|
/// Create a multipart upload
pub fn R2Bucket::create_multipart_upload(
  self : Self,
  key : String,
) -> Promise[R2MultipartUpload] {
  self.call("createMultipartUpload", [key]) |> unsafe_cast
}

///|
/// Create a multipart upload with options
pub fn R2Bucket::create_multipart_upload_with_options(
  self : Self,
  key : String,
  options : R2PutOptions,
) -> Promise[R2MultipartUpload] {
  self.call("createMultipartUpload", [key, options]) |> unsafe_cast
}

///|
/// Resume a multipart upload
pub fn R2Bucket::resume_multipart_upload(
  self : Self,
  key : String,
  upload_id : String,
) -> R2MultipartUpload {
  self.call("resumeMultipartUpload", [key, upload_id]) |> unsafe_cast
}

///|
/// Options for R2 get operations
pub(all) struct R2GetOptions {
  onlyIf : R2Conditional?
  range : R2Range?
}

///|
pub impl JsImpl for R2GetOptions with to_js(self) {
  let obj = @js.Object::new()
  match self.onlyIf {
    Some(cond) => {
      let cond_obj = @js.Object::new()
      match cond.etagMatches {
        Some(etag) => cond_obj.set("etagMatches", etag)
        None => ()
      }
      match cond.etagDoesNotMatch {
        Some(etag) => cond_obj.set("etagDoesNotMatch", etag)
        None => ()
      }
      match cond.uploadedBefore {
        Some(date) => cond_obj.set("uploadedBefore", date)
        None => ()
      }
      match cond.uploadedAfter {
        Some(date) => cond_obj.set("uploadedAfter", date)
        None => ()
      }
      obj.set("onlyIf", cond_obj)
    }
    None => ()
  }
  match self.range {
    Some(r) => {
      let range_obj = @js.Object::new()
      match r.offset {
        Some(offset) => range_obj.set("offset", offset)
        None => ()
      }
      match r.length {
        Some(length) => range_obj.set("length", length)
        None => ()
      }
      match r.suffix {
        Some(suffix) => range_obj.set("suffix", suffix)
        None => ()
      }
      obj.set("range", range_obj)
    }
    None => ()
  }
  obj.to_js()
}

///|
/// Conditional options for R2 operations
pub(all) struct R2Conditional {
  etagMatches : String?
  etagDoesNotMatch : String?
  uploadedBefore : Js?
  uploadedAfter : Js?
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
  customMetadata : Js?
  md5 : String?
  sha1 : String?
  sha256 : String?
  sha384 : String?
  sha512 : String?
}

///|
pub impl JsImpl for R2PutOptions with to_js(self) {
  let obj = @js.Object::new()
  match self.httpMetadata {
    Some(meta) => obj.set("httpMetadata", meta.to_js())
    None => ()
  }
  match self.customMetadata {
    Some(meta) => obj.set("customMetadata", meta)
    None => ()
  }
  match self.md5 {
    Some(hash) => obj.set("md5", hash)
    None => ()
  }
  match self.sha1 {
    Some(hash) => obj.set("sha1", hash)
    None => ()
  }
  match self.sha256 {
    Some(hash) => obj.set("sha256", hash)
    None => ()
  }
  match self.sha384 {
    Some(hash) => obj.set("sha384", hash)
    None => ()
  }
  match self.sha512 {
    Some(hash) => obj.set("sha512", hash)
    None => ()
  }
  obj.to_js()
}

///|
/// HTTP metadata for R2 objects
pub(all) struct R2HttpMetadata {
  contentType : String?
  contentLanguage : String?
  contentDisposition : String?
  contentEncoding : String?
  cacheControl : String?
  cacheExpiry : Js?
}

///|
pub impl JsImpl for R2HttpMetadata with to_js(self) {
  let obj = @js.Object::new()
  match self.contentType {
    Some(val) => obj.set("contentType", val)
    None => ()
  }
  match self.contentLanguage {
    Some(val) => obj.set("contentLanguage", val)
    None => ()
  }
  match self.contentDisposition {
    Some(val) => obj.set("contentDisposition", val)
    None => ()
  }
  match self.contentEncoding {
    Some(val) => obj.set("contentEncoding", val)
    None => ()
  }
  match self.cacheControl {
    Some(val) => obj.set("cacheControl", val)
    None => ()
  }
  match self.cacheExpiry {
    Some(val) => obj.set("cacheExpiry", val)
    None => ()
  }
  obj.to_js()
}

///|
/// Options for R2 list operations
pub(all) struct R2ListOptions {
  limit : Int?
  prefix : String?
  cursor : String?
  delimiter : String?
  startAfter : String?
  include : Array[String]?
}

///|
pub impl JsImpl for R2ListOptions with to_js(self) {
  let obj = @js.Object::new()
  match self.limit {
    Some(l) => obj.set("limit", l)
    None => ()
  }
  match self.prefix {
    Some(p) => obj.set("prefix", p)
    None => ()
  }
  match self.cursor {
    Some(c) => obj.set("cursor", c)
    None => ()
  }
  match self.delimiter {
    Some(d) => obj.set("delimiter", d)
    None => ()
  }
  match self.startAfter {
    Some(s) => obj.set("startAfter", s)
    None => ()
  }
  match self.include {
    Some(inc) => {
      let arr = @js.JsArray::new()
      let mut i = 0
      while i < inc.length() {
        arr.call("push", [inc[i]]) |> ignore
        i = i + 1
      }
      obj.set("include", arr)
    }
    None => ()
  }
  obj.to_js()
}

///|
/// R2 Object type
#external
pub type R2Object

///|
pub impl JsImpl for R2Object

///|
/// Get object key
pub fn R2Object::key(self : Self) -> String {
  unsafe_cast(self.get("key"))
}

///|
/// Get object version
pub fn R2Object::version(self : Self) -> String {
  unsafe_cast(self.get("version"))
}

///|
/// Get object size
pub fn R2Object::size(self : Self) -> Int {
  unsafe_cast(self.get("size"))
}

///|
/// Get object etag
pub fn R2Object::etag(self : Self) -> String {
  unsafe_cast(self.get("etag"))
}

///|
/// Get object HTTP metadata
pub fn R2Object::http_metadata(self : Self) -> Js {
  self.get("httpMetadata")
}

///|
/// Get object custom metadata
pub fn R2Object::custom_metadata(self : Self) -> Js {
  self.get("customMetadata")
}

///|
/// Get object uploaded time
pub fn R2Object::uploaded(self : Self) -> Js {
  self.get("uploaded")
}

///|
/// Get object body as ArrayBuffer
pub fn R2Object::array_buffer(self : Self) -> Promise[Js] {
  self.call("arrayBuffer", []) |> unsafe_cast
}

///|
/// Get object body as text
pub fn R2Object::text(self : Self) -> Promise[String] {
  self.call("text", []) |> unsafe_cast
}

///|
/// Get object body as JSON
pub fn R2Object::json(self : Self) -> Promise[Js] {
  self.call("json", []) |> unsafe_cast
}

///|
/// Get object body as blob
pub fn R2Object::blob(self : Self) -> Promise[Js] {
  self.call("blob", []) |> unsafe_cast
}

///|
/// Get object body
pub fn R2Object::body(self : Self) -> Js {
  self.get("body")
}

///|
/// Get object body used status
pub fn R2Object::body_used(self : Self) -> Bool {
  unsafe_cast(self.get("bodyUsed"))
}

///|
/// Write object to a writable stream
pub fn R2Object::write_http_metadata(self : Self, headers : Js) -> Unit {
  self.call("writeHttpMetadata", [headers]) |> unsafe_cast
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
pub impl JsImpl for R2Objects

///|
/// R2 Multipart Upload
#external
pub type R2MultipartUpload

///|
pub impl JsImpl for R2MultipartUpload

///|
/// Get upload key
pub fn R2MultipartUpload::key(self : Self) -> String {
  unsafe_cast(self.get("key"))
}

///|
/// Get upload ID
pub fn R2MultipartUpload::uploadId(self : Self) -> String {
  unsafe_cast(self.get("uploadId"))
}

///|
/// Upload a part
pub fn R2MultipartUpload::upload_part(
  self : Self,
  part_number : Int,
  value : Js,
) -> Promise[R2UploadedPart] {
  self.call("uploadPart", [part_number, value]) |> unsafe_cast
}

///|
/// Abort the multipart upload
pub fn R2MultipartUpload::abort(self : Self) -> Promise[Unit] {
  self.call("abort", []) |> unsafe_cast
}

///|
/// Complete the multipart upload
pub fn R2MultipartUpload::complete(
  self : Self,
  parts : Array[R2UploadedPart],
) -> Promise[R2Object] {
  let parts_js = @js.JsArray::new()
  let mut i = 0
  while i < parts.length() {
    parts_js.call("push", [parts[i]]) |> ignore
    i = i + 1
  }
  self.call("complete", [parts_js]) |> unsafe_cast
}

///|
/// Uploaded part information
pub(all) struct R2UploadedPart {
  partNumber : Int
  etag : String
}

///|
pub impl JsImpl for R2UploadedPart with to_js(self) {
  let obj = @js.Object::new()
  obj.set("partNumber", self.partNumber)
  obj.set("etag", self.etag)
  obj.to_js()
}
