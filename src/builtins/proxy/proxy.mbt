///|
/// JavaScript Proxy
///
/// After creation with Proxy::new(), use JsImpl trait methods to interact:
/// - proxy.get("key") - triggers get trap
/// - proxy.set("key", value) - triggers set trap
/// - proxy.delete("key") - triggers deleteProperty trap
/// - proxy.hasOwnProperty("key") - triggers has trap
/// - proxy.call_self(args) - triggers apply trap (for function proxies)
#external
pub type Proxy

///|
pub fn Proxy::as_any(self : Proxy) -> @nostd.Any = "%identity"

///|
/// Note: Keep JsImpl for backward compatibility with code expecting &JsImpl
pub impl @js.JsImpl for Proxy

///|
/// get the Proxy class
fn proxy_class() -> @nostd.Any {
  @nostd.global_this()["Proxy"]
}

///|
/// JS: new Proxy(target, handler)
/// Creates a new Proxy object with optional trap handlers
///
/// Example with get trap:
/// ```moonbit no-check
/// let target = @js.Object::new()
/// let _proxy = Proxy::new(@nostd.any(target), get=fn(_target, _prop, _receiver) { @nostd.any("value") })
/// ```
pub fn Proxy::new(
  target : @nostd.Any,
  get? : (@nostd.Any, @nostd.Any, @nostd.Any) -> @nostd.Any,
  set? : (@nostd.Any, @nostd.Any, @nostd.Any, @nostd.Any) -> Bool,
  has? : (@nostd.Any, @nostd.Any) -> Bool,
  deleteProperty? : (@nostd.Any, @nostd.Any) -> Bool,
  apply? : (@nostd.Any, @nostd.Any, @nostd.Any) -> @nostd.Any,
  construct? : (@nostd.Any, @nostd.Any, @nostd.Any) -> @nostd.Any,
  ownKeys? : (@nostd.Any) -> @nostd.Any,
  getPrototypeOf? : (@nostd.Any) -> @nostd.Any,
  setPrototypeOf? : (@nostd.Any, @nostd.Any) -> Bool,
  isExtensible? : (@nostd.Any) -> Bool,
  preventExtensions? : (@nostd.Any) -> Bool,
  getOwnPropertyDescriptor? : (@nostd.Any, @nostd.Any) -> @nostd.Any,
  defineProperty? : (@nostd.Any, @nostd.Any, @nostd.Any) -> Bool,
) -> Proxy {
  let handler = ffi_object_create()
  if get is Some(trap) {
    let js_fn : @nostd.Any = @nostd.identity(trap)
    handler["get"] = js_fn
  }
  if set is Some(trap) {
    let js_fn : @nostd.Any = @nostd.identity(trap)
    handler["set"] = js_fn
  }
  if has is Some(trap) {
    let js_fn : @nostd.Any = @nostd.identity(trap)
    handler["has"] = js_fn
  }
  if deleteProperty is Some(trap) {
    let js_fn : @nostd.Any = @nostd.identity(trap)
    handler["deleteProperty"] = js_fn
  }
  if apply is Some(trap) {
    let js_fn : @nostd.Any = @nostd.identity(trap)
    handler["apply"] = js_fn
  }
  if construct is Some(trap) {
    let js_fn : @nostd.Any = @nostd.identity(trap)
    handler["construct"] = js_fn
  }
  if ownKeys is Some(trap) {
    let js_fn : @nostd.Any = @nostd.identity(trap)
    handler["ownKeys"] = js_fn
  }
  if getPrototypeOf is Some(trap) {
    let js_fn : @nostd.Any = @nostd.identity(trap)
    handler["getPrototypeOf"] = js_fn
  }
  if setPrototypeOf is Some(trap) {
    let js_fn : @nostd.Any = @nostd.identity(trap)
    handler["setPrototypeOf"] = js_fn
  }
  if isExtensible is Some(trap) {
    let js_fn : @nostd.Any = @nostd.identity(trap)
    handler["isExtensible"] = js_fn
  }
  if preventExtensions is Some(trap) {
    let js_fn : @nostd.Any = @nostd.identity(trap)
    handler["preventExtensions"] = js_fn
  }
  if getOwnPropertyDescriptor is Some(trap) {
    let js_fn : @nostd.Any = @nostd.identity(trap)
    handler["getOwnPropertyDescriptor"] = js_fn
  }
  if defineProperty is Some(trap) {
    let js_fn : @nostd.Any = @nostd.identity(trap)
    handler["defineProperty"] = js_fn
  }
  ffi_new_proxy(target, handler)
}

