///|
/// Window represents the browser's window object
/// https://developer.mozilla.org/en-US/docs/Web/API/Window
#external
pub type Window

///|
pub impl Js for Window with to_js(self) {
  self |> unsafe_cast
}

///|
pub impl EventTargetImpl for Window

///|
/// Returns the global window object
pub extern "js" fn window() -> Window =
  #| () => window

///|
/// Returns the document contained in the window
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/document
pub fn Window::document(self : Self) -> Document {
  self.to_js().get("document").cast()
}

///|
/// Returns the navigator object
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/navigator
pub fn Window::navigator(self : Self) -> Val {
  self.to_js().get("navigator").cast()
}

///|
/// Returns the location object
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/location
pub fn Window::location(self : Self) -> Val {
  self.to_js().get("location").cast()
}

///|
/// Returns the localStorage object
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/localStorage
pub fn Window::local_storage(self : Self) -> Val {
  self.to_js().get("localStorage").cast()
}

///|
/// Returns the sessionStorage object
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/sessionStorage
pub fn Window::session_storage(self : Self) -> Val {
  self.to_js().get("sessionStorage").cast()
}

///|
/// Returns the console object
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/console
pub fn Window::console(self : Self) -> Val {
  self.to_js().get("console").cast()
}

///|
/// Returns the history object
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/history
pub fn Window::history(self : Self) -> Val {
  self.to_js().get("history").cast()
}

///|
/// Returns the inner width of the window
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/innerWidth
pub fn Window::inner_width(self : Self) -> Int {
  self.to_js().get("innerWidth").cast()
}

///|
/// Returns the inner height of the window
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/innerHeight
pub fn Window::inner_height(self : Self) -> Int {
  self.to_js().get("innerHeight").cast()
}

///|
/// Returns the outer width of the window
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/outerWidth
pub fn Window::outer_width(self : Self) -> Int {
  self.to_js().get("outerWidth").cast()
}

///|
/// Returns the outer height of the window
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/outerHeight
pub fn Window::outer_height(self : Self) -> Int {
  self.to_js().get("outerHeight").cast()
}

///|
/// Returns the screen object
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/screen
pub fn Window::screen(self : Self) -> Val {
  self.to_js().get("screen").cast()
}

///|
/// Returns the device pixel ratio
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/devicePixelRatio
pub fn Window::device_pixel_ratio(self : Self) -> Double {
  self.to_js().get("devicePixelRatio").cast()
}

///|
/// Displays an alert dialog
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/alert
pub fn Window::alert(self : Self, message : String) -> Unit {
  ignore(self.to_js().invoke("alert", [message]))
}

///|
/// Displays a confirm dialog
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/confirm
pub fn Window::confirm(self : Self, message : String) -> Bool {
  self.to_js().invoke("confirm", [message]).cast()
}

///|
/// Displays a prompt dialog
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/prompt
pub fn Window::prompt(
  self : Self,
  message : String,
  default? : String,
) -> String? {
  match default {
    Some(d) => self.to_js().invoke("prompt", [message, d]).cast_option()
    None => self.to_js().invoke("prompt", [message]).cast_option()
  }
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
  match (url, target, features) {
    (Some(u), Some(t), Some(f)) =>
      self.to_js().invoke("open", [u, t, f]).cast_option()
    (Some(u), Some(t), None) =>
      self.to_js().invoke("open", [u, t]).cast_option()
    (Some(u), None, _) => self.to_js().invoke("open", [u]).cast_option()
    (None, _, _) => self.to_js().invoke("open", []).cast_option()
  }
}

///|
/// Closes the window
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/close
pub fn Window::close(self : Self) -> Unit {
  ignore(self.to_js().invoke("close", []))
}

///|
/// Scrolls to a particular set of coordinates
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/scrollTo
pub fn Window::scroll_to(self : Self, x : Int, y : Int) -> Unit {
  ignore(self.to_js().invoke("scrollTo", [x, y]))
}

