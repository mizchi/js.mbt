///|
/// Window represents the browser's window object
/// https://developer.mozilla.org/en-US/docs/Web/API/Window
#external
pub type Window

///|
pub fn Window::as_any(self : Window) -> @nostd.Any = "%identity"

///|
pub fn Window::as_event_target(self : Window) -> @event.EventTarget = "%identity"

///|
pub impl @js.JsImpl for Window

///|
pub impl @event.EventTargetImpl for Window

///|
/// Returns the global window object
pub extern "js" fn window() -> Window =
  #| () => window

///|
/// Returns the document contained in the window
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/document
pub fn Window::document(self : Self) -> Document {
  self.as_any()._get("document").cast()
}

///|
/// Returns the navigator object
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/navigator
///
/// For typed access to Navigator methods, use the `mizchi/js/browser/navigator` package.
pub fn Window::navigator(self : Self) -> @js.Any {
  self.as_any()._get("navigator").cast()
}

///|
/// Returns the location object
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/location
///
/// For typed access to Location methods, use the `mizchi/js/browser/location` package.
pub fn Window::location(self : Self) -> @js.Any {
  self.as_any()._get("location").cast()
}

///|
/// Returns the localStorage object
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/localStorage
#alias(local_storage)
pub fn Window::localStorage(self : Self) -> @js.Any {
  self.as_any()._get("localStorage").cast()
}

///|
/// Returns the sessionStorage object
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/sessionStorage
#alias(session_storage)
pub fn Window::sessionStorage(self : Self) -> @js.Any {
  self.as_any()._get("sessionStorage").cast()
}

///|
/// Returns the console object
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/console
pub fn Window::console(self : Self) -> @js.Any {
  self.as_any()._get("console").cast()
}

///|
/// Returns the history object
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/history
pub fn Window::history(self : Self) -> @history.History {
  self.as_any()._get("history").cast()
}

///|
/// Returns the inner width of the window
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/innerWidth
#alias(inner_width)
pub fn Window::innerWidth(self : Self) -> Int {
  self.as_any()._get("innerWidth").cast()
}

///|
/// Returns the inner height of the window
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/innerHeight
#alias(inner_height)
pub fn Window::innerHeight(self : Self) -> Int {
  self.as_any()._get("innerHeight").cast()
}

///|
/// Returns the outer width of the window
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/outerWidth
#alias(outer_width)
pub fn Window::outerWidth(self : Self) -> Int {
  self.as_any()._get("outerWidth").cast()
}

///|
/// Returns the outer height of the window
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/outerHeight
#alias(outer_height)
pub fn Window::outerHeight(self : Self) -> Int {
  self.as_any()._get("outerHeight").cast()
}

///|
/// Returns the screen object
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/screen
pub fn Window::screen(self : Self) -> @js.Any {
  self.as_any()._get("screen").cast()
}

///|
/// Returns the device pixel ratio
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/devicePixelRatio
#alias(device_pixel_ratio)
pub fn Window::devicePixelRatio(self : Self) -> Double {
  self.as_any()._get("devicePixelRatio").cast()
}

///|
/// Displays an alert dialog
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/alert
pub fn Window::alert(self : Self, message : String) -> Unit {
  self.as_any()._call("alert", [@nostd.any(message)]) |> ignore
}

///|
/// Displays a confirm dialog
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/confirm
pub fn Window::confirm(self : Self, message : String) -> Bool {
  self.as_any()._call("confirm", [@nostd.any(message)]).cast()
}

///|
/// Displays a prompt dialog
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/prompt
pub fn Window::prompt(
  self : Self,
  message : String,
  default? : String,
) -> String? {
  let v : @js.Any = match default {
    Some(d) =>
      self.as_any()._call("prompt", [@nostd.any(message), @nostd.any(d)]).cast()
    None => self.as_any()._call("prompt", [@nostd.any(message)]).cast()
  }
  v |> @js.identity_option()
}

