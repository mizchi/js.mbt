///| Ink Testing Library
/// Bindings for https://github.com/vadimdemedes/ink-testing-library

///|
/// Ink Testing Library module handle
#external
pub type InkTestingLibrary

///|
pub fn InkTestingLibrary::as_any(self : InkTestingLibrary) -> @core.Any = "%identity"

///|
/// Dynamic import for ink-testing-library module (internal)
/// NOTE: This uses dynamic import which doesn't support tree-shaking.
/// When MoonBit adds native ESM support, this should be replaced with static imports.
extern "js" fn import_ink_testing_library_internal() -> @core.Promise[
  InkTestingLibrary,
] =
  #| () => import("ink-testing-library")

///|
/// Dynamic import for ink-testing-library module
/// Returns a Promise that resolves to the ink-testing-library module
pub fn dynamic_import_testing_library() -> @core.Promise[InkTestingLibrary] {
  import_ink_testing_library_internal()
}

// ============================================================
// Render Result
// ============================================================

///|
/// Result returned by render function
#external
pub type RenderResult

///|
pub fn RenderResult::as_any(self : RenderResult) -> @core.Any = "%identity"

///|
/// Get the last rendered frame as a string
pub fn RenderResult::lastFrame(self : RenderResult) -> String {
  let result = self.as_any()["lastFrame"]._invoke([])
  result.cast()
}

///|
/// Get all rendered frames
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
/// Rerender the component with a new element
pub fn RenderResult::rerender(
  self : RenderResult,
  element : @react.Element,
) -> Unit {
  self.as_any()["rerender"]._invoke([element.as_any()]) |> ignore
}

///|
/// Unmount the component
pub fn RenderResult::unmount(self : RenderResult) -> Unit {
  self.as_any()["unmount"]._invoke([]) |> ignore
}

///|
/// Get stdin for sending input
pub fn RenderResult::stdin(self : RenderResult) -> StdinMock {
  let stdin = self.as_any()["stdin"]
  { raw: stdin }
}

///|
/// Stdout stream access
pub fn RenderResult::stdout(self : RenderResult) -> StreamOutput {
  let stdout = self.as_any()["stdout"]
  { raw: stdout }
}

///|
/// Stderr stream access
pub fn RenderResult::stderr(self : RenderResult) -> StreamOutput {
  let stderr = self.as_any()["stderr"]
  { raw: stderr }
}

// ============================================================
// Stdin Mock
// ============================================================

///|
/// Mock stdin for sending input to components
pub(all) struct StdinMock {
  raw : @core.Any
}

///|
/// Write data to stdin
pub fn StdinMock::write(self : StdinMock, data : String) -> Unit {
  self.raw["write"]._invoke([@core.any(data)]) |> ignore
}

// ============================================================
// Stream Output
// ============================================================

///|
/// Mock stream output for stdout/stderr
pub(all) struct StreamOutput {
  raw : @core.Any
}

///|
/// Get the last frame from this stream
pub fn StreamOutput::lastFrame(self : StreamOutput) -> String {
  let result = self.raw["lastFrame"]._invoke([])
  result.cast()
}

///|
/// Get all frames from this stream
pub fn StreamOutput::frames(self : StreamOutput) -> Array[String] {
  let frames_arr = self.raw["frames"]
  let len : Int = frames_arr["length"].cast()
  let result : Array[String] = []
  for i = 0; i < len; i = i + 1 {
    let frame : String = frames_arr[i.to_string()].cast()
    result.push(frame)
  }
  result
}

// ============================================================
// Render Function
// ============================================================

///|
/// Render a React element for testing
/// Returns a RenderResult with utilities for assertions and interactions
pub fn InkTestingLibrary::render(
  self : InkTestingLibrary,
  element : @react.Element,
) -> RenderResult {
  let render_fn = self.as_any()["render"]
  render_fn._invoke([element.as_any()]).cast()
}
