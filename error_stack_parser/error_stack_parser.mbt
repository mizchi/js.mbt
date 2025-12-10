///|
/// error-stack-parser - Parse error stack traces
/// npm: error-stack-parser

///|
/// A parsed stack frame
pub(all) struct StackFrame {
  /// Function name (may be empty)
  function_name : String?
  /// File name or URL
  file_name : String?
  /// Line number (1-indexed)
  line_number : Int?
  /// Column number (1-indexed)
  column_number : Int?
  /// Source string
  source : String?
}

///|
fn StackFrame::from_any(obj : @core.Any) -> StackFrame {
  {
    function_name: obj["functionName"] |> @core.identity,
    file_name: obj["fileName"] |> @core.identity,
    line_number: obj["lineNumber"] |> @core.identity,
    column_number: obj["columnNumber"] |> @core.identity,
    source: obj["source"] |> @core.identity,
  }
}

///|
pub impl Show for StackFrame with output(self, logger) {
  let fn_name = self.function_name.unwrap_or("<anonymous>")
  let file = self.file_name.unwrap_or("<unknown>")
  let line = self.line_number.unwrap_or(0)
  let col = self.column_number.unwrap_or(0)
  logger.write_string("at \{fn_name} (\{file}:\{line}:\{col})")
}

///|
/// Parse an Error object's stack trace into StackFrames
pub fn parse(error : @core.Any) -> Array[StackFrame] {
  let frames = ffi_parse(error)
  let length : Int = frames["length"] |> @core.identity
  let result = Array::new(capacity=length)
  for i in 0..<length {
    let frame = frames[i.to_string()]
    result.push(StackFrame::from_any(frame))
  }
  result
}

///|
extern "js" fn ffi_parse(error : @core.Any) -> @core.Any =
  #|(error) => {
  #|  const ErrorStackParser = require('error-stack-parser');
  #|  return ErrorStackParser.parse(error);
  #|}

///|
/// Parse a stack trace string into StackFrames
pub fn parse_string(stack : String) -> Array[StackFrame] {
  let frames = ffi_parse_string(stack)
  let length : Int = frames["length"] |> @core.identity
  let result = Array::new(capacity=length)
  for i in 0..<length {
    let frame = frames[i.to_string()]
    result.push(StackFrame::from_any(frame))
  }
  result
}

///|
extern "js" fn ffi_parse_string(stack : String) -> @core.Any =
  #|(stack) => {
  #|  const ErrorStackParser = require('error-stack-parser');
  #|  // Create a fake error with the stack
  #|  const err = new Error();
  #|  err.stack = stack;
  #|  try {
  #|    return ErrorStackParser.parse(err);
  #|  } catch {
  #|    return [];
  #|  }
  #|}

///|
/// Capture the current stack trace
pub fn capture_stack_trace() -> Array[StackFrame] {
  let frames = ffi_capture_stack()
  let length : Int = frames["length"] |> @core.identity
  let result = Array::new(capacity=length)
  for i in 0..<length {
    let frame = frames[i.to_string()]
    result.push(StackFrame::from_any(frame))
  }
  result
}

///|
extern "js" fn ffi_capture_stack() -> @core.Any =
  #|() => {
  #|  const ErrorStackParser = require('error-stack-parser');
  #|  return ErrorStackParser.parse(new Error());
  #|}

///|
/// Format stack frames as a string (similar to console output)
pub fn format_stack(frames : Array[StackFrame]) -> String {
  let buf = StringBuilder::new()
  for i, frame in frames {
    if i > 0 {
      buf.write_char('\n')
    }
    let fn_name = frame.function_name.unwrap_or("<anonymous>")
    let file = frame.file_name.unwrap_or("<unknown>")
    let line = frame.line_number.unwrap_or(0)
    let col = frame.column_number.unwrap_or(0)
    buf.write_string("    at \{fn_name} (\{file}:\{line}:\{col})")
  }
  buf.to_string()
}

///|
/// Get stack frames filtered by file pattern
pub fn filter_by_file(
  frames : Array[StackFrame],
  pattern : String,
) -> Array[StackFrame] {
  frames.filter(fn(f) {
    match f.file_name {
      Some(name) => name.contains(pattern)
      None => false
    }
  })
}

///|
/// Get the first non-internal stack frame (skip node_modules, internal files)
pub fn first_user_frame(frames : Array[StackFrame]) -> StackFrame? {
  for frame in frames {
    match frame.file_name {
      Some(name) =>
        if not(name.contains("node_modules")) && not(name.has_prefix("node:")) {
          return Some(frame)
        }
      None => ()
    }
  }
  None
}