///|
/// Opens a new window
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/open
pub fn Window::open(
  self : Self,
  url? : String,
  target? : String,
  features? : String,
) -> Window? {
  let v : @js.Any = match (url, target, features) {
    (Some(u), Some(t), Some(f)) =>
      self
      .as_any()
      ._call("open", [@nostd.any(u), @nostd.any(t), @nostd.any(f)])
      .cast()
    (Some(u), Some(t), None) =>
      self.as_any()._call("open", [@nostd.any(u), @nostd.any(t)]).cast()
    (Some(u), None, _) => self.as_any()._call("open", [@nostd.any(u)]).cast()
    (None, _, _) => self.as_any()._call("open", []).cast()
  }
  v |> @js.identity_option
}

///|
/// Closes the window
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/close
pub fn Window::close(self : Self) -> Unit {
  self.as_any()._call("close", []) |> ignore
}

///|
/// Scrolls to a particular set of coordinates
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/scrollTo
#alias(scroll_to)
pub fn Window::scrollTo(self : Self, x : Int, y : Int) -> Unit {
  self.as_any()._call("scrollTo", [@nostd.any(x), @nostd.any(y)]) |> ignore
}

///|
/// Scrolls by a particular amount
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/scrollBy
#alias(scroll_by)
pub fn Window::scrollBy(self : Self, x : Int, y : Int) -> Unit {
  self.as_any()._call("scrollBy", [@nostd.any(x), @nostd.any(y)]) |> ignore
}

///|
/// Returns the horizontal scroll position
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/scrollX
#alias(scroll_x)
pub fn Window::scrollX(self : Self) -> Double {
  self.as_any()._get("scrollX").cast()
}

///|
/// Returns the vertical scroll position
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/scrollY
#alias(scroll_y)
pub fn Window::scrollY(self : Self) -> Double {
  self.as_any()._get("scrollY").cast()
}

///|
/// Calls a function after a specified delay
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/setTimeout
#alias(set_timeout)
pub fn Window::setTimeout(
  self : Self,
  handler : () -> Unit,
  delay : Int,
) -> Int {
  self
  .as_any()
  ._call("setTimeout", [@nostd.any(@js.from_fn0(handler)), @nostd.any(delay)])
  .cast()
}

///|
/// Cancels a timeout previously established by setTimeout
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/clearTimeout
#alias(clear_timeout)
pub fn Window::clearTimeout(self : Self, id : Int) -> Unit {
  self.as_any()._call("clearTimeout", [@nostd.any(id)]) |> ignore
}

///|
/// Repeatedly calls a function with a fixed time delay between each call
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/setInterval
#alias(set_interval)
pub fn Window::setInterval(
  self : Self,
  handler : () -> Unit,
  delay : Int,
) -> Int {
  self
  .as_any()
  ._call("setInterval", [@nostd.any(@js.from_fn0(handler)), @nostd.any(delay)])
  .cast()
}

///|
/// Cancels a timed, repeating action established by setInterval
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/clearInterval
#alias(clear_interval)
pub fn Window::clearInterval(self : Self, id : Int) -> Unit {
  self.as_any()._call("clearInterval", [@nostd.any(id)]) |> ignore
}

///|
/// Requests the browser to call a function to update an animation
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/requestAnimationFrame
#alias(request_animation_frame)
pub fn Window::requestAnimationFrame(
  self : Self,
  callback : (Double) -> Unit,
) -> Int {
  self
  .as_any()
  ._call("requestAnimationFrame", [@nostd.any(@js.unsafe_any(callback))])
  .cast()
}

///|
/// Cancels an animation frame request
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/cancelAnimationFrame
#alias(cancel_animation_frame)
pub fn Window::cancelAnimationFrame(self : Self, id : Int) -> Unit {
  self.as_any()._call("cancelAnimationFrame", [@nostd.any(id)]) |> ignore
}

