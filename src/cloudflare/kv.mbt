// Cloudflare KV Namespace bindings

///|
#external
pub type KVNamespace

///|
pub fn KVNamespace::as_any(self : KVNamespace) -> @nostd.Any = "%identity"

///|
extern "js" fn KVNamespace::get_impl(
  self : Self,
  key : String,
  options : @nostd.Any?,
) -> @js.Promise[String?] =
  #| async (self, key, options) => {
  #|   const result = options === undefined ? await self._get(key) : await self._get(key, options);
  #|   return result === null ? undefined : result;
  #| }

///|
/// Get a value from KV store
/// Returns null if key doesn't exist
pub async fn KVNamespace::get(
  self : Self,
  key : String,
  type_? : String,
  cacheTtl? : Int,
) -> String? {
  let options = if type_ is None && cacheTtl is None {
    None
  } else {
    Some(
      @mbtconv.from_option_map({
        "type": type_.map(fn(x) { @nostd.any(x) }),
        "cacheTtl": cacheTtl.map(fn(x) { @nostd.any(x) }),
      }).cast(),
    )
  }
  self.get_impl(key, options).wait()
}

///|
/// Get a value as ArrayBuffer
pub async fn KVNamespace::get_array_buffer(
  self : Self,
  key : String,
) -> @nostd.Any? {
  let opts_js = @nostd.from_entries([("type", @nostd.any("arrayBuffer"))])
  let promise : @js.Promise[@nostd.Any?] = self
    .as_any()
    ._call("get", [@nostd.any(key), @nostd.any(opts_js)])
    .cast()
  promise.wait()
}

///|
/// Get a value as JSON
pub async fn KVNamespace::get_json(self : Self, key : String) -> @nostd.Any? {
  let opts_js = @nostd.from_entries([("type", @nostd.any("json"))])
  let promise : @js.Promise[@nostd.Any?] = self
    .as_any()
    ._call("get", [@nostd.any(key), @nostd.any(opts_js)])
    .cast()
  promise.wait()
}

///|
/// Get a value as stream
pub async fn KVNamespace::get_stream(self : Self, key : String) -> @nostd.Any? {
  let opts_js = @nostd.from_entries([("type", @nostd.any("stream"))])
  let promise : @js.Promise[@nostd.Any?] = self
    .as_any()
    ._call("get", [@nostd.any(key), @nostd.any(opts_js)])
    .cast()
  promise.wait()
}

///|
/// Get value with metadata
pub async fn KVNamespace::get_with_metadata(
  self : Self,
  key : String,
  type_? : String,
  cacheTtl? : Int,
) -> KVValueWithMetadata {
  let opts_js = @mbtconv.from_option_map({
    "type": Some(@nostd.any(type_.unwrap_or("text"))),
    "cacheTtl": cacheTtl.map(fn(x) { @nostd.any(x) }),
  })
  let promise : @js.Promise[KVValueWithMetadata] = self
    .as_any()
    ._call("getWithMetadata", [@nostd.any(key), @nostd.any(opts_js)])
    .cast()
  promise.wait()
}

///|
/// Put a value into KV store
pub async fn KVNamespace::put(
  self : Self,
  key : String,
  value : String,
  expiration? : Int,
  expirationTtl? : Int,
  metadata? : @nostd.Any,
) -> Unit {
  let promise : @js.Promise[Unit] = if expiration is None &&
    expirationTtl is None &&
    metadata is None {
    self.as_any()._call("put", [@nostd.any(key), @nostd.any(value)]).cast()
  } else {
    let opts = @mbtconv.from_option_map({
      "expiration": expiration.map(fn(x) { @nostd.any(x) }),
      "expirationTtl": expirationTtl.map(fn(x) { @nostd.any(x) }),
      "metadata": metadata.map(fn(x) { @nostd.any(x) }),
    })
    self
    .as_any()
    ._call("put", [@nostd.any(key), @nostd.any(value), @nostd.any(opts)])
    .cast()
  }
  promise.wait()
}

///|
/// Put a value with metadata
pub async fn KVNamespace::put_with_metadata(
  self : Self,
  key : String,
  value : String,
  metadata : @nostd.Any,
) -> Unit {
  let opts_js = @nostd.from_entries([("metadata", @nostd.any(metadata))])
  let promise : @js.Promise[Unit] = self
    .as_any()
    ._call("put", [@nostd.any(key), @nostd.any(value), @nostd.any(opts_js)])
    .cast()
  promise.wait()
}

///|
/// Delete a key from KV store
pub async fn KVNamespace::delete(self : Self, key : String) -> Unit {
  let promise : @js.Promise[Unit] = self
    .as_any()
    ._call("delete", [@nostd.any(key)])
    .cast()
  promise.wait()
}

///|
/// List keys in the KV namespace
pub async fn KVNamespace::list(
  self : Self,
  prefix? : String,
  limit? : Int,
  cursor? : String,
) -> KVListResult {
  let promise : @js.Promise[KVListResult] = if prefix is None &&
    limit is None &&
    cursor is None {
    self.as_any()._call("list", []).cast()
  } else {
    let opts = @mbtconv.from_option_map({
      "prefix": prefix.map(fn(x) { @nostd.any(x) }),
      "limit": limit.map(fn(x) { @nostd.any(x) }),
      "cursor": cursor.map(fn(x) { @nostd.any(x) }),
    })
    self.as_any()._call("list", [@nostd.any(opts)]).cast()
  }
  promise.wait()
}

///|
/// Result of KV list operation
pub(all) struct KVListResult {
  keys : Array[KVKey]
  list_complete : Bool // Note: JS uses 'list_complete' not 'listComplete'
  cursor : String?
}

///|
pub fn KVListResult::as_any(self : KVListResult) -> @nostd.Any = "%identity"

///|
/// Key information in list result
pub(all) struct KVKey {
  name : String
  expiration : Int?
  metadata : @nostd.Any?
}

///|
pub fn KVKey::as_any(self : KVKey) -> @nostd.Any = "%identity"

///|
/// Value with metadata from getWithMetadata
pub(all) struct KVValueWithMetadata {
  value : @nostd.Any?
  metadata : @nostd.Any?
}

///|
pub fn KVValueWithMetadata::as_any(self : KVValueWithMetadata) -> @nostd.Any = "%identity"
