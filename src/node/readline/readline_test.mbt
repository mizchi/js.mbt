///|
/// Node.js Readline Tests
test "InterfaceOptions::new creates options" {
  let stdin : @stream.Readable = @js.identity(@js.Object::new())
  let stdout : @stream.Writable = @js.identity(@js.Object::new())
  let options = InterfaceOptions::new(stdin, Some(stdout))
  let js_obj = options.to_any()
  inspect(@js.typeof_(js_obj.get("input")), content="object")
}

///|
test "InterfaceOptions::to_any includes output when provided" {
  let stdin : @stream.Readable = @js.identity(@js.Object::new())
  let stdout : @stream.Writable = @js.identity(@js.Object::new())
  let options = InterfaceOptions::new(stdin, Some(stdout))
  let js_obj = options.to_any()

  // Check that output is included
  let has_output = @js.typeof_(js_obj.get("output")) != "undefined"
  inspect(has_output, content="true")
}