///|
/// JS: Proxy.revocable(target, handler)
/// Creates a revocable Proxy object
/// Returns an object with {proxy: Proxy, revoke: Function}
pub fn Proxy::revocable(
  target : @nostd.Any,
  get? : (@nostd.Any, @nostd.Any, @nostd.Any) -> @nostd.Any,
  set? : (@nostd.Any, @nostd.Any, @nostd.Any, @nostd.Any) -> Bool,
  has? : (@nostd.Any, @nostd.Any) -> Bool,
  deleteProperty? : (@nostd.Any, @nostd.Any) -> Bool,
  apply? : (@nostd.Any, @nostd.Any, @nostd.Any) -> @nostd.Any,
  construct? : (@nostd.Any, @nostd.Any, @nostd.Any) -> @nostd.Any,
  ownKeys? : (@nostd.Any) -> @nostd.Any,
  getPrototypeOf? : (@nostd.Any) -> @nostd.Any,
  setPrototypeOf? : (@nostd.Any, @nostd.Any) -> Bool,
  isExtensible? : (@nostd.Any) -> Bool,
  preventExtensions? : (@nostd.Any) -> Bool,
  getOwnPropertyDescriptor? : (@nostd.Any, @nostd.Any) -> @nostd.Any,
  defineProperty? : (@nostd.Any, @nostd.Any, @nostd.Any) -> Bool,
) -> @nostd.Any {
  let handler = ffi_object_create()
  if get is Some(trap) {
    let js_fn : @nostd.Any = @nostd.identity(trap)
    handler["get"] = js_fn
  }
  if set is Some(trap) {
    let js_fn : @nostd.Any = @nostd.identity(trap)
    handler["set"] = js_fn
  }
  if has is Some(trap) {
    let js_fn : @nostd.Any = @nostd.identity(trap)
    handler["has"] = js_fn
  }
  if deleteProperty is Some(trap) {
    let js_fn : @nostd.Any = @nostd.identity(trap)
    handler["deleteProperty"] = js_fn
  }
  if apply is Some(trap) {
    let js_fn : @nostd.Any = @nostd.identity(trap)
    handler["apply"] = js_fn
  }
  if construct is Some(trap) {
    let js_fn : @nostd.Any = @nostd.identity(trap)
    handler["construct"] = js_fn
  }
  if ownKeys is Some(trap) {
    let js_fn : @nostd.Any = @nostd.identity(trap)
    handler["ownKeys"] = js_fn
  }
  if getPrototypeOf is Some(trap) {
    let js_fn : @nostd.Any = @nostd.identity(trap)
    handler["getPrototypeOf"] = js_fn
  }
  if setPrototypeOf is Some(trap) {
    let js_fn : @nostd.Any = @nostd.identity(trap)
    handler["setPrototypeOf"] = js_fn
  }
  if isExtensible is Some(trap) {
    let js_fn : @nostd.Any = @nostd.identity(trap)
    handler["isExtensible"] = js_fn
  }
  if preventExtensions is Some(trap) {
    let js_fn : @nostd.Any = @nostd.identity(trap)
    handler["preventExtensions"] = js_fn
  }
  if getOwnPropertyDescriptor is Some(trap) {
    let js_fn : @nostd.Any = @nostd.identity(trap)
    handler["getOwnPropertyDescriptor"] = js_fn
  }
  if defineProperty is Some(trap) {
    let js_fn : @nostd.Any = @nostd.identity(trap)
    handler["defineProperty"] = js_fn
  }
  proxy_class()._call("revocable", [target, handler])
}

///| FFI

///|
extern "js" fn ffi_object_create() -> @nostd.Any =
  #| () => ({})

///|
extern "js" fn ffi_new_proxy(
  target : @nostd.Any,
  handler : @nostd.Any,
) -> Proxy =
  #| (target, handler) => new Proxy(target, handler)
