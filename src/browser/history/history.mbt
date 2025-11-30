///|
/// History represents the session history
/// https://developer.mozilla.org/en-US/docs/Web/API/History
pub(all) struct History {
  length : Int
  state : @nostd.Any?
  mut scrollRestoration : String
}

///|
pub fn History::as_any(self : History) -> @nostd.Any = "%identity"

///|
/// Returns the global history object
pub extern "js" fn history() -> History =
  #| () => history

///|
/// Loads the previous URL in the history list
/// https://developer.mozilla.org/en-US/docs/Web/API/History/back
pub fn History::back(self : History) -> Unit {
  self.as_any()._call("back", []) |> ignore
}

///|
/// Loads the next URL in the history list
/// https://developer.mozilla.org/en-US/docs/Web/API/History/forward
pub fn History::forward(self : History) -> Unit {
  self.as_any()._call("forward", []) |> ignore
}

///|
/// Loads a specific page from the session history
/// https://developer.mozilla.org/en-US/docs/Web/API/History/go
pub fn History::go(self : History, delta? : Int) -> Unit {
  let s = self.as_any()
  match delta {
    Some(d) => s._call("go", [@nostd.any(d)]) |> ignore
    None => s._call("go", []) |> ignore
  }
}

///|
/// Pushes a state onto the history stack
/// https://developer.mozilla.org/en-US/docs/Web/API/History/pushState
#alias(push_state)
pub fn History::pushState(
  self : History,
  state : @nostd.Any,
  unused : String,
  url? : String,
) -> Unit {
  let s = self.as_any()
  match url {
    Some(u) =>
      s._call("pushState", [state, @nostd.any(unused), @nostd.any(u)]) |> ignore
    None => s._call("pushState", [state, @nostd.any(unused)]) |> ignore
  }
}

///|
/// Modifies the current history entry
/// https://developer.mozilla.org/en-US/docs/Web/API/History/replaceState
#alias(replace_state)
pub fn History::replaceState(
  self : History,
  state : @nostd.Any,
  unused : String,
  url? : String,
) -> Unit {
  let s = self.as_any()
  match url {
    Some(u) =>
      s._call("replaceState", [state, @nostd.any(unused), @nostd.any(u)])
      |> ignore
    None => s._call("replaceState", [state, @nostd.any(unused)]) |> ignore
  }
}
