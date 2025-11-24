///|
/// History represents the session history
/// https://developer.mozilla.org/en-US/docs/Web/API/History
pub(all) struct History {
  length : Int
  state : @js.Any?
  mut scrollRestoration : String
}

///|
pub impl @js.JsImpl for History

///|
/// Returns the global history object
pub extern "js" fn history() -> History =
  #| () => history

///|
/// Loads the previous URL in the history list
/// https://developer.mozilla.org/en-US/docs/Web/API/History/back
pub fn History::back(self : Self) -> Unit {
  ignore(self.to_js().call0("back"))
}

///|
/// Loads the next URL in the history list
/// https://developer.mozilla.org/en-US/docs/Web/API/History/forward
pub fn History::forward(self : Self) -> Unit {
  ignore(self.to_js().call0("forward"))
}

///|
/// Loads a specific page from the session history
/// https://developer.mozilla.org/en-US/docs/Web/API/History/go
pub fn History::go(self : Self, delta? : Int) -> Unit {
  match delta {
    Some(d) => ignore(self.to_js().call("go", [d]))
    None => ignore(self.to_js().call0("go"))
  }
}

///|
/// Pushes a state onto the history stack
/// https://developer.mozilla.org/en-US/docs/Web/API/History/pushState
#alias(push_state)
pub fn History::pushState(
  self : Self,
  state : @js.Any,
  unused : String,
  url? : String,
) -> Unit {
  match url {
    Some(u) => ignore(self.to_js().call("pushState", [state, unused, u]))
    None => ignore(self.to_js().call2("pushState", state, unused))
  }
}

///|
/// Modifies the current history entry
/// https://developer.mozilla.org/en-US/docs/Web/API/History/replaceState
#alias(replace_state)
pub fn History::replaceState(
  self : Self,
  state : @js.Any,
  unused : String,
  url? : String,
) -> Unit {
  match url {
    Some(u) => ignore(self.to_js().call("replaceState", [state, unused, u]))
    None => ignore(self.to_js().call2("replaceState", state, unused))
  }
}
