// Cloudflare KV Namespace bindings

///|
#external
pub type KVNamespace

///|
pub impl JsImpl for KVNamespace

///|
/// Get a value from KV store
/// Returns null if key doesn't exist
pub fn KVNamespace::get(
  self : Self,
  key : String,
  options : KVGetOptions?,
) -> Promise[String?] {
  match options {
    None => self.invoke("get", [key]) |> unsafe_cast
    Some(opts) => self.invoke("get", [key, opts]) |> unsafe_cast
  }
}

///|
/// Get a value as ArrayBuffer
pub fn KVNamespace::get_array_buffer(self : Self, key : String) -> Promise[Js?] {
  let opts_js = @js.Object::new()
  opts_js.set("type", "arrayBuffer")
  self.invoke("get", [key, opts_js]) |> unsafe_cast
}

///|
/// Get a value as JSON
pub fn KVNamespace::get_json(self : Self, key : String) -> Promise[Js?] {
  let opts_js = @js.Object::new()
  opts_js.set("type", "json")
  self.invoke("get", [key, opts_js]) |> unsafe_cast
}

///|
/// Get a value as stream
pub fn KVNamespace::get_stream(self : Self, key : String) -> Promise[Js?] {
  let opts_js = @js.Object::new()
  opts_js.set("type", "stream")
  self.invoke("get", [key, opts_js]) |> unsafe_cast
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
      let opts_js = @js.Object::new()
      opts_js.set("type", "text")
      self.invoke("getWithMetadata", [key, opts_js]) |> unsafe_cast
    }
    Some(opts) => self.invoke("getWithMetadata", [key, opts]) |> unsafe_cast
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
    None => self.invoke("put", [key, value]) |> unsafe_cast
    Some(opts) => self.invoke("put", [key, value, opts]) |> unsafe_cast
  }
}

///|
/// Put a value with metadata
pub fn KVNamespace::put_with_metadata(
  self : Self,
  key : String,
  value : String,
  metadata : Js,
) -> Promise[Unit] {
  let opts_js = @js.Object::new()
  opts_js.set("metadata", metadata)
  self.invoke("put", [key, value, opts_js]) |> unsafe_cast
}

///|
/// Delete a key from KV store
pub fn KVNamespace::delete(self : Self, key : String) -> Promise[Unit] {
  self.invoke("delete", [key]) |> unsafe_cast
}

///|
/// List keys in the KV namespace
pub fn KVNamespace::list(
  self : Self,
  options : KVListOptions?,
) -> Promise[KVListResult] {
  match options {
    None => self.invoke("list", []) |> unsafe_cast
    Some(opts) => self.invoke("list", [opts.to_js()]) |> unsafe_cast
  }
}

///|
/// Options for KV get operations
pub(all) struct KVGetOptions {
  type_ : String? // "text" | "json" | "arrayBuffer" | "stream"
  cache_ttl : Int? // Cache TTL in seconds
}

///|
pub impl JsImpl for KVGetOptions with to_js(self) {
  let obj = @js.Object::new()
  match self.type_ {
    Some(t) => obj.set("type", t)
    None => ()
  }
  match self.cache_ttl {
    Some(ttl) => obj.set("cacheTtl", ttl)
    None => ()
  }
  obj.to_js()
}

///|
/// Options for KV put operations
pub(all) struct KVPutOptions {
  expiration : Int? // Absolute expiration time (unix timestamp)
  expiration_ttl : Int? // TTL in seconds
  metadata : Js? // Custom metadata
}

///|
pub impl JsImpl for KVPutOptions with to_js(self) {
  let obj = @js.Object::new()
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
  obj.to_js()
}

///|
/// Options for KV list operations
pub(all) struct KVListOptions {
  prefix : String? // Filter by prefix
  limit : Int? // Maximum number of keys to return (default 1000, max 1000)
  cursor : String? // Cursor for pagination
}

///|
pub impl JsImpl for KVListOptions with to_js(self) {
  let obj = @js.Object::new()
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
  obj.to_js()
}

///|
/// Result of KV list operation
pub(all) struct KVListResult {
  keys : Array[KVKey]
  list_complete : Bool
  cursor : String?
}

///|
pub impl JsImpl for KVListResult

///|
/// Key information in list result
pub(all) struct KVKey {
  name : String
  expiration : Int?
  metadata : Js?
}

///|
pub impl JsImpl for KVKey

///|
/// Value with metadata from getWithMetadata
pub(all) struct KVValueWithMetadata {
  value : Js?
  metadata : Js?
}

///|
pub impl JsImpl for KVValueWithMetadata
