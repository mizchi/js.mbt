///|
#external
pub type VueTestingLibrary

///|
fn VueTestingLibrary::as_any(self : VueTestingLibrary) -> @core.Any = "%identity"

///|
fn testing_library() -> VueTestingLibrary {
  @node.require("@testing-library/vue").cast()
}

///|
/// JS: import { screen } from '@testing-library/vue'
pub fn screen() -> @testing_library.Screen {
  testing_library().as_any()._get("screen").cast()
}

///|
/// JS: import { fireEvent } from '@testing-library/vue'
#alias(fire_event)
pub fn fireEvent() -> @testing_library.FireEvent {
  testing_library().as_any()._get("fireEvent").cast()
}

///|
/// RenderResult returned by render()
#external
pub type RenderResult

///|
pub fn RenderResult::as_any(self : RenderResult) -> @core.Any = "%identity"

///|
/// JS: render(component, options?)
/// Returns: RenderResult with queries, container, baseElement, debug, rerender, unmount
pub fn render(component : @vue.VNode) -> RenderResult {
  let vtl = testing_library()
  vtl.as_any()._call("render", [@core.identity(component.as_any())]).cast()
}

///|
/// JS: render(component, options?) with props
pub fn renderWithProps(
  component : @vue.VNode,
  props : @core.Any,
) -> RenderResult {
  let vtl = testing_library()
  let options = @core.new_object()
  options._set("props", @core.identity(props))
  vtl
  .as_any()
  ._call("render", [@core.identity(component.as_any()), options])
  .cast()
}

///|
/// JS: result.container
pub fn RenderResult::container(self : RenderResult) -> @dom.HTMLElement {
  self.as_any()._get("container").cast()
}

///|
/// JS: result.baseElement
pub fn RenderResult::baseElement(self : RenderResult) -> @dom.HTMLElement {
  self.as_any()._get("baseElement").cast()
}

///|
/// JS: result.debug()
pub fn RenderResult::debug(self : RenderResult) -> Unit {
  self.as_any()._call("debug", ([] : Array[@core.Any])) |> ignore
}

///|
/// JS: result.rerender(props)
pub fn RenderResult::rerender(self : RenderResult, props : @core.Any) -> Unit {
  self.as_any()._call("rerender", [@core.identity(props)]) |> ignore
}

///|
/// JS: result.unmount()
pub fn RenderResult::unmount(self : RenderResult) -> Unit {
  self.as_any()._call("unmount", ([] : Array[@core.Any])) |> ignore
}

///|
/// JS: result.html()
pub fn RenderResult::html(self : RenderResult) -> String {
  self.as_any()._call("html", ([] : Array[@core.Any])).cast()
}

///|
/// JS: cleanup()
pub fn cleanup() -> Unit {
  let vtl = testing_library()
  vtl.as_any()._call("cleanup", ([] : Array[@core.Any])) |> ignore
}

///|
/// JS: configure(options)
pub fn configure(options : @core.Any) -> Unit {
  let vtl = testing_library()
  vtl.as_any()._call("configure", [@core.identity(options)]) |> ignore
}

///|
/// JS: waitFor(callback, options?)
pub async fn waitFor(callback : () -> Unit) -> Unit {
  let vtl = testing_library()
  let promise : @js.Promise[Unit] = vtl
    .as_any()
    ._call("waitFor", [@core.any(callback)])
    .cast()
  promise.wait()
}

///|
/// JS: waitForElementToBeRemoved(callback, options?)
pub async fn waitForElementToBeRemoved(callback : () -> @core.Any) -> Unit {
  let vtl = testing_library()
  let promise : @js.Promise[Unit] = vtl
    .as_any()
    ._call("waitForElementToBeRemoved", [@core.any(callback)])
    .cast()
  promise.wait()
}
