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

///|
/// Helper function to create a handler object with get trap
pub fn create_handler_with_get(
  get_fn : (@js.Js, @js.Js, @js.Js) -> @js.Js,
) -> @js.Object {
  let handler = @js.Object::new()
  let js_fn : @js.Js = @js.unsafe_cast(get_fn)
  handler.set("get", js_fn)
  handler
}

///|
/// Helper function to create a handler object with set trap
pub fn create_handler_with_set(
  set_fn : (@js.Js, @js.Js, @js.Js, @js.Js) -> Bool,
) -> @js.Object {
  let handler = @js.Object::new()
  let js_fn : @js.Js = @js.unsafe_cast(set_fn)
  handler.set("set", js_fn)
  handler
}

///|
/// Helper function to create a handler object with has trap
pub fn create_handler_with_has(has_fn : (@js.Js, @js.Js) -> Bool) -> @js.Object {
  let handler = @js.Object::new()
  let js_fn : @js.Js = @js.unsafe_cast(has_fn)
  handler.set("has", js_fn)
  handler
}

///|
/// Helper function to create a handler object with deleteProperty trap
pub fn create_handler_with_delete(
  delete_fn : (@js.Js, @js.Js) -> Bool,
) -> @js.Object {
  let handler = @js.Object::new()
  let js_fn : @js.Js = @js.unsafe_cast(delete_fn)
  handler.set("deleteProperty", js_fn)
  handler
}

///|
/// Helper function to create a handler object with apply trap
pub fn create_handler_with_apply(
  apply_fn : (@js.Js, @js.Js, @js.Js) -> @js.Js,
) -> @js.Object {
  let handler = @js.Object::new()
  let js_fn : @js.Js = @js.unsafe_cast(apply_fn)
  handler.set("apply", js_fn)
  handler
}

///|
/// Helper function to create a handler object with construct trap
pub fn create_handler_with_construct(
  construct_fn : (@js.Js, @js.Js, @js.Js) -> @js.Js,
) -> @js.Object {
  let handler = @js.Object::new()
  let js_fn : @js.Js = @js.unsafe_cast(construct_fn)
  handler.set("construct", js_fn)
  handler
}

///|
/// Helper function to create a handler object with ownKeys trap
pub fn create_handler_with_ownKeys(
  ownKeys_fn : (@js.Js) -> @js.Js,
) -> @js.Object {
  let handler = @js.Object::new()
  let js_fn : @js.Js = @js.unsafe_cast(ownKeys_fn)
  handler.set("ownKeys", js_fn)
  handler
}

///|
/// Create an empty proxy handler object
/// You can manually add traps using handler.set() or handler_add_*_trap functions
pub fn new_handler() -> @js.Object {
  @js.Object::new()
}

///|
/// Add a get trap to an existing proxy handler
pub fn handler_add_get_trap(
  handler : @js.Object,
  get_fn : (@js.Js, @js.Js, @js.Js) -> @js.Js,
) -> Unit {
  let js_fn : @js.Js = @js.unsafe_cast(get_fn)
  handler.set("get", js_fn)
}

///|
/// Add a set trap to an existing proxy handler
pub fn handler_add_set_trap(
  handler : @js.Object,
  set_fn : (@js.Js, @js.Js, @js.Js, @js.Js) -> Bool,
) -> Unit {
  let js_fn : @js.Js = @js.unsafe_cast(set_fn)
  handler.set("set", js_fn)
}

///|
/// Add a has trap to an existing proxy handler
pub fn handler_add_has_trap(
  handler : @js.Object,
  has_fn : (@js.Js, @js.Js) -> Bool,
) -> Unit {
  let js_fn : @js.Js = @js.unsafe_cast(has_fn)
  handler.set("has", js_fn)
}

///|
/// Add a deleteProperty trap to an existing proxy handler
pub fn handler_add_delete_trap(
  handler : @js.Object,
  delete_fn : (@js.Js, @js.Js) -> Bool,
) -> Unit {
  let js_fn : @js.Js = @js.unsafe_cast(delete_fn)
  handler.set("deleteProperty", js_fn)
}

///|
/// Add an apply trap to an existing proxy handler
pub fn handler_add_apply_trap(
  handler : @js.Object,
  apply_fn : (@js.Js, @js.Js, @js.Js) -> @js.Js,
) -> Unit {
  let js_fn : @js.Js = @js.unsafe_cast(apply_fn)
  handler.set("apply", js_fn)
}

///|
/// Add a construct trap to an existing proxy handler
pub fn handler_add_construct_trap(
  handler : @js.Object,
  construct_fn : (@js.Js, @js.Js, @js.Js) -> @js.Js,
) -> Unit {
  let js_fn : @js.Js = @js.unsafe_cast(construct_fn)
  handler.set("construct", js_fn)
}

///|
/// Add an ownKeys trap to an existing proxy handler
pub fn handler_add_ownKeys_trap(
  handler : @js.Object,
  ownKeys_fn : (@js.Js) -> @js.Js,
) -> Unit {
  let js_fn : @js.Js = @js.unsafe_cast(ownKeys_fn)
  handler.set("ownKeys", js_fn)
}
