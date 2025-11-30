///| Ink Hooks
/// React hooks for Ink CLI applications

// ============================================================
// useApp Hook
// ============================================================

///|
/// App context returned by useApp hook
pub(all) struct UseAppResult {
  exit_fn : @nostd.Any
}

///|
/// Exit the app with optional error
pub fn UseAppResult::exit(self : UseAppResult, error? : @nostd.Any) -> Unit {
  match error {
    Some(e) => self.exit_fn._invoke([e]) |> ignore
    None => self.exit_fn._invoke([]) |> ignore
  }
}

///|
/// useApp hook - provides exit functionality
pub fn Ink::useApp(self : Ink) -> UseAppResult {
  let use_app = self.as_any()["useApp"]
  let result = use_app._invoke([])
  let exit_fn = result["exit"]
  { exit_fn, }
}

// ============================================================
// useInput Hook
// ============================================================

///|
/// Key information for input handler
pub(all) struct KeyInfo {
  /// Up arrow key
  up_arrow : Bool
  /// Down arrow key
  down_arrow : Bool
  /// Left arrow key
  left_arrow : Bool
  /// Right arrow key
  right_arrow : Bool
  /// Page down key
  page_down : Bool
  /// Page up key
  page_up : Bool
  /// Return/Enter key
  return_ : Bool
  /// Escape key
  escape : Bool
  /// Ctrl key modifier
  ctrl : Bool
  /// Shift key modifier
  shift : Bool
  /// Tab key
  tab : Bool
  /// Backspace key
  backspace : Bool
  /// Delete key
  delete : Bool
  /// Meta key modifier (Cmd on Mac)
  meta : Bool
}

///|
fn KeyInfo::from_any(raw : @nostd.Any) -> KeyInfo {
  {
    up_arrow: raw["upArrow"].cast(),
    down_arrow: raw["downArrow"].cast(),
    left_arrow: raw["leftArrow"].cast(),
    right_arrow: raw["rightArrow"].cast(),
    page_down: raw["pageDown"].cast(),
    page_up: raw["pageUp"].cast(),
    return_: raw["return"].cast(),
    escape: raw["escape"].cast(),
    ctrl: raw["ctrl"].cast(),
    shift: raw["shift"].cast(),
    tab: raw["tab"].cast(),
    backspace: raw["backspace"].cast(),
    delete: raw["delete"].cast(),
    meta: raw["meta"].cast(),
  }
}

///|
/// Input handler options
pub(all) struct UseInputOptions {
  /// Whether to listen for input (default: true)
  is_active : Bool?
}

///|
/// useInput hook - captures keyboard input
/// Handler receives input character and key information
pub fn Ink::useInput(
  self : Ink,
  handler : (String, KeyInfo) -> Unit,
  options? : UseInputOptions,
) -> Unit {
  let use_input = self.as_any()["useInput"]
  let wrapped_handler = ffi_wrap_input_handler(fn(
    input : @nostd.Any,
    key : @nostd.Any,
  ) {
    let input_str : String = input.cast()
    let key_info = KeyInfo::from_any(key)
    handler(input_str, key_info)
  })
  match options {
    Some(opts) => {
      let opts_obj = @nostd.Object::new()
      if opts.is_active is Some(active) {
        opts_obj["isActive"] = @nostd.any(active)
      }
      use_input._invoke([wrapped_handler, opts_obj]) |> ignore
    }
    None => use_input._invoke([wrapped_handler]) |> ignore
  }
}

///|
extern "js" fn ffi_wrap_input_handler(
  f : (@nostd.Any, @nostd.Any) -> Unit,
) -> @nostd.Any =
  #|(f) => f

// ============================================================
// useFocus Hook
// ============================================================

///|
/// Focus result returned by useFocus hook
pub(all) struct UseFocusResult {
  /// Whether the component is focused
  is_focused : Bool
}

///|
/// Focus options
pub(all) struct UseFocusOptions {
  /// Auto focus on mount
  auto_focus : Bool?
  /// Whether to participate in focus navigation
  is_active : Bool?
  /// Focus ID for programmatic focus
  id : String?
}

///|
/// useFocus hook - manages focus state for interactive components
pub fn Ink::useFocus(self : Ink, options? : UseFocusOptions) -> UseFocusResult {
  let use_focus = self.as_any()["useFocus"]
  let result = match options {
    Some(opts) => {
      let opts_obj = @nostd.Object::new()
      if opts.auto_focus is Some(af) {
        opts_obj["autoFocus"] = @nostd.any(af)
      }
      if opts.is_active is Some(active) {
        opts_obj["isActive"] = @nostd.any(active)
      }
      if opts.id is Some(id) {
        opts_obj["id"] = @nostd.any(id)
      }
      use_focus._invoke([opts_obj])
    }
    None => use_focus._invoke([])
  }
  { is_focused: result["isFocused"].cast() }
}

