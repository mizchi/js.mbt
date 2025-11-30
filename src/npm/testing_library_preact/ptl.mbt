///|
#external
pub type PreactTestingLibrary

///|
pub fn PreactTestingLibrary::as_any(self : PreactTestingLibrary) -> @nostd.Any = "%identity"

///|
fn testing_library() -> PreactTestingLibrary {
  @node.require("@testing-library/preact").cast()
}

///|
/// JS: import { screen } from '@testing-library/preact'
pub fn screen() -> @testing_library.Screen {
  testing_library().as_any()["screen"].cast()
}

///|
/// JS: import { fireEvent } from '@testing-library/preact'
#alias(fire_event)
pub fn fireEvent() -> @testing_library.FireEvent {
  testing_library().as_any()["fireEvent"].cast()
}

///|
/// RenderResult returned by render()
#external
pub type RenderResult

///|
pub fn RenderResult::as_any(self : RenderResult) -> @nostd.Any = "%identity"

///|
/// JS: render(element, options?)
/// Returns: RenderResult with queries, container, baseElement, debug, rerender, unmount, asFragment
pub fn render(element : @preact.VNode) -> RenderResult {
  let rtl = testing_library()
  rtl.as_any()._call("render", [element.as_any()]).cast()
}

///|
/// JS: result.container
pub fn RenderResult::container(self : RenderResult) -> @dom.HTMLElement {
  self.as_any()["container"].cast()
}

///|
/// JS: result.baseElement
pub fn RenderResult::baseElement(self : RenderResult) -> @dom.HTMLElement {
  self.as_any()["baseElement"].cast()
}

///|
/// JS: result.debug()
pub fn RenderResult::debug(self : RenderResult) -> Unit {
  self.as_any()._call("debug", []) |> ignore
}

///|
/// JS: result.rerender(element)
pub fn RenderResult::rerender(
  self : RenderResult,
  element : @preact.VNode,
) -> Unit {
  self.as_any()._call("rerender", [element.as_any()]) |> ignore
}

///|
/// JS: result.unmount()
pub fn RenderResult::unmount(self : RenderResult) -> Unit {
  self.as_any()._call("unmount", []) |> ignore
}

///|
/// JS: result.asFragment()
pub fn RenderResult::asFragment(self : RenderResult) -> @nostd.Any {
  self.as_any()._call("asFragment", [])
}

///|
/// JS: cleanup()
pub fn cleanup() -> Unit {
  let rtl = testing_library()
  rtl.as_any()._call("cleanup", []) |> ignore
}

///|
/// JS: act(callback)
pub fn act(callback : () -> Unit) -> @nostd.Any {
  let rtl = testing_library()
  rtl.as_any()._call("act", [@nostd.any(callback)])
}

///|
/// JS: configure(options)
pub fn configure(options : @nostd.Any) -> Unit {
  let rtl = testing_library()
  rtl.as_any()._call("configure", [options]) |> ignore
}

///|
/// RenderHookResult returned by renderHook()
#external
pub type RenderHookResult

///|
pub fn RenderHookResult::as_any(self : RenderHookResult) -> @nostd.Any = "%identity"

///|
/// JS: renderHook(hook, options?)
pub fn renderHook(hook : @nostd.Any) -> RenderHookResult {
  let ptl = testing_library()
  ptl.as_any()._call("renderHook", [hook]).cast()
}

///|
/// JS: result.result
pub fn RenderHookResult::result(self : RenderHookResult) -> @nostd.Any {
  self.as_any()["result"]
}

///|
/// JS: result.rerender(props)
pub fn RenderHookResult::rerender(
  self : RenderHookResult,
  props : @nostd.Any,
) -> Unit {
  self.as_any()._call("rerender", [props]) |> ignore
}

///|
/// JS: result.unmount()
pub fn RenderHookResult::unmount(self : RenderHookResult) -> Unit {
  self.as_any()._call("unmount", []) |> ignore
}

///|
/// JS: waitFor(callback, options?)
pub async fn waitFor(callback : () -> Unit) -> Unit {
  let ptl = testing_library()
  let promise : @nostd.Promise[Unit] = ptl
    .as_any()
    ._call("waitFor", [@nostd.any(callback)])
    .cast()
  promise.wait()
}
