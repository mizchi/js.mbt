///|
pub extern "js" fn load_react_router() -> @js.Promise[@js.Value] =
  #| () => import("react-router")

///|
pub async fn init_react_router() -> Unit {
  if @js.global_this().get("__ReactRouterApi").is_undefined() {
    let v = load_react_router().wait()
    @js.global_this().set("__ReactRouterApi", v)
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
pub fn router_provider(router : Router) -> @react.Element {
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
fn Route::to_rr_obj(self : Route) -> @js.Value {
  match self {
    Route::Component(path~, component~) => {
      let obj = @js.new_object()
      obj.set("path", path)
      obj.set("Component", component |> @js.to_js)
      obj
    }
    Route::Element(path~, element~) => {
      let obj = @js.new_object()
      obj.set("path", path)
      obj.set("element", element |> @js.to_js)
      obj
    }
  }
}

///|
pub fn create_browser_router(routes : Array[Route]) -> Router {
  let create_browser_router : (Array[@js.Value]) -> Router = @js.global_this()
    .get("__ReactRouterApi")
    .get("createBrowserRouter")
    .cast()
  let rr_routes = routes.map(_.to_rr_obj())
  create_browser_router(rr_routes)
}

///|
pub struct LinkProps {
  to : String
}

///|
extern "js" fn get_link() -> (LinkProps) -> @react.Element =
  #| () => __ReactRouterApi.Link

///|
pub fn link(to~ : String, children : Array[&@js.ToJs]) -> @react.Element {
  let p = get_link()
  @react.c(p, LinkProps::{ to, }, children~)
}
