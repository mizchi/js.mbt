///|
/// JavaScript Proxy
///
/// After creation with Proxy::new(), use JsImpl trait methods to interact:
/// - proxy.get("key") - triggers get trap
/// - proxy.set("key", value) - triggers set trap
/// - proxy.delete("key") - triggers deleteProperty trap
/// - proxy.hasOwnProperty("key") - triggers has trap
/// - proxy._invoke(args) - triggers apply trap (for function proxies)
#external
pub type Proxy

///|
pub fn Proxy::as_any(self : Proxy) -> @core.Any = "%identity"

///|
/// get the Proxy class
fn proxy_class() -> @core.Any {
  @core.global_this()["Proxy"]
}

///|
/// JS: new Proxy(target, handler)
/// Creates a new Proxy object with optional trap handlers
///
/// Example with get trap:
/// ```moonbit no-check
/// let target = @core.Object::new()
///
/// let _proxy = Proxy::new(@core.any(target), get=fn(_target, _prop, _receiver) {
///   @core.any("value")
/// })
/// ```
pub fn Proxy::new(
  target : @core.Any,
  get? : (@core.Any, @core.Any, @core.Any) -> @core.Any,
  set? : (@core.Any, @core.Any, @core.Any, @core.Any) -> Bool,
  has? : (@core.Any, @core.Any) -> Bool,
  deleteProperty? : (@core.Any, @core.Any) -> Bool,
  apply? : (@core.Any, @core.Any, @core.Any) -> @core.Any,
  construct? : (@core.Any, @core.Any, @core.Any) -> @core.Any,
  ownKeys? : (@core.Any) -> @core.Any,
  getPrototypeOf? : (@core.Any) -> @core.Any,
  setPrototypeOf? : (@core.Any, @core.Any) -> Bool,
  isExtensible? : (@core.Any) -> Bool,
  preventExtensions? : (@core.Any) -> Bool,
  getOwnPropertyDescriptor? : (@core.Any, @core.Any) -> @core.Any,
  defineProperty? : (@core.Any, @core.Any, @core.Any) -> Bool,
) -> Proxy {
  let handler = ffi_object_create()
  if get is Some(trap) {
    let js_fn : @core.Any = @core.identity(trap)
    handler["get"] = js_fn
  }
  if set is Some(trap) {
    let js_fn : @core.Any = @core.identity(trap)
    handler["set"] = js_fn
  }
  if has is Some(trap) {
    let js_fn : @core.Any = @core.identity(trap)
    handler["has"] = js_fn
  }
  if deleteProperty is Some(trap) {
    let js_fn : @core.Any = @core.identity(trap)
    handler["deleteProperty"] = js_fn
  }
  if apply is Some(trap) {
    let js_fn : @core.Any = @core.identity(trap)
    handler["apply"] = js_fn
  }
  if construct is Some(trap) {
    let js_fn : @core.Any = @core.identity(trap)
    handler["construct"] = js_fn
  }
  if ownKeys is Some(trap) {
    let js_fn : @core.Any = @core.identity(trap)
    handler["ownKeys"] = js_fn
  }
  if getPrototypeOf is Some(trap) {
    let js_fn : @core.Any = @core.identity(trap)
    handler["getPrototypeOf"] = js_fn
  }
  if setPrototypeOf is Some(trap) {
    let js_fn : @core.Any = @core.identity(trap)
    handler["setPrototypeOf"] = js_fn
  }
  if isExtensible is Some(trap) {
    let js_fn : @core.Any = @core.identity(trap)
    handler["isExtensible"] = js_fn
  }
  if preventExtensions is Some(trap) {
    let js_fn : @core.Any = @core.identity(trap)
    handler["preventExtensions"] = js_fn
  }
  if getOwnPropertyDescriptor is Some(trap) {
    let js_fn : @core.Any = @core.identity(trap)
    handler["getOwnPropertyDescriptor"] = js_fn
  }
  if defineProperty is Some(trap) {
    let js_fn : @core.Any = @core.identity(trap)
    handler["defineProperty"] = js_fn
  }
  ffi_new_proxy(target, handler)
}

///|
/// JS: Proxy.revocable(target, handler)
/// Creates a revocable Proxy object
/// Returns an object with {proxy: Proxy, revoke: Function}
pub fn Proxy::revocable(
  target : @core.Any,
  get? : (@core.Any, @core.Any, @core.Any) -> @core.Any,
  set? : (@core.Any, @core.Any, @core.Any, @core.Any) -> Bool,
  has? : (@core.Any, @core.Any) -> Bool,
  deleteProperty? : (@core.Any, @core.Any) -> Bool,
  apply? : (@core.Any, @core.Any, @core.Any) -> @core.Any,
  construct? : (@core.Any, @core.Any, @core.Any) -> @core.Any,
  ownKeys? : (@core.Any) -> @core.Any,
  getPrototypeOf? : (@core.Any) -> @core.Any,
  setPrototypeOf? : (@core.Any, @core.Any) -> Bool,
  isExtensible? : (@core.Any) -> Bool,
  preventExtensions? : (@core.Any) -> Bool,
  getOwnPropertyDescriptor? : (@core.Any, @core.Any) -> @core.Any,
  defineProperty? : (@core.Any, @core.Any, @core.Any) -> Bool,
) -> @core.Any {
  let handler = ffi_object_create()
  if get is Some(trap) {
    let js_fn : @core.Any = @core.identity(trap)
    handler["get"] = js_fn
  }
  if set is Some(trap) {
    let js_fn : @core.Any = @core.identity(trap)
    handler["set"] = js_fn
  }
  if has is Some(trap) {
    let js_fn : @core.Any = @core.identity(trap)
    handler["has"] = js_fn
  }
  if deleteProperty is Some(trap) {
    let js_fn : @core.Any = @core.identity(trap)
    handler["deleteProperty"] = js_fn
  }
  if apply is Some(trap) {
    let js_fn : @core.Any = @core.identity(trap)
    handler["apply"] = js_fn
  }
  if construct is Some(trap) {
    let js_fn : @core.Any = @core.identity(trap)
    handler["construct"] = js_fn
  }
  if ownKeys is Some(trap) {
    let js_fn : @core.Any = @core.identity(trap)
    handler["ownKeys"] = js_fn
  }
  if getPrototypeOf is Some(trap) {
    let js_fn : @core.Any = @core.identity(trap)
    handler["getPrototypeOf"] = js_fn
  }
  if setPrototypeOf is Some(trap) {
    let js_fn : @core.Any = @core.identity(trap)
    handler["setPrototypeOf"] = js_fn
  }
  if isExtensible is Some(trap) {
    let js_fn : @core.Any = @core.identity(trap)
    handler["isExtensible"] = js_fn
  }
  if preventExtensions is Some(trap) {
    let js_fn : @core.Any = @core.identity(trap)
    handler["preventExtensions"] = js_fn
  }
  if getOwnPropertyDescriptor is Some(trap) {
    let js_fn : @core.Any = @core.identity(trap)
    handler["getOwnPropertyDescriptor"] = js_fn
  }
  if defineProperty is Some(trap) {
    let js_fn : @core.Any = @core.identity(trap)
    handler["defineProperty"] = js_fn
  }
  proxy_class()._call("revocable", [target, handler])
}

///| FFI

///|
extern "js" fn ffi_object_create() -> @core.Any =
  #| () => ({})

///|
extern "js" fn ffi_new_proxy(target : @core.Any, handler : @core.Any) -> Proxy =
  #| (target, handler) => new Proxy(target, handler)
