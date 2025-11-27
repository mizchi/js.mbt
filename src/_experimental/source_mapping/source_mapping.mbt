///|
/// source_mapping - Trace MoonBit errors to original source positions
/// Combines source-map and error-stack-parser for error tracing
///
/// Note: This package may be split into a separate repository in the future.

///|
/// A resolved stack frame with original source position
pub(all) struct ResolvedFrame {
  /// Original stack frame (from JS)
  js_frame : @error_stack_parser.StackFrame
  /// Original source position (if source map available)
  original : @source_map.OriginalPosition?
}

///|
pub impl Show for ResolvedFrame with output(self, logger) {
  match self.original {
    Some(pos) if pos.is_found() => logger.write_string(pos.to_string())
    _ => {
      let fn_name = self.js_frame.function_name.unwrap_or("<anonymous>")
      let file = self.js_frame.file_name.unwrap_or("<unknown>")
      let line = self.js_frame.line_number.unwrap_or(0)
      let col = self.js_frame.column_number.unwrap_or(0)
      logger.write_string("\{fn_name} at \{file}:\{line}:\{col}")
    }
  }
}

///|
/// Error tracer that can resolve stack frames to original positions
pub struct ErrorTracer {
  consumers : @hashmap.HashMap[String, @source_map.SourceMapConsumer]
}

///|
/// Create a new error tracer
pub fn ErrorTracer::new() -> ErrorTracer {
  { consumers: @hashmap.new() }
}

///|
/// Add a source map for a specific file
pub async fn ErrorTracer::add_source_map(
  self : ErrorTracer,
  file : String,
  source_map_json : String,
) -> Unit {
  let consumer = @source_map.SourceMapConsumer::from_json(source_map_json)
  self.consumers.set(file, consumer)
}

///|
/// Add a source map from raw object
pub async fn ErrorTracer::add_source_map_raw(
  self : ErrorTracer,
  file : String,
  source_map : @js.Any,
) -> Unit {
  let consumer = @source_map.SourceMapConsumer::from_raw(source_map)
  self.consumers.set(file, consumer)
}

///|
/// Resolve a single stack frame to its original position
pub fn ErrorTracer::resolve_frame(
  self : ErrorTracer,
  frame : @error_stack_parser.StackFrame,
) -> ResolvedFrame {
  let original = match frame.file_name {
    Some(file) =>
      match self.consumers.get(file) {
        Some(consumer) => {
          let line = frame.line_number.unwrap_or(1)
          let col = frame.column_number.unwrap_or(0)
          Some(consumer.originalPositionFor(line, col))
        }
        None => None
      }
    None => None
  }
  { js_frame: frame, original }
}

///|
/// Resolve all frames from an error
pub fn ErrorTracer::resolve_error(
  self : ErrorTracer,
  error : @js.Any,
) -> Array[ResolvedFrame] {
  let frames = @error_stack_parser.parse(error)
  frames.map(fn(f) { self.resolve_frame(f) })
}

///|
/// Resolve frames from current stack
pub fn ErrorTracer::resolve_current_stack(
  self : ErrorTracer,
) -> Array[ResolvedFrame] {
  let frames = @error_stack_parser.capture_stack_trace()
  frames.map(fn(f) { self.resolve_frame(f) })
}

///|
/// Clean up all source map consumers
pub fn ErrorTracer::destroy(self : ErrorTracer) -> Unit {
  for consumer in self.consumers.values() {
    consumer.destroy()
  }
  self.consumers.clear()
}

///|
/// Format resolved frames as a readable stack trace
pub fn format_resolved_stack(frames : Array[ResolvedFrame]) -> String {
  let buf = StringBuilder::new()
  for i, frame in frames {
    if i > 0 {
      buf.write_char('\n')
    }
    buf.write_string("    at ")
    buf.write_string(frame.to_string())
  }
  buf.to_string()
}

///|
/// Load source map from a URL (e.g., from .map file)
pub async fn load_source_map_from_url(url : String) -> @js.Any {
  ffi_fetch_source_map(url).wait()
}

///|
extern "js" fn ffi_fetch_source_map(url : String) -> @js.Promise[@js.Any] =
  #|async (url) => {
  #|  const response = await fetch(url);
  #|  return response.json();
  #|}

///|
/// Try to find and load source map for a JS file
/// Looks for //# sourceMappingURL= comment or .map file
pub async fn find_source_map_for_file(js_file_path : String) -> @js.Any? {
  ffi_find_source_map(js_file_path).wait() |> @js.identity
}

///|
extern "js" fn ffi_find_source_map(path : String) -> @js.Promise[@js.Any] =
  #|async (path) => {
  #|  const fs = require('fs').promises;
  #|  try {
  #|    // Try to read the JS file and find sourceMappingURL
  #|    const content = await fs.readFile(path, 'utf8');
  #|    const match = content.match(/\/\/[#@]\s*sourceMappingURL=(.+)/);
  #|    if (match) {
  #|      const mapUrl = match[1].trim();
  #|      // If it's a data URL, parse it
  #|      if (mapUrl.startsWith('data:')) {
  #|        const base64 = mapUrl.split(',')[1];
  #|        return JSON.parse(Buffer.from(base64, 'base64').toString());
  #|      }
  #|      // Otherwise load from file
  #|      const mapPath = require('path').resolve(require('path').dirname(path), mapUrl);
  #|      const mapContent = await fs.readFile(mapPath, 'utf8');
  #|      return JSON.parse(mapContent);
  #|    }
  #|    // Try .map file
  #|    const mapPath = path + '.map';
  #|    const mapContent = await fs.readFile(mapPath, 'utf8');
  #|    return JSON.parse(mapContent);
  #|  } catch {
  #|    return null;
  #|  }
  #|}
