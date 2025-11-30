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
pub fn InkTestingLibrary::as_any(self : InkTestingLibrary) -> @nostd.Any = "%identity"

///|
/// Dynamic import for ink-testing-library module (internal)
/// NOTE: This uses dynamic import which doesn't support tree-shaking.
/// When MoonBit adds native ESM support, this should be replaced with static imports.
extern "js" fn import_ink_testing_library_internal() -> @nostd.Promise[
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
pub fn RenderResult::as_any(self : RenderResult) -> @nostd.Any = "%identity"

///|
/// JS: InkTestingLibrary.render(element)
/// Returns: RenderResult with lastFrame, frames, rerender, unmount, stdin, stdout, stderr
pub fn InkTestingLibrary::render(
  self : InkTestingLibrary,
  element : @react.Element,
) -> RenderResult {
  self.as_any()["render"]._invoke([element.as_any()]).cast()
}

///|
/// JS: result.lastFrame()
/// Returns the last rendered frame as a string, or None if nothing was rendered
pub fn RenderResult::lastFrame(self : RenderResult) -> String? {
  let result = self.as_any()["lastFrame"]._invoke([])
  if @nostd.is_undefined(result) || @nostd.is_null(result) {
    None
  } else {
    Some(result.cast())
  }
}

///|
/// JS: result.frames
/// Returns all rendered frames as an array
pub fn RenderResult::frames(self : RenderResult) -> Array[String] {
  let frames_arr = self.as_any()["frames"]
  let len : Int = frames_arr["length"].cast()
  let result : Array[String] = []
  for i = 0; i < len; i = i + 1 {
    let frame : String = frames_arr[i.to_string()].cast()
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
  self.as_any()["rerender"]._invoke([element.as_any()]) |> ignore
}

///|
/// JS: result.unmount()
/// Unmount the rendered component
pub fn RenderResult::unmount(self : RenderResult) -> Unit {
  self.as_any()["unmount"]._invoke([]) |> ignore
}

// ============================================================
// Stdin
// ============================================================

///|
/// Stdin object from RenderResult
#external
pub type Stdin

///|
pub fn Stdin::as_any(self : Stdin) -> @nostd.Any = "%identity"

///|
/// JS: result.stdin
/// Get the stdin object for simulating input
pub fn RenderResult::stdin(self : RenderResult) -> Stdin {
  self.as_any()["stdin"].cast()
}

///|
/// JS: stdin.write(data)
/// Write data to stdin to simulate user input
pub fn Stdin::write(self : Stdin, data : String) -> Unit {
  self.as_any()["write"]._invoke([@nostd.any(data)]) |> ignore
}

// ============================================================
// Stdout
// ============================================================

///|
/// Stdout object from RenderResult
#external
pub type Stdout

///|
pub fn Stdout::as_any(self : Stdout) -> @nostd.Any = "%identity"

///|
/// JS: result.stdout
/// Get the stdout object
pub fn RenderResult::stdout(self : RenderResult) -> Stdout {
  self.as_any()["stdout"].cast()
}

///|
/// JS: stdout.lastFrame()
/// Returns the last frame written to stdout
pub fn Stdout::lastFrame(self : Stdout) -> String? {
  let result = self.as_any()["lastFrame"]._invoke([])
  if @nostd.is_undefined(result) || @nostd.is_null(result) {
    None
  } else {
    Some(result.cast())
  }
}

///|
/// JS: stdout.frames
/// Returns all frames written to stdout
pub fn Stdout::frames(self : Stdout) -> Array[String] {
  let frames_arr = self.as_any()["frames"]
  let len : Int = frames_arr["length"].cast()
  let result : Array[String] = []
  for i = 0; i < len; i = i + 1 {
    let frame : String = frames_arr[i.to_string()].cast()
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
pub fn Stderr::as_any(self : Stderr) -> @nostd.Any = "%identity"

///|
/// JS: result.stderr
/// Get the stderr object
pub fn RenderResult::stderr(self : RenderResult) -> Stderr {
  self.as_any()["stderr"].cast()
}

///|
/// JS: stderr.lastFrame()
/// Returns the last frame written to stderr
pub fn Stderr::lastFrame(self : Stderr) -> String? {
  let result = self.as_any()["lastFrame"]._invoke([])
  if @nostd.is_undefined(result) || @nostd.is_null(result) {
    None
  } else {
    Some(result.cast())
  }
}

///|
/// JS: stderr.frames
/// Returns all frames written to stderr
pub fn Stderr::frames(self : Stderr) -> Array[String] {
  let frames_arr = self.as_any()["frames"]
  let len : Int = frames_arr["length"].cast()
  let result : Array[String] = []
  for i = 0; i < len; i = i + 1 {
    let frame : String = frames_arr[i.to_string()].cast()
    result.push(frame)
  }
  result
}
