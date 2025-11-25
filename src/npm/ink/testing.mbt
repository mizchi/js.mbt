///| Ink Testing Library
/// Bindings for https://github.com/vadimdemedes/ink-testing-library

///|
fn require_ink_testing_library() -> @js.Any {
  @node.require("ink-testing-library")
}

// ============================================================
// Render Result
// ============================================================

///|
/// Result returned by render function
#external
pub type RenderResult

///|
pub impl @js.JsImpl for RenderResult

///|
/// Get the last rendered frame as a string
pub fn RenderResult::lastFrame(self : RenderResult) -> String {
  let result = self.to_any().get("lastFrame").call_self([])
  @js.identity(result)
}

///|
/// Get all rendered frames
pub fn RenderResult::frames(self : RenderResult) -> Array[String] {
  let frames_arr = self.to_any().get("frames")
  let len : Int = @js.identity(frames_arr.get("length"))
  let result : Array[String] = []
  for i = 0; i < len; i = i + 1 {
    let frame : String = @js.identity(frames_arr.get(i.to_string()))
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
  self.to_any().get("rerender").call_self([element.to_any()]) |> ignore
}

///|
/// Unmount the component
pub fn RenderResult::unmount(self : RenderResult) -> Unit {
  self.to_any().get("unmount").call_self([]) |> ignore
}

///|
/// Get stdin for sending input
pub fn RenderResult::stdin(self : RenderResult) -> StdinMock {
  let stdin = self.to_any().get("stdin")
  { raw: stdin }
}

///|
/// Stdout stream access
pub fn RenderResult::stdout(self : RenderResult) -> StreamOutput {
  let stdout = self.to_any().get("stdout")
  { raw: stdout }
}

///|
/// Stderr stream access
pub fn RenderResult::stderr(self : RenderResult) -> StreamOutput {
  let stderr = self.to_any().get("stderr")
  { raw: stderr }
}

// ============================================================
// Stdin Mock
// ============================================================

///|
/// Mock stdin for sending input to components
pub(all) struct StdinMock {
  raw : @js.Any
}

///|
/// Write data to stdin
pub fn StdinMock::write(self : StdinMock, data : String) -> Unit {
  self.raw.get("write").call_self([data |> @js.any]) |> ignore
}

// ============================================================
// Stream Output
// ============================================================

///|
/// Mock stream output for stdout/stderr
pub(all) struct StreamOutput {
  raw : @js.Any
}

///|
/// Get the last frame from this stream
pub fn StreamOutput::lastFrame(self : StreamOutput) -> String {
  let result = self.raw.get("lastFrame").call_self([])
  @js.identity(result)
}

///|
/// Get all frames from this stream
pub fn StreamOutput::frames(self : StreamOutput) -> Array[String] {
  let frames_arr = self.raw.get("frames")
  let len : Int = @js.identity(frames_arr.get("length"))
  let result : Array[String] = []
  for i = 0; i < len; i = i + 1 {
    let frame : String = @js.identity(frames_arr.get(i.to_string()))
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
pub fn render_for_test(element : @react.Element) -> RenderResult {
  let lib = require_ink_testing_library()
  let render_fn = lib.get("render")
  render_fn.call_self([element.to_any()]) |> @js.identity
}