///|
/// Scrolls by a particular amount
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/scrollBy
pub fn Window::scroll_by(self : Self, x : Int, y : Int) -> Unit {
  ignore(self.to_js().invoke("scrollBy", [x, y]))
}

///|
/// Returns the horizontal scroll position
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/scrollX
pub fn Window::scroll_x(self : Self) -> Double {
  self.to_js().get("scrollX").cast()
}

///|
/// Returns the vertical scroll position
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/scrollY
pub fn Window::scroll_y(self : Self) -> Double {
  self.to_js().get("scrollY").cast()
}

///|
/// Calls a function after a specified delay
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/setTimeout
pub fn Window::set_timeout(
  self : Self,
  handler : () -> Unit,
  delay : Int,
) -> Int {
  self.to_js().invoke("setTimeout", [@js.js(handler), delay]).cast()
}

///|
/// Cancels a timeout previously established by setTimeout
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/clearTimeout
pub fn Window::clear_timeout(self : Self, id : Int) -> Unit {
  ignore(self.to_js().invoke("clearTimeout", [id]))
}

///|
/// Repeatedly calls a function with a fixed time delay between each call
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/setInterval
pub fn Window::set_interval(
  self : Self,
  handler : () -> Unit,
  delay : Int,
) -> Int {
  self.to_js().invoke("setInterval", [@js.js(handler), delay]).cast()
}

///|
/// Cancels a timed, repeating action established by setInterval
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/clearInterval
pub fn Window::clear_interval(self : Self, id : Int) -> Unit {
  ignore(self.to_js().invoke("clearInterval", [id]))
}

///|
/// Requests the browser to call a function to update an animation
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/requestAnimationFrame
pub fn Window::request_animation_frame(
  self : Self,
  callback : (Double) -> Unit,
) -> Int {
  self.to_js().invoke("requestAnimationFrame", [@js.js(callback)]).cast()
}

///|
/// Cancels an animation frame request
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/cancelAnimationFrame
pub fn Window::cancel_animation_frame(self : Self, id : Int) -> Unit {
  ignore(self.to_js().invoke("cancelAnimationFrame", [id]))
}

///|
/// Starts the process of fetching a resource from the network
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/fetch
pub fn Window::fetch(self : Self, input : String, init? : Val) -> Promise[Val] {
  match init {
    Some(i) => self.to_js().invoke("fetch", [input, i]).cast()
    None => self.to_js().invoke("fetch", [input]).cast()
  }
}

///|
/// Returns a selection object representing selected text
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/getSelection
pub fn Window::get_selection(self : Self) -> Val? {
  self.to_js().invoke("getSelection", []).cast_option()
}

///|
/// Returns computed style of an element
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/getComputedStyle
pub fn Window::get_computed_style(
  self : Self,
  element : Element,
  pseudo_elt? : String,
) -> Val {
  match pseudo_elt {
    Some(p) =>
      self.to_js().invoke("getComputedStyle", [element.to_js(), p]).cast()
    None =>
      self.to_js().invoke("getComputedStyle", [element.to_js()]).cast()
  }
}

///|
/// Returns a media query list
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/matchMedia
pub fn Window::match_media(self : Self, query : String) -> Val {
  self.to_js().invoke("matchMedia", [query]).cast()
}

///|
/// Posts a message to the window
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/postMessage
pub fn Window::post_message(
  self : Self,
  message : Val,
  target_origin : String,
) -> Unit {
  ignore(self.to_js().invoke("postMessage", [message, target_origin]))
}

///|
/// Posts a message to the window with transfer
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/postMessage
pub fn[T : Transferable] Window::post_message_with_transfer(
  self : Self,
  message : Val,
  target_origin : String,
  transfer : Array[T],
) -> Unit {
  let transfer_vals = transfer.map(fn(t) { t.to_transferable() })
  ignore(
    self
    .to_js()
    .invoke("postMessage", [message, target_origin, @js.js(transfer_vals)]),
  )
}
