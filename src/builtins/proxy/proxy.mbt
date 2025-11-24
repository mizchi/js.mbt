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
pub impl @js.JsImpl for Proxy

///|
/// get the Proxy class
fn proxy_class() -> @js.Any {
  @js.globalThis().get("Proxy")
}

///|
/// JS: new Proxy(target, handler)
/// Creates a new Proxy object with optional trap handlers
///
/// Example with get trap:
/// ```moonbit
/// let target = @js.Object::new()
/// let _proxy = Proxy::new(target, get=fn(_target, _prop, _receiver) { @js.any("value") })
/// ```
pub fn Proxy::new(
  target : &@js.JsImpl,
  get? : (@js.Any, @js.Any, @js.Any) -> @js.Any,
  set? : (@js.Any, @js.Any, @js.Any, @js.Any) -> Bool,
  has? : (@js.Any, @js.Any) -> Bool,
  deleteProperty? : (@js.Any, @js.Any) -> Bool,
  apply? : (@js.Any, @js.Any, @js.Any) -> @js.Any,
  construct? : (@js.Any, @js.Any, @js.Any) -> @js.Any,
  ownKeys? : (@js.Any) -> @js.Any,
  getPrototypeOf? : (@js.Any) -> @js.Any,
  setPrototypeOf? : (@js.Any, @js.Any) -> Bool,
  isExtensible? : (@js.Any) -> Bool,
  preventExtensions? : (@js.Any) -> Bool,
  getOwnPropertyDescriptor? : (@js.Any, @js.Any) -> @js.Any,
  defineProperty? : (@js.Any, @js.Any, @js.Any) -> Bool,
) -> Proxy {
  let handler = @js.Object::new()
  if get is Some(trap) {
    let js_fn : @js.Any = @js.identity(trap)
    handler.set("get", js_fn)
  }
  if set is Some(trap) {
    let js_fn : @js.Any = @js.identity(trap)
    handler.set("set", js_fn)
  }
  if has is Some(trap) {
    let js_fn : @js.Any = @js.identity(trap)
    handler.set("has", js_fn)
  }
  if deleteProperty is Some(trap) {
    let js_fn : @js.Any = @js.identity(trap)
    handler.set("deleteProperty", js_fn)
  }
  if apply is Some(trap) {
    let js_fn : @js.Any = @js.identity(trap)
    handler.set("apply", js_fn)
  }
  if construct is Some(trap) {
    let js_fn : @js.Any = @js.identity(trap)
    handler.set("construct", js_fn)
  }
  if ownKeys is Some(trap) {
    let js_fn : @js.Any = @js.identity(trap)
    handler.set("ownKeys", js_fn)
  }
  if getPrototypeOf is Some(trap) {
    let js_fn : @js.Any = @js.identity(trap)
    handler.set("getPrototypeOf", js_fn)
  }
  if setPrototypeOf is Some(trap) {
    let js_fn : @js.Any = @js.identity(trap)
    handler.set("setPrototypeOf", js_fn)
  }
  if isExtensible is Some(trap) {
    let js_fn : @js.Any = @js.identity(trap)
    handler.set("isExtensible", js_fn)
  }
  if preventExtensions is Some(trap) {
    let js_fn : @js.Any = @js.identity(trap)
    handler.set("preventExtensions", js_fn)
  }
  if getOwnPropertyDescriptor is Some(trap) {
    let js_fn : @js.Any = @js.identity(trap)
    handler.set("getOwnPropertyDescriptor", js_fn)
  }
  if defineProperty is Some(trap) {
    let js_fn : @js.Any = @js.identity(trap)
    handler.set("defineProperty", js_fn)
  }
  @js.new_(proxy_class(), [target.to_any(), handler.to_any()]).cast()
}

///|
/// JS: Proxy.revocable(target, handler)
/// Creates a revocable Proxy object
/// Returns an object with {proxy: Proxy, revoke: Function}
pub fn Proxy::revocable(
  target : &@js.JsImpl,
  get? : (@js.Any, @js.Any, @js.Any) -> @js.Any,
  set? : (@js.Any, @js.Any, @js.Any, @js.Any) -> Bool,
  has? : (@js.Any, @js.Any) -> Bool,
  deleteProperty? : (@js.Any, @js.Any) -> Bool,
  apply? : (@js.Any, @js.Any, @js.Any) -> @js.Any,
  construct? : (@js.Any, @js.Any, @js.Any) -> @js.Any,
  ownKeys? : (@js.Any) -> @js.Any,
  getPrototypeOf? : (@js.Any) -> @js.Any,
  setPrototypeOf? : (@js.Any, @js.Any) -> Bool,
  isExtensible? : (@js.Any) -> Bool,
  preventExtensions? : (@js.Any) -> Bool,
  getOwnPropertyDescriptor? : (@js.Any, @js.Any) -> @js.Any,
  defineProperty? : (@js.Any, @js.Any, @js.Any) -> Bool,
) -> @js.Any {
  let handler = @js.Object::new()
  if get is Some(trap) {
    let js_fn : @js.Any = @js.identity(trap)
    handler.set("get", js_fn)
  }
  if set is Some(trap) {
    let js_fn : @js.Any = @js.identity(trap)
    handler.set("set", js_fn)
  }
  if has is Some(trap) {
    let js_fn : @js.Any = @js.identity(trap)
    handler.set("has", js_fn)
  }
  if deleteProperty is Some(trap) {
    let js_fn : @js.Any = @js.identity(trap)
    handler.set("deleteProperty", js_fn)
  }
  if apply is Some(trap) {
    let js_fn : @js.Any = @js.identity(trap)
    handler.set("apply", js_fn)
  }
  if construct is Some(trap) {
    let js_fn : @js.Any = @js.identity(trap)
    handler.set("construct", js_fn)
  }
  if ownKeys is Some(trap) {
    let js_fn : @js.Any = @js.identity(trap)
    handler.set("ownKeys", js_fn)
  }
  if getPrototypeOf is Some(trap) {
    let js_fn : @js.Any = @js.identity(trap)
    handler.set("getPrototypeOf", js_fn)
  }
  if setPrototypeOf is Some(trap) {
    let js_fn : @js.Any = @js.identity(trap)
    handler.set("setPrototypeOf", js_fn)
  }
  if isExtensible is Some(trap) {
    let js_fn : @js.Any = @js.identity(trap)
    handler.set("isExtensible", js_fn)
  }
  if preventExtensions is Some(trap) {
    let js_fn : @js.Any = @js.identity(trap)
    handler.set("preventExtensions", js_fn)
  }
  if getOwnPropertyDescriptor is Some(trap) {
    let js_fn : @js.Any = @js.identity(trap)
    handler.set("getOwnPropertyDescriptor", js_fn)
  }
  if defineProperty is Some(trap) {
    let js_fn : @js.Any = @js.identity(trap)
    handler.set("defineProperty", js_fn)
  }
  proxy_class().call2("revocable", target.to_any(), handler.to_any())
}
