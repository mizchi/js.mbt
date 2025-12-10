///|
#external
pub type ReactTestingLibrary

///|
pub fn ReactTestingLibrary::as_any(self : ReactTestingLibrary) -> @core.Any = "%identity"

///|
fn testing_library() -> ReactTestingLibrary {
  @node.require("@testing-library/react").cast()
}

///|
/// JS: import { screen } from '@testing-library/react'
pub fn screen() -> @testing_library.Screen {
  testing_library().as_any()["screen"].cast()
}

///|
/// JS: import { fireEvent } from '@testing-library/react'
#alias(fire_event)
pub fn fireEvent() -> @testing_library.FireEvent {
  testing_library().as_any()["fireEvent"].cast()
}

///|
/// RenderResult returned by render()
#external
pub type RenderResult

///|
pub fn RenderResult::as_any(self : RenderResult) -> @core.Any = "%identity"

///|
/// JS: render(element, options?)
/// Returns: RenderResult with queries, container, baseElement, debug, rerender, unmount, asFragment
pub fn render(element : @react.Element) -> RenderResult {
  let rtl = testing_library()
  rtl.as_any()["render"]._invoke([element.as_any()]).cast()
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
  self.as_any()["debug"]._invoke([]) |> ignore
}

///|
/// JS: result.rerender(element)
pub fn RenderResult::rerender(
  self : RenderResult,
  element : @react.Element,
) -> Unit {
  self.as_any()["rerender"]._invoke([element.as_any()]) |> ignore
}

///|
/// JS: result.unmount()
pub fn RenderResult::unmount(self : RenderResult) -> Unit {
  self.as_any()["unmount"]._invoke([]) |> ignore
}

///|
/// JS: result.asFragment()
pub fn RenderResult::asFragment(self : RenderResult) -> @core.Any {
  self.as_any()["asFragment"]._invoke([])
}

///|
/// JS: cleanup()
pub fn cleanup() -> Unit {
  let rtl = testing_library()
  rtl.as_any()["cleanup"]._invoke([]) |> ignore
}

///|
/// JS: act(callback)
pub fn act(callback : () -> Unit) -> @core.Any {
  let rtl = testing_library()
  rtl.as_any()["act"]._invoke([@core.any(callback)])
}

///|
/// JS: configure(options)
pub fn configure(options : @core.Any) -> Unit {
  let rtl = testing_library()
  rtl.as_any()["configure"]._invoke([options]) |> ignore
}

///|
/// RenderHookResult returned by renderHook()
#external
pub type RenderHookResult

///|
pub fn RenderHookResult::as_any(self : RenderHookResult) -> @core.Any = "%identity"

///|
/// JS: renderHook(hook, options?)
pub fn renderHook(hook : @core.Any) -> RenderHookResult {
  let rtl = testing_library()
  rtl.as_any()["renderHook"]._invoke([hook]).cast()
}

///|
/// JS: result.result
pub fn RenderHookResult::result(self : RenderHookResult) -> @core.Any {
  self.as_any()["result"]
}

///|
/// JS: result.rerender(props)
pub fn RenderHookResult::rerender(
  self : RenderHookResult,
  props : @core.Any,
) -> Unit {
  self.as_any()["rerender"]._invoke([props]) |> ignore
}

///|
/// JS: result.unmount()
pub fn RenderHookResult::unmount(self : RenderHookResult) -> Unit {
  self.as_any()["unmount"]._invoke([]) |> ignore
}
