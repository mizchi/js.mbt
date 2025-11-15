// Cloudflare KV Namespace bindings

///|
#external
pub type KVNamespace

///|
pub impl Js for KVNamespace with to_js(self) {
  self |> js
}

///|
/// Get a value from KV store
/// Returns null if key doesn't exist
pub fn KVNamespace::get(
  self : Self,
  key : String,
  options : KVGetOptions?,
) -> Promise[String?] {
  match options {
    None => self.to_js().invoke("get", [key]).cast()
    Some(opts) => self.to_js().invoke("get", [key, opts]).cast()
  }
}

///|
/// Get a value as ArrayBuffer
pub fn KVNamespace::get_array_buffer(
  self : Self,
  key : String,
) -> Promise[Val?] {
  let opts_js = js("{}")
  opts_js.set("type", "arrayBuffer")
  self.to_js().invoke("get", [key, opts_js]).cast()
}

///|
/// Get a value as JSON
pub fn KVNamespace::get_json(self : Self, key : String) -> Promise[Val?] {
  let opts_js = js("{}")
  opts_js.set("type", "json")
  self.to_js().invoke("get", [key, opts_js]).cast()
}

///|
/// Get a value as stream
pub fn KVNamespace::get_stream(self : Self, key : String) -> Promise[Val?] {
  let opts_js = js("{}")
  opts_js.set("type", "stream")
  self.to_js().invoke("get", [key, opts_js]).cast()
}

///|
/// Get value with metadata
pub fn KVNamespace::get_with_metadata(
  self : Self,
  key : String,
  options : KVGetOptions?,
) -> Promise[KVValueWithMetadata] {
  match options {
    None => {
      let opts_js = js("{}")
      opts_js.set("type", "text")
      self.to_js().invoke("getWithMetadata", [key, opts_js]).cast()
    }
    Some(opts) =>
      self.to_js().invoke("getWithMetadata", [key, opts]).cast()
  }
}

///|
/// Put a value into KV store
pub fn KVNamespace::put(
  self : Self,
  key : String,
  value : String,
  options : KVPutOptions?,
) -> Promise[Unit] {
  match options {
    None => self.to_js().invoke("put", [key, value]).cast()
    Some(opts) => self.to_js().invoke("put", [key, value, opts]).cast()
  }
}

///|
/// Put a value with metadata
pub fn KVNamespace::put_with_metadata(
  self : Self,
  key : String,
  value : String,
  metadata : Val,
) -> Promise[Unit] {
  let opts_js = js("{}")
  opts_js.set("metadata", metadata)
  self.to_js().invoke("put", [key, value, opts_js]).cast()
}

///|
/// Delete a key from KV store
pub fn KVNamespace::delete(self : Self, key : String) -> Promise[Unit] {
  self.to_js().invoke("delete", [key]).cast()
}

///|
/// List keys in the KV namespace
pub fn KVNamespace::list(
  self : Self,
  options : KVListOptions?,
) -> Promise[KVListResult] {
  match options {
    None => self.to_js().invoke("list", []).cast()
    Some(opts) => self.to_js().invoke("list", [opts.to_js()]).cast()
  }
}

///|
/// Options for KV get operations
pub(all) struct KVGetOptions {
  type_ : String? // "text" | "json" | "arrayBuffer" | "stream"
  cache_ttl : Int? // Cache TTL in seconds
}

///|
pub impl Js for KVGetOptions with to_js(self) {
  let obj = js("{}")
  match self.type_ {
    Some(t) => obj.set("type", t)
    None => ()
  }
  match self.cache_ttl {
    Some(ttl) => obj.set("cacheTtl", ttl)
    None => ()
  }
  obj
}

///|
/// Options for KV put operations
pub(all) struct KVPutOptions {
  expiration : Int? // Absolute expiration time (unix timestamp)
  expiration_ttl : Int? // TTL in seconds
  metadata : Val? // Custom metadata
}

///|
pub impl Js for KVPutOptions with to_js(self) {
  let obj = js("{}")
  match self.expiration {
    Some(exp) => obj.set("expiration", exp)
    None => ()
  }
  match self.expiration_ttl {
    Some(ttl) => obj.set("expirationTtl", ttl)
    None => ()
  }
  match self.metadata {
    Some(meta) => obj.set("metadata", meta)
    None => ()
  }
  obj
}

///|
/// Options for KV list operations
pub(all) struct KVListOptions {
  prefix : String? // Filter by prefix
  limit : Int? // Maximum number of keys to return (default 1000, max 1000)
  cursor : String? // Cursor for pagination
}

///|
pub impl Js for KVListOptions with to_js(self) {
  let obj = js("{}")
  match self.prefix {
    Some(p) => obj.set("prefix", p)
    None => ()
  }
  match self.limit {
    Some(l) => obj.set("limit", l)
    None => ()
  }
  match self.cursor {
    Some(c) => obj.set("cursor", c)
    None => ()
  }
  obj
}

///|
/// Result of KV list operation
pub(all) struct KVListResult {
  keys : Array[KVKey]
  list_complete : Bool
  cursor : String?
}

///|
pub impl Js for KVListResult with to_js(self) {
  self |> js
}

///|
/// Key information in list result
pub(all) struct KVKey {
  name : String
  expiration : Int?
  metadata : Val?
}

///|
pub impl Js for KVKey with to_js(self) {
  self |> js
}

///|
/// Value with metadata from getWithMetadata
pub(all) struct KVValueWithMetadata {
  value : Val?
  metadata : Val?
}

///|
pub impl Js for KVValueWithMetadata with to_js(self) {
  self |> js
}
