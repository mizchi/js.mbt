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
fn proxy_class() -> @js.Js {
  @js.globalThis().get("Proxy")
}

///|
/// JS: new Proxy(target, handler)
/// Creates a new Proxy object with optional trap handlers
///
/// Example with get trap:
/// ```moonbit
/// let target = @js.Object::new()
/// let proxy = Proxy::new(target, get=fn(_target, _prop, _receiver) { @js.js("value") })
/// ```
pub fn Proxy::new(
  target : &@js.JsImpl,
  get? : (@js.Js, @js.Js, @js.Js) -> @js.Js,
  set? : (@js.Js, @js.Js, @js.Js, @js.Js) -> Bool,
  has? : (@js.Js, @js.Js) -> Bool,
  deleteProperty? : (@js.Js, @js.Js) -> Bool,
  apply? : (@js.Js, @js.Js, @js.Js) -> @js.Js,
  construct? : (@js.Js, @js.Js, @js.Js) -> @js.Js,
  ownKeys? : (@js.Js) -> @js.Js,
  getPrototypeOf? : (@js.Js) -> @js.Js,
  setPrototypeOf? : (@js.Js, @js.Js) -> Bool,
  isExtensible? : (@js.Js) -> Bool,
  preventExtensions? : (@js.Js) -> Bool,
  getOwnPropertyDescriptor? : (@js.Js, @js.Js) -> @js.Js,
  defineProperty? : (@js.Js, @js.Js, @js.Js) -> Bool,
) -> Proxy {
  let handler = @js.Object::new()
  if get is Some(trap) {
    let js_fn : @js.Js = @js.unsafe_cast(trap)
    handler.set("get", js_fn)
  }
  if set is Some(trap) {
    let js_fn : @js.Js = @js.unsafe_cast(trap)
    handler.set("set", js_fn)
  }
  if has is Some(trap) {
    let js_fn : @js.Js = @js.unsafe_cast(trap)
    handler.set("has", js_fn)
  }
  if deleteProperty is Some(trap) {
    let js_fn : @js.Js = @js.unsafe_cast(trap)
    handler.set("deleteProperty", js_fn)
  }
  if apply is Some(trap) {
    let js_fn : @js.Js = @js.unsafe_cast(trap)
    handler.set("apply", js_fn)
  }
  if construct is Some(trap) {
    let js_fn : @js.Js = @js.unsafe_cast(trap)
    handler.set("construct", js_fn)
  }
  if ownKeys is Some(trap) {
    let js_fn : @js.Js = @js.unsafe_cast(trap)
    handler.set("ownKeys", js_fn)
  }
  if getPrototypeOf is Some(trap) {
    let js_fn : @js.Js = @js.unsafe_cast(trap)
    handler.set("getPrototypeOf", js_fn)
  }
  if setPrototypeOf is Some(trap) {
    let js_fn : @js.Js = @js.unsafe_cast(trap)
    handler.set("setPrototypeOf", js_fn)
  }
  if isExtensible is Some(trap) {
    let js_fn : @js.Js = @js.unsafe_cast(trap)
    handler.set("isExtensible", js_fn)
  }
  if preventExtensions is Some(trap) {
    let js_fn : @js.Js = @js.unsafe_cast(trap)
    handler.set("preventExtensions", js_fn)
  }
  if getOwnPropertyDescriptor is Some(trap) {
    let js_fn : @js.Js = @js.unsafe_cast(trap)
    handler.set("getOwnPropertyDescriptor", js_fn)
  }
  if defineProperty is Some(trap) {
    let js_fn : @js.Js = @js.unsafe_cast(trap)
    handler.set("defineProperty", js_fn)
  }
  @js.new_(proxy_class(), [target.to_js(), handler.to_js()]) |> @js.unsafe_cast
}

///|
/// JS: Proxy.revocable(target, handler)
/// Creates a revocable Proxy object
/// Returns an object with {proxy: Proxy, revoke: Function}
pub fn Proxy::revocable(
  target : &@js.JsImpl,
  get? : (@js.Js, @js.Js, @js.Js) -> @js.Js,
  set? : (@js.Js, @js.Js, @js.Js, @js.Js) -> Bool,
  has? : (@js.Js, @js.Js) -> Bool,
  deleteProperty? : (@js.Js, @js.Js) -> Bool,
  apply? : (@js.Js, @js.Js, @js.Js) -> @js.Js,
  construct? : (@js.Js, @js.Js, @js.Js) -> @js.Js,
  ownKeys? : (@js.Js) -> @js.Js,
  getPrototypeOf? : (@js.Js) -> @js.Js,
  setPrototypeOf? : (@js.Js, @js.Js) -> Bool,
  isExtensible? : (@js.Js) -> Bool,
  preventExtensions? : (@js.Js) -> Bool,
  getOwnPropertyDescriptor? : (@js.Js, @js.Js) -> @js.Js,
  defineProperty? : (@js.Js, @js.Js, @js.Js) -> Bool,
) -> @js.Js {
  let handler = @js.Object::new()
  if get is Some(trap) {
    let js_fn : @js.Js = @js.unsafe_cast(trap)
    handler.set("get", js_fn)
  }
  if set is Some(trap) {
    let js_fn : @js.Js = @js.unsafe_cast(trap)
    handler.set("set", js_fn)
  }
  if has is Some(trap) {
    let js_fn : @js.Js = @js.unsafe_cast(trap)
    handler.set("has", js_fn)
  }
  if deleteProperty is Some(trap) {
    let js_fn : @js.Js = @js.unsafe_cast(trap)
    handler.set("deleteProperty", js_fn)
  }
  if apply is Some(trap) {
    let js_fn : @js.Js = @js.unsafe_cast(trap)
    handler.set("apply", js_fn)
  }
  if construct is Some(trap) {
    let js_fn : @js.Js = @js.unsafe_cast(trap)
    handler.set("construct", js_fn)
  }
  if ownKeys is Some(trap) {
    let js_fn : @js.Js = @js.unsafe_cast(trap)
    handler.set("ownKeys", js_fn)
  }
  if getPrototypeOf is Some(trap) {
    let js_fn : @js.Js = @js.unsafe_cast(trap)
    handler.set("getPrototypeOf", js_fn)
  }
  if setPrototypeOf is Some(trap) {
    let js_fn : @js.Js = @js.unsafe_cast(trap)
    handler.set("setPrototypeOf", js_fn)
  }
  if isExtensible is Some(trap) {
    let js_fn : @js.Js = @js.unsafe_cast(trap)
    handler.set("isExtensible", js_fn)
  }
  if preventExtensions is Some(trap) {
    let js_fn : @js.Js = @js.unsafe_cast(trap)
    handler.set("preventExtensions", js_fn)
  }
  if getOwnPropertyDescriptor is Some(trap) {
    let js_fn : @js.Js = @js.unsafe_cast(trap)
    handler.set("getOwnPropertyDescriptor", js_fn)
  }
  if defineProperty is Some(trap) {
    let js_fn : @js.Js = @js.unsafe_cast(trap)
    handler.set("defineProperty", js_fn)
  }
  proxy_class().call("revocable", [target.to_js(), handler.to_js()])
}
