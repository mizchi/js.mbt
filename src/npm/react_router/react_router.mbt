///|
/// Dynamic import for react-router module
/// NOTE: This uses dynamic import which doesn't support tree-shaking.
/// When MoonBit adds native ESM support, this should be replaced with static imports.
extern "js" fn import_react_router() -> @js.Promise[@js.Any] =
  #|() => import("react-router")

///|
/// Internal FFI to create React element with component
extern "js" fn ffi_create_element(
  tag : @js.Any,
  props : @js.Any,
  children : @js.Any,
) -> @react.Element =
  #|(tag, props, children) => {
  #|  return __ReactApi.createElement(tag, props, ...children)
  #|}

///|
/// Dynamic import and initialize React Router API asynchronously
/// NOTE: This uses dynamic import which doesn't support tree-shaking.
/// When MoonBit adds native ESM support, this should be replaced with static imports.
///
/// Implementation detail: Stores the module in globalThis for internal use.
pub async fn dynamic_import() -> Unit {
  if @js.is_undefined(@js.globalThis().get("__ReactRouterApi")) {
    let v = import_react_router().wait()
    @js.globalThis().set("__ReactRouterApi", v)
  }
}

///|
/// @deprecated Use dynamic_import() instead
pub async fn init_react_router_async() -> Unit {
  dynamic_import()
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
/// RouterProvider component - provides routing context to the app
/// https://reactrouter.com/en/main/routers/router-provider
pub fn router_provider(router : Router) -> @react.Element {
  let p = get_router_provider()
  @react.component(p, RouterProviderProps::{ router, })
}

///|
pub(all) struct RouteProps {
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
      obj.set("Component", component |> @js.unsafe_any)
      obj.to_any()
    }
    Route::Element(path~, element~) => {
      let obj = @js.Object::new()
      obj.set("path", path)
      obj.set("element", element |> @js.unsafe_any)
      obj.to_any()
    }
  }
}

///|
/// Creates a browser router with the given routes
/// https://reactrouter.com/en/main/routers/create-browser-router
pub fn create_browser_router(routes : Array[Route]) -> Router {
  let create_fn : (Array[@js.Any]) -> Router = @js.global_this()
    .get("__ReactRouterApi")
    .get("createBrowserRouter")
    .cast()
  create_fn(routes.map(_.to_any()))
}

///|
/// Options for createMemoryRouter
pub(all) struct MemoryRouterOptions {
  /// Initial entries in the history stack
  initial_entries : Array[String]?
  /// Initial index in the history stack
  initial_index : Int?
}

