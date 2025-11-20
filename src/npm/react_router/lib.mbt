///|
using @js {type Js, trait JsImpl, unsafe_cast, type Promise}

///|
extern "js" fn import_react_router() -> Promise[Js] =
  #|() => import("react-router")

///|
pub async fn init_react_router_async() -> Unit {
  if @js.is_undefined(@js.globalThis().get("__ReactRouterApi")) {
    let v = import_react_router().unwrap()
    @js.globalThis().set("__ReactRouterApi", v)
  }
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
  @react.c(p, RouterProviderProps::{ router, })
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
impl JsImpl for Route with to_js(self : Route) {
  match self {
    Route::Component(path~, component~) => {
      let obj = @js.Object::new()
      obj.set("path", path)
      obj.set("Component", component |> @js.unsafe_js)
      obj.to_js()
    }
    Route::Element(path~, element~) => {
      let obj = @js.Object::new()
      obj.set("path", path)
      obj.set("element", element |> @js.unsafe_js)
      obj.to_js()
    }
  }
}

///|
#alias(create_browser_router)
pub fn createBrowserRouter(routes : Array[Route]) -> Router {
  let create_browser_router : (Array[Js]) -> Router = unsafe_cast(
    @js.global_this().get("__ReactRouterApi").get("createBrowserRouter"),
  )
  create_browser_router(routes.map(_.to_js()))
}

///|
pub struct LinkProps {
  to : String
}

///|
extern "js" fn get_link() -> (LinkProps) -> @react.Element =
  #| () => __ReactRouterApi.Link

///|
pub fn link(to~ : String, children : Array[&JsImpl]) -> @react.Element {
  let p = get_link()
  @react.c(p, LinkProps::{ to, }, children~)
}
