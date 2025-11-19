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
/// Creates a new Proxy object
///
/// Note: To add traps to the handler, you need to use JavaScript functions.
/// For transparent proxies, use an empty handler object.
pub fn Proxy::new(target : &@js.JsImpl, handler : &@js.JsImpl) -> Proxy {
  @js.new_(proxy_class(), [target, handler]) |> @js.unsafe_cast
}

///|
/// JS: Proxy.revocable(target, handler)
/// Creates a revocable Proxy object
/// Returns an object with {proxy: Proxy, revoke: Function}
pub fn Proxy::revocable(target : &@js.JsImpl, handler : &@js.JsImpl) -> @js.Js {
  proxy_class().call("revocable", [target.to_js(), handler.to_js()])
}