///|
/// Creates a memory router for testing and non-browser environments
/// https://reactrouter.com/en/main/routers/create-memory-router
pub fn create_memory_router(
  routes : Array[Route],
  options? : MemoryRouterOptions,
) -> Router {
  let create_fn : (Array[@js.Any], @js.Any) -> Router = @js.global_this()
    .get("__ReactRouterApi")
    .get("createMemoryRouter")
    .cast()
  let opts = @js.Object::new()
  match options {
    Some(o) => {
      match o.initial_entries {
        Some(entries) => opts.set("initialEntries", @js.from_array(entries))
        None => ()
      }
      match o.initial_index {
        Some(idx) => opts.set("initialIndex", idx)
        None => ()
      }
    }
    None => ()
  }
  create_fn(routes.map(_.to_any()), opts.to_any())
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

// =============================================================================
// React Router Hooks
// =============================================================================

///|
/// Params represents route parameters from dynamic segments
/// This is a JavaScript object that maps parameter names to their values
#external
pub type Params

///|
pub impl @js.JsImpl for Params

///|
/// Get a parameter value by name
pub fn Params::get(self : Self, name : String) -> String? {
  let val = self.to_any().get(name)
  if @js.is_undefined(val) || @js.is_null(val) {
    None
  } else {
    Some(val.cast())
  }
}

///|
/// Location represents the current location object from React Router
/// https://reactrouter.com/en/main/hooks/use-location
pub(all) struct Location {
  pathname : String
  search : String
  hash : String
  state : @js.Any
  key : String
}

///|
pub impl @js.JsImpl for Location

///|
/// Hook: Returns the current location object
/// https://reactrouter.com/en/main/hooks/use-location
pub fn useLocation() -> Location {
  let hook : () -> Location = @js.global_this()
    .get("__ReactRouterApi")
    .get("useLocation")
    .cast()
  hook()
}

///|
/// Hook: Returns the current URL params from the route
/// https://reactrouter.com/en/main/hooks/use-params
pub fn useParams() -> Params {
  let hook : () -> Params = @js.global_this()
    .get("__ReactRouterApi")
    .get("useParams")
    .cast()
  hook()
}

///|
/// NavigateFunction type for programmatic navigation
pub(all) struct NavigateFunction((@js.Any, @js.Any?) -> Unit)

///|
/// NavigateOptions for navigate function
pub(all) struct NavigateOptions {
  replace : Bool?
  state : @js.Any?
  relative : String? // "route" | "path"
}

///|
impl @js.JsImpl for NavigateOptions with to_any(self) {
  let obj = @js.Object::new()
  match self.replace {
    Some(r) => obj.set("replace", r)
    None => ()
  }
  match self.state {
    Some(s) => obj.set("state", s)
    None => ()
  }
  match self.relative {
    Some(r) => obj.set("relative", r)
    None => ()
  }
  obj.to_any()
}

///|
/// Hook: Returns a navigate function for programmatic navigation
/// https://reactrouter.com/en/main/hooks/use-navigate
pub fn useNavigate() -> NavigateFunction {
  let hook : () -> NavigateFunction = @js.global_this()
    .get("__ReactRouterApi")
    .get("useNavigate")
    .cast()
  hook()
}

///|
/// Navigate to a path
pub fn NavigateFunction::to(
  self : NavigateFunction,
  path : String,
  replace? : Bool,
  state? : @js.Any,
  relative? : String,
) -> Unit {
  if replace is None && state is None && relative is None {
    (self.0)(path |> @js.unsafe_any, None)
  } else {
    let options = NavigateOptions::{ replace, state, relative }
    (self.0)(path |> @js.unsafe_any, Some(options.to_any()))
  }
}

///|
/// Navigate back/forward in history by delta
pub fn NavigateFunction::go(self : NavigateFunction, delta : Int) -> Unit {
  (self.0)(delta |> @js.unsafe_any, None)
}

///|
/// Navigate back in history
pub fn NavigateFunction::back(self : NavigateFunction) -> Unit {
  self.go(-1)
}

///|
/// Navigate forward in history
pub fn NavigateFunction::forward(self : NavigateFunction) -> Unit {
  self.go(1)
}

///|
/// Hook: Returns URLSearchParams for the current URL
/// https://reactrouter.com/en/main/hooks/use-search-params
pub fn useSearchParams() -> (
  @url.URLSearchParams,
  (@url.URLSearchParams) -> Unit,
) {
  let hook : () -> Array[@js.Any] = @js.global_this()
    .get("__ReactRouterApi")
    .get("useSearchParams")
    .cast()
  let result = hook()
  let search_params : @url.URLSearchParams = result[0].cast()
  let set_search_params : (@url.URLSearchParams) -> Unit = result[1].cast()
  (search_params, set_search_params)
}

///|
/// Match represents the result of useMatch
pub(all) struct Match {
  params : Params
  pathname : String
  pathnameBase : String
  pattern : @js.Any
}

///|
pub impl @js.JsImpl for Match

///|
/// Hook: Returns match data if the current location matches the given path pattern
/// https://reactrouter.com/en/main/hooks/use-match
pub fn useMatch(pattern : String) -> Match? {
  let hook : (String) -> @js.Any = @js.global_this()
    .get("__ReactRouterApi")
    .get("useMatch")
    .cast()
  let result = hook(pattern)
  if @js.is_null(result) {
    None
  } else {
    Some(result.cast())
  }
}

// =============================================================================
// NavLink Component (Link with active state)
// =============================================================================

///|
/// NavLinkRenderProps passed to NavLink's children render function
pub(all) struct NavLinkRenderProps {
  isActive : Bool
  isPending : Bool
  isTransitioning : Bool
}

///|
pub impl @js.JsImpl for NavLinkRenderProps

///|
extern "js" fn get_nav_link() -> @js.Any =
  #| () => __ReactRouterApi.NavLink

///|
/// NavLink component - a Link that knows whether it's active
/// https://reactrouter.com/en/main/components/nav-link
pub fn nav_link(
  to~ : String,
  class_name? : String,
  active_class_name? : String,
  children : Array[&@react.ReactNode],
) -> @react.Element {
  let nav_link_component = get_nav_link()
  let props = @js.Object::new()
  props.set("to", to)
  match (class_name, active_class_name) {
    (Some(base), Some(active)) =>
      props.set(
        "className",
        @js.from_fn1(fn(render_props : NavLinkRenderProps) {
          if render_props.isActive {
            base + " " + active
          } else {
            base
          }
        }),
      )
    (Some(base), None) => props.set("className", base)
    (None, Some(active)) =>
      props.set(
        "className",
        @js.from_fn1(fn(render_props : NavLinkRenderProps) {
          if render_props.isActive {
            active
          } else {
            ""
          }
        }),
      )
    (None, None) => ()
  }
  let children_js = children.map(fn(c) { c.to_react_node() }) |> @js.from_array
  props.set("children", children_js)
  let empty : Array[@js.Any] = []
  ffi_create_element(nav_link_component, props.to_any(), @js.from_array(empty))
}

///|
/// NavLink with render function for full control over active state
pub fn nav_link_render(
  to~ : String,
  render~ : (NavLinkRenderProps) -> @react.Element,
) -> @react.Element {
  let nav_link_component = get_nav_link()
  let props = @js.Object::new()
  props.set("to", to)
  props.set("children", @js.from_fn1(render))
  let empty : Array[@js.Any] = []
  ffi_create_element(nav_link_component, props.to_any(), @js.from_array(empty))
}

// =============================================================================
// Outlet Component
// =============================================================================

///|
extern "js" fn get_outlet() -> @js.Any =
  #| () => __ReactRouterApi.Outlet

///|
/// Outlet component - renders child routes
/// https://reactrouter.com/en/main/components/outlet
pub fn outlet() -> @react.Element {
  let outlet_component = get_outlet()
  let empty : Array[@js.Any] = []
  ffi_create_element(outlet_component, @js.null_(), @js.from_array(empty))
}

// =============================================================================
// Navigate Component
// =============================================================================

///|
pub struct NavigateProps {
  to : String
  replace : Bool?
  state : @js.Any?
  relative : String?
}

///|
impl @js.JsImpl for NavigateProps with to_any(self) {
  let obj = @js.Object::new()
  obj.set("to", self.to)
  match self.replace {
    Some(r) => obj.set("replace", r)
    None => ()
  }
  match self.state {
    Some(s) => obj.set("state", s)
    None => ()
  }
  match self.relative {
    Some(r) => obj.set("relative", r)
    None => ()
  }
  obj.to_any()
}

///|
extern "js" fn get_navigate_component() -> (@js.Any) -> @react.Element =
  #| () => __ReactRouterApi.Navigate

///|
/// Navigate component - renders a redirect
/// https://reactrouter.com/en/main/components/navigate
pub fn navigate(
  to~ : String,
  replace? : Bool,
  state? : @js.Any,
  relative? : String,
) -> @react.Element {
  let nav_component = get_navigate_component()
  let props = NavigateProps::{ to, replace, state, relative }
  nav_component(props.to_any())
}
