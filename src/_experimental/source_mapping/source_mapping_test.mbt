///|
/// Tests for source_mapping package
/// Demonstrates tracing MoonBit errors to original source positions

///|
/// Test ErrorTracer with a mock source map
async test "ErrorTracer resolves position from source map" {
  // Create a source map that maps generated position (1,0) to original position
  let source_map_json =
    #|{
    #|  "version": 3,
    #|  "file": "test.js",
    #|  "sources": ["test.mbt"],
    #|  "names": ["my_function"],
    #|  "mappings": "AAAA,AAIA,SAASA"
    #|}
  let tracer = @source_mapping.ErrorTracer::new()
  defer tracer.destroy()
  tracer.add_source_map("test.js", source_map_json)
  // Create a mock frame
  let frame : @error_stack_parser.StackFrame = {
    function_name: Some("compiled_func"),
    file_name: Some("test.js"),
    line_number: Some(1),
    column_number: Some(0),
    source: None,
  }
  let resolved = tracer.resolve_frame(frame)
  // Check that we got an original position
  assert_true(not(resolved.original is None))
  let orig = resolved.original.unwrap()
  inspect(orig.source, content="Some(\"test.mbt\")")
}

///|
/// Test format_resolved_stack
test "format_resolved_stack" {
  let frames : Array[@source_mapping.ResolvedFrame] = [
    {
      js_frame: {
        function_name: Some("js_func"),
        file_name: Some("out.js"),
        line_number: Some(100),
        column_number: Some(5),
        source: None,
      },
      original: Some({
        source: Some("main.mbt"),
        line: Some(10),
        column: Some(2),
        name: Some("my_func"),
      }),
    },
    {
      js_frame: {
        function_name: Some("helper"),
        file_name: Some("lib.js"),
        line_number: Some(50),
        column_number: Some(0),
        source: None,
      },
      original: None,
    },
  ]
  let formatted = @source_mapping.format_resolved_stack(frames)
  // First frame should show original position
  assert_true(formatted.contains("main.mbt:10:2"))
  // Second frame should show JS position (no source map)
  assert_true(formatted.contains("lib.js"))
}

///|
/// Test resolving current stack trace
/// This demonstrates capturing and resolving the current call stack
test "resolve_current_stack returns frames" {
  let tracer = @source_mapping.ErrorTracer::new()
  defer tracer.destroy()
  // Capture current stack (won't have source maps, but should work)
  let frames = tracer.resolve_current_stack()
  // Should have at least one frame
  assert_true(frames.length() > 0)
  // All frames should have js_frame populated
  for frame in frames {
    // js_frame should exist
    assert_true(not(frame.js_frame.file_name is None))
  }
}

///|
/// Demonstrate the intended use case: Error handler for MoonBit apps
/// This is a pattern for wrapping errors in production
test "example: moonbit error handler pattern" {
  // In production, you would:
  // 1. Load source maps at startup
  // 2. Catch errors and resolve them
  // 3. Log resolved stack traces
  //
  // Example pseudo-code:
  // ```moonbit
  // let tracer = ErrorTracer::new()
  // tracer.add_source_map("/app/main.js", main_source_map)
  //
  // try {
  //   run_app()
  // } catch {
  //   error => {
  //     let frames = tracer.resolve_error(error |> @js.any)
  //     let stack = format_resolved_stack(frames)
  //     @js.log("Error in MoonBit code:\n\{stack}")
  //   }
  // }
  // ```
  //
  // The stack trace will show original .mbt file positions instead of
  // generated JS positions.
  ()
}
