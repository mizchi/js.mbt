///|
#external
pub type VueTestingLibrary

///|
fn VueTestingLibrary::as_any(self : VueTestingLibrary) -> @nostd.Any = "%identity"

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
pub fn RenderResult::as_any(self : RenderResult) -> @nostd.Any = "%identity"

///|
/// JS: render(component, options?)
/// Returns: RenderResult with queries, container, baseElement, debug, rerender, unmount
pub fn render(component : @vue.VNode) -> RenderResult {
  let vtl = testing_library()
  vtl.as_any()._call("render", [@nostd.identity(component.as_any())]).cast()
}

///|
/// JS: render(component, options?) with props
pub fn renderWithProps(component : @vue.VNode, props : @nostd.Any) -> RenderResult {
  let vtl = testing_library()
  let options = @nostd.Object::new()
  options._set("props", @nostd.identity(props))
  vtl
  .as_any()
  ._call("render", [@nostd.identity(component.as_any()), options])
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
  self.as_any()._call("debug", ([] : Array[@nostd.Any])) |> ignore
}

///|
/// JS: result.rerender(props)
pub fn RenderResult::rerender(self : RenderResult, props : @nostd.Any) -> Unit {
  self.as_any()._call("rerender", [@nostd.identity(props)]) |> ignore
}

///|
/// JS: result.unmount()
pub fn RenderResult::unmount(self : RenderResult) -> Unit {
  self.as_any()._call("unmount", ([] : Array[@nostd.Any])) |> ignore
}

///|
/// JS: result.html()
pub fn RenderResult::html(self : RenderResult) -> String {
  self.as_any()._call("html", ([] : Array[@nostd.Any])).cast()
}

///|
/// JS: cleanup()
pub fn cleanup() -> Unit {
  let vtl = testing_library()
  vtl.as_any()._call("cleanup", ([] : Array[@nostd.Any])) |> ignore
}

///|
/// JS: configure(options)
pub fn configure(options : @nostd.Any) -> Unit {
  let vtl = testing_library()
  vtl.as_any()._call("configure", [@nostd.identity(options)]) |> ignore
}

///|
/// JS: waitFor(callback, options?)
pub async fn waitFor(callback : () -> Unit) -> Unit {
  let vtl = testing_library()
  let promise : @js.Promise[Unit] = vtl
    .as_any()
    ._call("waitFor", [@nostd.any(callback)])
    .cast()
  promise.wait()
}

///|
/// JS: waitForElementToBeRemoved(callback, options?)
pub async fn waitForElementToBeRemoved(callback : () -> @nostd.Any) -> Unit {
  let vtl = testing_library()
  let promise : @js.Promise[Unit] = vtl
    .as_any()
    ._call("waitForElementToBeRemoved", [@nostd.any(callback)])
    .cast()
  promise.wait()
}
