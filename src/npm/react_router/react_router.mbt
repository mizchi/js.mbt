///|
/// Dynamic import for react-router module
/// NOTE: This uses dynamic import which doesn't support tree-shaking.
/// When MoonBit adds native ESM support, this should be replaced with static imports.
extern "js" fn import_react_router() -> @js.Promise[@nostd.Any] =
  #|() => import("react-router")

///|
/// Internal FFI to create React element with component
extern "js" fn ffi_create_element(
  tag : @nostd.Any,
  props : @nostd.Any,
  children : @nostd.Any,
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
  if @js.is_undefined(@global.global_this()._get("__ReactRouterApi")) {
    let v = import_react_router().wait()
    @global.global_this().set("__ReactRouterApi", v)
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
pub fn Route::as_any(self : Route) -> @nostd.Any {
  match self {
    Route::Component(path~, component~) => {
      let obj = @nostd.Object::new()
      obj.set("path", path)
      obj.set("Component", component |> @js.unsafe_any)
      obj
    }
    Route::Element(path~, element~) => {
      let obj = @nostd.Object::new()
      obj.set("path", path)
      obj.set("element", element |> @js.unsafe_any)
      obj
    }
  }
}

///|
/// Creates a browser router with the given routes
/// https://reactrouter.com/en/main/routers/create-browser-router
pub fn create_browser_router(routes : Array[Route]) -> Router {
  let create_fn : (Array[@nostd.Any]) -> Router = @global.global_this()
    ._get("__ReactRouterApi")
    ._get("createBrowserRouter")
    .cast()
  create_fn(routes.map(_.as_any()))
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
  let create_fn : (Array[@nostd.Any], @nostd.Any) -> Router = @global.global_this()
    ._get("__ReactRouterApi")
    ._get("createMemoryRouter")
    .cast()
  let opts = @nostd.Object::new()
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
  create_fn(routes.map(_.as_any()), opts)
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
pub fn Params::as_any(self : Params) -> @nostd.Any = "%identity"

///|
/// Get a parameter value by name
pub fn Params::get(self : Self, name : String) -> String? {
  let val = self.as_any()._get(name)
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
  state : @nostd.Any
  key : String
}

///|
pub fn Location::as_any(self : Location) -> @nostd.Any = "%identity"

///|
/// Hook: Returns the current location object
/// https://reactrouter.com/en/main/hooks/use-location
pub fn useLocation() -> Location {
  let hook : () -> Location = @global.global_this()
    ._get("__ReactRouterApi")
    ._get("useLocation")
    .cast()
  hook()
}

///|
/// Hook: Returns the current URL params from the route
/// https://reactrouter.com/en/main/hooks/use-params
pub fn useParams() -> Params {
  let hook : () -> Params = @global.global_this()
    ._get("__ReactRouterApi")
    ._get("useParams")
    .cast()
  hook()
}

///|
/// NavigateFunction type for programmatic navigation
pub(all) struct NavigateFunction((@nostd.Any, @nostd.Any?) -> Unit)

///|
/// NavigateOptions for navigate function
pub(all) struct NavigateOptions {
  replace : Bool?
  state : @nostd.Any?
  relative : String? // "route" | "path"
}

///|
pub fn NavigateOptions::as_any(self : NavigateOptions) -> @nostd.Any {
  let obj = @nostd.Object::new()
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
  obj
}

///|
/// Hook: Returns a navigate function for programmatic navigation
/// https://reactrouter.com/en/main/hooks/use-navigate
pub fn useNavigate() -> NavigateFunction {
  let hook : () -> NavigateFunction = @global.global_this()
    ._get("__ReactRouterApi")
    ._get("useNavigate")
    .cast()
  hook()
}

///|
/// Navigate to a path
pub fn NavigateFunction::to(
  self : NavigateFunction,
  path : String,
  replace? : Bool,
  state? : @nostd.Any,
  relative? : String,
) -> Unit {
  if replace is None && state is None && relative is None {
    (self.0)(path |> @js.unsafe_any, None)
  } else {
    let options = NavigateOptions::{ replace, state, relative }
    (self.0)(path |> @js.unsafe_any, Some(options.as_any()))
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
  let hook : () -> Array[@nostd.Any] = @global.global_this()
    ._get("__ReactRouterApi")
    ._get("useSearchParams")
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
  pattern : @nostd.Any
}

///|
pub fn Match::as_any(self : Match) -> @nostd.Any = "%identity"

///|
/// Hook: Returns match data if the current location matches the given path pattern
/// https://reactrouter.com/en/main/hooks/use-match
pub fn useMatch(pattern : String) -> Match? {
  let hook : (String) -> @nostd.Any = @global.global_this()
    ._get("__ReactRouterApi")
    ._get("useMatch")
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
pub fn NavLinkRenderProps::as_any(self : NavLinkRenderProps) -> @nostd.Any = "%identity"

///|
extern "js" fn get_nav_link() -> @nostd.Any =
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
  let props = @nostd.Object::new()
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
  let children_arr : Array[@nostd.Any] = children.map(fn(c) {
    c.to_react_node()
  })
  let children_js : @nostd.Any = children_arr.map(fn(c) -> @nostd.Any {
      c.cast()
    })
    |> @js.from_array
  props.set("children", children_js)
  let empty : Array[@nostd.Any] = []
  ffi_create_element(nav_link_component, props, @nostd.any(empty))
}

///|
/// NavLink with render function for full control over active state
pub fn nav_link_render(
  to~ : String,
  render~ : (NavLinkRenderProps) -> @react.Element,
) -> @react.Element {
  let nav_link_component = get_nav_link()
  let props = @nostd.Object::new()
  props.set("to", to)
  props.set("children", @js.from_fn1(render))
  let empty : Array[@nostd.Any] = []
  ffi_create_element(nav_link_component, props, @nostd.any(empty))
}

// =============================================================================
// Outlet Component
// =============================================================================

///|
extern "js" fn get_outlet() -> @nostd.Any =
  #| () => __ReactRouterApi.Outlet

///|
/// Outlet component - renders child routes
/// https://reactrouter.com/en/main/components/outlet
pub fn outlet() -> @react.Element {
  let outlet_component = get_outlet()
  let empty : Array[@nostd.Any] = []
  ffi_create_element(outlet_component, @nostd.null(), @js.from_array(empty))
}

// =============================================================================
// Navigate Component
// =============================================================================

///|
pub struct NavigateProps {
  to : String
  replace : Bool?
  state : @nostd.Any?
  relative : String?
}

///|
pub fn NavigateProps::as_any(self : NavigateProps) -> @nostd.Any {
  let obj = @nostd.Object::new()
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
  obj
}

///|
extern "js" fn get_navigate_component() -> (@nostd.Any) -> @react.Element =
  #| () => __ReactRouterApi.Navigate

///|
/// Navigate component - renders a redirect
/// https://reactrouter.com/en/main/components/navigate
pub fn navigate(
  to~ : String,
  replace? : Bool,
  state? : @nostd.Any,
  relative? : String,
) -> @react.Element {
  let nav_component = get_navigate_component()
  let props = NavigateProps::{ to, replace, state, relative }
  nav_component(props.as_any())
}
