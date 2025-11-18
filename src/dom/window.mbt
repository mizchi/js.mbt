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
pub impl EventTarget for Window

///|
/// Returns the global window object
pub extern "js" fn window() -> Window =
  #| () => window

///|
/// Returns the document contained in the window
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/document
pub fn Window::document(self : Self) -> Document {
  unsafe_cast(self.get("document"))
}

///|
/// Returns the navigator object
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/navigator
pub fn Window::navigator(self : Self) -> Val {
  unsafe_cast(self.get("navigator"))
}

///|
/// Returns the location object
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/location
pub fn Window::location(self : Self) -> Val {
  unsafe_cast(self.get("location"))
}

///|
/// Returns the localStorage object
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/localStorage
#alias(local_storage)
pub fn Window::localStorage(self : Self) -> Val {
  unsafe_cast(self.get("localStorage"))
}

///|
/// Returns the sessionStorage object
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/sessionStorage
#alias(session_storage)
pub fn Window::sessionStorage(self : Self) -> Val {
  unsafe_cast(self.get("sessionStorage"))
}

///|
/// Returns the console object
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/console
pub fn Window::console(self : Self) -> Val {
  unsafe_cast(self.get("console"))
}

///|
/// Returns the history object
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/history
pub fn Window::history(self : Self) -> Val {
  unsafe_cast(self.get("history"))
}

///|
/// Returns the inner width of the window
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/innerWidth
#alias(inner_width)
pub fn Window::innerWidth(self : Self) -> Int {
  unsafe_cast(self.get("innerWidth"))
}

///|
/// Returns the inner height of the window
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/innerHeight
#alias(inner_height)
pub fn Window::innerHeight(self : Self) -> Int {
  unsafe_cast(self.get("innerHeight"))
}

///|
/// Returns the outer width of the window
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/outerWidth
#alias(outer_width)
pub fn Window::outerWidth(self : Self) -> Int {
  unsafe_cast(self.get("outerWidth"))
}

///|
/// Returns the outer height of the window
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/outerHeight
#alias(outer_height)
pub fn Window::outerHeight(self : Self) -> Int {
  unsafe_cast(self.get("outerHeight"))
}

///|
/// Returns the screen object
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/screen
pub fn Window::screen(self : Self) -> Val {
  unsafe_cast(self.get("screen"))
}

///|
/// Returns the device pixel ratio
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/devicePixelRatio
#alias(device_pixel_ratio)
pub fn Window::devicePixelRatio(self : Self) -> Double {
  unsafe_cast(self.get("devicePixelRatio"))
}

///|
/// Displays an alert dialog
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/alert
pub fn Window::alert(self : Self, message : String) -> Unit {
  ignore(self.invoke("alert", [message]))
}

///|
/// Displays a confirm dialog
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/confirm
pub fn Window::confirm(self : Self, message : String) -> Bool {
  self.invoke("confirm", [message]) |> unsafe_cast
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
    Some(d) => self.invoke("prompt", [message, d]) |> to_option()
    None => self.invoke("prompt", [message]) |> to_option()
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
    (Some(u), Some(t), Some(f)) => self.invoke("open", [u, t, f]) |> to_option
    (Some(u), Some(t), None) => self.invoke("open", [u, t]) |> to_option
    (Some(u), None, _) => self.invoke("open", [u]) |> to_option
    (None, _, _) => self.invoke("open", []) |> to_option
  }
}

///|
/// Closes the window
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/close
pub fn Window::close(self : Self) -> Unit {
  ignore(self.invoke("close", []))
}

///|
/// Scrolls to a particular set of coordinates
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/scrollTo
#alias(scroll_to)
pub fn Window::scrollTo(self : Self, x : Int, y : Int) -> Unit {
  ignore(self.invoke("scrollTo", [x, y]))
}

///|
/// Scrolls by a particular amount
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/scrollBy
#alias(scroll_by)
pub fn Window::scrollBy(self : Self, x : Int, y : Int) -> Unit {
  ignore(self.invoke("scrollBy", [x, y]))
}

///|
/// Returns the horizontal scroll position
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/scrollX
#alias(scroll_x)
pub fn Window::scrollX(self : Self) -> Double {
  unsafe_cast(self.get("scrollX"))
}

///|
/// Returns the vertical scroll position
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/scrollY
#alias(scroll_y)
pub fn Window::scrollY(self : Self) -> Double {
  unsafe_cast(self.get("scrollY"))
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
  self.invoke("setTimeout", [@js.js(handler), delay]) |> unsafe_cast
}

///|
/// Cancels a timeout previously established by setTimeout
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/clearTimeout
#alias(clear_timeout)
pub fn Window::clearTimeout(self : Self, id : Int) -> Unit {
  ignore(self.invoke("clearTimeout", [id]))
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
  self.invoke("setInterval", [@js.js(handler), delay]) |> unsafe_cast
}

///|
/// Cancels a timed, repeating action established by setInterval
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/clearInterval
#alias(clear_interval)
pub fn Window::clearInterval(self : Self, id : Int) -> Unit {
  ignore(self.invoke("clearInterval", [id]))
}

///|
/// Requests the browser to call a function to update an animation
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/requestAnimationFrame
#alias(request_animation_frame)
pub fn Window::requestAnimationFrame(
  self : Self,
  callback : (Double) -> Unit,
) -> Int {
  self.invoke("requestAnimationFrame", [@js.js(callback)]) |> unsafe_cast
}

///|
/// Cancels an animation frame request
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/cancelAnimationFrame
#alias(cancel_animation_frame)
pub fn Window::cancelAnimationFrame(self : Self, id : Int) -> Unit {
  ignore(self.invoke("cancelAnimationFrame", [id]))
}

///|
/// Starts the process of fetching a resource from the network
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/fetch
pub fn Window::fetch(self : Self, input : String, init? : Val) -> Promise[Val] {
  match init {
    Some(i) => self.invoke("fetch", [input, i]) |> unsafe_cast
    None => self.invoke("fetch", [input]) |> unsafe_cast
  }
}

///|
/// Returns a selection object representing selected text
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/getSelection
#alias(get_selection)
pub fn Window::getSelection(self : Self) -> Val? {
  self.invoke("getSelection", []) |> to_option
}

///|
/// Returns computed style of an element
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/getComputedStyle
#alias(get_computed_style)
pub fn Window::getComputedStyle(
  self : Self,
  element : Element,
  pseudo_elt? : String,
) -> Val {
  match pseudo_elt {
    Some(p) =>
      self.invoke("getComputedStyle", [element.to_js(), p]) |> unsafe_cast
    None => self.invoke("getComputedStyle", [element.to_js()]) |> unsafe_cast
  }
}

///|
/// Returns a media query list
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/matchMedia
#alias(match_media)
pub fn Window::matchMedia(self : Self, query : String) -> Val {
  self.invoke("matchMedia", [query]) |> unsafe_cast
}

///|
/// Posts a message to the window
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/postMessage
#alias(post_message)
pub fn Window::postMessage(
  self : Self,
  message : Val,
  target_origin : String,
) -> Unit {
  ignore(self.invoke("postMessage", [message, target_origin]))
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
