///|
/// NavigationHistoryEntry represents a single navigation history entry.
/// https://developer.mozilla.org/en-US/docs/Web/API/NavigationHistoryEntry
#external
pub type NavigationHistoryEntry

///|
pub fn NavigationHistoryEntry::as_any(
  self : NavigationHistoryEntry,
) -> @core.Any = "%identity"

///|
fn NavigationHistoryEntry::as_event_target(
  self : NavigationHistoryEntry,
) -> @event.EventTarget = "%identity"

///|
/// Returns the unique identifier of the history entry.
pub fn NavigationHistoryEntry::id(self : NavigationHistoryEntry) -> String {
  self.as_any()._get("id").cast()
}

///|
/// Returns the index of the history entry in the entries list.
pub fn NavigationHistoryEntry::index(self : NavigationHistoryEntry) -> Int {
  self.as_any()._get("index").cast()
}

///|
/// Returns the unique key of the history entry.
pub fn NavigationHistoryEntry::key(self : NavigationHistoryEntry) -> String {
  self.as_any()._get("key").cast()
}

///|
/// Returns whether the entry is for the same document.
#alias(same_document)
pub fn NavigationHistoryEntry::sameDocument(
  self : NavigationHistoryEntry,
) -> Bool {
  self.as_any()._get("sameDocument").cast()
}

///|
/// Returns the absolute URL of the history entry.
pub fn NavigationHistoryEntry::url(self : NavigationHistoryEntry) -> String? {
  let v = self.as_any()._get("url")
  if @core.is_null(v) {
    None
  } else {
    Some(v.cast())
  }
}

///|
/// Returns a clone of the state associated with the history entry.
#alias(get_state)
pub fn NavigationHistoryEntry::getState(
  self : NavigationHistoryEntry,
) -> @core.Any {
  self.as_any()._call("getState", [])
}

///|
/// Adds an event listener for the dispose event.
#alias(on_dispose)
pub fn NavigationHistoryEntry::onDispose(
  self : NavigationHistoryEntry,
  handler : (@core.Any) -> Unit,
) -> Unit {
  self.as_event_target().addEventListener("dispose", handler)
}

///|
/// NavigationDestination represents the destination of a navigation.
/// https://developer.mozilla.org/en-US/docs/Web/API/NavigationDestination
#external
pub type NavigationDestination

///|
pub fn NavigationDestination::as_any(self : NavigationDestination) -> @core.Any = "%identity"

///|
/// Returns the id of the destination history entry (for traverse navigations).
pub fn NavigationDestination::id(self : NavigationDestination) -> String {
  self.as_any()._get("id").cast()
}

///|
/// Returns the index of the destination history entry (for traverse navigations).
pub fn NavigationDestination::index(self : NavigationDestination) -> Int {
  self.as_any()._get("index").cast()
}

///|
/// Returns the key of the destination history entry (for traverse navigations).
pub fn NavigationDestination::key(self : NavigationDestination) -> String {
  self.as_any()._get("key").cast()
}

///|
/// Returns whether the navigation is to the same document.
#alias(same_document)
pub fn NavigationDestination::sameDocument(
  self : NavigationDestination,
) -> Bool {
  self.as_any()._get("sameDocument").cast()
}

///|
/// Returns the URL being navigated to.
pub fn NavigationDestination::url(self : NavigationDestination) -> String {
  self.as_any()._get("url").cast()
}

///|
/// Returns a clone of the state associated with the destination.
#alias(get_state)
pub fn NavigationDestination::getState(
  self : NavigationDestination,
) -> @core.Any {
  self.as_any()._call("getState", [])
}

///|
/// NavigationTransition represents an ongoing navigation.
/// https://developer.mozilla.org/en-US/docs/Web/API/NavigationTransition
#external
pub type NavigationTransition

///|
pub fn NavigationTransition::as_any(self : NavigationTransition) -> @core.Any = "%identity"

///|
/// Returns the history entry being navigated from.
pub fn NavigationTransition::from(
  self : NavigationTransition,
) -> NavigationHistoryEntry {
  self.as_any()._get("from").cast()
}