// ============================================================
// useFocusManager Hook
// ============================================================

///|
/// Focus manager for programmatic focus control
pub(all) struct UseFocusManagerResult {
  raw : @nostd.Any
}

///|
/// Enable focus for the focused component
pub fn UseFocusManagerResult::enableFocus(self : UseFocusManagerResult) -> Unit {
  self.raw["enableFocus"]._invoke([]) |> ignore
}

///|
/// Disable focus for all components
pub fn UseFocusManagerResult::disableFocus(
  self : UseFocusManagerResult,
) -> Unit {
  self.raw["disableFocus"]._invoke([]) |> ignore
}

///|
/// Focus next focusable component
pub fn UseFocusManagerResult::focusNext(self : UseFocusManagerResult) -> Unit {
  self.raw["focusNext"]._invoke([]) |> ignore
}

///|
/// Focus previous focusable component
pub fn UseFocusManagerResult::focusPrevious(
  self : UseFocusManagerResult,
) -> Unit {
  self.raw["focusPrevious"]._invoke([]) |> ignore
}

///|
/// Focus a specific component by ID
pub fn UseFocusManagerResult::focus(
  self : UseFocusManagerResult,
  id : String,
) -> Unit {
  self.raw["focus"]._invoke([@nostd.any(id)]) |> ignore
}

///|
/// useFocusManager hook - programmatically manage focus
pub fn Ink::useFocusManager(self : Ink) -> UseFocusManagerResult {
  let use_focus_manager = self.as_any()["useFocusManager"]
  let result = use_focus_manager._invoke([])
  { raw: result }
}

// ============================================================
// useStdin Hook
// ============================================================

///|
/// Stdin result returned by useStdin hook
pub(all) struct UseStdinResult {
  /// Standard input stream
  stdin : @nostd.Any
  /// Whether stdin is in raw mode
  is_raw_mode_supported : Bool
  /// Set raw mode
  set_raw_mode_fn : @nostd.Any
}

///|
/// Set raw mode on stdin
pub fn UseStdinResult::setRawMode(self : UseStdinResult, value : Bool) -> Unit {
  self.set_raw_mode_fn._invoke([@nostd.any(value)]) |> ignore
}

///|
/// useStdin hook - access stdin stream
pub fn Ink::useStdin(self : Ink) -> UseStdinResult {
  let use_stdin = self.as_any()["useStdin"]
  let result = use_stdin._invoke([])
  {
    stdin: result["stdin"],
    is_raw_mode_supported: result["isRawModeSupported"].cast(),
    set_raw_mode_fn: result["setRawMode"],
  }
}

// ============================================================
// useStdout Hook
// ============================================================

///|
/// Stdout result returned by useStdout hook
pub(all) struct UseStdoutResult {
  /// Standard output stream
  stdout : @nostd.Any
  /// Write to stdout
  write_fn : @nostd.Any
}

///|
/// Write to stdout
pub fn UseStdoutResult::write(self : UseStdoutResult, data : String) -> Unit {
  self.write_fn._invoke([@nostd.any(data)]) |> ignore
}

///|
/// useStdout hook - access stdout stream
pub fn Ink::useStdout(self : Ink) -> UseStdoutResult {
  let use_stdout = self.as_any()["useStdout"]
  let result = use_stdout._invoke([])
  { stdout: result["stdout"], write_fn: result["write"] }
}

// ============================================================
// useStderr Hook
// ============================================================

///|
/// Stderr result returned by useStderr hook
pub(all) struct UseStderrResult {
  /// Standard error stream
  stderr : @nostd.Any
  /// Write to stderr
  write_fn : @nostd.Any
}

///|
/// Write to stderr
pub fn UseStderrResult::write(self : UseStderrResult, data : String) -> Unit {
  self.write_fn._invoke([@nostd.any(data)]) |> ignore
}

///|
/// useStderr hook - access stderr stream
pub fn Ink::useStderr(self : Ink) -> UseStderrResult {
  let use_stderr = self.as_any()["useStderr"]
  let result = use_stderr._invoke([])
  { stderr: result["stderr"], write_fn: result["write"] }
}