///|
/// Starts the process of fetching a resource from the network
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/fetch
pub async fn Window::fetch(
  self : Self,
  input : String,
  init? : @http.RequestInit,
) -> @http.Response {
  let promise : @js.Promise[@http.Response] = match init {
    Some(i) =>
      self.as_any()._call("fetch", [@nostd.any(input), @nostd.any(i)]).cast()
    None => self.as_any()._call("fetch", [@nostd.any(input)]).cast()
  }
  promise.wait()
}

///|
/// Returns a selection object representing selected text
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/getSelection
#alias(get_selection)
pub fn Window::getSelection(self : Self) -> @js.Any? {
  let v : @js.Any = self.as_any()._call("getSelection", []).cast()
  v |> @js.identity_option
}

///|
/// Returns computed style of an element
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/getComputedStyle
#alias(get_computed_style)
pub fn Window::getComputedStyle(
  self : Self,
  element : Element,
  pseudo_elt? : String,
) -> @js.Any {
  match pseudo_elt {
    Some(p) =>
      self
      .as_any()
      ._call("getComputedStyle", [element.as_any(), @nostd.any(p)])
      .cast()
    None =>
      self.as_any()._call("getComputedStyle", [element.as_any()]).cast()
  }
}

///|
/// Returns a media query list
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/matchMedia
#alias(match_media)
pub fn Window::matchMedia(self : Self, query : String) -> @js.Any {
  self.as_any()._call("matchMedia", [@nostd.any(query)]).cast()
}

///|
/// Posts a message to the window
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/postMessage
#alias(post_message)
pub fn Window::postMessage(
  self : Self,
  message : @js.Any,
  target_origin : String,
  transfer? : Array[@js.Any],
) -> Unit {
  match transfer {
    Some(t) =>
      self
      .as_any()
      ._call("postMessage", [
        @nostd.any(message),
        @nostd.any(target_origin),
        @nostd.any(@js.from_array(t)),
      ])
      |> ignore
    None =>
      self
      .as_any()
      ._call("postMessage", [@nostd.any(message), @nostd.any(target_origin)])
      |> ignore
  }
}

///|
/// Adds a popstate event listener (fired when active history entry changes)
/// Equivalent to: window.addEventListener("popstate", handler)
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/popstate_event
pub fn Window::add_popstate_listener(
  self : Self,
  handler : (PopStateEvent) -> Unit,
) -> Unit {
  self.as_event_target().on("popstate", fn(event) { handler(event.cast()) })
}

///|
/// Adds a hashchange event listener (fired when URL fragment changes)
/// Equivalent to: window.addEventListener("hashchange", handler)
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/hashchange_event
pub fn Window::add_hashchange_listener(
  self : Self,
  handler : (HashChangeEvent) -> Unit,
) -> Unit {
  self.as_event_target().on("hashchange", fn(event) { handler(event.cast()) })
}

///|
/// Adds a beforeunload event listener (fired before the window unloads)
/// Equivalent to: window.addEventListener("beforeunload", handler)
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/beforeunload_event
pub fn Window::add_beforeunload_listener(
  self : Self,
  handler : (BeforeUnloadEvent) -> Unit,
) -> Unit {
  self.as_event_target().on("beforeunload", fn(event) { handler(event.cast()) })
}

///|
/// Adds a pagehide event listener (fired when a session history entry becomes hidden)
/// Equivalent to: window.addEventListener("pagehide", handler)
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/pagehide_event
pub fn Window::add_pagehide_listener(
  self : Self,
  handler : (PageTransitionEvent) -> Unit,
) -> Unit {
  self.as_event_target().on("pagehide", fn(event) { handler(event.cast()) })
}

///|
/// Adds a pageshow event listener (fired when a session history entry becomes visible)
/// Equivalent to: window.addEventListener("pageshow", handler)
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/pageshow_event
pub fn Window::add_pageshow_listener(
  self : Self,
  handler : (PageTransitionEvent) -> Unit,
) -> Unit {
  self.as_event_target().on("pageshow", fn(event) { handler(event.cast()) })
}