///|
/// Returns the type of navigation.
#alias(navigation_type)
pub fn NavigationTransition::navigationType(
  self : NavigationTransition,
) -> String {
  self.as_any()._get("navigationType").cast()
}

///|
/// Returns a promise that fulfills when the navigation succeeds or rejects when it fails.
pub fn NavigationTransition::finished(
  self : NavigationTransition,
) -> @js.Promise[NavigationHistoryEntry] {
  self.as_any()._get("finished").cast()
}

///|
/// NavigationActivation represents information about the most recent cross-document navigation.
/// https://developer.mozilla.org/en-US/docs/Web/API/NavigationActivation
#external
pub type NavigationActivation

///|
pub fn NavigationActivation::as_any(self : NavigationActivation) -> @core.Any = "%identity"

///|
/// Returns the history entry of the "to" document.
pub fn NavigationActivation::entry(
  self : NavigationActivation,
) -> NavigationHistoryEntry {
  self.as_any()._get("entry").cast()
}

///|
/// Returns the history entry of the "from" document.
pub fn NavigationActivation::from(
  self : NavigationActivation,
) -> NavigationHistoryEntry? {
  let v = self.as_any()._get("from")
  if @core.is_null(v) {
    None
  } else {
    Some(v.cast())
  }
}

///|
/// Returns the type of navigation.
#alias(navigation_type)
pub fn NavigationActivation::navigationType(
  self : NavigationActivation,
) -> String {
  self.as_any()._get("navigationType").cast()
}

///|
/// NavigationResult represents the result of a navigation operation.
/// Contains committed and finished promises.
#external
pub type NavigationResult

///|
pub fn NavigationResult::as_any(self : NavigationResult) -> @core.Any = "%identity"

///|
/// Returns a promise that fulfills when the visible URL changes and a new entry is created.
pub fn NavigationResult::committed(
  self : NavigationResult,
) -> @js.Promise[NavigationHistoryEntry] {
  self.as_any()._get("committed").cast()
}

///|
/// Returns a promise that fulfills when all promises passed to intercept() have fulfilled.
pub fn NavigationResult::finished(
  self : NavigationResult,
) -> @js.Promise[NavigationHistoryEntry] {
  self.as_any()._get("finished").cast()
}

///|
/// Navigation represents all navigation actions for the current window.
/// https://developer.mozilla.org/en-US/docs/Web/API/Navigation
#external
pub type Navigation

///|
pub fn Navigation::as_any(self : Navigation) -> @core.Any = "%identity"

///|
fn Navigation::as_event_target(self : Navigation) -> @event.EventTarget = "%identity"

///|
/// Returns the global navigation object.
pub extern "js" fn navigation() -> Navigation =
  #| () => navigation

///|
/// Returns the current navigation entry.
#alias(current_entry)
pub fn Navigation::currentEntry(self : Navigation) -> NavigationHistoryEntry? {
  let v = self.as_any()._get("currentEntry")
  if @core.is_null(v) || @core.is_undefined(v) {
    None
  } else {
    Some(v.cast())
  }
}

///|
/// Returns whether it's possible to navigate backward.
#alias(can_go_back)
pub fn Navigation::canGoBack(self : Navigation) -> Bool {
  self.as_any()._get("canGoBack").cast()
}

///|
/// Returns whether it's possible to navigate forward.
#alias(can_go_forward)
pub fn Navigation::canGoForward(self : Navigation) -> Bool {
  self.as_any()._get("canGoForward").cast()
}

///|
/// Returns the ongoing navigation transition, or null if none.
pub fn Navigation::transition(self : Navigation) -> NavigationTransition? {
  let v = self.as_any()._get("transition")
  if @core.is_null(v) {
    None
  } else {
    Some(v.cast())
  }
}

///|
/// Returns information about the most recent cross-document navigation.
pub fn Navigation::activation(self : Navigation) -> NavigationActivation? {
  let v = self.as_any()._get("activation")
  if @core.is_null(v) {
    None
  } else {
    Some(v.cast())
  }
}

