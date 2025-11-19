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
  match get {
    Some(trap) => {
      let js_fn : @js.Js = @js.unsafe_cast(trap)
      handler.set("get", js_fn)
    }
    None => ()
  }
  match set {
    Some(trap) => {
      let js_fn : @js.Js = @js.unsafe_cast(trap)
      handler.set("set", js_fn)
    }
    None => ()
  }
  match has {
    Some(trap) => {
      let js_fn : @js.Js = @js.unsafe_cast(trap)
      handler.set("has", js_fn)
    }
    None => ()
  }
  match deleteProperty {
    Some(trap) => {
      let js_fn : @js.Js = @js.unsafe_cast(trap)
      handler.set("deleteProperty", js_fn)
    }
    None => ()
  }
  match apply {
    Some(trap) => {
      let js_fn : @js.Js = @js.unsafe_cast(trap)
      handler.set("apply", js_fn)
    }
    None => ()
  }
  match construct {
    Some(trap) => {
      let js_fn : @js.Js = @js.unsafe_cast(trap)
      handler.set("construct", js_fn)
    }
    None => ()
  }
  match ownKeys {
    Some(trap) => {
      let js_fn : @js.Js = @js.unsafe_cast(trap)
      handler.set("ownKeys", js_fn)
    }
    None => ()
  }
  match getPrototypeOf {
    Some(trap) => {
      let js_fn : @js.Js = @js.unsafe_cast(trap)
      handler.set("getPrototypeOf", js_fn)
    }
    None => ()
  }
  match setPrototypeOf {
    Some(trap) => {
      let js_fn : @js.Js = @js.unsafe_cast(trap)
      handler.set("setPrototypeOf", js_fn)
    }
    None => ()
  }
  match isExtensible {
    Some(trap) => {
      let js_fn : @js.Js = @js.unsafe_cast(trap)
      handler.set("isExtensible", js_fn)
    }
    None => ()
  }
  match preventExtensions {
    Some(trap) => {
      let js_fn : @js.Js = @js.unsafe_cast(trap)
      handler.set("preventExtensions", js_fn)
    }
    None => ()
  }
  match getOwnPropertyDescriptor {
    Some(trap) => {
      let js_fn : @js.Js = @js.unsafe_cast(trap)
      handler.set("getOwnPropertyDescriptor", js_fn)
    }
    None => ()
  }
  match defineProperty {
    Some(trap) => {
      let js_fn : @js.Js = @js.unsafe_cast(trap)
      handler.set("defineProperty", js_fn)
    }
    None => ()
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
  match get {
    Some(trap) => {
      let js_fn : @js.Js = @js.unsafe_cast(trap)
      handler.set("get", js_fn)
    }
    None => ()
  }
  match set {
    Some(trap) => {
      let js_fn : @js.Js = @js.unsafe_cast(trap)
      handler.set("set", js_fn)
    }
    None => ()
  }
  match has {
    Some(trap) => {
      let js_fn : @js.Js = @js.unsafe_cast(trap)
      handler.set("has", js_fn)
    }
    None => ()
  }
  match deleteProperty {
    Some(trap) => {
      let js_fn : @js.Js = @js.unsafe_cast(trap)
      handler.set("deleteProperty", js_fn)
    }
    None => ()
  }
  match apply {
    Some(trap) => {
      let js_fn : @js.Js = @js.unsafe_cast(trap)
      handler.set("apply", js_fn)
    }
    None => ()
  }
  match construct {
    Some(trap) => {
      let js_fn : @js.Js = @js.unsafe_cast(trap)
      handler.set("construct", js_fn)
    }
    None => ()
  }
  match ownKeys {
    Some(trap) => {
      let js_fn : @js.Js = @js.unsafe_cast(trap)
      handler.set("ownKeys", js_fn)
    }
    None => ()
  }
  match getPrototypeOf {
    Some(trap) => {
      let js_fn : @js.Js = @js.unsafe_cast(trap)
      handler.set("getPrototypeOf", js_fn)
    }
    None => ()
  }
  match setPrototypeOf {
    Some(trap) => {
      let js_fn : @js.Js = @js.unsafe_cast(trap)
      handler.set("setPrototypeOf", js_fn)
    }
    None => ()
  }
  match isExtensible {
    Some(trap) => {
      let js_fn : @js.Js = @js.unsafe_cast(trap)
      handler.set("isExtensible", js_fn)
    }
    None => ()
  }
  match preventExtensions {
    Some(trap) => {
      let js_fn : @js.Js = @js.unsafe_cast(trap)
      handler.set("preventExtensions", js_fn)
    }
    None => ()
  }
  match getOwnPropertyDescriptor {
    Some(trap) => {
      let js_fn : @js.Js = @js.unsafe_cast(trap)
      handler.set("getOwnPropertyDescriptor", js_fn)
    }
    None => ()
  }
  match defineProperty {
    Some(trap) => {
      let js_fn : @js.Js = @js.unsafe_cast(trap)
      handler.set("defineProperty", js_fn)
    }
    None => ()
  }
  proxy_class().call("revocable", [target.to_js(), handler.to_js()])
}
