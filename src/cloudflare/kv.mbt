// Cloudflare KV Namespace bindings

///|
#external
pub type KVNamespace

///|
pub fn KVNamespace::as_any(self : KVNamespace) -> @core.Any = "%identity"

///|
extern "js" fn KVNamespace::get_impl(
  self : Self,
  key : String,
  options : @core.Any?,
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
        "type": type_.map(fn(x) { @core.any(x) }),
        "cacheTtl": cacheTtl.map(fn(x) { @core.any(x) }),
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
) -> @core.Any? {
  let opts_js = @core.from_entries([("type", @core.any("arrayBuffer"))])
  let promise : @js.Promise[@core.Any?] = self
    .as_any()
    ._call("get", [@core.any(key), @core.any(opts_js)])
    .cast()
  promise.wait()
}

///|
/// Get a value as JSON
pub async fn KVNamespace::get_json(self : Self, key : String) -> @core.Any? {
  let opts_js = @core.from_entries([("type", @core.any("json"))])
  let promise : @js.Promise[@core.Any?] = self
    .as_any()
    ._call("get", [@core.any(key), @core.any(opts_js)])
    .cast()
  promise.wait()
}

///|
/// Get a value as stream
pub async fn KVNamespace::get_stream(self : Self, key : String) -> @core.Any? {
  let opts_js = @core.from_entries([("type", @core.any("stream"))])
  let promise : @js.Promise[@core.Any?] = self
    .as_any()
    ._call("get", [@core.any(key), @core.any(opts_js)])
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
    "type": Some(@core.any(type_.unwrap_or("text"))),
    "cacheTtl": cacheTtl.map(fn(x) { @core.any(x) }),
  })
  let promise : @js.Promise[KVValueWithMetadata] = self
    .as_any()
    ._call("getWithMetadata", [@core.any(key), @core.any(opts_js)])
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
  metadata? : @core.Any,
) -> Unit {
  let promise : @js.Promise[Unit] = if expiration is None &&
    expirationTtl is None &&
    metadata is None {
    self.as_any()._call("put", [@core.any(key), @core.any(value)]).cast()
  } else {
    let opts = @mbtconv.from_option_map({
      "expiration": expiration.map(fn(x) { @core.any(x) }),
      "expirationTtl": expirationTtl.map(fn(x) { @core.any(x) }),
      "metadata": metadata.map(fn(x) { @core.any(x) }),
    })
    self
    .as_any()
    ._call("put", [@core.any(key), @core.any(value), @core.any(opts)])
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
  metadata : @core.Any,
) -> Unit {
  let opts_js = @core.from_entries([("metadata", @core.any(metadata))])
  let promise : @js.Promise[Unit] = self
    .as_any()
    ._call("put", [@core.any(key), @core.any(value), @core.any(opts_js)])
    .cast()
  promise.wait()
}

///|
/// Delete a key from KV store
pub async fn KVNamespace::delete(self : Self, key : String) -> Unit {
  let promise : @js.Promise[Unit] = self
    .as_any()
    ._call("delete", [@core.any(key)])
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
      "prefix": prefix.map(fn(x) { @core.any(x) }),
      "limit": limit.map(fn(x) { @core.any(x) }),
      "cursor": cursor.map(fn(x) { @core.any(x) }),
    })
    self.as_any()._call("list", [@core.any(opts)]).cast()
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
pub fn KVListResult::as_any(self : KVListResult) -> @core.Any = "%identity"

///|
/// Key information in list result
pub(all) struct KVKey {
  name : String
  expiration : Int?
  metadata : @core.Any?
}

///|
pub fn KVKey::as_any(self : KVKey) -> @core.Any = "%identity"

///|
/// Value with metadata from getWithMetadata
pub(all) struct KVValueWithMetadata {
  value : @core.Any?
  metadata : @core.Any?
}

///|
pub fn KVValueWithMetadata::as_any(self : KVValueWithMetadata) -> @core.Any = "%identity"
