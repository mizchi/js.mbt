///|
/// Node.js Readline Tests
test "InterfaceOptions::new creates options" {
  let stdin : @stream.Readable = @js.unsafe_cast(@js.Object::new())
  let stdout : @stream.Writable = @js.unsafe_cast(@js.Object::new())
  let options = InterfaceOptions::new(stdin, Some(stdout))
  let js_obj = options.to_js()
  inspect(@js.typeof_(js_obj.get("input")), content="object")
}

///|
test "InterfaceOptions::to_js includes output when provided" {
  let stdin : @stream.Readable = @js.unsafe_cast(@js.Object::new())
  let stdout : @stream.Writable = @js.unsafe_cast(@js.Object::new())
  let options = InterfaceOptions::new(stdin, Some(stdout))
  let js_obj = options.to_js()

  // Check that output is included
  let has_output = @js.typeof_(js_obj.get("output")) != "undefined"
  inspect(has_output, content="true")
}