///|
/// Returns an array of all history entries.
pub fn Navigation::entries(self : Navigation) -> Array[NavigationHistoryEntry] {
  let arr = self.as_any()._call("entries", [])
  let len : Int = arr._get("length").cast()
  let result : Array[NavigationHistoryEntry] = []
  for i = 0; i < len; i = i + 1 {
    result.push(arr._get_by_index(i).cast())
  }
  result
}

///|
/// Navigates to a new URL.
pub fn Navigation::navigate(
  self : Navigation,
  url : String,
  state? : @core.Any,
  info? : @core.Any,
  history? : String,
) -> NavigationResult {
  let opts = @core.new_object()
  match state {
    Some(s) => opts._set("state", s)
    None => ()
  }
  match info {
    Some(i) => opts._set("info", i)
    None => ()
  }
  match history {
    Some(h) => opts._set("history", @core.any(h))
    None => ()
  }
  self.as_any()._call("navigate", [@core.any(url), opts]).cast()
}

///|
/// Reloads the current entry.
pub fn Navigation::reload(
  self : Navigation,
  state? : @core.Any,
  info? : @core.Any,
) -> NavigationResult {
  let opts = @core.new_object()
  match state {
    Some(s) => opts._set("state", s)
    None => ()
  }
  match info {
    Some(i) => opts._set("info", i)
    None => ()
  }
  self.as_any()._call("reload", [opts]).cast()
}

///|
/// Navigates backward in the history.
pub fn Navigation::back(
  self : Navigation,
  info? : @core.Any,
) -> NavigationResult {
  match info {
    Some(i) => {
      let opts = @core.new_object()
      opts._set("info", i)
      self.as_any()._call("back", [opts]).cast()
    }
    None => self.as_any()._call("back", []).cast()
  }
}

///|
/// Navigates forward in the history.
pub fn Navigation::forward(
  self : Navigation,
  info? : @core.Any,
) -> NavigationResult {
  match info {
    Some(i) => {
      let opts = @core.new_object()
      opts._set("info", i)
      self.as_any()._call("forward", [opts]).cast()
    }
    None => self.as_any()._call("forward", []).cast()
  }
}

///|
/// Navigates to a specific history entry by key.
#alias(traverse_to)
pub fn Navigation::traverseTo(
  self : Navigation,
  key : String,
  info? : @core.Any,
) -> NavigationResult {
  match info {
    Some(i) => {
      let opts = @core.new_object()
      opts._set("info", i)
      self.as_any()._call("traverseTo", [@core.any(key), opts]).cast()
    }
    None => self.as_any()._call("traverseTo", [@core.any(key)]).cast()
  }
}

///|
/// Updates the state of the current entry without navigation.
#alias(update_current_entry)
pub fn Navigation::updateCurrentEntry(
  self : Navigation,
  state : @core.Any,
) -> Unit {
  let opts = @core.new_object()
  opts._set("state", state)
  self.as_any()._call("updateCurrentEntry", [opts]) |> ignore
}

///|
/// Adds an event listener for the navigate event.
#alias(on_navigate)
pub fn Navigation::onNavigate(
  self : Navigation,
  handler : (NavigateEvent) -> Unit,
) -> Unit {
  self
  .as_event_target()
  .addEventListener("navigate", fn(e) { handler(e.cast()) })
}

///|
/// Adds an event listener for the navigatesuccess event.
#alias(on_navigate_success)
pub fn Navigation::onNavigateSuccess(
  self : Navigation,
  handler : (@core.Any) -> Unit,
) -> Unit {
  self.as_event_target().addEventListener("navigatesuccess", handler)
}

///|
/// Adds an event listener for the navigateerror event.
#alias(on_navigate_error)
pub fn Navigation::onNavigateError(
  self : Navigation,
  handler : (@core.Any) -> Unit,
) -> Unit {
  self.as_event_target().addEventListener("navigateerror", handler)
}

///|
/// Adds an event listener for the currententrychange event.
#alias(on_current_entry_change)
pub fn Navigation::onCurrentEntryChange(
  self : Navigation,
  handler : (NavigationCurrentEntryChangeEvent) -> Unit,
) -> Unit {
  self
  .as_event_target()
  .addEventListener("currententrychange", fn(e) { handler(e.cast()) })
}
