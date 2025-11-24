// Cloudflare KV Namespace bindings

///|
#external
pub type KVNamespace

///|
pub impl @js.JsImpl for KVNamespace

///|
/// Get a value from KV store
/// Returns null if key doesn't exist
pub extern "js" fn KVNamespace::get(
  self : Self,
  key : String,
  options : KVGetOptions?,
) -> @js.Promise[String?] =
  #| async (self, key, options) => {
  #|   const result = options === undefined ? await self.get(key) : await self.get(key, options);
  #|   return result === null ? undefined : result;
  #| }

///|
/// Get a value as ArrayBuffer
pub fn KVNamespace::get_array_buffer(
  self : Self,
  key : String,
) -> @js.Promise[@js.Any?] {
  let opts_js = @js.from_entries([("type", "arrayBuffer")])
  self.call2("get", key, opts_js).cast()
}

///|
/// Get a value as JSON
pub fn KVNamespace::get_json(
  self : Self,
  key : String,
) -> @js.Promise[@js.Any?] {
  let opts_js = @js.from_entries([("type", "json")])
  self.call2("get", key, opts_js).cast()
}

///|
/// Get a value as stream
pub fn KVNamespace::get_stream(
  self : Self,
  key : String,
) -> @js.Promise[@js.Any?] {
  let opts_js = @js.from_entries([("type", "stream")])
  self.call2("get", key, opts_js).cast()
}

///|
/// Get value with metadata
pub fn KVNamespace::get_with_metadata(
  self : Self,
  key : String,
  options : KVGetOptions?,
) -> @js.Promise[KVValueWithMetadata] {
  match options {
    None => {
      let opts_js = @js.from_entries([("type", "text")])
      self.call2("getWithMetadata", key, opts_js).cast()
    }
    Some(opts) => self.call2("getWithMetadata", key, opts).cast()
  }
}

///|
/// Put a value into KV store
pub fn KVNamespace::put(
  self : Self,
  key : String,
  value : String,
  options : KVPutOptions?,
) -> @js.Promise[Unit] {
  match options {
    None => self.call2("put", key, value).cast()
    Some(opts) => self.call("put", [key, value, opts]).cast()
  }
}

///|
/// Put a value with metadata
pub fn KVNamespace::put_with_metadata(
  self : Self,
  key : String,
  value : String,
  metadata : @js.Any,
) -> @js.Promise[Unit] {
  let opts_js = @js.from_entries([("metadata", metadata)])
  self.call("put", [key, value, opts_js]).cast()
}

///|
/// Delete a key from KV store
pub fn KVNamespace::delete(self : Self, key : String) -> @js.Promise[Unit] {
  self.call("delete", [key]).cast()
}

///|
/// List keys in the KV namespace
pub fn KVNamespace::list(
  self : Self,
  options : KVListOptions?,
) -> @js.Promise[KVListResult] {
  match options {
    None => self.call0("list").cast()
    Some(opts) => self.call("list", [opts.to_any()]).cast()
  }
}

///|
/// Options for KV get operations
pub(all) struct KVGetOptions {
  type_ : String? // "text" | "json" | "arrayBuffer" | "stream"
  cacheTtl : Int? // Cache TTL in seconds
}

///|
pub impl @js.JsImpl for KVGetOptions with to_any(self) {
  @js.from_entries_option([
    ("type", self.type_.map(x => x)),
    ("cacheTtl", self.cacheTtl.map(x => x)),
  ])
}

///|
/// Options for KV put operations
pub(all) struct KVPutOptions {
  expiration : Int? // Absolute expiration time (unix timestamp)
  expirationTtl : Int? // TTL in seconds
  metadata : @js.Any? // Custom metadata
}

///|
pub impl @js.JsImpl for KVPutOptions with to_any(self) {
  @js.from_entries_option([
    ("expiration", self.expiration.map(x => x)),
    ("expirationTtl", self.expirationTtl.map(x => x)),
    ("metadata", self.metadata.map(x => x)),
  ])
}

///|
/// Options for KV list operations
pub(all) struct KVListOptions {
  prefix : String? // Filter by prefix
  limit : Int? // Maximum number of keys to return (default 1000, max 1000)
  cursor : String? // Cursor for pagination
}

///|
pub impl @js.JsImpl for KVListOptions with to_any(self) {
  @js.from_entries_option([
    ("prefix", self.prefix.map(x => x)),
    ("limit", self.limit.map(x => x)),
    ("cursor", self.cursor.map(x => x)),
  ])
}

///|
/// Result of KV list operation
pub(all) struct KVListResult {
  keys : Array[KVKey]
  list_complete : Bool // Note: JS uses 'list_complete' not 'listComplete'
  cursor : String?
}

///|
pub impl @js.JsImpl for KVListResult

///|
/// Key information in list result
pub(all) struct KVKey {
  name : String
  expiration : Int?
  metadata : @js.Any?
}

///|
pub impl @js.JsImpl for KVKey

///|
/// Value with metadata from getWithMetadata
pub(all) struct KVValueWithMetadata {
  value : @js.Any?
  metadata : @js.Any?
}

///|
pub impl @js.JsImpl for KVValueWithMetadata
