///|
#external
pub type PreactTestingLibrary

///|
impl @js.JsImpl for PreactTestingLibrary

///|
fn testing_library() -> PreactTestingLibrary {
  @node.require("@testing-library/preact").cast()
}

///|
/// Helper to set optional value on JS object, returns true if value was set
fn[T : @js.JsImpl] set_opt(obj : @js.Any, key : String, val : T?) -> Bool {
  match val {
    Some(v) => {
      obj.set(key, v)
      true
    }
    None => false
  }
}

///|
/// Helper to convert object to Some if any options were set, None otherwise
fn to_options(obj : @js.Any, has_any : Bool) -> @js.Any? {
  if has_any {
    Some(obj)
  } else {
    None
  }
}

///|
/// RenderResult returned by render()
#external
pub type RenderResult

///|
pub impl @js.JsImpl for RenderResult

///|
/// JS: render(element, options?)
/// Returns: RenderResult with queries, container, baseElement, debug, rerender, unmount, asFragment
pub fn render(element : @preact.VNode) -> RenderResult {
  let rtl = testing_library()
  rtl.call1("render", element).cast()
}

///|
/// JS: result.container
pub fn RenderResult::container(self : RenderResult) -> @dom.HTMLElement {
  self.get("container").cast()
}

///|
/// JS: result.baseElement
pub fn RenderResult::baseElement(self : RenderResult) -> @dom.HTMLElement {
  self.get("baseElement").cast()
}

///|
/// JS: result.debug()
pub fn RenderResult::debug(self : RenderResult) -> Unit {
  self.call0("debug") |> ignore
}

///|
/// JS: result.rerender(element)
pub fn RenderResult::rerender(
  self : RenderResult,
  element : @preact.VNode,
) -> Unit {
  self.call1("rerender", element) |> ignore
}

///|
/// JS: result.unmount()
pub fn RenderResult::unmount(self : RenderResult) -> Unit {
  self.call0("unmount") |> ignore
}

///|
/// JS: result.asFragment()
pub fn RenderResult::asFragment(self : RenderResult) -> @js.Any {
  self.call0("asFragment")
}

///|
/// JS: cleanup()
pub fn cleanup() -> Unit {
  let rtl = testing_library()
  rtl.call0("cleanup") |> ignore
}

///|
/// JS: act(callback)
pub fn act(callback : () -> Unit) -> @js.Any {
  let rtl = testing_library()
  rtl.call1("act", @js.identity(callback))
}

///|
/// JS: configure(options)
pub fn configure(options : @js.Any) -> Unit {
  let rtl = testing_library()
  rtl.call1("configure", options) |> ignore
}

///|
/// RenderHookResult returned by renderHook()
#external
pub type RenderHookResult

///|
pub impl @js.JsImpl for RenderHookResult

///|
/// JS: renderHook(hook, options?)
pub fn renderHook(hook : @js.Any) -> RenderHookResult {
  let ptl = testing_library()
  ptl.call1("renderHook", hook).cast()
}

///|
/// JS: result.result
pub fn RenderHookResult::result(self : RenderHookResult) -> @js.Any {
  self.get("result")
}

///|
/// JS: result.rerender(props)
pub fn RenderHookResult::rerender(
  self : RenderHookResult,
  props : @js.Any,
) -> Unit {
  self.call1("rerender", props) |> ignore
}

///|
/// JS: result.unmount()
pub fn RenderHookResult::unmount(self : RenderHookResult) -> Unit {
  self.call0("unmount") |> ignore
}

///|
/// JS: waitFor(callback, options?)
pub async fn waitFor(callback : () -> Unit) -> Unit {
  let ptl = testing_library()
  let promise : @js.Promise[Unit] = ptl
    .call1("waitFor", @js.identity(callback))
    .cast()
  promise.wait()
}
