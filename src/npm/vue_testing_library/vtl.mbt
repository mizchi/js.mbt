///|
#external
pub type VueTestingLibrary

///|
impl @js.JsImpl for VueTestingLibrary

///|
fn testing_library() -> VueTestingLibrary {
  @node.require("@testing-library/vue").cast()
}

///|
/// RenderResult returned by render()
#external
pub type RenderResult

///|
pub impl @js.JsImpl for RenderResult

///|
/// JS: render(component, options?)
/// Returns: RenderResult with queries, container, baseElement, debug, rerender, unmount
pub fn render(component : @vue.VNode) -> RenderResult {
  let vtl = testing_library()
  vtl.call1("render", component).cast()
}

///|
/// JS: render(component, options?) with props
pub fn renderWithProps(component : @vue.VNode, props : @js.Any) -> RenderResult {
  let vtl = testing_library()
  let options = @js.Object::new()
  options.set("props", props)
  vtl.call2("render", component, options.to_any()).cast()
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
/// JS: result.rerender(props)
pub fn RenderResult::rerender(self : RenderResult, props : @js.Any) -> Unit {
  self.call1("rerender", props) |> ignore
}

///|
/// JS: result.unmount()
pub fn RenderResult::unmount(self : RenderResult) -> Unit {
  self.call0("unmount") |> ignore
}

///|
/// JS: result.html()
pub fn RenderResult::html(self : RenderResult) -> String {
  self.call0("html").cast()
}

///|
/// JS: cleanup()
pub fn cleanup() -> Unit {
  let vtl = testing_library()
  vtl.call0("cleanup") |> ignore
}

///|
/// JS: configure(options)
pub fn configure(options : @js.Any) -> Unit {
  let vtl = testing_library()
  vtl.call1("configure", options) |> ignore
}

///|
/// JS: waitFor(callback, options?)
pub async fn waitFor(callback : () -> Unit) -> Unit {
  let vtl = testing_library()
  let promise : @js.Promise[Unit] = vtl
    .call1("waitFor", @js.identity(callback))
    .cast()
  promise.wait()
}

///|
/// JS: waitForElementToBeRemoved(callback, options?)
pub async fn waitForElementToBeRemoved(callback : () -> @js.Any) -> Unit {
  let vtl = testing_library()
  let promise : @js.Promise[Unit] = vtl
    .call1("waitForElementToBeRemoved", @js.identity(callback))
    .cast()
  promise.wait()
}
