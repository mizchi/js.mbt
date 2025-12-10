///|
/// Tests for error-stack-parser package
/// Note: These tests require 'error-stack-parser' npm package to be installed

///|
/// Test parsing a captured stack trace
test "capture_stack_trace" {
  let frames = @error_stack_parser.capture_stack_trace()
  // Should have at least one frame
  assert_true(frames.length() > 0)
  // First frame should have file info
  let first = frames[0]
  assert_true(not(first.file_name is None))
}

///|
/// Test format_stack
test "format_stack" {
  let frames : Array[@error_stack_parser.StackFrame] = [
    {
      function_name: Some("test_func"),
      file_name: Some("test.mbt"),
      line_number: Some(10),
      column_number: Some(5),
      source: None,
    },
  ]
  let formatted = @error_stack_parser.format_stack(frames)
  inspect(formatted, content="    at test_func (test.mbt:10:5)")
}

///|
/// Test filter_by_file
test "filter_by_file" {
  let frames : Array[@error_stack_parser.StackFrame] = [
    {
      function_name: Some("a"),
      file_name: Some("/app/src/foo.mbt"),
      line_number: Some(1),
      column_number: Some(0),
      source: None,
    },
    {
      function_name: Some("b"),
      file_name: Some("/app/node_modules/lib.js"),
      line_number: Some(100),
      column_number: Some(0),
      source: None,
    },
    {
      function_name: Some("c"),
      file_name: Some("/app/src/bar.mbt"),
      line_number: Some(5),
      column_number: Some(0),
      source: None,
    },
  ]
  let filtered = @error_stack_parser.filter_by_file(frames, ".mbt")
  inspect(filtered.length(), content="2")
  inspect(filtered[0].function_name, content="Some(\"a\")")
  inspect(filtered[1].function_name, content="Some(\"c\")")
}

///|
/// Test first_user_frame
test "first_user_frame" {
  let frames : Array[@error_stack_parser.StackFrame] = [
    {
      function_name: Some("internal"),
      file_name: Some("node:internal/modules"),
      line_number: Some(1),
      column_number: Some(0),
      source: None,
    },
    {
      function_name: Some("lib_func"),
      file_name: Some("/node_modules/some-lib/index.js"),
      line_number: Some(50),
      column_number: Some(0),
      source: None,
    },
    {
      function_name: Some("my_func"),
      file_name: Some("/app/src/main.mbt"),
      line_number: Some(10),
      column_number: Some(5),
      source: None,
    },
  ]
  let user_frame = @error_stack_parser.first_user_frame(frames)
  assert_true(not(user_frame is None))
  inspect(user_frame.unwrap().function_name, content="Some(\"my_func\")")
}
