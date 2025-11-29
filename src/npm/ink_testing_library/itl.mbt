///| ink-testing-library bindings
/// Bindings for https://github.com/vadimdemedes/ink-testing-library

// ============================================================
// Module Handle
// ============================================================

///|
/// InkTestingLibrary module handle
#external
pub type InkTestingLibrary

///|
pub impl @js.JsImpl for InkTestingLibrary

///|
/// Dynamic import for ink-testing-library module (internal)
/// NOTE: This uses dynamic import which doesn't support tree-shaking.
/// When MoonBit adds native ESM support, this should be replaced with static imports.
extern "js" fn import_ink_testing_library_internal() -> @js.Promise[
  InkTestingLibrary,
] =
  #| () => import("ink-testing-library")

///|
/// Dynamic import for ink-testing-library module
/// NOTE: This uses dynamic import which doesn't support tree-shaking.
/// When MoonBit adds native ESM support, this should be replaced with static imports.
pub async fn dynamic_import() -> InkTestingLibrary {
  import_ink_testing_library_internal().wait()
}

// ============================================================
// RenderResult
// ============================================================

///|
/// RenderResult returned by render()
#external
pub type RenderResult

///|
pub impl @js.JsImpl for RenderResult

///|
/// JS: InkTestingLibrary.render(element)
/// Returns: RenderResult with lastFrame, frames, rerender, unmount, stdin, stdout, stderr
pub fn InkTestingLibrary::render(
  self : InkTestingLibrary,
  element : @react.Element,
) -> RenderResult {
  self.call1("render", element).cast()
}

///|
/// JS: result.lastFrame()
/// Returns the last rendered frame as a string, or None if nothing was rendered
pub fn RenderResult::lastFrame(self : RenderResult) -> String? {
  let result = self.call0("lastFrame")
  if @js.is_undefined(result) || @js.is_null(result) {
    None
  } else {
    Some(result.cast())
  }
}

///|
/// JS: result.frames
/// Returns all rendered frames as an array
pub fn RenderResult::frames(self : RenderResult) -> Array[String] {
  let frames_arr = self.get("frames")
  let len : Int = @js.identity(frames_arr.get("length"))
  let result : Array[String] = []
  for i = 0; i < len; i = i + 1 {
    let frame : String = @js.identity(frames_arr.get(i.to_string()))
    result.push(frame)
  }
  result
}

///|
/// JS: result.rerender(element)
/// Rerender with a new element
pub fn RenderResult::rerender(
  self : RenderResult,
  element : @react.Element,
) -> Unit {
  self.call1("rerender", element) |> ignore
}

///|
/// JS: result.unmount()
/// Unmount the rendered component
pub fn RenderResult::unmount(self : RenderResult) -> Unit {
  self.call0("unmount") |> ignore
}

// ============================================================
// Stdin
// ============================================================

///|
/// Stdin object from RenderResult
#external
pub type Stdin

///|
pub impl @js.JsImpl for Stdin

///|
/// JS: result.stdin
/// Get the stdin object for simulating input
pub fn RenderResult::stdin(self : RenderResult) -> Stdin {
  self.get("stdin").cast()
}

///|
/// JS: stdin.write(data)
/// Write data to stdin to simulate user input
pub fn Stdin::write(self : Stdin, data : String) -> Unit {
  self.call1("write", data) |> ignore
}

// ============================================================
// Stdout
// ============================================================

///|
/// Stdout object from RenderResult
#external
pub type Stdout

///|
pub impl @js.JsImpl for Stdout

///|
/// JS: result.stdout
/// Get the stdout object
pub fn RenderResult::stdout(self : RenderResult) -> Stdout {
  self.get("stdout").cast()
}

///|
/// JS: stdout.lastFrame()
/// Returns the last frame written to stdout
pub fn Stdout::lastFrame(self : Stdout) -> String? {
  let result = self.call0("lastFrame")
  if @js.is_undefined(result) || @js.is_null(result) {
    None
  } else {
    Some(result.cast())
  }
}

///|
/// JS: stdout.frames
/// Returns all frames written to stdout
pub fn Stdout::frames(self : Stdout) -> Array[String] {
  let frames_arr = self.get("frames")
  let len : Int = @js.identity(frames_arr.get("length"))
  let result : Array[String] = []
  for i = 0; i < len; i = i + 1 {
    let frame : String = @js.identity(frames_arr.get(i.to_string()))
    result.push(frame)
  }
  result
}

// ============================================================
// Stderr
// ============================================================

///|
/// Stderr object from RenderResult
#external
pub type Stderr

///|
pub impl @js.JsImpl for Stderr

///|
/// JS: result.stderr
/// Get the stderr object
pub fn RenderResult::stderr(self : RenderResult) -> Stderr {
  self.get("stderr").cast()
}

///|
/// JS: stderr.lastFrame()
/// Returns the last frame written to stderr
pub fn Stderr::lastFrame(self : Stderr) -> String? {
  let result = self.call0("lastFrame")
  if @js.is_undefined(result) || @js.is_null(result) {
    None
  } else {
    Some(result.cast())
  }
}

///|
/// JS: stderr.frames
/// Returns all frames written to stderr
pub fn Stderr::frames(self : Stderr) -> Array[String] {
  let frames_arr = self.get("frames")
  let len : Int = @js.identity(frames_arr.get("length"))
  let result : Array[String] = []
  for i = 0; i < len; i = i + 1 {
    let frame : String = @js.identity(frames_arr.get(i.to_string()))
    result.push(frame)
  }
  result
}
