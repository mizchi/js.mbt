///|
/// NavigateEvent represents the event object for the navigate event.
/// https://developer.mozilla.org/en-US/docs/Web/API/NavigateEvent
#external
pub type NavigateEvent

///|
pub fn NavigateEvent::as_any(self : NavigateEvent) -> @core.Any = "%identity"

///|
/// Returns whether the navigation can be intercepted.
#alias(can_intercept)
pub fn NavigateEvent::canIntercept(self : NavigateEvent) -> Bool {
  self.as_any()._get("canIntercept").cast()
}

///|
/// Returns the destination of the navigation.
pub fn NavigateEvent::destination(
  self : NavigateEvent,
) -> NavigationDestination {
  self.as_any()._get("destination").cast()
}

///|
/// Returns the filename if this is a download navigation, otherwise null.
#alias(download_request)
pub fn NavigateEvent::downloadRequest(self : NavigateEvent) -> String? {
  let v = self.as_any()._get("downloadRequest")
  if @core.is_null(v) {
    None
  } else {
    Some(v.cast())
  }
}

///|
/// Returns the FormData for POST form submissions, otherwise null.
#alias(form_data)
pub fn NavigateEvent::formData(self : NavigateEvent) -> @core.Any? {
  let v = self.as_any()._get("formData")
  if @core.is_null(v) {
    None
  } else {
    Some(v)
  }
}

///|
/// Returns whether this is a hash change navigation.
#alias(hash_change)
pub fn NavigateEvent::hashChange(self : NavigateEvent) -> Bool {
  self.as_any()._get("hashChange").cast()
}

///|
/// Returns whether the user agent performed a visual transition.
#alias(has_ua_visual_transition)
pub fn NavigateEvent::hasUAVisualTransition(self : NavigateEvent) -> Bool {
  self.as_any()._get("hasUAVisualTransition").cast()
}

///|
/// Returns the info data passed to the navigation operation.
pub fn NavigateEvent::info(self : NavigateEvent) -> @core.Any {
  self.as_any()._get("info")
}

///|
/// Returns the type of navigation: push, reload, replace, or traverse.
#alias(navigation_type)
pub fn NavigateEvent::navigationType(self : NavigateEvent) -> String {
  self.as_any()._get("navigationType").cast()
}

///|
/// Returns the AbortSignal that will be aborted if the navigation is canceled.
pub fn NavigateEvent::signal(self : NavigateEvent) -> @core.Any {
  self.as_any()._get("signal")
}

///|
/// Returns the element that initiated the navigation, if any.
#alias(source_element)
pub fn NavigateEvent::sourceElement(self : NavigateEvent) -> @core.Any? {
  let v = self.as_any()._get("sourceElement")
  if @core.is_null(v) {
    None
  } else {
    Some(v)
  }
}

///|
/// Returns whether the navigation was initiated by the user.
#alias(user_initiated)
pub fn NavigateEvent::userInitiated(self : NavigateEvent) -> Bool {
  self.as_any()._get("userInitiated").cast()
}

///|
/// Intercepts the navigation and turns it into a same-document navigation.
pub fn NavigateEvent::intercept(
  self : NavigateEvent,
  handler? : () -> @core.Any,
  focus_reset? : String,
  scroll? : String,
) -> Unit {
  let opts = @core.new_object()
  match handler {
    Some(h) => opts._set("handler", @core.any(h))
    None => ()
  }
  match focus_reset {
    Some(fr) => opts._set("focusReset", @core.any(fr))
    None => ()
  }
  match scroll {
    Some(s) => opts._set("scroll", @core.any(s))
    None => ()
  }
  self.as_any()._call("intercept", [opts]) |> ignore
}

///|
/// Intercepts the navigation with an async handler.
#alias(intercept_async)
pub fn NavigateEvent::interceptAsync(
  self : NavigateEvent,
  handler : () -> @js.Promise[@core.Any],
  focus_reset? : String,
  scroll? : String,
) -> Unit {
  let opts = @core.new_object()
  opts._set("handler", @core.any(handler))
  match focus_reset {
    Some(fr) => opts._set("focusReset", @core.any(fr))
    None => ()
  }
  match scroll {
    Some(s) => opts._set("scroll", @core.any(s))
    None => ()
  }
  self.as_any()._call("intercept", [opts]) |> ignore
}

///|
/// Manually triggers browser-driven scroll behavior.
pub fn NavigateEvent::scroll(self : NavigateEvent) -> Unit {
  self.as_any()._call("scroll", []) |> ignore
}

///|
/// Prevents the default browser navigation behavior.
#alias(prevent_default)
pub fn NavigateEvent::preventDefault(self : NavigateEvent) -> Unit {
  self.as_any()._call("preventDefault", []) |> ignore
}

///|
/// NavigationCurrentEntryChangeEvent represents the event for currententrychange.
/// https://developer.mozilla.org/en-US/docs/Web/API/NavigationCurrentEntryChangeEvent
#external
pub type NavigationCurrentEntryChangeEvent

///|
pub fn NavigationCurrentEntryChangeEvent::as_any(
  self : NavigationCurrentEntryChangeEvent,
) -> @core.Any = "%identity"

///|
/// Returns the history entry that was navigated from.
pub fn NavigationCurrentEntryChangeEvent::from(
  self : NavigationCurrentEntryChangeEvent,
) -> NavigationHistoryEntry? {
  let v = self.as_any()._get("from")
  if @core.is_null(v) {
    None
  } else {
    Some(v.cast())
  }
}

///|
/// Returns the type of navigation that caused the change.
#alias(navigation_type)
pub fn NavigationCurrentEntryChangeEvent::navigationType(
  self : NavigationCurrentEntryChangeEvent,
) -> String? {
  let v = self.as_any()._get("navigationType")
  if @core.is_null(v) {
    None
  } else {
    Some(v.cast())
  }
}
