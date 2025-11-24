///|
/// Dynamic import for react-router module
/// NOTE: This uses dynamic import which doesn't support tree-shaking.
/// When MoonBit adds native ESM support, this should be replaced with static imports.
extern "js" fn import_react_router() -> @js.Promise[@js.Any] =
  #|() => import("react-router")

///|
/// Dynamic import and initialize React Router API asynchronously
/// NOTE: This uses dynamic import which doesn't support tree-shaking.
/// When MoonBit adds native ESM support, this should be replaced with static imports.
///
/// Implementation detail: Stores the module in globalThis for internal use.
pub async fn dynamic_import_async() -> Unit {
  if @js.is_undefined(@js.globalThis().get("__ReactRouterApi")) {
    let v = import_react_router().wait()
    @js.globalThis().set("__ReactRouterApi", v)
  }
}

///|
/// @deprecated Use dynamic_import_async() instead
pub async fn init_react_router_async() -> Unit {
  dynamic_import_async()
}

///|
#external
pub type Router

///|
pub struct RouterProviderProps {
  router : Router
}

///|
extern "js" fn get_router_provider() -> (RouterProviderProps) -> @react.Element =
  #| () => __ReactRouterApi.RouterProvider

///|
#alias(router_provider)
pub fn routerProvider(router : Router) -> @react.Element {
  let p = get_router_provider()
  @react.component(p, RouterProviderProps::{ router, })
}

///|
pub(all) struct RouteProps {
  // params: @js.Map[String, String]
  pathname : String
  search : String
  hash : String
}

///|
pub(all) enum Route {
  Component(path~ : String, component~ : (RouteProps) -> @react.Element)
  Element(path~ : String, element~ : @react.Element)
}

///|
impl @js.JsImpl for Route with to_any(self) {
  match self {
    Route::Component(path~, component~) => {
      let obj = @js.Object::new()
      obj.set("path", path)
      obj.set("Component", component |> @js.unsafe_js)
      obj.to_any()
    }
    Route::Element(path~, element~) => {
      let obj = @js.Object::new()
      obj.set("path", path)
      obj.set("element", element |> @js.unsafe_js)
      obj.to_any()
    }
  }
}

///|
#alias(create_browser_router)
pub fn createBrowserRouter(routes : Array[Route]) -> Router {
  let create_browser_router : (Array[@js.Any]) -> Router = @js.global_this()
    .get("__ReactRouterApi")
    .get("createBrowserRouter")
    .cast()
  create_browser_router(routes.map(_.to_any()))
}

///|
pub struct LinkProps {
  to : String
}

///|
extern "js" fn get_link() -> (LinkProps) -> @react.Element =
  #| () => __ReactRouterApi.Link

///|
pub fn link(
  to~ : String,
  children : Array[&@react.ReactNode],
) -> @react.Element {
  let p = get_link()
  @react.c(p, LinkProps::{ to, }, children~)
}
