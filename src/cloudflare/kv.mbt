// Cloudflare KV Namespace bindings

///|
#external
pub type KVNamespace

///|
pub impl @js.JsImpl for KVNamespace

///|
extern "js" fn KVNamespace::get_impl(
  self : Self,
  key : String,
  options : @js.Any?,
) -> @js.Promise[String?] =
  #| async (self, key, options) => {
  #|   const result = options === undefined ? await self.get(key) : await self.get(key, options);
  #|   return result === null ? undefined : result;
  #| }

///|
/// Get a value from KV store
/// Returns null if key doesn't exist
pub fn KVNamespace::get(
  self : Self,
  key : String,
  type_? : String,
  cacheTtl? : Int,
) -> @js.Promise[String?] {
  let options = if type_ is None && cacheTtl is None {
    None
  } else {
    Some(
      @js.from_option_map({
        "type": type_.map(fn(x) { @js.any(x) }),
        "cacheTtl": cacheTtl.map(fn(x) { @js.any(x) }),
      }),
    )
  }
  self.get_impl(key, options)
}

///|
/// Get a value as ArrayBuffer
pub fn KVNamespace::get_array_buffer(
  self : Self,
  key : String,
) -> @js.Promise[@js.Any?] {
  let opts_js = @js.from_map({ "type": @js.any("arrayBuffer") })
  self.call2("get", key, opts_js).cast()
}

///|
/// Get a value as JSON
pub fn KVNamespace::get_json(
  self : Self,
  key : String,
) -> @js.Promise[@js.Any?] {
  let opts_js = @js.from_map({ "type": @js.any("json") })
  self.call2("get", key, opts_js).cast()
}

///|
/// Get a value as stream
pub fn KVNamespace::get_stream(
  self : Self,
  key : String,
) -> @js.Promise[@js.Any?] {
  let opts_js = @js.from_map({ "type": @js.any("stream") })
  self.call2("get", key, opts_js).cast()
}

///|
/// Get value with metadata
pub fn KVNamespace::get_with_metadata(
  self : Self,
  key : String,
  type_? : String,
  cacheTtl? : Int,
) -> @js.Promise[KVValueWithMetadata] {
  let opts_js = @js.from_option_map({
    "type": Some(@js.any(type_.unwrap_or("text"))),
    "cacheTtl": cacheTtl.map(fn(x) { @js.any(x) }),
  })
  self.call2("getWithMetadata", key, opts_js).cast()
}

///|
/// Put a value into KV store
pub fn KVNamespace::put(
  self : Self,
  key : String,
  value : String,
  expiration? : Int,
  expirationTtl? : Int,
  metadata? : @js.Any,
) -> @js.Promise[Unit] {
  if expiration is None && expirationTtl is None && metadata is None {
    self.call2("put", key, value).cast()
  } else {
    let opts = @js.from_option_map({
      "expiration": expiration.map(fn(x) { @js.any(x) }),
      "expirationTtl": expirationTtl.map(fn(x) { @js.any(x) }),
      "metadata": metadata,
    })
    self.call("put", [key, value, opts]).cast()
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
  let opts_js = @js.from_map({ "metadata": metadata })
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
  prefix? : String,
  limit? : Int,
  cursor? : String,
) -> @js.Promise[KVListResult] {
  if prefix is None && limit is None && cursor is None {
    self.call0("list").cast()
  } else {
    let opts = @js.from_option_map({
      "prefix": prefix.map(fn(x) { @js.any(x) }),
      "limit": limit.map(fn(x) { @js.any(x) }),
      "cursor": cursor.map(fn(x) { @js.any(x) }),
    })
    self.call("list", [opts]).cast()
  }
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
