///|
/// JavaScript: AbortController
#external
pub type AbortController

///|
pub impl Js for AbortController

///|
/// JS: new AbortController()
pub extern "js" fn AbortController::new() -> AbortController =
  #| () => new AbortController()

///|
/// JS: abortController.abort()
pub fn AbortController::abort(self : Self) -> AbortController {
  self.invoke("abort", []) |> unsafe_cast
}

///|
#external
pub type AbortSignal

///|
pub impl Js for AbortSignal

///|
pub fn AbortController::signal(self : Self) -> AbortSignal {
  self.get("signal") |> unsafe_cast
}
